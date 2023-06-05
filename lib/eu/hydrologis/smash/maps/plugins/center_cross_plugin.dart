/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:smashlibs/smashlibs.dart';

class CenterCrossStyle {
  bool visible = true;
  String color = "#000000";
  double size = 30;
  double lineWidth = 3;

  CenterCrossStyle.fromPreferences() {
    var json = GpPreferences()
        .getStringSync(SmashPreferencesKeys.KEY_CENTERCROSS_STYLE, null);
    if (json != null) {
      Map<String, dynamic> data = JSON.jsonDecode(json);
      visible = data['visible'];
      color = data['color'];
      size = data['size'];
      lineWidth = data['lineWidth'];
    } else {
      // first time
      saveToPreferences();
    }
  }

  Future saveToPreferences() async {
    var json = toJson();
    await GpPreferences()
        .setString(SmashPreferencesKeys.KEY_CENTERCROSS_STYLE, json);
  }

  String toJson() {
    return JSON.jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['visible'] = visible;
    map['color'] = color;
    map['size'] = size;
    map['lineWidth'] = lineWidth;
    return map;
  }
}

class CenterCrossLayer extends StatelessWidget {
  final Color crossColor;
  final double crossSize;
  final double lineWidth;

  CenterCrossLayer(
      {this.crossColor = Colors.black,
      this.crossSize = 10,
      this.lineWidth = 2});

  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.maybeOf(context)!;
    var center = map.center;
    CustomPoint centerPixel = map.project(center);
    CustomPoint pixelOrigin = map.pixelOrigin;

    double centerX = (centerPixel.x - pixelOrigin.x).toDouble();
    double centerY = (centerPixel.y - pixelOrigin.y).toDouble();
    CustomPoint centerPix = CustomPoint(centerX, centerY);

    return CustomPaint(
      painter: CenterCrossLayerPainter(
        centerPix,
        crossColor: crossColor,
        crossSize: crossSize,
        lineWidth: lineWidth,
      ),
    );
  }
}

class CenterCrossLayerPainter extends CustomPainter {
  CenterCrossLayerPainter(this.centerPixel,
      {required this.crossColor,
      required this.crossSize,
      required this.lineWidth});

  double lineWidth;
  double crossSize;
  Color crossColor;
  CustomPoint centerPixel;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = crossColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = lineWidth;

    var p1 = Offset(centerPixel.x - crossSize / 2, centerPixel.y.toDouble());
    var p2 = Offset(centerPixel.x + crossSize / 2, centerPixel.y.toDouble());
    canvas.drawLine(p1, p2, paint);
    var p3 = Offset(centerPixel.x.toDouble(), centerPixel.y - crossSize / 2);
    var p4 = Offset(centerPixel.x.toDouble(), centerPixel.y + crossSize / 2);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
