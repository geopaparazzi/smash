/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/files.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/logging.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/share.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/mapsforge.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/validators.dart';

class TileSource {
  String label;
  String file;
  String url;
  int minZoom;
  int maxZoom;
  String attribution;
  List<String> subdomains = [];
  bool isVisible = false;

  TileSource(
      {this.label,
      this.file,
      this.url,
      this.minZoom,
      this.maxZoom,
      this.attribution,
      this.subdomains,
      this.isVisible});

  TileSource.Open_Street_Map_Standard({
    this.label: "Open Street Map",
    this.url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.subdomains: const ['a', 'b', 'c'],
  });

  TileSource.Open_Stree_Map_Cicle({
    this.label: "Open Cicle Map",
    this.url: "https://tile.opencyclemap.org/cycle/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
  });

  TileSource.Open_Street_Map_HOT({
    this.label: "Open Street Map H.O.T.",
    this.url: "https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
  });

  TileSource.Stamen_Watercolor({
    this.label: "Stamen Terrain",
    this.url: "https://tile.stamen.com/watercolor/{z}/{x}/{y}.png",
    this.attribution:
        "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
  });

  TileSource.Stamen_Terrain({
    this.label: "Stamen Terrain",
    this.url: "https://tile.stamen.com/terrain/{z}/{x}/{y}.png",
    this.attribution:
        "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
  });

  TileSource.Wikimedia_Map({
    this.label: "Wikimedia Map",
    this.url: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap contributors, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
  });

  TileSource.Esri_Satellite({
    this.label: "Esri Satellite",
    this.url:
        "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{x}/{y}.png",
    this.attribution: "Esri",
    this.minZoom: 0,
    this.maxZoom: 19,
  });

  TileSource.Mapsforge(String filePath) {
    this.file = filePath;
    this.attribution =
        "Map tiles by Mapsforge, Data by OpenStreetMap, under ODbL";
    this.minZoom = 0;
    this.maxZoom = 22;
  }

  Future<TileLayerOptions> toTileLayer() async {
    if (file != null) {
      // mapsforge
      double tileSize = 256;
      var mapsforgeTileProvider =
          MapsforgeTileProvider(File(file), tileSize: tileSize);
      await mapsforgeTileProvider.open();
      return new TileLayerOptions(
        tileProvider: mapsforgeTileProvider,
        tileSize: tileSize,
        keepBuffer: 2,
        backgroundColor: SmashColors.mainBackground,
        maxZoom: 21,
      );
    } else {
      return new TileLayerOptions(
        urlTemplate: url,
        backgroundColor: SmashColors.mainBackground,
        maxZoom: maxZoom.toDouble(),
        subdomains: subdomains,
      );
    }
  }

  String toJson() {
    return '''
        label: '${label}',
        ${file != null ? "file: '$file'," : ""}
        ${url != null ? "url: '$url'," : ""}
        minzoom: $minZoom,
        maxzoom: $maxZoom,
        attribution: '$attribution',
        isvisible: $isVisible,
        ${subdomains.length > 0 ? "${subdomains.join(',')}," : ""}
    ''';
  }

  static TileSource fromJson(String json) {
    var map = jsonDecode(json);
    TileSource ts = TileSource()
      ..label = map['label']
      ..file = map['file']
      ..url = map['url']
      ..minZoom = map['minzoom']
      ..maxZoom = map['maxzoom']
      ..attribution = map['attribution']
      ..isVisible = map['isVisible'];

    var subDomains = map['subdomains'] as String;
    if (subDomains != null) {
      ts.subdomains = subDomains.split(",");
    }
    return ts;
  }
}

final List<TileSource> onlinesTilesSources = [
  TileSource.Open_Street_Map_Standard(),
  TileSource.Open_Stree_Map_Cicle(),
  TileSource.Open_Street_Map_HOT(),
  TileSource.Stamen_Watercolor(),
  TileSource.Stamen_Terrain(),
  TileSource.Wikimedia_Map(),
  TileSource.Esri_Satellite(),
];

class LayerManager {
  static final LayerManager _instance = LayerManager._internal();

  factory LayerManager() => _instance;

  List<TileSource> _baseLayers = onlinesTilesSources;
  List<TileSource> _mbtilesLayers = [];

  LayerManager._internal() {}

  void initialize() async {
    var blList = await GpPreferences().getBaseLayerInfoList();
    if (blList.length > 0) {
      _baseLayers = blList.map((json) => TileSource.fromJson(json));
    } else {
      _baseLayers = [TileSource.Open_Street_Map_Standard()];
    }
    // TODO mbtiles part
  }

  List<TileSource> getActiveLayers() {
    var list = <TileSource>[];
    list.addAll(_baseLayers.where((ts) => ts.isVisible));
    list.addAll(_mbtilesLayers.where((ts) => ts.isVisible));
    return list;
  }

  void addBaseLayerData(TileSource layerData) {
    _baseLayers.add(layerData);
  }

  List<TileSource> getAllLayers() {
    var list = [];
    list.addAll(_baseLayers);
    list.addAll(_mbtilesLayers);
    return list;
  }
}
