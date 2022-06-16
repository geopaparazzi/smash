/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:math' as math;

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';

/// Plugin to show the current GPS position
class GpsPositionPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is GpsPositionPluginOption) {
      return GpsPositionLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for GpsPositionPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is GpsPositionPluginOption;
  }
}

class GpsPositionPluginOption extends LayerOptions {
  Color markerColor;
  Color markerColorStale;
  Color? markerColorLogging;
  double markerSize;

  GpsPositionPluginOption({
    this.markerColor = Colors.black,
    this.markerColorStale = Colors.grey,
    this.markerColorLogging,
    this.markerSize = 10,
  }) {
    markerColorLogging ??= SmashColors.gpsLogging;
  }
}

class GpsPositionLayer extends StatelessWidget {
  final GpsPositionPluginOption gpsPositionLayerOpts;
  final MapState map;
  final Stream<void> stream;

  GpsPositionLayer(this.gpsPositionLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);

    return CustomPaint(
      painter: CurrentGpsPositionPainter(gpsPositionLayerOpts, gpsState, map),
    );
  }
}

class CurrentGpsPositionPainter extends CustomPainter {
  MapState map;
  GpsState gpsState;
  GpsPositionPluginOption gpsPositionLayerOpts;
  Paint paintStrokeWhite = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  Paint paintFillWhite = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  Paint paintStrokeBlack = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  Paint paintFillBlack = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;
  Paint accuracyStroke = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  Paint accuracyFill = Paint()
    ..color = Colors.blue.withAlpha(50)
    ..style = PaintingStyle.fill;

  CurrentGpsPositionPainter(this.gpsPositionLayerOpts, this.gpsState, this.map)
      : super(repaint: gpsState);

  @override
  void paint(Canvas canvas, Size size) {
    var pos = gpsState.lastGpsPosition;
    if (pos != null &&
        gpsState.status != GpsStatus.OFF &&
        gpsState.status != GpsStatus.NOGPS) {
      LatLng mainPosLL;
      LatLng secPosLL;
      var accuracy;
      if (gpsState.useFilteredGps) {
        mainPosLL = LatLng(pos.filteredLatitude, pos.filteredLongitude);
        secPosLL = LatLng(pos.latitude, pos.longitude);
        accuracy = pos.filteredAccuracy;
      } else {
        secPosLL = LatLng(pos.filteredLatitude, pos.filteredLongitude);
        mainPosLL = LatLng(pos.latitude, pos.longitude);
        accuracy = pos.accuracy;
      }
      var bounds = map.getBounds();
      if (!bounds.contains(mainPosLL)) {
        return;
      }

      var color;
      var paintStroke;
      var paintFill;
      if (gpsState.status == GpsStatus.ON_WITH_FIX) {
        color = gpsPositionLayerOpts.markerColor;
        paintStroke = paintStrokeWhite;
        paintFill = paintFillWhite;
      } else if (gpsState.status == GpsStatus.ON_NO_FIX) {
        color = gpsPositionLayerOpts.markerColorStale;
        paintStroke = paintStrokeWhite;
        paintFill = paintFillWhite;
      } else {
        color = gpsPositionLayerOpts.markerColorLogging;
        paintStroke = paintStrokeBlack;
        paintFill = paintFillBlack;
      }

      CustomPoint pixelOrigin = map.getPixelOrigin();
      var radius = gpsPositionLayerOpts.markerSize / 2;

      CustomPoint mainPosPixel = map.project(mainPosLL);
      double mainCenterX = mainPosPixel.x - pixelOrigin.x.toDouble();
      double mainCenterY = (mainPosPixel.y - pixelOrigin.y.toDouble());

      CustomPoint secPosPixel = map.project(secPosLL);
      double secCenterX = secPosPixel.x - pixelOrigin.x.toDouble();
      double secCenterY = (secPosPixel.y - pixelOrigin.y.toDouble());

      var secPaint = Paint()
        ..color = Colors.red.withAlpha(100)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(secCenterX, secCenterY), 4, secPaint);
      var secLinePaint = Paint()
        ..color = Colors.red.withAlpha(100)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(secCenterX, secCenterY),
          Offset(mainCenterX, mainCenterY), secLinePaint);

      if (accuracy != null) {
        var radiusLL =
            calculateEndingGlobalCoordinates(mainPosLL, 90, accuracy);
        CustomPoint tmpPixel = map.project(radiusLL);
        double tmpX = tmpPixel.x - pixelOrigin.x.toDouble();
        double accuracyRadius = (mainCenterX - tmpX).abs();

        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), accuracyRadius, accuracyStroke);
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), accuracyRadius, accuracyFill);
      }

      if (pos.heading != null && pos.heading > 0) {
        var heading = pos.heading - 90;
        double rad = degToRadian(heading);

        var rect = Rect.fromCircle(
            center: Offset(mainCenterX, mainCenterY), radius: radius * 0.7);

        var delta = math.pi / 4;

        canvas.drawArc(
            rect, rad + delta / 2, math.pi * 2 - delta, false, paintStroke);
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.3, paintFill);

        delta = delta * 1.1;
        var paintStrokeOver = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        var paintFillOver = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawArc(
            rect, rad + delta / 2, math.pi * 2 - delta, false, paintStrokeOver);
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.2, paintFillOver);
      } else {
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.7, paintStroke);
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.3, paintFill);

        var paintStrokeOver = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        var paintFillOver = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.7, paintStrokeOver);
        canvas.drawCircle(
            Offset(mainCenterX, mainCenterY), radius * 0.2, paintFillOver);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
