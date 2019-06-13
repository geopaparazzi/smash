/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class GeopaparazziColors{
  static Color mainBackground = const ColorExt("#FFFFFF");
  static Color mainDecorations = ColorExt("#5d9d76");
  static Color mainDecorationsDark = ColorExt("#378756");
  static Color mainTextColor = ColorExt("#5d9d76");
  static Color mainTextColorNeutral = ColorExt("#000000");
  static Color mainSelection = ColorExt("#FF9933");
  static Color mainSelectionBorder = ColorExt("#993300");
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
          return int.parse("#d32f2f", radix: 16); //
        case "pink":
          return int.parse("#c2185b", radix: 16); //
        case "purple":
          return int.parse("#7b1fa2", radix: 16); //
        case "deep_purple":
          return int.parse("#512da8", radix: 16); //
        case "indigo":
          return int.parse("#303f9f", radix: 16); //
        case "blue":
          return int.parse("#1976d2", radix: 16); //
        case "light_blue":
          return int.parse("#0288d1", radix: 16); //
        case "cyan":
          return int.parse("#0097a7", radix: 16); //
        case "teal":
          return int.parse("#00796b", radix: 16); //
        case "green":
          return int.parse("#00796b", radix: 16); //
        case "light_green":
          return int.parse("#689f38", radix: 16); //
        case "lime":
          return int.parse("#afb42b", radix: 16); //
        case "yellow":
          return int.parse("#fbc02d", radix: 16); //
        case "amber":
          return int.parse("#ffa000", radix: 16); //
        case "orange":
          return int.parse("#f57c00", radix: 16); //
        case "deep_orange":
          return int.parse("#e64a19", radix: 16); //
        case "brown":
          return int.parse("#5d4037", radix: 16); //
        case "grey":
          return int.parse("#616161", radix: 16); //
        case "blue_grey":
          return int.parse("#455a64", radix: 16); //
        case "white":
          return int.parse("#ffffff", radix: 16); //
        case "almost_black":
          return int.parse("#212121", radix: 16); //
        default:
          return Colors.red.value;
      }
    }
  }

  ColorExt(final String hexColor) : super(_getColorFromHex(hexColor));
}
