/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/projection.dart';
import 'package:smash/eu/hydrologis/smash/maps/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/worldimage.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';
import 'package:sqflite/sqflite.dart';

import 'gpx.dart';
import 'mapsforge.dart';

abstract class LayerSource {
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

      String file = map['file'];
      if (file != null && FileManager.isGpx(file)) {
        GpxSource gpx = GpxSource.fromMap(map);
        return [gpx];
      } else if (file != null && FileManager.isWorldImage(file)) {
        WorldImageSource world = WorldImageSource.fromMap(map);
        return [world];
      } else if (file != null && FileManager.isGeopackage(file)) {
        bool isVector = map['isVector'];
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
    this.name = map['label'];
    var relativePath = map['file'];
    if (relativePath != null) {
      absolutePath = Workspace.makeAbsolute(relativePath);
    }
    this.url = map['url'];
    this.minZoom = map['minzoom'];
    this.maxZoom = map['maxzoom'];
    this.attribution = map['attribution'];
    this.isVisible = map['isvisible'];

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
    } else if (this.isOnlineService()) {
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

    var json = '''
    {
        "label": "$name",
        ${savePath != null ? "\"file\": \"$savePath\"," : ""}
        ${url != null ? "\"url\": \"$url\"," : ""}
        "minzoom": $minZoom,
        "maxzoom": $maxZoom,
        "attribution": "$attribution",
        "isvisible": $isVisible ${subdomains.isNotEmpty ? "," : ""}
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

final List<TileSource> onlinesTilesSources = [
  TileSource.Open_Street_Map_Standard(),
  TileSource.Open_Stree_Map_Cicle(),
  TileSource.Open_Street_Map_HOT(),
  TileSource.Stamen_Watercolor(),
  TileSource.Wikimedia_Map(),
];

class LayerManager {
  static final LayerManager _instance = LayerManager._internal();

  factory LayerManager() => _instance;

  List<LayerSource> _baseLayers = onlinesTilesSources;
  List<LayerSource> _vectorLayers = [];

  LayerManager._internal() {}

  Future<void> initialize() async {
    List<String> blList = await GpPreferences().getBaseLayerInfoList();
    if (blList.isNotEmpty) {
      _baseLayers = [];
      blList.forEach((json) {
        var fromJson = LayerSource.fromJson(json);
        _baseLayers.addAll(fromJson);
      });
    } else {
      _baseLayers = [TileSource.Open_Street_Map_Standard()..isVisible = true];
    }
    List<String> vlList = await GpPreferences().getVectorLayerInfoList();
    if (vlList.isNotEmpty) {
      _vectorLayers = [];
      vlList.forEach((json) {
        var fromJson = LayerSource.fromJson(json);
        _vectorLayers.addAll(fromJson);
      });
    }
  }

  List<LayerSource> getActiveLayers() {
    var list = <LayerSource>[];
    List<LayerSource> where = _baseLayers.where((ts) {
      if (ts.isActive()) {
        String file = ts.getAbsolutePath();
        if (file != null && file.isNotEmpty) {
          if (!File(file).existsSync()) {
            return false;
          }
        }
        return true;
      }
      return false;
    }).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    where = _vectorLayers.where((ts) => ts.isActive()).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    return list;
  }

  List<LayerSource> getActiveBaseLayers() {
    var list = <LayerSource>[];
    List<LayerSource> where = _baseLayers.where((ts) {
      if (ts.isActive()) {
        String file = ts.getAbsolutePath();
        if (file != null && file.isNotEmpty) {
          if (!File(file).existsSync()) {
            return false;
          }
        }
        return true;
      }
      return false;
    }).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    return list;
  }

  void addLayer(LayerSource layerData) {
    if ((layerData is TileSource || layerData is WorldImageSource) &&
        !_baseLayers.contains(layerData)) {
      _baseLayers.add(layerData);
    } else if (layerData is VectorLayerSource &&
        !_vectorLayers.contains(layerData)) {
      _vectorLayers.add(layerData);
    }
  }

  List<LayerSource> getAllLayers() {
    var list = <LayerSource>[];
    list.addAll(_baseLayers);
    list.addAll(_vectorLayers);
    return list;
  }

  void removeLayerSource(LayerSource sourceItem) {
    sourceItem.disposeSource();
    if (_baseLayers.contains(sourceItem)) {
      _baseLayers.remove(sourceItem);
    }
    if (_vectorLayers.contains(sourceItem)) {
      _vectorLayers.remove(sourceItem);
    }
  }
}

class LayersPage extends StatefulWidget {
  Function _reloadFunction;

  LayersPage(this._reloadFunction);

  @override
  State<StatefulWidget> createState() => LayersPageState();
}

class LayersPageState extends State<LayersPage> {
  bool _somethingChanged = false;

  @override
  Widget build(BuildContext context) {
    List<LayerSource> _layersList = LayerManager().getAllLayers();

    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            setLayersOnChange(_layersList);
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Layer List"),
          ),
          body: ListView.builder(
              itemCount: _layersList.length,
              itemBuilder: (context, index) {
                LayerSource layerSourceItem = _layersList[index];
                return Dismissible(
                  confirmDismiss: _confirmLogDismiss,
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (layerSourceItem.isActive()) {
                      _somethingChanged = true;
                    }
                    _layersList.removeAt(index);
                    LayerManager().removeLayerSource(layerSourceItem);
                  },
                  key: ValueKey(layerSourceItem),
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
                      SmashIcons.forPath(layerSourceItem.getAbsolutePath() ??
                          layerSourceItem.getUrl()),
                      color: SmashColors.mainDecorations,
                      size: SmashUI.MEDIUM_ICON_SIZE,
                    ),
                    trailing: Checkbox(
                        value: layerSourceItem.isActive(),
                        onChanged: (isVisible) async {
                          layerSourceItem.setActive(isVisible);
                          _somethingChanged = true;
                          setState(() {});
                        }),
                    title: Text('${layerSourceItem.getName()}'),
                    subtitle: Text('${layerSourceItem.getAttribution()}'),
                    onLongPress: () async {
                      LatLngBounds bb = await layerSourceItem.getBounds();
                      if (bb != null) {
                        setLayersOnChange(_layersList);

                        SmashMapState mapState =
                            Provider.of<SmashMapState>(context, listen: false);
                        mapState.setBounds(
                            new Envelope(bb.west, bb.east, bb.south, bb.north));
                        Navigator.of(context).pop();
                      }
                    },
                    onTap: () {
                      if (layerSourceItem is GpxSource) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GpxPropertiesWidget(
                                    layerSourceItem, widget._reloadFunction)));
                      } else if (layerSourceItem is WorldImageSource) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TiffPropertiesWidget(
                                    layerSourceItem, widget._reloadFunction)));
                      }
                    },
                  ),
                );
              }),
          floatingActionButton: AnimatedFloatingActionButton(
              fabButtons: <Widget>[
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      //Navigator.of(context).pop();
                      var lastUsedFolder = await Workspace.getLastUsedFolder();
                      var allowed = <String>[]
                        ..addAll(FileManager.ALLOWED_VECTOR_DATA_EXT)
                        ..addAll(FileManager.ALLOWED_RASTER_DATA_EXT)
                        ..addAll(FileManager.ALLOWED_TILE_DATA_EXT);
                      var selectedPath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FileBrowser(false, allowed, lastUsedFolder)));

                      if (selectedPath != null) {
                        await loadLayer(context, selectedPath);
                      }
                    },
                    tooltip: "Load spatial datasets",
                    child: Icon(MdiIcons.map),
                    heroTag: null,
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      var selected = await showComboDialog(
                          context,
                          "Select online tile source",
                          onlinesTilesSources.map((ts) => ts.name).toList());
                      if (selected != null) {
                        var selectedTs = onlinesTilesSources
                            .where((ts) => ts.name == selected)
                            .first;
                        LayerManager().addLayer(selectedTs);
                        setState(() {});
                      }
                    },
                    tooltip: "Online Sources",
                    child: Icon(MdiIcons.earth),
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

  void setLayersOnChange(List<LayerSource> _layersList) {
    List<String> baseLayers = [];
    List<String> vectorLayers = [];
    _layersList.forEach((layer) {
      if (layer is TileSource) {
        baseLayers.add(layer.toJson());
      }
      if (layer is VectorLayerSource) {
        vectorLayers.add(layer.toJson());
      }
    });

    GpPreferences().setBaseLayerInfoList(baseLayers);
    GpPreferences().setVectorLayerInfoList(vectorLayers);
    widget._reloadFunction();
  }

  Future<bool> _confirmLogDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove layer'),
            content: Text('Are you sure you want to remove the layer?'),
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

Future<bool> loadLayer(BuildContext context, String filePath) async {
  if (FileManager.isMapsforge(filePath)) {
    TileSource ts = TileSource.Mapsforge(filePath);
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isMbtiles(filePath)) {
    TileSource ts = TileSource.Mbtiles(filePath);
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isMapurl(filePath)) {
    TileSource ts = TileSource.Mapurl(filePath);
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isGpx(filePath)) {
    GpxSource gpxLayer = GpxSource(filePath);
    await gpxLayer.load(context);
    if (gpxLayer.hasData()) {
      LayerManager().addLayer(gpxLayer);
      return true;
    }
  } else if (FileManager.isWorldImage(filePath)) {
    var worldFile = WorldImageSource.getWorldFile(filePath);
    var prjFile = SmashPrj.getPrjForImage(filePath);
    if (worldFile == null) {
      showWarningDialog(context,
          "Only image files with world file definition are supported.");
    } else if (prjFile == null) {
      showWarningDialog(
          context, "Only image files with prj file definition are supported.");
    } else {
      WorldImageSource worldLayer = WorldImageSource(filePath);
      await worldLayer.load(context);
      if (worldLayer.hasData()) {
        LayerManager().addLayer(worldLayer);
        return true;
      }
    }
  } else if (FileManager.isGeopackage(filePath)) {
    var ch = ConnectionsHandler();
    try {
      var db = await ch.open(filePath);
      List<FeatureEntry> features = await db.features();
      features.forEach((f) {
        GeopackageSource gps = GeopackageSource(filePath, f.tableName);
        LayerManager().addLayer(gps);
        return true;
      });

      List<TileEntry> tiles = await db.tiles();
      tiles.forEach((t) {
        var ts = TileSource.Geopackage(filePath, t.tableName);
        LayerManager().addLayer(ts);
        return true;
      });
    } finally {
      await ch?.close(filePath);
    }
  } else {
    showWarningDialog(context, "File format not supported.");
  }
  return false;
}

class SmashMBTilesImageProvider extends TileProvider {
  final File mbtilesFile;

  Database _loadedDb;
  bool isDisposed = false;
  LatLngBounds _bounds;
  Uint8List _emptyImageBytes;

  SmashMBTilesImageProvider(this.mbtilesFile);

  Future<Database> open() async {
    if (_loadedDb == null) {
      _loadedDb = await openDatabase(mbtilesFile.path);

      try {
        String boundsSql = "select value from metadata where name='bounds'";
        List<Map> result = await _loadedDb.rawQuery(boundsSql);
        String boundsString = result.first['value'];
        List<String> boundsSplit =
            boundsString.split(","); //left, bottom, right, top
        LatLngBounds b = LatLngBounds();
        b.extend(
            LatLng(double.parse(boundsSplit[1]), double.parse(boundsSplit[0])));
        b.extend(
            LatLng(double.parse(boundsSplit[3]), double.parse(boundsSplit[2])));
        _bounds = b;

        ByteData imageData = await rootBundle.load('assets/emptytile256.png');
        _emptyImageBytes = imageData.buffer.asUint8List();

//        UI.Image _emptyImage = await ImageWidgetUtilities.transparentImage();
//        var byteData = await _emptyImage.toByteData(format: UI.ImageByteFormat.png);
//        _emptyImageBytes = byteData.buffer.asUint8List();

      } catch (e) {
        GpLogger().err("Error getting mbtiles bounds or empty image.", e);
      }

      if (isDisposed) {
        await _loadedDb.close();
        _loadedDb = null;
        throw Exception('Tileprovider is already disposed');
      }
    }

    return _loadedDb;
  }

  LatLngBounds get bounds => this._bounds;

  @override
  void dispose() {
    if (_loadedDb != null) {
      _loadedDb.close();
      _loadedDb = null;
    }
    isDisposed = true;
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    var x = coords.x.round();
    var y = options.tms
        ? invertY(coords.y.round(), coords.z.round())
        : coords.y.round();
    var z = coords.z.round();

    return SmashMBTileImage(
        _loadedDb, Coords<int>(x, y)..z = z, _emptyImageBytes);
  }
}

class SmashMBTileImage extends ImageProvider<SmashMBTileImage> {
  final Database database;
  final Coords<int> coords;
  Uint8List _emptyImageBytes;

  SmashMBTileImage(this.database, this.coords, this._emptyImageBytes);

  @override
  ImageStreamCompleter load(SmashMBTileImage key, DecoderCallback decoder) {
    // TODo check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<ImageProvider>('Image key', key);
        });
  }

  Future<UI.Codec> _loadAsync(SmashMBTileImage key) async {
    assert(key == this);

    final db = key.database;
    List<Map> result = await db.rawQuery('select tile_data from tiles '
        'where zoom_level = ${coords.z} AND '
        'tile_column = ${coords.x} AND '
        'tile_row = ${coords.y} limit 1');
    Uint8List bytes = result.isNotEmpty ? result.first['tile_data'] : null;

    if (bytes == null) {
      if (_emptyImageBytes != null) {
        bytes = _emptyImageBytes;
      } else {
        return Future<UI.Codec>.error(
            'Failed to load tile for coords: $coords');
      }
    }
    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  Future<SmashMBTileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(other) {
    return other is SmashMBTileImage && coords == other.coords;
  }
}

class GeopackageImageProvider extends TileProvider {
  final File geopackageFile;
  final String tableName;

  GeopackageDb _loadedDb;
  bool isDisposed = true;
  LatLngBounds _bounds;
  Uint8List _emptyImageBytes;

  GeopackageImageProvider(this.geopackageFile, this.tableName);

  Future<GeopackageDb> open() async {
    if (_loadedDb == null || !_loadedDb.isOpen()) {
      var ch = ConnectionsHandler();
      _loadedDb = await ch.open(geopackageFile.path, tableName: tableName);
    }
    if (isDisposed) {
      await _loadedDb.openOrCreate();

      try {
        TileEntry tile = await _loadedDb.tile(tableName);
        Envelope bounds = tile.getBounds();
        Envelope bounds4326 = MercatorUtils.convert3857To4326Env(bounds);
        var w = bounds4326.getMinX();
        var e = bounds4326.getMaxX();
        var s = bounds4326.getMinY();
        var n = bounds4326.getMaxY();

        LatLngBounds b = LatLngBounds();
        b.extend(LatLng(s, w));
        b.extend(LatLng(n, e));
        _bounds = b;

        ByteData imageData = await rootBundle.load('assets/emptytile256.png');
        _emptyImageBytes = imageData.buffer.asUint8List();

//        UI.Image _emptyImage = await ImageWidgetUtilities.transparentImage();
//        var byteData = await _emptyImage.toByteData(format: UI.ImageByteFormat.png);
//        _emptyImageBytes = byteData.buffer.asUint8List();

      } catch (e) {
        GpLogger().err("Error getting geopackage bounds or empty image.", e);
      }

      isDisposed = false;
    }

    return _loadedDb;
  }

  LatLngBounds get bounds => this._bounds;

  @override
  void dispose() {
    // dispose of db connections is done when layers are removed
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    var x = coords.x.round();
    var y = options.tms
        ? invertY(coords.y.round(), coords.z.round())
        : coords.y.round();
    var z = coords.z.round();

    return GeopackageImage(geopackageFile.path, tableName,
        Coords<int>(x, y)..z = z, _emptyImageBytes);
  }
}

class GeopackageImage extends ImageProvider<GeopackageImage> {
  final String databasePath;
  String tableName;
  final Coords<int> coords;
  Uint8List _emptyImageBytes;

  GeopackageImage(
      this.databasePath, this.tableName, this.coords, this._emptyImageBytes);

  @override
  ImageStreamCompleter load(GeopackageImage key, DecoderCallback decoder) {
    // TODo check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<ImageProvider>('Image key', key);
        });
  }

  Future<UI.Codec> _loadAsync(GeopackageImage key) async {
    assert(key == this);

    final db = await ConnectionsHandler()
        .open(key.databasePath, tableName: key.tableName);
    var tileBytes = await db.getTile(tableName, coords.x, coords.y, coords.z);
    if (tileBytes != null) {
      Uint8List bytes = tileBytes;
      return await PaintingBinding.instance.instantiateImageCodec(bytes);
    } else {
      // TODO get from other zoomlevels
      if (_emptyImageBytes != null) {
        var bytes = _emptyImageBytes;
        return await PaintingBinding.instance.instantiateImageCodec(bytes);
      } else {
        return Future<UI.Codec>.error(
            'Failed to load tile for coords: $coords');
      }
    }
  }

  @override
  Future<GeopackageImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(other) {
    return other is GeopackageImage && coords == other.coords;
  }
}
