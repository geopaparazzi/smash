/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/src/layer/tile_layer.dart' hide Tile;
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/datastore.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/src/graphics/tilebitmap.dart';
import 'package:mapsforge_flutter/src/implementation/graphics/fluttertilebitmap.dart';
import 'package:mapsforge_flutter/src/model/tile.dart';
import 'package:mapsforge_flutter/src/renderer/rendererjob.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart' as FM;
import 'package:latlong/latlong.dart';

import 'package:flutter/foundation.dart' show DiagnosticsProperty;
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database/database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';

const MAPSFORGE_TILESIZE = 256.0;

Future<TileLayerOptions> loadMapsforgeLayer(File file) async {
  var mapsforgeTileProvider =
      MapsforgeTileProvider(file, tileSize: MAPSFORGE_TILESIZE);
  await mapsforgeTileProvider.open();
  return TileLayerOptions(
    tileProvider: mapsforgeTileProvider,
    tileSize: MAPSFORGE_TILESIZE,
    keepBuffer: 2,
    backgroundColor: SmashColors.mainBackground,
    maxZoom: 22,
  );
}

Future<void> fillBaseCache(File file) async {
  GpLogger().d("Filling mbtiles cache in ${file.path}");
  var mapsforgeTileProvider =
      MapsforgeTileProvider(file, tileSize: MAPSFORGE_TILESIZE);
  await mapsforgeTileProvider.open();

  await mapsforgeTileProvider.fillCache();
  mapsforgeTileProvider.close();
  GpLogger().d("Done mbtiles cache in ${file.path}");
}

Future<FM.LatLngBounds> getMapsforgeBounds(File file) async {
  var mapsforgeTileProvider =
      MapsforgeTileProvider(file, tileSize: MAPSFORGE_TILESIZE);
  await mapsforgeTileProvider.createMapDataStore();
  var bounds = mapsforgeTileProvider.getBounds();
  mapsforgeTileProvider.close();
  return bounds;
}

class MapsforgeTileProvider extends FM.TileProvider {
  File _mapsforgeFile;
  DisplayModel _displayModel;
  RenderTheme _renderTheme;
  double tileSize;

//  BitmapCache _bitmapCache;

  MapsforgeTileProvider(this._mapsforgeFile,
      {this.tileSize: MAPSFORGE_TILESIZE});

  MultiMapDataStore _multiMapDataStore;
  MapDataStoreRenderer _dataStoreRenderer;
  MBTilesDb _mbtilesCache;

  Future<void> open() async {
    await createMapDataStore();

    GraphicFactory graphicFactory = FlutterGraphicFactory();
    _displayModel = DisplayModel();
    _displayModel.setFixedTileSize(tileSize);
    _displayModel.setUserScaleFactor(1);
    SymbolCache symbolCache = SymbolCache(graphicFactory, _displayModel);

    RenderThemeBuilder renderThemeBuilder =
        RenderThemeBuilder(graphicFactory, _displayModel, symbolCache);
    String content = await rootBundle.loadString("assets/defaultrender.xml");
    await renderThemeBuilder.parseXml(content);

    _renderTheme = renderThemeBuilder.build();

    _dataStoreRenderer = MapDataStoreRenderer(
        _multiMapDataStore, _renderTheme, graphicFactory, true);

//    _bitmapCache = FileBitmapCache(_dataStoreRenderer.getRenderKey());

    // create a mbtiles cache
    String chachePath = _mapsforgeFile.path + ".mbtiles";
    var name = FileUtilities.nameFromFile(chachePath, false);
    _mbtilesCache = MBTilesDb(chachePath);
    await _mbtilesCache.open();
    GpLogger().d("Creating mbtiles cache in $chachePath");

    BoundingBox bBox = _multiMapDataStore.boundingBox;
    await _mbtilesCache.fillMetadata(bBox.maxLatitude, bBox.minLatitude,
        bBox.minLongitude, bBox.maxLongitude, name, "png", 8, 22);
  }

  Future<void> createMapDataStore() async {
    _multiMapDataStore = MultiMapDataStore(DataPolicy.DEDUPLICATE);
    ReadBuffer readBuffer = ReadBuffer(_mapsforgeFile.path);
    MapFile mapFile = MapFile(readBuffer, null, null);
    await mapFile.init();
    //await mapFile.debug();
    _multiMapDataStore.addMapDataStore(mapFile, false, false);
  }

  FM.LatLngBounds getBounds() {
    BoundingBox bBox = _multiMapDataStore.boundingBox;
    FM.LatLngBounds bounds = FM.LatLngBounds();
    bounds.extend(LatLng(bBox.minLatitude, bBox.minLongitude));
    bounds.extend(LatLng(bBox.maxLatitude, bBox.maxLongitude));
    return bounds;
  }

  void close() {
    if (_multiMapDataStore != null) {
      _multiMapDataStore.close();
    }
    if (_mbtilesCache != null) {
      _mbtilesCache.close();
    }
  }

