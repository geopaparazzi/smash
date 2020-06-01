/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';

/// Plugin to show the current GPS position
class GpsPositionPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
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
  Color markerColorLogging;
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
  final Stream<Null> stream;

  GpsPositionLayer(this.gpsPositionLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);

    return CustomPaint(
      painter: CurrentLogPathPainter(gpsPositionLayerOpts, gpsState, map),
    );
  }
}

class CurrentLogPathPainter extends CustomPainter {
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

  CurrentLogPathPainter(this.gpsPositionLayerOpts, this.gpsState, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    var pos = gpsState.lastGpsPosition;
    if (pos != null && gpsState.status != GpsStatus.OFF) {
      LatLng posLL = LatLng(pos.latitude, pos.longitude);
      var bounds = map.getBounds();
      if (!bounds.contains(posLL)) {
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

      CustomPoint posPixel = map.project(posLL);
      CustomPoint pixelOrigin = map.getPixelOrigin();
      var radius = gpsPositionLayerOpts.markerSize / 2;
      double centerX = posPixel.x - pixelOrigin.x;
      double centerY = (posPixel.y - pixelOrigin.y);

      if (pos.accuracy != null) {
        var radiusLL =
            calculateEndingGlobalCoordinates(posLL, 90, pos.accuracy);
        CustomPoint tmpPixel = map.project(radiusLL);
        double tmpX = tmpPixel.x - pixelOrigin.x;
        double accuracyRadius = (centerX - tmpX).abs();

        canvas.drawCircle(
            Offset(centerX, centerY), accuracyRadius, accuracyStroke);
        canvas.drawCircle(
            Offset(centerX, centerY), accuracyRadius, accuracyFill);
      }

      if (pos.heading != null && pos.heading > 0) {
        var heading = pos.heading - 90;
        double rad = degToRadian(heading);

        var rect = Rect.fromCircle(
            center: Offset(centerX, centerY), radius: radius * 0.7);

        var delta = math.pi / 4;

        canvas.drawArc(
            rect, rad + delta / 2, math.pi * 2 - delta, false, paintStroke);
        canvas.drawCircle(Offset(centerX, centerY), radius * 0.3, paintFill);

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
            Offset(centerX, centerY), radius * 0.2, paintFillOver);
      } else {
        canvas.drawCircle(Offset(centerX, centerY), radius * 0.7, paintStroke);
        canvas.drawCircle(Offset(centerX, centerY), radius * 0.3, paintFill);

        var paintStrokeOver = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        var paintFillOver = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(centerX, centerY), radius * 0.7, paintStrokeOver);
        canvas.drawCircle(
            Offset(centerX, centerY), radius * 0.2, paintFillOver);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
