/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';

const DEBUG_NOTIFICATIONS = true;

class ChangeNotifierPlus with ChangeNotifier {
  void notifyListenersMsg([String msg]) {
    if (DEBUG_NOTIFICATIONS) {
      print(
          "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.now())}:: ${runtimeType.toString()}: ${msg ?? "notify triggered"}");
    }

    notifyListeners();
  }
}