/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class GeopaparazziColors {
  static Color mainBackground = ColorExt("#FFFFFF");
  static Color mainDecorations = ColorExt("#5d9d76");
  static Color mainDecorationsDark = ColorExt("#378756");
  static Color mainTextColor = ColorExt("#5d9d76");
  static Color mainTextColorNeutral = ColorExt("#000000");
  static Color mainSelection = ColorExt("#FF9933");
  static Color mainSelectionBorder = ColorExt("#993300");
  static Color gpsNoPermission = ColorExt("#ff8484");
  static Color gpsOnNoFix = ColorExt("#ffd293");
  static Color gpsOnWithFix = ColorExt("#00ff08");
  static Color gpsLogging = ColorExt("#84beff");
  static Color gpsOff = ColorExt("#ff8484");

  static MaterialColor mainBackgroundMc = toMaterialColor(mainBackground);
  static MaterialColor mainDecorationsMc = toMaterialColor(mainDecorations);
  static MaterialColor mainDecorationsDarkMc =
      toMaterialColor(mainDecorationsDark);
  static MaterialColor mainTextColorMc = toMaterialColor(mainTextColor);
  static MaterialColor mainTextColorNeutralMc =
      toMaterialColor(mainTextColorNeutral);
  static MaterialColor mainSelectionMc = toMaterialColor(mainSelection);
  static MaterialColor mainSelectionBorderMc =
      toMaterialColor(mainSelectionBorder);
}

MaterialColor toMaterialColor(Color color) {
  Map<int, Color> swatch = {
    50: color.withOpacity(.1),
    100: color.withOpacity(.2),
    200: color.withOpacity(.3),
    300: color.withOpacity(.4),
    400: color.withOpacity(.5),
    500: color.withOpacity(.6),
    600: color.withOpacity(.7),
    700: color.withOpacity(.8),
    800: color.withOpacity(.9),
    900: color.withOpacity(1),
  };
  MaterialColor colorMc = MaterialColor(color.value, swatch);
  return colorMc;
}

/// Color Extended
///
/// A color class that also allows to use hex and wkt colors in the constructor.
class ColorExt extends Color {
  static int _getColorFromHex(String hexOrNamedColor) {
    if (hexOrNamedColor.startsWith("#")) {
      hexOrNamedColor = hexOrNamedColor.toUpperCase().replaceAll("#", "");
      if (hexOrNamedColor.length == 6) {
        hexOrNamedColor = "FF" + hexOrNamedColor;
      }
      return int.parse(hexOrNamedColor, radix: 16);
    } else {
      // compatibility with older geopaparazzi
      String colorName = hexOrNamedColor.toLowerCase();
      switch (colorName) {
        case "red":
          return int.parse("ffd32f2f", radix: 16); //
        case "pink":
          return int.parse("ffc2185b", radix: 16); //
        case "purple":
          return int.parse("ff7b1fa2", radix: 16); //
        case "deep_purple":
          return int.parse("ff512da8", radix: 16); //
        case "indigo":
          return int.parse("ff303f9f", radix: 16); //
        case "blue":
          return int.parse("ff1976d2", radix: 16); //
        case "light_blue":
          return int.parse("ff0288d1", radix: 16); //
        case "cyan":
          return int.parse("ff0097a7", radix: 16); //
        case "teal":
          return int.parse("ff00796b", radix: 16); //
        case "green":
          return int.parse("ff00796b", radix: 16); //
        case "light_green":
          return int.parse("ff689f38", radix: 16); //
        case "lime":
          return int.parse("ffafb42b", radix: 16); //
        case "yellow":
          return int.parse("fffbc02d", radix: 16); //
        case "amber":
          return int.parse("ffffa000", radix: 16); //
        case "orange":
          return int.parse("fff57c00", radix: 16); //
        case "deep_orange":
          return int.parse("ffe64a19", radix: 16); //
        case "brown":
          return int.parse("ff5d4037", radix: 16); //
        case "grey":
          return int.parse("ff616161", radix: 16); //
        case "blue_grey":
          return int.parse("ff455a64", radix: 16); //
        case "white":
          return int.parse("ffffffff", radix: 16); //
        case "almost_black":
          return int.parse("ff212121", radix: 16); //
        default:
          return Colors.red.value;
      }
    }
  }

  ColorExt(final String hexColor) : super(_getColorFromHex(hexColor));
}
