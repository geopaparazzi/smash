/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

/// Class to handle screen issues, like size and orientation
class ScreenUtilities {
  /// Check if the screen is in large width mode, i.e. tablet or phone landscape
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Check if the device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if the device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static void keepScreenOn(bool keepOn) {
    Screen.keepOn(keepOn);
  }
}
