/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/mapsforge.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/mbtiles.dart';

class TileSource extends LayerSource {
  String name;
  String absolutePath;
  String url;
  int minZoom;
  int maxZoom;
  String attribution;
  LatLngBounds bounds;
  List<String> subdomains = [];
  bool isVisible = true;
  bool isTms = false;
  bool isWms = false;

  TileSource({
    this.name,
    this.absolutePath,
    this.url,
    this.minZoom,
    this.maxZoom,
    this.attribution,
    this.subdomains: const <String>[],
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.fromMap(Map<String, dynamic> map) {
    this.name = map[LAYERSKEY_LABEL];
    var relativePath = map[LAYERSKEY_FILE];
    if (relativePath != null) {
      absolutePath = Workspace.makeAbsolute(relativePath);
    }
    this.url = map[LAYERSKEY_URL];
    this.minZoom = map[LAYERSKEY_MINZOOM];
    this.maxZoom = map[LAYERSKEY_MAXZOOM];
    this.attribution = map[LAYERSKEY_ATTRIBUTION];
    this.isVisible = map[LAYERSKEY_ISVISIBLE];

    var subDomains = map['subdomains'] as String;
    if (subDomains != null) {
      this.subdomains = subDomains.split(",");
    }
  }

  TileSource.Open_Street_Map_Standard({
    this.name: "Open Street Map",
    this.url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.subdomains: const ['a', 'b', 'c'],
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Open_Stree_Map_Cicle({
    this.name: "Open Cicle Map",
    this.url: "https://tile.opencyclemap.org/cycle/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
  });

  TileSource.Open_Street_Map_HOT({
    this.name: "Open Street Map H.O.T.",
    this.url: "https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Stamen_Watercolor({
    this.name: "Stamen Watercolor",
    this.url: "https://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg",
    this.attribution:
        "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Wikimedia_Map({
    this.name: "Wikimedia Map",
    this.url: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap contributors, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Esri_Satellite({
    this.name: "Esri Satellite",
    this.url:
        "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    this.attribution: "Esri",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
    this.isTms: true,
  });

  TileSource.Mapsforge(String filePath) {
    this.name = FileUtilities.nameFromFile(filePath, false);
    this.absolutePath = Workspace.makeAbsolute(filePath);
    this.attribution =
        "Map tiles by Mapsforge, Data by OpenStreetMap, under ODbL";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = false;
  }

  TileSource.Mapurl(String filePath) {
    //        url=http://tile.openstreetmap.org/ZZZ/XXX/YYY.png
    //        minzoom=0
    //        maxzoom=19
    //        center=11.42 46.8
    //        type=google
    //        format=png
    //        defaultzoom=13
    //        mbtiles=defaulttiles/_mapnik.mbtiles
    //        description=Mapnik - Openstreetmap Slippy Map Tileserver - Data, imagery and map information provided by MapQuest, OpenStreetMap and contributors, ODbL.

    this.name = FileUtilities.nameFromFile(filePath, false);

    var paramsMap = FileUtilities.readFileToHashMap(filePath);

    String type = paramsMap["type"] ?? "tms";
    if (type.toLowerCase() == "wms") {
      throw ArgumentError("WMS mapurls are not supported at the time.");
      // TODO work on fixing WMS support, needs more love
//      String layer = paramsMap["layer"];
//      if (layer != null) {
//        this.name = layer;
//        this.isWms = true;
//      }
    }

    String url = paramsMap["url"];
    if (url == null) {
      throw ArgumentError("The url for the service needs to be defined.");
    }
    url = url.replaceFirst("ZZZ", "{z}");
    url = url.replaceFirst("YYY", "{y}");
    url = url.replaceFirst("XXX", "{x}");

    String maxZoomStr = paramsMap["maxzoom"] ?? "19";
    int maxZoom = double.parse(maxZoomStr).toInt();
    String minZoomStr = paramsMap["minzoom"] ?? "0";
    int minZoom = double.parse(minZoomStr).toInt();
    String descr = paramsMap["description"] ?? "no description";

    this.url = url;
    this.attribution = descr;
    this.minZoom = minZoom;
    this.maxZoom = maxZoom;
    this.isVisible = true;
    this.isTms = type == "tms";
  }

  TileSource.Mbtiles(String filePath) {
    this.name = FileUtilities.nameFromFile(filePath, false);
    this.absolutePath = Workspace.makeAbsolute(filePath);
    this.attribution = "";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = true;
  }

  TileSource.Geopackage(String filePath, String tableName) {
    this.name = tableName;
    this.absolutePath = Workspace.makeAbsolute(filePath);
    this.attribution = "";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = true;
  }

  String getAbsolutePath() {
    return absolutePath;
  }

  String getUrl() {
    return url;
  }

  String getName() {
    return name;
  }

  String getAttribution() {
    return attribution;
  }

  bool isActive() {
    return isVisible;
  }

  void setActive(bool active) {
    isVisible = active;
  }

  Future<LatLngBounds> getBounds() async {
    if (FileManager.isMapsforge(getAbsolutePath())) {
      return await getMapsforgeBounds(File(absolutePath));
    } else if (FileManager.isMbtiles(getAbsolutePath())) {
      var prov = SmashMBTilesImageProvider(File(absolutePath));
      await prov.open();
      var bounds = prov.bounds;
      prov.dispose();
      return bounds;
    } else if (FileManager.isGeopackage(getAbsolutePath())) {
      var prov = GeopackageImageProvider(File(absolutePath), name);
      await prov.open();
      var bounds = prov.bounds;
      prov.dispose();
      return bounds;
    }
    return null;
  }

  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    if (FileManager.isMapsforge(getAbsolutePath())) {
      // mapsforge
      double tileSize = 256;
      var mapsforgeTileProvider =
          MapsforgeTileProvider(File(absolutePath), tileSize: tileSize);
      await mapsforgeTileProvider.open();
      return [
        TileLayerOptions(
          tileProvider: mapsforgeTileProvider,
          tileSize: tileSize,
          keepBuffer: 2,
          backgroundColor: Colors.white.withOpacity(0),
          maxZoom: 21,
          tms: isTms,
        )
      ];
    } else if (FileManager.isMbtiles(getAbsolutePath())) {
      var tileProvider = SmashMBTilesImageProvider(File(absolutePath));
      await tileProvider.open();
      // mbtiles
      return [
        TileLayerOptions(
          tileProvider: tileProvider,
          maxZoom: maxZoom.toDouble(),
          backgroundColor: Colors.white.withOpacity(0),
          tms: true,
        )
      ];
    } else if (FileManager.isGeopackage(getAbsolutePath())) {
      var tileProvider = GeopackageImageProvider(File(absolutePath), name);
      await tileProvider.open();
      return [
        TileLayerOptions(
          tileProvider: tileProvider,
          maxZoom: maxZoom.toDouble(),
          backgroundColor: Colors.white.withOpacity(0),
          tms: true,
        )
      ];
    } else if (isOnlineService()) {
      if (isWms) {
        return [
          TileLayerOptions(
            wmsOptions: WMSTileLayerOptions(
              baseUrl: url,
              layers: [name],
            ),
            backgroundColor: Colors.white.withOpacity(0),
            maxZoom: maxZoom.toDouble(),
          )
        ];
      } else {
        return [
          TileLayerOptions(
            tms: isTms,
            urlTemplate: url,
            backgroundColor: Colors.white.withOpacity(0),
            maxZoom: maxZoom.toDouble(),
            subdomains: subdomains,
          )
        ];
      }
    } else {
      throw Exception(
          "Type not supported: ${absolutePath != null ? absolutePath : url}");
    }
  }

  String toJson() {
    String savePath;
    if (absolutePath != null) {
      savePath = Workspace.makeRelative(absolutePath);
    }

    var pathLine =
        savePath != null ? "\"$LAYERSKEY_FILE\": \"$savePath\"," : "";
    var urlLine = url != null ? "\"$LAYERSKEY_URL\": \"$url\"," : "";

    var json = '''
    {
        "$LAYERSKEY_LABEL": "$name",
        $pathLine
        $urlLine
        "$LAYERSKEY_MINZOOM": $minZoom,
        "$LAYERSKEY_MAXZOOM": $maxZoom,
        "$LAYERSKEY_ATTRIBUTION: "$attribution",
        "$LAYERSKEY_TYPE": "$LAYERSTYPE_TMS",
        "$LAYERSKEY_ISVISIBLE": $isVisible ${subdomains.isNotEmpty ? "," : ""}
        ${subdomains.isNotEmpty ? "\"subdomains\": \"${subdomains.join(',')}\"" : ""}
    }
    ''';
    return json;
  }

  @override
  void disposeSource() {
    ConnectionsHandler().close(getAbsolutePath(), tableName: getName());
  }
}
