import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';
import 'package:smashlibs/smashlibs.dart';

final colorsRainbow = [
  ColorExt("#FFFF00"),
  ColorExt("#00FF00"),
  ColorExt("#00FFFF"),
  ColorExt("#0000FF"),
  ColorExt("#FF00FF"),
  ColorExt("#FF0000"),
];

final colorsElevation = [
  ColorExt("#00bfbf"),
  ColorExt("#00FF00"),
  ColorExt("#FFFF00"),
  ColorExt("#ff7f00"),
  ColorExt("#bf7f3f"),
  ColorExt("#141514"),
];

final colorsSlope = [
  ColorExt("#FFFF00"),
  ColorExt("#80ff00"),
  ColorExt("#00FF00"),
  ColorExt("#00ff80"),
  ColorExt("#00FFFF"),
  ColorExt("#0080FF"),
  ColorExt("#0000FF"),
  ColorExt("#8000FF"),
  ColorExt("#FF00FF"),
  ColorExt("#FF0080"),
  ColorExt("#FF0000"),
];

const ECOLORSEP = "@";
const COLORTABLEPREF = "ct:";

/// Enumeration of supported colortables
class ColorTables {
  static final none = ColorTables._("none", null);
  static final elevation = ColorTables._("elevation", colorsElevation);
  static final slope = ColorTables._("slope", colorsSlope);
  static final speed = ColorTables._("speed", colorsRainbow);
  static final accuracy = ColorTables._("accuracy", colorsRainbow);

  static List<ColorTables> get valuesGpx => [none, elevation, slope];

  static List<ColorTables> get valuesLogs =>
      [none, elevation, slope, speed, accuracy];

  final String name;
  final List<Color>? colors;

  const ColorTables._(this.name, this.colors);

  bool isValid() {
    return this != none;
  }

  Rainbow getColorInterpolator({double? min, double? max}) {
    if (name == slope.name) {
      return Rainbow(rangeStart: 0.0, rangeEnd: 0.3, spectrum: colors!);
    } else if (name == accuracy.name) {
      return Rainbow(rangeStart: 0, rangeEnd: 50, spectrum: colors!);
    } else if (min == null || max == null) {
      throw ArgumentError(
          "The colortable needs min and max range to be defined.");
    }
    return Rainbow(rangeStart: min, rangeEnd: max, spectrum: colors!);
  }

  static ColorTables? forName(String name) {
    return valuesLogs.firstWhere((ct) => ct.name == name);
  }
}

/// Class to handle enhance colors.
///
/// Enhanced colors can carry to information of colortables apart of the hex
/// colorstring.
///
/// For example we can have #FF0000@ct:elevation, which means that the colortable
/// elevation should be applied if possible or else use red as fallback.
/// The colortable information can be absent, in which case the solid color
/// is valid.
class EnhancedColorUtility {
  /// Checks if the log color also has information about the elevation coloring.
  ///
  /// Returns two values as [logColorString, doElevationColor] (string and bool).
  static List<dynamic> splitEnhancedColorString(String colorString) {
    var result = [];
    if (colorString.contains(ECOLORSEP)) {
      var split = colorString.split(ECOLORSEP);

      String solidColor = split[0];
      result.add(solidColor);
      if (split.length > 1) {
        // enhanced color, for now only colortable is supported
        if (split[1].toLowerCase().startsWith(COLORTABLEPREF)) {
          String ctName = split[1].substring(3);
          var ct = ColorTables.forName(ctName);
          if (ct != null) {
            result.add(ct);
          }
        }
      }
      if (result.length == 1) {
        result.add(ColorTables.none);
      }
    } else {
      result.add(colorString);
      result.add(ColorTables.none);
    }

    return result;
  }

  /// Build an enhanced color string.
  static String buildEnhancedColor(String color, {ColorTables? ct}) {
    if (ct == null) {
      return color;
    }
    String add = color + ECOLORSEP + COLORTABLEPREF + ct.name;
    return add;
  }

