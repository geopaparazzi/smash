/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class GeometryEditorState extends ChangeNotifier {
  bool _isEnabled = false;

  set isEnabled(bool isEnabled) {
    this._isEnabled = isEnabled;
    notifyListeners();
  }

  bool get isEnabled => _isEnabled;
}
