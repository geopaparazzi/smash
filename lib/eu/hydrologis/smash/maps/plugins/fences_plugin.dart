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
import 'package:latlong2/latlong.dart' hide Path;
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash/eu/hydrologis/smash/util/notifications.dart';

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
  static double width = 2;

  Paint noSoundFillColor = Paint()
    ..color = Colors.grey.withAlpha(60)
    ..style = PaintingStyle.fill;
  Paint fillColor = Paint()
    ..color = Colors.red.withAlpha(60)
    ..style = PaintingStyle.fill;

  Paint noSoundStrokeColor = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
  Paint enterSoundStrokeColor = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
  Paint exitSoundStrokeColor = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
}

class FencesLayer extends StatelessWidget {
  final FencesPluginOption opts;
  final MapState mapState;
  final Stream<Null> stream;

  FencesLayer(this.opts, this.mapState, this.stream) {}

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurrentLogPathPainter(opts, mapState),
    );
  }
}

class CurrentLogPathPainter extends CustomPainter {
  MapState map;
  FencesPluginOption opts;

  CurrentLogPathPainter(this.opts, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    var fencesList = FenceMaster().fencesList;
    var bb = map.getBounds();
    Envelope mapEnv = Envelope(bb.west, bb.east, bb.south, bb.north);
    for (var i = 0; i < fencesList.length; i++) {
      var fence = fencesList[i];

      LatLng center = LatLng(fence.lat, fence.lon);
      LatLng offsetX =
          CoordinateUtilities.getAtOffset(center, fence.radius, 90);
      double deltaX = (offsetX.longitude - center.longitude).abs();
      LatLng offsetY = CoordinateUtilities.getAtOffset(center, fence.radius, 0);
      double deltaY = (offsetY.latitude - center.latitude).abs();

      Envelope env = Envelope(
          center.longitude - deltaX,
          center.longitude + deltaX,
          center.latitude - deltaY,
          center.latitude + deltaY);

      if (!mapEnv.intersectsEnvelope(env)) {
        continue;
      }

      CustomPoint pixelOrigin = map.getPixelOrigin();

      CustomPoint mainPosPixel = map.project(center);
      double mainCenterX = mainPosPixel.x - pixelOrigin.x;
      double mainCenterY = (mainPosPixel.y - pixelOrigin.y);

      CustomPoint tmpPixelX = map.project(offsetX);
      double tmpX = tmpPixelX.x - pixelOrigin.x;
      double rX = (mainCenterX - tmpX).abs();
      CustomPoint tmpPixelY = map.project(offsetY);
      double tmpY = tmpPixelY.y - pixelOrigin.y;
      double rY = (mainCenterY - tmpY).abs();

      bool hasEnter = fence.onEnter != ENotificationSounds.nosound;
      bool hasExit = fence.onExit != ENotificationSounds.nosound;

      Rect rect = Rect.fromPoints(Offset(mainCenterX - rX, mainCenterY - rY),
          Offset(mainCenterX + rX, mainCenterY + rY));
      Rect rectEnter = Rect.fromPoints(
          Offset(mainCenterX - rX - FencesPluginOption.width,
              mainCenterY - rY - FencesPluginOption.width),
          Offset(mainCenterX + rX + FencesPluginOption.width,
              mainCenterY + rY + FencesPluginOption.width));
      Rect rectExit = Rect.fromPoints(
          Offset(mainCenterX - rX + FencesPluginOption.width,
              mainCenterY - rY + FencesPluginOption.width),
          Offset(mainCenterX + rX - FencesPluginOption.width,
              mainCenterY + rY - FencesPluginOption.width));
      if (hasExit || hasEnter) {
        canvas.drawOval(rect, opts.fillColor);
        if (hasEnter) {
          canvas.drawOval(rectEnter, opts.enterSoundStrokeColor);
        }
        if (hasExit) {
          canvas.drawOval(rectExit, opts.exitSoundStrokeColor);
        }
      } else {
        canvas.drawOval(rect, opts.noSoundFillColor);
        canvas.drawOval(rect, opts.noSoundStrokeColor);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