  static List<Polyline> buildPolylines(
      List<Polyline> lines,
      List<LatLng> linePoints,
      ColorTables colorTable,
      double strokeWidth,
      double minLineElev,
      double maxLineElev) {
    // TODO bring this to setting?
    var interval = 20;

    if (colorTable == ColorTables.elevation) {
      var rb =
          colorTable.getColorInterpolator(min: minLineElev, max: maxLineElev);

      List<Polyline> back = [];
      List<Polyline> front = [];
      loopLine(linePoints, interval, (startI, endI, points) {
        ElevationPoint p1 = linePoints[startI] as ElevationPoint;
        ElevationPoint p2 = linePoints[endI] as ElevationPoint;
        List<Color> grad = [rb[p1.altitude], rb[p2.altitude]];
        back.add(Polyline(
          points: points,
          strokeWidth: strokeWidth + 2,
          color: Colors.black,
          isDotted: p1.altitude > p2.altitude,
        ));
        front.add(Polyline(
          points: points,
          strokeWidth: strokeWidth,
          gradientColors: grad,
        ));
      });

      lines.addAll(back);
      lines.addAll(front);
    } else if (colorTable == ColorTables.slope) {
      var rb = colorTable.getColorInterpolator();

      List<Polyline> back = [];
      List<Polyline> front = [];
      double prevSlope = 0.0;
      loopLine(linePoints, interval, (startI, endI, points) {
        ElevationPoint p1 = linePoints[startI] as ElevationPoint;
        ElevationPoint p2 = linePoints[endI] as ElevationPoint;
        var distance = CoordinateUtilities.getDistance(p1, p2);
        if (distance == 0.0) {
          distance = 0.1;
        }
        double slope = ((p2.altitude - p1.altitude) / distance).abs();

        List<Color> grad = [rb[prevSlope], rb[slope]];
        prevSlope = slope;

        back.add(Polyline(
          points: points,
          strokeWidth: strokeWidth + 2,
          color: Colors.black,
          isDotted: p1.altitude > p2.altitude,
        ));
        front.add(Polyline(
          points: points,
          strokeWidth: strokeWidth,
          gradientColors: grad,
        ));
      });

      lines.addAll(back);
      lines.addAll(front);
    } else if (colorTable == ColorTables.speed && linePoints[0] is LatLngExt) {
      double minSpeed = double.infinity;
      double maxSpeed = double.negativeInfinity;
      for (var i = 0; i < linePoints.length; i = i + interval) {
        var p = linePoints[i] as LatLngExt;
        minSpeed = min(minSpeed, p.speed);
        maxSpeed = max(maxSpeed, p.speed);
      }
      var rb = colorTable.getColorInterpolator(min: minSpeed, max: maxSpeed);

      List<Polyline> back = [];
      List<Polyline> front = [];
      loopLine(linePoints, interval, (startI, endI, points) {
        LatLngExt p1 = linePoints[startI] as LatLngExt;
        LatLngExt p2 = linePoints[endI] as LatLngExt;

        List<Color> grad = [rb[p1.speed], rb[p2.speed]];
        back.add(Polyline(
          points: points,
          strokeWidth: strokeWidth + 2,
          color: Colors.black,
          isDotted: p1.altitude > p2.altitude,
        ));
        front.add(Polyline(
          points: points,
          strokeWidth: strokeWidth,
          gradientColors: grad,
        ));
      });

      lines.addAll(back);
      lines.addAll(front);
    } else if (colorTable == ColorTables.accuracy &&
        linePoints[0] is LatLngExt) {
      var rb = colorTable.getColorInterpolator();

      List<Polyline> back = [];
      List<Polyline> front = [];
      loopLine(linePoints, interval, (startI, endI, points) {
        LatLngExt p1 = linePoints[startI] as LatLngExt;
        LatLngExt p2 = linePoints[endI] as LatLngExt;

        List<Color> grad = [rb[p1.accuracy], rb[p2.accuracy]];
        back.add(Polyline(
          points: points,
          strokeWidth: strokeWidth + 2,
          color: Colors.black,
          isDotted: p1.altitude > p2.altitude,
        ));
        front.add(Polyline(
          points: points,
          strokeWidth: strokeWidth,
          gradientColors: grad,
        ));
      });

      lines.addAll(back);
      lines.addAll(front);
    }
    return lines;
  }

  static void loopLine(List linePoints, int interval, Function process) {
    var size = linePoints.length;
    for (var i = 0; i < size; i = i + interval) {
      var startI = i == 0 ? i : i - 1;
      var endI = i + interval > size - 1 ? size - 1 : i + interval;
      var sublist = linePoints.sublist(startI, endI);
      process(startI, endI, sublist);
    }
  }

