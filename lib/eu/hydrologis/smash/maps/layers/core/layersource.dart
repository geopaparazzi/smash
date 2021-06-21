/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:core';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geoimage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/gpx.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/postgis.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/shapefile.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/wms.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

const LAYERSKEY_FILE = 'file';
const LAYERSKEY_URL = 'url';
const LAYERSKEY_USER = 'user';
const LAYERSKEY_PWD = 'pwd';
const LAYERSKEY_WHERE = 'where';
const LAYERSKEY_BOUNDS = 'bounds';
const LAYERSKEY_TYPE = 'type';
const LAYERSKEY_FORMAT = 'format';
const LAYERSKEY_ISVECTOR = 'isVector';
const LAYERSKEY_LABEL = 'label';
const LAYERSKEY_SRID = 'srid';
const LAYERSKEY_ISVISIBLE = 'isvisible';
const LAYERSKEY_OPACITY = 'opacity';
const LAYERSKEY_COLORTABLE = 'colortable';
const LAYERSKEY_COLORTOHIDE = 'colortohide';
const LAYERSKEY_ATTRIBUTION = 'attribution';
const LAYERSKEY_SUBDOMAINS = 'subdomains';
const LAYERSKEY_MINZOOM = 'minzoom';
const LAYERSKEY_MAXZOOM = 'maxzoom';
const LAYERSKEY_GPKG_DOOVERLAY = "geopackage_dooverlay";
const DEFAULT_MINZOOM = 1;
const DEFAULT_MAXZOOM = 19;

const LAYERSTYPE_WMS = 'wms';
const LAYERSTYPE_TMS = 'tms';
const LAYERSKEY_WMSVERSION = 'wmsversion';
const LAYERSTYPE_FORMAT_JPG = "image/jpeg";
const LAYERSTYPE_FORMAT_PNG = "image/png";
const LAYERSTYPE_FORMAT_TIFF = "image/tiff";

/// A generic persistable layer source.
abstract class LayerSource {
  /// Get the optional absolute file path, if file based.
  String getAbsolutePath();

  /// Get the optional URL if URL based.
  String getUrl();

  /// Get the name for this layerSource.
  String getName();

  String getUser();

  String getPassword();

  /// Get the optional attribution of the dataset.
  String getAttribution();

  /// Convert the current layer source to an array of layers
  /// with their data loaded and ready to be displayed in map.
  Future<List<LayerOptions>> toLayers(BuildContext context);

  /// Returns the active flag of the layer (usually visible/non visible).
  bool isActive();

  /// Toggle the active flag.
  void setActive(bool active);

  /// Get the bounds for the resource.
  Future<LatLngBounds> getBounds();

  /// Dispose the current layeresource.
  void disposeSource();

  /// Check if the layersource is online.
  bool isOnlineService() {
    return getUrl() != null;
  }

  /// Return true if the layersource supports zooming to bounds.
  bool isZoomable();

  /// Returns true if the layersource can be styled or configured.
  bool hasProperties();

  // Returns the widget to use to set the properties of the layer.
  Widget getPropertiesWidget();

  /// Convert the source to json for persistence.
  String toJson();

  /// Get the srid integer.
  ///
  /// For sources that only read the srid onLoad, calculateSrid might be necessary before to avoid loading all data.
  int getSrid();

  /// Get the proper icon for this layer.
  IconData getIcon();

  /// This can be used to calculate the srid if an async moment can be exploited and is necessary.
  ///
  /// After this getSrid is assured to have the right srid.
  void calculateSrid() {
    return;
  }

  /// Create a layersource from a presistence [json].
  static List<LayerSource> fromJson(String json) {
    try {
      var map = jsonDecode(json);

      String file = map[LAYERSKEY_FILE];
      String type = map[LAYERSKEY_TYPE];
      String url = map[LAYERSKEY_URL];
      if (type != null && type == LAYERSTYPE_WMS) {
        var wms = WmsSource.fromMap(map);
        return [wms];
      } else if (file != null && FileManager.isGpx(file)) {
        GpxSource gpx = GpxSource.fromMap(map);
        return [gpx];
      } else if (file != null && FileManager.isShp(file)) {
        ShapefileSource shp = ShapefileSource.fromMap(map);
        return [shp];
      } else if (file != null && FileManager.isWorldImage(file)) {
        GeoImageSource world = GeoImageSource.fromMap(map);
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
      } else if (url != null && url.toLowerCase().startsWith("postgis")) {
        PostgisSource pg = PostgisSource.fromMap(map);
        return [pg];
      } else {
        TileSource ts = TileSource.fromMap(map);
        return [ts];
      }
    } on Exception catch (e, s) {
      SMLogger().e("Error while loading layer: \n$json", e, s);
      return [];
    }
  }

