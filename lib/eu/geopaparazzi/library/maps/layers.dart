/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/layers.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/mapsforge.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

class TileSource {
  String label;
  String file;
  String url;
  int minZoom;
  int maxZoom;
  String attribution;
  List<String> subdomains = [];
  bool isVisible = true;
  bool isTms = false;

  TileSource({
    this.label,
    this.file,
    this.url,
    this.minZoom,
    this.maxZoom,
    this.attribution,
    this.subdomains: const <String>[],
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Open_Street_Map_Standard({
    this.label: "Open Street Map",
    this.url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.subdomains: const ['a', 'b', 'c'],
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Open_Stree_Map_Cicle({
    this.label: "Open Cicle Map",
    this.url: "https://tile.opencyclemap.org/cycle/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
  });

  TileSource.Open_Street_Map_HOT({
    this.label: "Open Street Map H.O.T.",
    this.url: "https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap, ODbL",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Stamen_Watercolor({
    this.label: "Stamen Watercolor",
    this.url: "https://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg",
    this.attribution:
        "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Wikimedia_Map({
    this.label: "Wikimedia Map",
    this.url: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png",
    this.attribution: "OpenStreetMap contributors, under ODbL",
    this.minZoom: 0,
    this.maxZoom: 20,
    this.isVisible: true,
    this.isTms: false,
  });

  TileSource.Esri_Satellite({
    this.label: "Esri Satellite",
    this.url:
        "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    this.attribution: "Esri",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
    this.isTms: true,
  });

  TileSource.Mapsforge(String filePath) {
    this.label = FileUtils.nameFromFile(filePath, false);
    this.file = filePath;
    this.attribution =
        "Map tiles by Mapsforge, Data by OpenStreetMap, under ODbL";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = false;
  }

  TileSource.Mbtiles(String filePath) {
    this.label = FileUtils.nameFromFile(filePath, false);
    this.file = filePath;
    this.attribution = "";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = true;
  }

  Future<TileLayerOptions> toTileLayer() async {
    if (file != null) {
      if (file.toLowerCase().endsWith("map")) {
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
          tms: isTms,
        );
      } else if (file.toLowerCase().endsWith("mbtiles")) {
        // mbtiles
        return TileLayerOptions(
            tileProvider: MBTilesImageProvider.fromFile(File(file)),
            maxZoom: maxZoom.toDouble(),
            backgroundColor: Colors.white,
            tms: true);
      }
    } else {
      return new TileLayerOptions(
        tms: isTms,
        urlTemplate: url,
        backgroundColor: SmashColors.mainBackground,
        maxZoom: maxZoom.toDouble(),
        subdomains: subdomains,
      );
    }
  }

  String toJson() {
    var json = '''
    {
        "label": "${label}",
        ${file != null ? "\"file\": \"$file\"," : ""}
        ${url != null ? "\"url\": \"$url\"," : ""}
        "minzoom": $minZoom,
        "maxzoom": $maxZoom,
        "attribution": "$attribution",
        "isvisible": $isVisible ${subdomains.length > 0 ? "," : ""}
        ${subdomains.length > 0 ? "\"subdomains\": \"${subdomains.join(',')}\"" : ""}
    }
    ''';
    return json;
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
      ..isVisible = map['isvisible'];

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
    List<String> blList = await GpPreferences().getBaseLayerInfoList();
    if (blList.length > 0) {
      _baseLayers = blList.map((json) => TileSource.fromJson(json)).toList();
    } else {
      _baseLayers = [TileSource.Open_Street_Map_Standard()..isVisible = true];
    }
    // TODO mbtiles part
  }

  List<TileSource> getActiveLayers() {
    var list = <TileSource>[];
    List<TileSource> where =
        _baseLayers.where((ts) => ts.isVisible ??= true).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    where = _mbtilesLayers.where((ts) => ts.isVisible ??= true).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    return list;
  }

  void addBaseLayerData(TileSource layerData) {
    _baseLayers.add(layerData);
  }

  List<TileSource> getAllLayers() {
    var list = <TileSource>[];
    list.addAll(_baseLayers);
    list.addAll(_mbtilesLayers);
    return list;
  }

  void removeTileSource(TileSource tileSourceItem) {
    if (_baseLayers.contains(tileSourceItem)) {
      _baseLayers.remove(tileSourceItem);
    }
    if (_mbtilesLayers.contains(tileSourceItem)) {
      _mbtilesLayers.remove(tileSourceItem);
    }
  }
}

class LayersPage extends StatefulWidget {
  Function _reloadFunction;
  Function _moveToFunction;

  LayersPage(this._reloadFunction, this._moveToFunction);

  @override
  State<StatefulWidget> createState() => LayersPageState();
}

class LayersPageState extends State<LayersPage> {
  bool _somethingChanged = false;

  @override
  Widget build(BuildContext context) {
    List<TileSource> _tsList = LayerManager().getAllLayers();

    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            GpPreferences().setBaseLayerInfoList(
                _tsList.map((ts) => ts.toJson()).toList());
            widget._reloadFunction();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tilesources list"),
          ),
          body: ListView.builder(
              itemCount: _tsList.length,
              itemBuilder: (context, index) {
                TileSource tileSourceItem = _tsList[index];
                return Dismissible(
                  confirmDismiss: _confirmLogDismiss,
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    LayerManager().removeTileSource(tileSourceItem);
                    if (tileSourceItem.isVisible) {
                      _somethingChanged = true;
                    }
                  },
                  key: ValueKey(tileSourceItem),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      tileSourceItem.file != null
                          ? tileSourceItem.file.endsWith("map")
                              ? FontAwesomeIcons.map
                              : FontAwesomeIcons.database
                          : FontAwesomeIcons.globe,
                      color: SmashColors.mainDecorations,
                      size: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                    ),
                    trailing: Checkbox(
                        value: tileSourceItem.isVisible,
                        onChanged: (isVisible) async {
                          tileSourceItem.isVisible = isVisible;
                          _somethingChanged = true;
                          setState(() {});
                        }),
                    title: Text('${tileSourceItem.label}'),
                    subtitle: Text('${tileSourceItem.attribution}'),
//                        onTap: () =>
//                            _navigateToLogProperties(context, tileSourceItem),
                    onLongPress: () async {
//                          var db = await gpProjectModel.getDatabase();
//                          LatLng position =
//                              await db.getLogStartPosition(tileSourceItem.id);
//                          widget._moveToFunction(position);
//                          Navigator.of(context).pop();
                    },
                  ),
                );
              }),
          floatingActionButton: AnimatedFloatingActionButton(
              fabButtons: <Widget>[
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      File file = await FilePicker.getFile(
                          type: FileType.ANY);
                      if (file != null) {
                        if (file.path.endsWith(".map")) {
                          TileSource ts = TileSource.Mapsforge(file.path);
                          LayerManager().addBaseLayerData(ts);
                          setState(() {});
                        } else if (file.path.endsWith(".mbtiles")) {
                          TileSource ts = TileSource.Mbtiles(file.path);
                          LayerManager().addBaseLayerData(ts);
                          setState(() {});
                        } else {
                          showWarningDialog(
                              context, "File format not supported.");
                        }
                      }
                    },
                    tooltip: "Load map/mbtiles files",
                    child: Icon(FontAwesomeIcons.map),
                    heroTag: null,
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      var selected = await showComboDialog(
                          context,
                          "Select online tile source",
                          onlinesTilesSources.map((ts) => ts.label).toList());
                      if (selected != null) {
                        var selectedTs = onlinesTilesSources
                            .where((ts) => ts.label == selected)
                            .first;
                        LayerManager().addBaseLayerData(selectedTs);
                        setState(() {});
                      }
                    },
                    tooltip: "Online Sources",
                    child: Icon(FontAwesomeIcons.globe),
                    heroTag: null,
                  ),
                ),
              ],
              colorStartAnimation: SmashColors.mainSelection,
              colorEndAnimation: SmashColors.mainSelectionBorder,
              animatedIconData: AnimatedIcons.menu_close //To principal button
              ),
        ));
  }

  Future<bool> _confirmLogDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove tilesource'),
            content: Text('Are you sure you want to remove the tilesource?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
            ],
          );
        });
  }
}
