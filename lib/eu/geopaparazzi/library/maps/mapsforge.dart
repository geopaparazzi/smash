/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/src/layer/tile_layer.dart' hide Tile;
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/datastore.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/src/graphics/tilebitmap.dart';
import 'package:mapsforge_flutter/src/implementation/graphics/fluttertilebitmap.dart';
import 'package:mapsforge_flutter/src/model/tile.dart';
import 'package:mapsforge_flutter/src/renderer/rendererjob.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show DiagnosticsProperty;

Future<TileLayerOptions> loadMapsforgeLayer(File file) async {
  double tileSize = 256;
  var mapsforgeTileProvider = MapsforgeTileProvider(file, tileSize: tileSize);
  await mapsforgeTileProvider.open();
  return new TileLayerOptions(
    tileProvider: mapsforgeTileProvider,
    tileSize: tileSize,
    keepBuffer: 2,
    backgroundColor: SmashColors.mainBackground,
    maxZoom: 21,
  );
}

class MapsforgeTileProvider extends TileProvider {
  File _mapsforgeFile;
  DisplayModel _displayModel;
  RenderTheme _renderTheme;
  double tileSize;
  BitmapCache _bitmapCache;

  MapsforgeTileProvider(this._mapsforgeFile, {this.tileSize: 256.0});

  MultiMapDataStore _multiMapDataStore;
  MapDataStoreRenderer _dataStoreRenderer;

  Future<void> open() async {
    _multiMapDataStore = MultiMapDataStore(DataPolicy.DEDUPLICATE);
    print("opening mapfile");
    ReadBuffer readBuffer = ReadBuffer(_mapsforgeFile.path);
    MapFile mapFile = MapFile(readBuffer, null, null);
    await mapFile.init();
    //await mapFile.debug();
    _multiMapDataStore.addMapDataStore(mapFile, false, false);

    GraphicFactory graphicFactory = FlutterGraphicFactory();
    _displayModel = DisplayModel();
    _displayModel.setFixedTileSize(tileSize);
    _displayModel.setUserScaleFactor(2.5);
    SymbolCache symbolCache = SymbolCache(graphicFactory, _displayModel);

    RenderThemeBuilder renderThemeBuilder =
        RenderThemeBuilder(graphicFactory, _displayModel, symbolCache);
    String content = await rootBundle.loadString("assets/defaultrender.xml");
    await renderThemeBuilder.parseXml(content);

    _renderTheme = renderThemeBuilder.build();

    _dataStoreRenderer = MapDataStoreRenderer(
        _multiMapDataStore, _renderTheme, graphicFactory, true);

    _bitmapCache = FileBitmapCache(_dataStoreRenderer.getRenderKey());
    //_bitmapCache.purge();
//
//    MapModel _mapModel = MapModel(
//      displayModel: _displayModel,
//      graphicsFactory: graphicFactory,
//      renderer: _dataStoreRenderer,
//      symbolCache: symbolCache,
//      bitmapCache: bitmapCache,
//    );
//    _mapModel.
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    int xTile = coords.x.round();
    int yTile = coords.y.round();
    int zoom = coords.z.round();

    Tile tile = new Tile(xTile, yTile, zoom, tileSize);

    var tileBitmap = _bitmapCache.getTileBitmap(tile);
    if (tileBitmap != null) {
      return BitmapImageProvider(tileBitmap, coords);
    }

    // Draw the tile
    var userScaleFactor = _displayModel.getUserScaleFactor();

    RendererJob mapGeneratorJob = new RendererJob(tile, _multiMapDataStore,
        _renderTheme, _displayModel, userScaleFactor, false, false);
//    Future<TileBitmap> executeJob =
//        _dataStoreRenderer.executeJob(mapGeneratorJob);

    return MapsforgeImageProvider(
        _dataStoreRenderer, mapGeneratorJob, tile, _bitmapCache);
  }
}

class MapsforgeImageProvider extends ImageProvider<MapsforgeImageProvider> {
  MapDataStoreRenderer _dataStoreRenderer;
  RendererJob _mapGeneratorJob;
  Tile _tile;
  BitmapCache _bitmapCache;

  MapsforgeImageProvider(this._dataStoreRenderer, this._mapGeneratorJob,
      this._tile, this._bitmapCache);

  @override
  ImageStreamCompleter load(MapsforgeImageProvider key) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: 1,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<MapsforgeImageProvider>('Image key', key);
      },
    );
  }

  Future<Codec> _loadAsync(MapsforgeImageProvider key) async {
    assert(key == this);

    TileBitmap resultTile;
    try {
      resultTile =
          await key._dataStoreRenderer.executeJob(key._mapGeneratorJob);

      // todo make this way better
      Uint8List bytes;
      if (resultTile == null) {
        String url =
            "https://tile.openstreetmap.org/${_tile.zoomLevel}/${_tile.tileX}/${_tile.tileY}.png";
        var response = await http.get(url);
        if (response == null) {
          return Future<Codec>.error('Failed to load tile for coords: $_tile');
        }
        bytes = response.bodyBytes;
      } else {
        _bitmapCache.addTileBitmap(_tile, resultTile);

        ui.Image img = (resultTile as FlutterTileBitmap).bitmap;
        var byteData = await img.toByteData(format: ImageByteFormat.png);
        bytes = byteData.buffer.asUint8List();
      }

      var codec = await PaintingBinding.instance.instantiateImageCodec(bytes);
      return codec;
    } catch (ex, stacktrace) {
      print(stacktrace);
    }
    return Future<Codec>.error('Failed to load tile for coords: $_tile');
  }

  @override
  Future<MapsforgeImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => _tile.hashCode;

  @override
  bool operator ==(other) {
    return other is MapsforgeImageProvider && _tile == other._tile;
  }
}

class BitmapImageProvider extends ImageProvider<BitmapImageProvider> {
  TileBitmap _bitmap;

  var _coords;

  BitmapImageProvider(this._bitmap, this._coords);

  @override
  ImageStreamCompleter load(BitmapImageProvider key) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: 1,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<BitmapImageProvider>('Image key', key);
      },
    );
  }

  Future<Codec> _loadAsync(BitmapImageProvider key) async {
    assert(key == this);

    try {
      ui.Image img = (_bitmap as FlutterTileBitmap).bitmap;
      var byteData = await img.toByteData(format: ImageByteFormat.png);
      final Uint8List bytes = byteData.buffer.asUint8List();

      var codec = await PaintingBinding.instance.instantiateImageCodec(bytes);
      return codec;
    } catch (ex, stacktrace) {
      print(stacktrace);
    }
    return Future<Codec>.error('Failed to load tile for coords: $_coords');
  }

  @override
  Future<BitmapImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => _coords.hashCode;

  @override
  bool operator ==(other) {
    return other is BitmapImageProvider && _coords == other._coords;
  }
}
