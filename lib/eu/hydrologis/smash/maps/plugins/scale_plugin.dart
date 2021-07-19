/*
 * Authors: the flutter_map authors.
 */
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:smashlibs/smashlibs.dart';

class ScaleLayerPluginOption extends LayerOptions {
  TextStyle textStyle;
  Color lineColor;
  double lineWidth;
  final EdgeInsets padding;

  ScaleLayerPluginOption(
      {this.textStyle,
      this.lineColor = Colors.white,
      this.lineWidth = 2,
      this.padding});
}

class ScaleLayerPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ScaleLayerPluginOption) {
      return ScaleLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for ScaleLayerPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ScaleLayerPluginOption;
  }
}

class ScaleLayer extends StatelessWidget {
  final ScaleLayerPluginOption scaleLayerOpts;
  final MapState map;
  final Stream<Null> stream;
  final scale = [
    25000000,
    15000000,
    8000000,
    4000000,
    2000000,
    1000000,
    500000,
    250000,
    100000,
    50000,
    25000,
    15000,
    8000,
    4000,
    2000,
    1000,
    500,
    250,
    100,
    50,
    25,
    10,
    5
  ];

  ScaleLayer(this.scaleLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    var zoom = map.zoom;
    var distance = scale[max(0, min(20, zoom.round() + 2))].toDouble();
    var center = map.center;
    var start = map.project(center);
    var targetPoint = calculateEndingGlobalCoordinates(center, 90, distance);
    var end = map.project(targetPoint);
    var displayDistance = distance > 999
        ? '${(distance / 1000).toStringAsFixed(0)} km'
        : '${distance.toStringAsFixed(0)} m';
    double width = (end.x - start.x);

    return CustomPaint(
      painter: ScalePainter(
        map,
        width,
        displayDistance,
        lineColor: scaleLayerOpts.lineColor,
        lineWidth: scaleLayerOpts.lineWidth,
        padding: scaleLayerOpts.padding,
        textStyle: scaleLayerOpts.textStyle,
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  ScalePainter(this.map, this.width, this.text,
      {this.padding, this.textStyle, this.lineWidth, this.lineColor});

  final MapState map;
  final double width;
  final EdgeInsets padding;
  final String text;
  TextStyle textStyle;
  double lineWidth;
  Color lineColor;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // TODO fix when time
//    var heading = map.rotation;
//    if (heading < 0) {
//      heading = 360 + heading;
//    }
//    double rad = toRadians(-heading);
//    canvas.rotate(rad);
//    print("${map.rotation} -> ${rad}");

    final paint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = lineWidth;

    var sizeForStartEnd = 4;
    var paddingLeft = padding == null ? 0 : padding.left + sizeForStartEnd / 2;
    var paddingTop = padding == null ? 0 : padding.top;

    var textSpan = TextSpan(style: textStyle, text: text);
    var textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    textPainter.paint(canvas,
        Offset(width / 2 - textPainter.width / 2 + paddingLeft, paddingTop));
    paddingTop += textPainter.height;
    var p1 = Offset(paddingLeft, sizeForStartEnd + paddingTop);
    var p2 = Offset(paddingLeft + width, sizeForStartEnd + paddingTop);
    // draw start line
    canvas.drawLine(Offset(paddingLeft, paddingTop),
        Offset(paddingLeft, sizeForStartEnd + paddingTop), paint);
    // draw middle line
    var middleX = width / 2 + paddingLeft - lineWidth / 2;
    canvas.drawLine(Offset(middleX, paddingTop + sizeForStartEnd / 2),
        Offset(middleX, sizeForStartEnd + paddingTop), paint);
    // draw end line
    canvas.drawLine(Offset(width + paddingLeft, paddingTop),
        Offset(width + paddingLeft, sizeForStartEnd + paddingTop), paint);
    // draw bottom line
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

LatLng calculateEndingGlobalCoordinates(
    LatLng start, double startBearing, double distance) {
  var mSemiMajorAxis = 6378137.0; //WGS84 major axis
  var mSemiMinorAxis = (1.0 - 1.0 / 298.257223563) * 6378137.0;
  var mFlattening = 1.0 / 298.257223563;
  // double mInverseFlattening = 298.257223563;

  var a = mSemiMajorAxis;
  var b = mSemiMinorAxis;
  var aSquared = a * a;
  var bSquared = b * b;
  var f = mFlattening;
  var phi1 = MercatorUtils.degToRadian(start.latitude);
  var alpha1 = MercatorUtils.degToRadian(startBearing);
  var cosAlpha1 = cos(alpha1);
  var sinAlpha1 = sin(alpha1);
  var s = distance;
  var tanU1 = (1.0 - f) * tan(phi1);
  var cosU1 = 1.0 / sqrt(1.0 + tanU1 * tanU1);
  var sinU1 = tanU1 * cosU1;

  // eq. 1
  var sigma1 = atan2(tanU1, cosAlpha1);

  // eq. 2
  var sinAlpha = cosU1 * sinAlpha1;

  var sin2Alpha = sinAlpha * sinAlpha;
  var cos2Alpha = 1 - sin2Alpha;
  var uSquared = cos2Alpha * (aSquared - bSquared) / bSquared;

  // eq. 3
  var A = 1 +
      (uSquared / 16384) *
          (4096 + uSquared * (-768 + uSquared * (320 - 175 * uSquared)));

  // eq. 4
  var B = (uSquared / 1024) *
      (256 + uSquared * (-128 + uSquared * (74 - 47 * uSquared)));

  // iterate until there is a negligible change in sigma
  double deltaSigma;
  var sOverbA = s / (b * A);
  var sigma = sOverbA;
  double sinSigma;
  var prevSigma = sOverbA;
  double sigmaM2;
  double cosSigmaM2;
  double cos2SigmaM2;

  for (;;) {
    // eq. 5
    sigmaM2 = 2.0 * sigma1 + sigma;
    cosSigmaM2 = cos(sigmaM2);
    cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;
    sinSigma = sin(sigma);
    var cosSignma = cos(sigma);

    // eq. 6
    deltaSigma = B *
        sinSigma *
        (cosSigmaM2 +
            (B / 4.0) *
                (cosSignma * (-1 + 2 * cos2SigmaM2) -
                    (B / 6.0) *
                        cosSigmaM2 *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM2)));

    // eq. 7
    sigma = sOverbA + deltaSigma;

    // break after converging to tolerance
    if ((sigma - prevSigma).abs() < 0.0000000000001) break;

    prevSigma = sigma;
  }

  sigmaM2 = 2.0 * sigma1 + sigma;
  cosSigmaM2 = cos(sigmaM2);
  cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;

  var cosSigma = cos(sigma);
  sinSigma = sin(sigma);

  // eq. 8
  var phi2 = atan2(
      sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
      (1.0 - f) *
          sqrt(sin2Alpha +
              pow(sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1, 2.0)));

  // eq. 9
  // This fixes the pole crossing defect spotted by Matt Feemster. When a
  // path passes a pole and essentially crosses a line of latitude twice -
  // once in each direction - the longitude calculation got messed up.
  // Using
  // atan2 instead of atan fixes the defect. The change is in the next 3
  // lines.
  // double tanLambda = sinSigma * sinAlpha1 / (cosU1 * cosSigma - sinU1 *
  // sinSigma * cosAlpha1);
  // double lambda = Math.atan(tanLambda);
  var lambda = atan2(
      sinSigma * sinAlpha1, (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1));

  // eq. 10
  var C = (f / 16) * cos2Alpha * (4 + f * (4 - 3 * cos2Alpha));

  // eq. 11
  var L = lambda -
      (1 - C) *
          f *
          sinAlpha *
          (sigma +
              C *
                  sinSigma *
                  (cosSigmaM2 + C * cosSigma * (-1 + 2 * cos2SigmaM2)));

  // eq. 12
  // double alpha2 = Math.atan2(sinAlpha, -sinU1 * sinSigma + cosU1 *
  // cosSigma * cosAlpha1);

  // build result
  var latitude = MercatorUtils.radianToDeg(phi2);
  var longitude = start.longitude + MercatorUtils.radianToDeg(L);

  // if ((endBearing != null) && (endBearing.length > 0)) {
  // endBearing[0] = toDegrees(alpha2);
  // }

  latitude = latitude < -90 ? -90 : latitude;
  latitude = latitude > 90 ? 90 : latitude;
  longitude = longitude < -180 ? -180 : longitude;
  longitude = longitude > 180 ? 180 : longitude;
  return LatLng(latitude, longitude);
}