  bool operator ==(dynamic other) {
    if (other is LayerSource) {
      if (getUrl() != null &&
          (getName() != other.getName() || getUrl() != other.getUrl())) {
        return false;
      }
      if (getAbsolutePath() != null &&
          (getName() != other.getName() ||
              getAbsolutePath() != other.getAbsolutePath())) {
        return false;
      }
      if (this is DbVectorLayerSource &&
          other is DbVectorLayerSource &&
          !areDbSame(this, other)) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  bool areDbSame(DbVectorLayerSource db1, DbVectorLayerSource db2) {
    var where1 = db1.getWhere() ?? "";
    var where2 = db2.getWhere() ?? "";
    var user1 = db1.getUser() ?? "";
    var user2 = db2.getUser() ?? "";
    var pwd1 = db1.getPassword() ?? "";
    var pwd2 = db2.getPassword() ?? "";
    return where1 == where2 && user1 == user2 && pwd1 == pwd2;
  }

  int get hashCode {
    var obj = [];
    if (getUrl() != null) {
      obj.add(getUrl());
    }
    if (getAbsolutePath() != null) {
      obj.add(getAbsolutePath());
    }
    if (getName() != null) {
      obj.add(getName());
    }
    if (this is DbVectorLayerSource) {
      if ((this as DbVectorLayerSource).getWhere() != null) {
        obj.add((this as DbVectorLayerSource).getWhere());
      }
      if ((this as DbVectorLayerSource).getUser() != null) {
        obj.add((this as DbVectorLayerSource).getUser());
      }
      if ((this as DbVectorLayerSource).getPassword() != null) {
        obj.add((this as DbVectorLayerSource).getPassword());
      }
    }

    return HashUtilities.hashObjects(obj);
  }
}

/// Interface for SLD supporting layersources.
abstract class SldLayerSource {
  void updateStyle(String sldString);
}

/// Interface for vector data based layersources.
abstract class VectorLayerSource extends LoadableLayerSource {}

/// Interface for database vector sources.
abstract class DbVectorLayerSource extends EditableVectorLayerSource {
  String getWhere();
  String getUser();
  String getPassword();

  dynamic get db;

  static Future<dynamic> getDb(LayerSource source) async {
    if (!(source is DbVectorLayerSource)) {
      return null;
    }
    DbVectorLayerSource dbSource = source;
    if (dbSource.db != null) {
      return dbSource.db;
    }
    if (dbSource is GeopackageSource) {
      return Future.value(
          ConnectionsHandler().open(dbSource.getAbsolutePath()));
    } else if (dbSource is PostgisSource) {
      return await PostgisConnectionsHandler().open(dbSource.getUrl(),
          dbSource.getName(), dbSource.getUser(), dbSource.getPassword());
    } else {
      throw ArgumentError("Layersource is not a db source: $source");
    }
  }

  static LayerSource fromMap(Map<String, dynamic> map) {
    var url = map[LAYERSKEY_URL];
    if (url != null && url.startsWith("postgis")) {
      return PostgisSource.fromMap(map);
    }
    var file = map[LAYERSKEY_FILE];
    var isVector = map[LAYERSKEY_ISVECTOR];
    if (file != null &&
        FileManager.isGeopackage(file) &&
        isVector != null &&
        isVector) {
      return GeopackageSource.fromMap(map);
    }

    return null;
  }

  static bool isDbVectorLayerSource(LayerSource source) {
    return source is GeopackageSource || source is PostgisSource;
  }
}

/// Interface for editable vector data based layersources.
abstract class EditableVectorLayerSource extends VectorLayerSource {}

/// Interface for raster data based layersources.
abstract class RasterLayerSource extends LoadableLayerSource {}

abstract class LoadableLayerSource extends LayerSource {
  bool isLoaded = false;

  Future<void> load(BuildContext context);
}

/// Interface for raster data based layersources.
abstract class TiledRasterLayerSource extends RasterLayerSource {}

/// List of default online tile layer sources.
final List<TileSource> onlinesTilesSources = [
  TileSource.Open_Street_Map_Standard(),
  TileSource.Wikimedia_Map(),
  TileSource.Opnvkarte_Transport(),
  TileSource.OpenTopoMap(),
  TileSource.Esri_Satellite(),
];
