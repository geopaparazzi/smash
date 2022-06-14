/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/tools.dart';

class RulerState extends ChangeNotifier {
  static final type = BottomToolbarToolsRegistry.RULER;

  bool isEnabled = false;

  double? xTapPosition;
  double? yTapPosition;
  double? _lengthMeters;

  double? get lengthMeters => _lengthMeters;

  set lengthMeters(double? newLength) {
    _lengthMeters = newLength;
    notifyListeners();
  }

  void setTapAreaCenter(double x, double y) {
    xTapPosition = x;
    yTapPosition = y;
    notifyListeners();
  }

  void setEnabled(bool isEnabled) {
    this.isEnabled = isEnabled;
    if (isEnabled) {
      // when enabled the tap position is reset
      xTapPosition = null;
      yTapPosition = null;
    }
    notifyListeners();
  }
}
