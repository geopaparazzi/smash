/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as IMG;

import 'gpx.dart';
import 'mapsforge.dart';

abstract class LayerSource {
  String toJson();

  Future<List<LayerOptions>> toLayers(Function showSnackbar);

  bool isActive();

  void setActive(bool active);

  String getFile();

  String getUrl();

  String getLabel();

  String getAttribution();

  Future<LatLngBounds> getBounds();

  bool isMapsforge() {
    return getFile() != null && getFile().toLowerCase().endsWith("map");
  }

  bool isMbtiles() {
    return getFile() != null && getFile().toLowerCase().endsWith("mbtiles");
  }

  bool isGpx() {
    return getFile() != null && getFile().toLowerCase().endsWith("gpx");
  }

  bool isOnlineService() {
    return getUrl() != null;
  }

  bool operator ==(dynamic other) {
    if (other is LayerSource) {
      if (getFile() != null && getFile() == other.getFile()) {
        return true;
      } else if (getUrl() != null && getUrl() == other.getUrl()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static List<LayerSource> fromJson(String json) {
    try {
      var map = jsonDecode(json);

      String file = map['file'];
      if (file != null && file.endsWith("gpx")) {
        GpxSource gpx = GpxSource.fromMap(map);
        return [gpx];
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

abstract class VectorLayerSource extends LayerSource {}

class TileSource extends LayerSource {
  String label;
  String file;
  String url;
  int minZoom;
  int maxZoom;
  String attribution;
  LatLngBounds bounds;
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

  TileSource.fromMap(Map<String, dynamic> map) {
    this.label = map['label'];
    this.file = map['file'];
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
    this.attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL",
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
    this.url: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
    this.attribution: "Esri",
    this.minZoom: 0,
    this.maxZoom: 19,
    this.isVisible: true,
    this.isTms: true,
  });

  TileSource.Mapsforge(String filePath) {
    this.label = FileUtilities.nameFromFile(filePath, false);
    this.file = filePath;
    this.attribution = "Map tiles by Mapsforge, Data by OpenStreetMap, under ODbL";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = false;
  }

  TileSource.Mbtiles(String filePath) {
    this.label = FileUtilities.nameFromFile(filePath, false);
    this.file = filePath;
    this.attribution = "";
    this.minZoom = 0;
    this.maxZoom = 22;
    this.isVisible = true;
    this.isTms = true;
  }

  String getFile() {
    return file;
  }

  String getUrl() {
    return url;
  }

  String getLabel() {
    return label;
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
    if (this.isMapsforge()) {
      return await getMapsforgeBounds(File(file));
    } else if (this.isMbtiles()) {
      var prov = SmashMBTilesImageProvider(File(file));
      await prov.open();
      var bounds = prov.bounds;
      prov.dispose();
      return bounds;
    }
    return null;
  }

  Future<List<LayerOptions>> toLayers(Function showSnackbar) async {
    if (this.isMapsforge()) {
      // mapsforge
      double tileSize = 256;
      var mapsforgeTileProvider = MapsforgeTileProvider(File(file), tileSize: tileSize);
      await mapsforgeTileProvider.open();
      return [
        TileLayerOptions(
          tileProvider: mapsforgeTileProvider,
          tileSize: tileSize,
          keepBuffer: 2,
          backgroundColor: SmashColors.mainBackground,
          maxZoom: 21,
          tms: isTms,
        )
      ];
    } else if (this.isMbtiles()) {
      var tileProvider = SmashMBTilesImageProvider(File(file));
      // mbtiles
      return [TileLayerOptions(tileProvider: tileProvider, maxZoom: maxZoom.toDouble(), backgroundColor: Colors.white, tms: true)];
    } else if (this.isOnlineService()) {
      return [
        TileLayerOptions(
          tms: isTms,
          urlTemplate: url,
          backgroundColor: SmashColors.mainBackground,
          maxZoom: maxZoom.toDouble(),
          subdomains: subdomains,
        )
      ];
    } else {
      throw Exception("Type not supported: ${file != null ? file : url}");
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
        "isvisible": $isVisible ${subdomains.isNotEmpty ? "," : ""}
        ${subdomains.isNotEmpty ? "\"subdomains\": \"${subdomains.join(',')}\"" : ""}
    }
    ''';
    return json;
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
        String file = ts.getFile();
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
//    where = _mbtilesLayers.where((ts) => ts.isActive()).toList();
//    if (where.isNotEmpty) list.addAll(where.toList());
    where = _vectorLayers.where((ts) => ts.isActive()).toList();
    if (where.isNotEmpty) list.addAll(where.toList());
    return list;
  }

  void addLayer(LayerSource layerData) {
    if (layerData is TileSource && !_baseLayers.contains(layerData)) {
      _baseLayers.add(layerData);
    } else if (layerData is GpxSource && !_vectorLayers.contains(layerData)) {
      _vectorLayers.add(layerData);
    }
  }

  List<LayerSource> getAllLayers() {
    var list = <LayerSource>[];
    list.addAll(_baseLayers);
//    list.addAll(_mbtilesLayers);
    list.addAll(_vectorLayers);
    return list;
  }

  void removeLayerSource(LayerSource sourceItem) {
    if (_baseLayers.contains(sourceItem)) {
      _baseLayers.remove(sourceItem);
    }
//    if (_mbtilesLayers.contains(sourceItem)) {
//      _mbtilesLayers.remove(sourceItem);
//    }
    if (_vectorLayers.contains(sourceItem)) {
      _vectorLayers.remove(sourceItem);
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
                    LayerManager().removeLayerSource(layerSourceItem);
                    if (layerSourceItem.isActive()) {
                      _somethingChanged = true;
                    }
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
                      layerSourceItem.getFile() != null
                          ? layerSourceItem.getFile().endsWith("map")
                              ? MdiIcons.map
                              : layerSourceItem.getFile().endsWith("gpx") ? MdiIcons.mapMarker : MdiIcons.database
                          : MdiIcons.earth,
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
                    title: Text('${layerSourceItem.getLabel()}'),
                    subtitle: Text('${layerSourceItem.getAttribution()}'),
                    onLongPress: () async {
                      var bounds = await layerSourceItem.getBounds();
                      if (bounds != null) {
                        setLayersOnChange(_layersList);
                        widget._moveToFunction(bounds);
                        Navigator.of(context).pop();
                      }
                    },
                    onTap: () {
                      if (layerSourceItem is GpxSource) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GpxPropertiesWidget(layerSourceItem, widget._reloadFunction)));
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
                      File file = await FilePicker.getFile(type: FileType.ANY);
                      if (file != null) {
                        if (file.path.endsWith(".map")) {
                          TileSource ts = TileSource.Mapsforge(file.path);
                          LayerManager().addLayer(ts);
                          _somethingChanged = true;
                          setState(() {});
                        } else if (file.path.endsWith(".mbtiles")) {
                          TileSource ts = TileSource.Mbtiles(file.path);
                          LayerManager().addLayer(ts);
                          _somethingChanged = true;
                          setState(() {});
                        } else if (file.path.endsWith(".gpx")) {
                          GpxSource gpxLayer = GpxSource(file.path);
                          if (gpxLayer.hasData()) {
                            LayerManager().addLayer(gpxLayer);
                            _somethingChanged = true;
                            setState(() {});
                          }
                        } else {
                          showWarningDialog(context, "File format not supported.");
                        }
                      }
                    },
                    tooltip: "Load map/mbtiles files",
                    child: Icon(MdiIcons.map),
                    heroTag: null,
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      var selected = await showComboDialog(context, "Select online tile source", onlinesTilesSources.map((ts) => ts.label).toList());
                      if (selected != null) {
                        var selectedTs = onlinesTilesSources.where((ts) => ts.label == selected).first;
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
      if (layer is GpxSource) {
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

class SmashMBTilesImageProvider extends TileProvider {
  final File mbtilesFile;

  Future<Database> database;
  Database _loadedDb;
  bool isDisposed = false;
  LatLngBounds _bounds;
  Uint8List _emptyImageBytes;

  SmashMBTilesImageProvider(this.mbtilesFile) {
    database = open();
  }

  Future<Database> open() async {
    if (_loadedDb == null) {
      _loadedDb = await openDatabase(mbtilesFile.path);

      try {
        String boundsSql = "select value from metadata where name='bounds'";
        List<Map> result = await _loadedDb.rawQuery(boundsSql);
        String boundsString = result.first['value'];
        List<String> boundsSplit = boundsString.split(","); //left, bottom, right, top
        LatLngBounds b = LatLngBounds();
        b.extend(LatLng(double.parse(boundsSplit[1]), double.parse(boundsSplit[0])));
        b.extend(LatLng(double.parse(boundsSplit[3]), double.parse(boundsSplit[2])));
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
    var y = options.tms ? invertY(coords.y.round(), coords.z.round()) : coords.y.round();
    var z = coords.z.round();

    return SmashMBTileImage(database, Coords<int>(x, y)..z = z, _emptyImageBytes);
  }
}

class SmashMBTileImage extends ImageProvider<SmashMBTileImage> {
  final Future<Database> database;
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

    final db = await key.database;
    List<Map> result = await db.rawQuery('select tile_data from tiles '
        'where zoom_level = ${coords.z} AND '
        'tile_column = ${coords.x} AND '
        'tile_row = ${coords.y} limit 1');
    Uint8List bytes = result.isNotEmpty ? result.first['tile_data'] : null;

    if (bytes == null) {
      if (_emptyImageBytes != null) {
        bytes = _emptyImageBytes;
      } else {
        return Future<UI.Codec>.error('Failed to load tile for coords: $coords');
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
