/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash/eu/hydrologis/smash/util/notifications.dart';

/// Plugin to show the current GPS log
class FencesPluginOption {
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
  FencesLayer() : super(key: ValueKey("SMASH_FENCESLAYER"));

  @override
  Widget build(BuildContext context) {
    var mapState = FlutterMapState.maybeOf(context)!;
    return CustomPaint(
      painter: CurrentLogPathPainter(FencesPluginOption(), mapState),
    );
  }
}

class CurrentLogPathPainter extends CustomPainter {
  FlutterMapState map;
  FencesPluginOption opts;

  CurrentLogPathPainter(this.opts, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    var fencesList = FenceMaster().fencesList;
    var bb = map.bounds;
    Envelope mapEnv = Envelope(bb.west, bb.east, bb.south, bb.north);
    for (var i = 0; i < fencesList.length; i++) {
      var fence = fencesList[i];

      Coordinate center = Coordinate.fromYX(fence.lat, fence.lon);
      Coordinate offsetX =
          CoordinateUtilities.getAtOffset(center, fence.radius, 90);
      double deltaX = (offsetX.x - center.x).abs();
      Coordinate offsetY =
          CoordinateUtilities.getAtOffset(center, fence.radius, 0);
      double deltaY = (offsetY.y - center.y).abs();

      Envelope env = Envelope(center.x - deltaX, center.x + deltaX,
          center.y - deltaY, center.y + deltaY);

      if (!mapEnv.intersectsEnvelope(env)) {
        continue;
      }

      CustomPoint pixelOrigin = map.pixelOrigin;

      CustomPoint mainPosPixel = map.project(LatLng(center.y, center.x));
      double mainCenterX = mainPosPixel.x - pixelOrigin.x.toDouble();
      double mainCenterY = (mainPosPixel.y - pixelOrigin.y.toDouble());

      CustomPoint tmpPixelX = map.project(LatLng(offsetX.y, offsetX.x));
      double tmpX = tmpPixelX.x - pixelOrigin.x.toDouble();
      double rX = (mainCenterX - tmpX).abs();
      CustomPoint tmpPixelY = map.project(LatLng(offsetY.y, offsetY.x));
      double tmpY = tmpPixelY.y - pixelOrigin.y.toDouble();
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
