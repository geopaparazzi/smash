/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/gpx.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/worldimage.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';

const LAYERSKEY_FILE = 'file';
const LAYERSKEY_ISVECTOR = 'isVector';
const LAYERSKEY_LABEL = 'label';
const LAYERSKEY_ISVISIBLE = 'isvisible';
const LAYERSKEY_OPACITY = 'opacity';

/// A generic persistable layer source.
abstract class LayerSource {
  /// Convert the source to json for persistence.
  String toJson();

  Future<List<LayerOptions>> toLayers(BuildContext context);

  bool isActive();

  void setActive(bool active);

  String getAbsolutePath();

  String getUrl();

  String getName();

  String getAttribution();

  Future<LatLngBounds> getBounds();

  void disposeSource();

  bool isOnlineService() {
    return getUrl() != null;
  }

  bool operator ==(dynamic other) {
    if (other is LayerSource) {
      if (getUrl() != null && getUrl() != other.getUrl()) {
        return false;
      } else if (getAbsolutePath() != null &&
          (getName() != other.getName() ||
              getAbsolutePath() != other.getAbsolutePath())) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static List<LayerSource> fromJson(String json) {
    try {
      var map = jsonDecode(json);

      String file = map[LAYERSKEY_FILE];
      if (file != null && FileManager.isGpx(file)) {
        GpxSource gpx = GpxSource.fromMap(map);
        return [gpx];
      } else if (file != null && FileManager.isWorldImage(file)) {
        WorldImageSource world = WorldImageSource.fromMap(map);
        return [world];
      } else if (file != null && FileManager.isGeopackage(file)) {
        bool isVector = map[LAYERSKEY_ISVECTOR];
        if (isVector == null || !isVector) {
          TileSource ts = TileSource.fromMap(map);
          return [ts];
        } else {
          GeopackageSource gpkg = GeopackageSource.fromMap(map);
          return [gpkg];
        }
      } else {
        TileSource ts = TileSource.fromMap(map);
        return [ts];
      }
    } catch (e) {
      GpLogger().e("Error while loading layer: \n$json", e);
      return [];
    }
  }
}

abstract class VectorLayerSource extends LayerSource {
  Future<void> load(BuildContext context);
}

abstract class RasterLayerSource extends LayerSource {
  Future<void> load(BuildContext context);
}

final List<TileSource> onlinesTilesSources = [
  TileSource.Open_Street_Map_Standard(),
  TileSource.Open_Stree_Map_Cicle(),
  TileSource.Open_Street_Map_HOT(),
  TileSource.Stamen_Watercolor(),
  TileSource.Wikimedia_Map(),
];