  static List<Polyline> buildPolylines2(
      List<Polyline> lines,
      List<LatLng> linePoints,
      ColorTables colorTable,
      double strokeWidth,
      double minLineElev,
      double maxLineElev) {
    if (colorTable == ColorTables.elevation) {
      var rb =
          colorTable.getColorInterpolator(min: minLineElev, max: maxLineElev);
      var interval = 10; // points to jump
      List<double> colorStops = getLineCoordinateStops(linePoints, interval);
      List<Color> grad = [];
      for (var i = 0; i < linePoints.length; i++) {
        if (interval == 1 || i % interval == 0) {
          ElevationPoint p = linePoints[i] as ElevationPoint;
          grad.add(rb[p.altitude]);
        }
      }
      grad.add(grad.last);

      lines.add(Polyline(
        points: linePoints,
        strokeWidth: strokeWidth,
        gradientColors: grad,
        colorsStop: colorStops,
        borderColor: Colors.black,
        borderStrokeWidth: 1,
      ));
    } else if (colorTable == ColorTables.slope) {
      var rb = colorTable.getColorInterpolator();

      List<double> colorStops = getLineCoordinateStops(linePoints);
      List<Color> grad = [rb[0.0]];
      for (var i = 1; i < linePoints.length; i++) {
        ElevationPoint p1 = linePoints[i - 1] as ElevationPoint;
        ElevationPoint p2 = linePoints[i] as ElevationPoint;
        var distance = CoordinateUtilities.getDistance(p1, p2);
        if (distance == 0.0) {
          distance = 0.1;
        }
        double slope = (p2.altitude - p1.altitude) / distance;
        grad.add(rb[slope.abs()]);
      }
      lines.add(Polyline(
        points: linePoints,
        strokeWidth: strokeWidth,
        gradientColors: grad,
        colorsStop: colorStops,
        borderColor: Colors.black,
        borderStrokeWidth: 1,
      ));
    } else if (colorTable == ColorTables.speed && linePoints[0] is LatLngExt) {
      double minSpeed = double.infinity;
      double maxSpeed = double.negativeInfinity;
      for (var i = 0; i < linePoints.length; i++) {
        var p = linePoints[i] as LatLngExt;
        minSpeed = min(minSpeed, p.speed);
        maxSpeed = max(maxSpeed, p.speed);
      }
      print("$minSpeed / $maxSpeed");
      var rb = colorTable.getColorInterpolator(min: minSpeed, max: maxSpeed);
      List<double> colorStops = getLineCoordinateStops(linePoints);
      List<Color> grad = [];
      for (var i = 0; i < linePoints.length; i++) {
        LatLngExt p1 = linePoints[i] as LatLngExt;
        grad.add(rb[p1.speed]);
      }
      lines.add(Polyline(
        points: linePoints,
        strokeWidth: strokeWidth,
        gradientColors: grad,
        colorsStop: colorStops,
        borderColor: Colors.black,
        borderStrokeWidth: 1,
      ));
    } else if (colorTable == ColorTables.accuracy &&
        linePoints[0] is LatLngExt) {
      var rb = colorTable.getColorInterpolator();

      List<double> lineStops = getLineCoordinateStops(linePoints);

      List<Color> grad = [];
      for (var i = 0; i < linePoints.length; i++) {
        LatLngExt p1 = linePoints[i] as LatLngExt;
        grad.add(rb[p1.accuracy]);
      }

      lines.add(Polyline(
        points: linePoints,
        strokeWidth: strokeWidth,
        gradientColors: grad,
        colorsStop: lineStops,
        borderColor: Colors.black,
        borderStrokeWidth: 1,
      ));
    }
    return lines;
  }

  static List<double> getLineCoordinateStops(List<LatLng> linePoints,
      [int? interval]) {
    interval ??= 1;
    List<double> lineStops = [];
    double runningDistance = 0;
    for (var i = 0; i < linePoints.length - 1; i++) {
      LatLng p1 = linePoints[i];
      LatLng p2 = linePoints[i + 1];

      if (interval == 1 || i % interval == 0) {
        lineStops.add(runningDistance);
      }
      var dist = sqrt(pow(p2.latitude - p1.latitude, 2) +
          pow(p1.longitude - p1.longitude, 2));
      // var dist = distance3d(p1 as LatLngExt, p2 as LatLngExt);
      runningDistance += dist;
    }
    lineStops.add(runningDistance);
    // normalize
    return lineStops.map((value) => value / runningDistance).toList();
  }

  /// Calculates the 3d distance between two coordinates that have an elevation information.
  ///
  /// @param c1 coordinate 1.
  /// @param c2 coordinate 2.
  /// @param geodeticCalculator If supplied it will be used for planar distance calculation.
  /// @return the distance considering also elevation.
  static double distance3d(LatLngExt c1, LatLngExt c2) {
    double deltaElev = (c1.altitude - c2.altitude).abs();
    var dist = CoordinateUtilities.getDistance(c1, c2);

    double distance = pythagoras(dist, deltaElev);
    return distance;
  }

  /// Calculates the hypothenuse as of the Pythagorean theorem.
  ///
  /// @param d1 the length of the first leg.
  /// @param d2 the length of the second leg.
  /// @return the length of the hypothenuse.
  static double pythagoras(double d1, double d2) {
    return sqrt(pow(d1, 2.0) + pow(d2, 2.0));
  }
}
