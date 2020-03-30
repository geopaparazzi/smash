/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class MapProgressState extends ChangeNotifier {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  setInProgress(bool progress) {
    _inProgress = progress;
    notifyListeners();
  }
}
