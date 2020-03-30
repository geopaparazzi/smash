/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';

/// Plugin to show the current GPS log
class CurrentGpsLogPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is CurrentGpsLogPluginOption) {
      return CurrentGpsLogLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for CurrentGpsLogPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is CurrentGpsLogPluginOption;
  }
}

class CurrentGpsLogPluginOption extends LayerOptions {
  Color logColor;
  double logWidth;

  CurrentGpsLogPluginOption({
    this.logColor = Colors.red,
    this.logWidth = 4,
  });
}

class CurrentGpsLogLayer extends StatelessWidget {
  final CurrentGpsLogPluginOption currentGpsLogLayerOpts;
  final MapState map;
  final Stream<Null> stream;

  CurrentGpsLogLayer(this.currentGpsLogLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint()
      ..color = currentGpsLogLayerOpts.logColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = currentGpsLogLayerOpts.logWidth;

    return Consumer<GpsState>(builder: (context, gpsState, child) {
      if (gpsState.isLogging && gpsState.currentLogPoints.length > 1) {
        return CustomPaint(
          painter: CurrentLogPathPainter(paint, gpsState.currentLogPoints, map),
        );
      } else {
        return Container();
      }
    });
  }
}

class CurrentLogPathPainter extends CustomPainter {
  var cPaint;
  List<LatLng> currentLogPoints;
  MapState map;

  CurrentLogPathPainter(this.cPaint, this.currentLogPoints, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    CustomPoint posPixel = map.project(currentLogPoints[0]);
    var pixelBounds = map.getLastPixelBounds();
    CustomPoint pixelOrigin = map.getPixelOrigin();
    double centerX = posPixel.x - pixelOrigin.x;
    double centerY = (posPixel.y - pixelOrigin.y);
    path.moveTo(centerX, centerY);

    for (int i = 1; i < currentLogPoints.length; i++) {
      CustomPoint posPixel = map.project(currentLogPoints[i]);
      var pixelBounds = map.getLastPixelBounds();
      CustomPoint pixelOrigin = map.getPixelOrigin();
      double centerX = posPixel.x - pixelOrigin.x;
      double centerY = (posPixel.y - pixelOrigin.y);
      path.lineTo(centerX, centerY);
    }
    canvas.drawPath(path, cPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
