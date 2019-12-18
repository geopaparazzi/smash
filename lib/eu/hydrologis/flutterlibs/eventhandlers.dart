/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'geo/geo.dart';

/// Main event handler that takes care of centering on map,
/// updating gps status and reloading projects, layers and
/// map on new center.
class MainEventHandler {
  Function reloadLayersFunction;
  Function reloadProjectFunction;
  Function moveToFunction;

  MainEventHandler(this.reloadLayersFunction, this.reloadProjectFunction,
      this.moveToFunction);

}
