/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';

enum SmashThemes { LIGHT, DARK }

class ThemeState extends ChangeNotifier {
  static final List<ThemeData> themeData = [
    ThemeData(
      brightness: Brightness.light,
      primaryColor: SmashColors.mainDecorationsMc,
      primarySwatch: SmashColors.mainDecorationsMc,
      accentColor: SmashColors.mainSelectionMc,
      canvasColor: SmashColors.mainBackground,
      inputDecorationTheme: getInputdecoTheme(),
    ),
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: SmashColors.mainBackgroundDarkTheme,
      primarySwatch: SmashColors.mainDecorationsMcDarkTheme,
      accentColor: SmashColors.mainSelectionMcDarkTheme,
      canvasColor: SmashColors.mainBackgroundDarkTheme,
    )
  ];

  SmashThemes _currentTheme = SmashThemes.LIGHT;
  ThemeData _currentThemeData = themeData[0];

  void switchTheme() => currentTheme == SmashThemes.LIGHT ? currentTheme = SmashThemes.DARK : currentTheme = SmashThemes.LIGHT;

  set currentTheme(SmashThemes theme) {
    if (theme != null) {
      _currentTheme = theme;
      _currentThemeData = currentTheme == SmashThemes.LIGHT ? themeData[0] : themeData[1];

      notifyListeners();
    }
  }

  get currentTheme => _currentTheme;

  get currentThemeData => _currentThemeData;

  static InputDecorationTheme getInputdecoTheme() {
    return InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, SmashColors.mainDecorationsDarkR, SmashColors.mainDecorationsDarkG, SmashColors.mainDecorationsDarkB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, SmashColors.mainDecorationsDarkR, SmashColors.mainDecorationsDarkG, SmashColors.mainDecorationsDarkB)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, SmashColors.mainSelectionBorderR, SmashColors.mainSelectionBorderG, SmashColors.mainSelectionBorderB)),
      ),
//            labelStyle: const TextStyle(
//              color: Color.fromARGB(255, 128, 128, 128),
//            ),
    );
  }
}
