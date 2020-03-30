/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';

/// The SMASH Colors list
///
/// https://material.io/tools/color/#!/?view.left=0&view.right=0&primary.color=1976D2&secondary.color=BF360C
class SmashColors {
  static final ColorExt mainBackground = ColorExt("#ffFFFFFF");
  static final ColorExt mainBackgroundDarkTheme = ColorExt("#00000000");

  static final ColorExt mainDecorations = ColorExt("#ff1976d2");
  static final ColorExt mainDecorationsDarkTheme = ColorExt("#ffe6e6e6");
  static const int mainDecorationsR = 25;
  static const int mainDecorationsG = 118;
  static const int mainDecorationsB = 210;

  static final ColorExt mainDecorationsDarker = ColorExt("#ff004ba0");
  static const int mainDecorationsDarkR = 0;
  static const int mainDecorationsDarkG = 75;
  static const int mainDecorationsDarkB = 160;

  static final ColorExt mainTextColor = ColorExt("#ff004ba0");
  static final ColorExt mainTextColorNeutral = ColorExt("#ff000000");

  static final ColorExt mainSelection = ColorExt("#ffbf360c");
  static final ColorExt mainSelectionDarkTheme = ColorExt("#800000");

  static final ColorExt mainSelectionBorder = ColorExt("#ff870000");
  static const int mainSelectionBorderR = 135;
  static const int mainSelectionBorderG = 0;
  static const int mainSelectionBorderB = 0;

  static final ColorExt mainDanger = ColorExt("#ffFF0000");
  static final ColorExt gpsNoPermission = ColorExt("#ffff8484");
  static final ColorExt gpsOnNoFix = ColorExt("#ffffd293");
  static final ColorExt gpsOnWithFix = ColorExt("#ff00ff08");
  static final ColorExt gpsLogging = ColorExt("#ff84beff");
  static final ColorExt gpsOff = ColorExt("#ffff8484");
  static final ColorExt snackBarColor = ColorExt("#daffffff");

  static final ColorExt tableBorder = mainDecorations;

  static final MaterialColor mainBackgroundMc = toMaterialColor(mainBackground);
  static final MaterialColor mainDecorationsMc =
      toMaterialColor(mainDecorations);
  static final MaterialColor mainDecorationsMcDarkTheme =
      toMaterialColor(mainDecorationsDarkTheme);
  static final MaterialColor mainDecorationsDarkerMc =
      toMaterialColor(mainDecorationsDarker);
  static final MaterialColor mainTextColorMc = toMaterialColor(mainTextColor);
  static final MaterialColor mainTextColorNeutralMc =
      toMaterialColor(mainTextColorNeutral);
  static final MaterialColor mainSelectionMc = toMaterialColor(mainSelection);
  static final MaterialColor mainSelectionMcDarkTheme =
      toMaterialColor(mainSelectionDarkTheme);
  static final MaterialColor mainSelectionBorderMc =
      toMaterialColor(mainSelectionBorder);
}

class SmashColorPalette {
  static const NAVY = const SmashColorPalette._("#001f3f");
  static const BLUE = const SmashColorPalette._("#0074D9");
  static const AQUA = const SmashColorPalette._("#7FDBFF");
  static const TEAL = const SmashColorPalette._("#39CCCC");
  static const OLIVE = const SmashColorPalette._("#3D9970");
  static const GREEN = const SmashColorPalette._("#2ECC40");
  static const LIME = const SmashColorPalette._("#01FF70");
  static const YELLOW = const SmashColorPalette._("#FFDC00");
  static const ORANGE = const SmashColorPalette._("#FF851B");
  static const RED = const SmashColorPalette._("#FF4136");
  static const MAROON = const SmashColorPalette._("#85144b");
  static const FUCHSIA = const SmashColorPalette._("#F012BE");
  static const PURPLE = const SmashColorPalette._("#B10DC9");
  static const BLACK = const SmashColorPalette._("#000000");
  static const GRAY = const SmashColorPalette._("#AAAAAA");
  static const SILVER = const SmashColorPalette._("#DDDDDD");
  static const WHITE = const SmashColorPalette._("#FFFFFF");

  static get values => [
        WHITE,
        YELLOW,
        ORANGE,
        RED,
        FUCHSIA,
        PURPLE,
        MAROON,
        LIME,
        GREEN,
        OLIVE,
        TEAL,
        AQUA,
        BLUE,
        NAVY,
        SILVER,
        GRAY,
        BLACK,
      ];

  static List<ColorSwatch> getColorSwatchValues() {
    List<ColorSwatch> colors = [];
    for (var o in values) {
      colors.add(toMaterialColor(ColorExt(o.colorHex)));
    }
    return colors;
  }

  final String colorHex;

  const SmashColorPalette._(this.colorHex);
}

/// The Geopaparazzi Colors list
class GeopaparazziColors {
  static final Color mainBackground = ColorExt("#ffFFFFFF");
  static final Color mainDecorations = ColorExt("#ff5d9d76");
  static final Color mainDecorationsDark = ColorExt("#ff378756");
  static final Color mainTextColor = ColorExt("#ff5d9d76");
  static final Color mainTextColorNeutral = ColorExt("#ff000000");
  static final Color mainSelection = ColorExt("#ffFF9933");
  static final Color mainSelectionBorder = ColorExt("ff#993300");
  static final Color mainDanger = ColorExt("#ffFF0000");
  static final Color gpsNoPermission = ColorExt("#ffff8484");
  static final Color gpsOnNoFix = ColorExt("#ffffd293");
  static final Color gpsOnWithFix = ColorExt("#ff00ff08");
  static final Color gpsLogging = ColorExt("#ff84beff");
  static final Color gpsOff = ColorExt("#ffff8484");
  static final Color snackBarColor = ColorExt("#daffffff");

  static final MaterialColor mainBackgroundMc = toMaterialColor(mainBackground);
  static final MaterialColor mainDecorationsMc =
      toMaterialColor(mainDecorations);
  static final MaterialColor mainDecorationsDarkMc =
      toMaterialColor(mainDecorationsDark);
  static final MaterialColor mainTextColorMc = toMaterialColor(mainTextColor);
  static final MaterialColor mainTextColorNeutralMc =
      toMaterialColor(mainTextColorNeutral);
  static final MaterialColor mainSelectionMc = toMaterialColor(mainSelection);
  static final MaterialColor mainSelectionBorderMc =
      toMaterialColor(mainSelectionBorder);
}

/// Converts a [Color] to a [MaterialColor].
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

/// The Flutter Color class Extended
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

  static ColorExt fromColor(Color color) {
    String hex = asHex(color);
    return ColorExt(hex);
  }

  static String asHex(Color color) {
    var hex = '#${color.value.toRadixString(16)}';
    return hex;
  }
}
