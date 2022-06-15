/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';

const DEBUG_NOTIFICATIONS = false;

class ChangeNotifierPlus with ChangeNotifier {
  void notifyListenersMsg([String? msg]) {
    if (DEBUG_NOTIFICATIONS) {
      print(
          "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.now())}:: ${runtimeType.toString()}: ${msg ?? "notify triggered"}");
    }

    notifyListeners();
  }
}