  Future<void> fillCache() async {
    BoundingBox bBox = _multiMapDataStore.boundingBox;
    var userScaleFactor = _displayModel.getUserScaleFactor();
    List<int> zoomLevels = [3, 4, 5, 6, 7, 8, 9];
    for (var i = 0; i < zoomLevels.length; i++) {
      var z = zoomLevels[i];
//      print("Filling zoomlevel: $z with center in ${bBox.getCenterPoint()}");
      List<int> ul =
          MercatorUtils.getTileNumber(bBox.maxLatitude, bBox.minLongitude, z);
      List<int> lr =
          MercatorUtils.getTileNumber(bBox.minLatitude, bBox.maxLongitude, z);

      int minTileX = min(ul[1], lr[1]);
      int maxTileX = max(ul[1], lr[1]);
      int minTileY = min(lr[2], ul[2]);
      int maxTileY = max(lr[2], ul[2]);
      for (var x = minTileX; x <= maxTileX; x++) {
        for (var y = minTileY; y <= maxTileY; y++) {
          Tile tile = new Tile(x, y, z, tileSize);
          RendererJob mapGeneratorJob =
              new RendererJob(tile, userScaleFactor, false);
          var resultTile = await _dataStoreRenderer.executeJob(mapGeneratorJob);
          if (resultTile != null) {
            ui.Image img = (resultTile as FlutterTileBitmap).bitmap;
            var byteData = await img.toByteData(format: ImageByteFormat.png);
            var bytes = byteData.buffer.asUint8List();
            await _mbtilesCache.addTile(x, y, z, bytes);
          }
        }
      }
    }
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    int xTile = coords.x.round();
    int yTile = coords.y.round();
    int zoom = coords.z.round();

    Tile tile = new Tile(xTile, yTile, zoom, tileSize);

//    var tileBitmap = _bitmapCache.getTileBitmap(tile);
//    if (tileBitmap != null) {
//      return BitmapImageProvider(tileBitmap, coords);
//    }

    // Draw the tile
    var userScaleFactor = _displayModel.getUserScaleFactor();

    RendererJob mapGeneratorJob = new RendererJob(
        tile,
        /* _multiMapDataStore,         _renderTheme, _displayModel,*/
        userScaleFactor,
        false /*, false*/);
//    Future<TileBitmap> executeJob =
//        _dataStoreRenderer.executeJob(mapGeneratorJob);

    return MapsforgeImageProvider(
        _dataStoreRenderer, mapGeneratorJob, tile, _mbtilesCache);
  }
}

class MapsforgeImageProvider extends ImageProvider<MapsforgeImageProvider> {
  MapDataStoreRenderer _dataStoreRenderer;
  RendererJob _mapGeneratorJob;
  Tile _tile;
  MBTilesDb _bitmapCache;

  MapsforgeImageProvider(this._dataStoreRenderer, this._mapGeneratorJob,
      this._tile, this._bitmapCache);

  @override
  ImageStreamCompleter load(MapsforgeImageProvider key , DecoderCallback decoder) {
    // TODo check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
    return MultiFrameImageStreamCompleter(
      codec: loadAsync(key),
      scale: 1,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<MapsforgeImageProvider>('Image key', key);
      },
    );
  }

  Future<Codec> loadAsync(MapsforgeImageProvider key) async {
    assert(key == this);

    try {
      Uint8List tileData =
          await _bitmapCache.getTile(_tile.tileX, _tile.tileY, _tile.zoomLevel);
      if (tileData != null) {
        return await PaintingBinding.instance.instantiateImageCodec(tileData);
      }
    } catch (e) {
      print(e); // ignore later
    }

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
        ui.Image img = (resultTile as FlutterTileBitmap).bitmap;
        var byteData = await img.toByteData(format: ImageByteFormat.png);
        bytes = byteData.buffer.asUint8List();

        _bitmapCache.addTile(_tile.tileX, _tile.tileY, _tile.zoomLevel, bytes);
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
  ImageStreamCompleter load(BitmapImageProvider key, DecoderCallback decoder) {
    // TODO check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
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

class BytesImageProvider extends ImageProvider<BytesImageProvider> {
  Uint8List _bytes;

  var _coords;

  BytesImageProvider(this._bytes, this._coords);

  @override
  ImageStreamCompleter load(BytesImageProvider key, DecoderCallback decoder) {
    // TODO check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: 1,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<BytesImageProvider>('Image key', key);
      },
    );
  }

  Future<Codec> _loadAsync(BytesImageProvider key) async {
    assert(key == this);

    try {
      var codec = await PaintingBinding.instance.instantiateImageCodec(_bytes);
      return codec;
    } catch (ex, stacktrace) {
      return Future<Codec>.error(
          'Failed to load tile for coords: $_coords -> ${ex.toString()}');
    }
  }

  @override
  Future<BytesImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => _coords.hashCode;

  @override
  bool operator ==(other) {
    return other is BitmapImageProvider && _coords == other._coords;
  }
}
