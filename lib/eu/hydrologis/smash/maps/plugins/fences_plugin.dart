/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';

/// Plugin to show the current GPS log
class FencesPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is FencesPluginOption) {
      return FencesLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for FencesPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is FencesPluginOption;
  }
}

class FencesPluginOption extends LayerOptions {
  Color color;
  double width;

  FencesPluginOption({
    this.color = Colors.red,
    this.width = 2,
  });
}

class FencesLayer extends StatelessWidget {
  final FencesPluginOption opts;
  final MapState mapState;
  final Stream<Null> stream;
  Paint fillPaint;
  Paint strokePaint;

  FencesLayer(this.opts, this.mapState, this.stream) {
    fillPaint = Paint()
      ..color = opts.color.withAlpha(60)
      ..style = PaintingStyle.fill;
    strokePaint = Paint()
      ..color = opts.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = opts.width;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurrentLogPathPainter(fillPaint, strokePaint, mapState),
    );
  }
}

class CurrentLogPathPainter extends CustomPainter {
  MapState map;
  Paint fillPaint;
  Paint strokePaint;

  CurrentLogPathPainter(this.fillPaint, this.strokePaint, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    var fencesList = FenceMaster().fencesList;
    var bb = map.getBounds();
    Envelope mapEnv = Envelope(bb.west, bb.east, bb.south, bb.north);
    for (var i = 0; i < fencesList.length; i++) {
      var fence = fencesList[i];

      LatLng center = LatLng(fence.lat, fence.lon);
      // var offsetLL = calculateEndingGlobalCoordinates(center, 90, fence.radius);
      LatLng offsetLL =
          CoordinateUtilities.getAtOffset(center, fence.radius, 90);
      double delta = (offsetLL.longitude - center.longitude).abs();

      Envelope env = Envelope(
          center.longitude - delta,
          center.longitude + delta,
          center.latitude - delta,
          center.latitude + delta);

      if (!mapEnv.intersectsEnvelope(env)) {
        continue;
      }

      CustomPoint pixelOrigin = map.getPixelOrigin();

      CustomPoint mainPosPixel = map.project(center);
      double mainCenterX = mainPosPixel.x - pixelOrigin.x;
      double mainCenterY = (mainPosPixel.y - pixelOrigin.y);

      CustomPoint tmpPixel = map.project(offsetLL);
      double tmpX = tmpPixel.x - pixelOrigin.x;
      double r = (mainCenterX - tmpX).abs();

      canvas.drawCircle(Offset(mainCenterX, mainCenterY), r, fillPaint);
      canvas.drawCircle(Offset(mainCenterX, mainCenterY), r, strokePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
