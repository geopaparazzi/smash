/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/smash/maps/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers.dart';

class InfoToolState extends ChangeNotifier {
  bool isEnabled = false;
  bool isSearching = false;

  double xTapPosition;
  double yTapPosition;
  double tapRadius;

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

  void setSearching(bool isSearching) {
    this.isSearching = isSearching;
    notifyListeners();
  }

  void tappedOn(LatLng tapLatLong, BuildContext context) async {
    if (isEnabled) {
      var env = Envelope.fromCoordinate(
          Coordinate(tapLatLong.longitude, tapLatLong.latitude));
      env.expandByDistance(0.001);
      List<LayerSource> visibleVectorLayers = LayerManager()
          .getActiveLayers()
          .where((l) => l is VectorLayerSource && l.isActive())
          .toList();
      for (var vLayer in visibleVectorLayers) {
        if (vLayer is GeopackageSource) {
          var db = await ConnectionsHandler().open(vLayer.getAbsolutePath());
          QueryResult queryResult =
              await db.getTableData(vLayer.getName(), envelope: env);
          if (queryResult.data.isNotEmpty) {
            print("Found data for: " + vLayer.getName());
          }
        }
      }
    }
  }
}
