/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/foundation.dart' show DiagnosticsProperty;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart' as FM;
import 'package:flutter_map/src/layer/tile_layer.dart' hide Tile;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/datastore.dart';
import 'package:mapsforge_flutter/maps.dart';
import 'package:mapsforge_flutter/marker.dart';
import 'package:mapsforge_flutter/special.dart';
import 'package:mapsforge_flutter/src/graphics/tilebitmap.dart';
import 'package:mapsforge_flutter/src/implementation/graphics/fluttertilebitmap.dart';
import 'package:mapsforge_flutter/src/model/tile.dart';
import 'package:mapsforge_flutter/src/layer/job/job.dart';
import 'package:mapsforge_flutter/src/layer/job/jobresult.dart';
import 'package:mapsforge_flutter/src/mapfile/mapfile.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:synchronized/synchronized.dart';

const MAPSFORGE_TILESIZE = 256.0;

const DOCACHE = true;

/// Fills the base cache for a given mapsforge [file].
Future<void> fillBaseCache(File file) async {
  SMLogger().d("Filling mbtiles cache in ${file.path}");
  var mapsforgeTileProvider =
      MapsforgeTileProvider(file, tileSize: MAPSFORGE_TILESIZE);
  await mapsforgeTileProvider.open();

  await mapsforgeTileProvider.fillCache();
  mapsforgeTileProvider.close();
  SMLogger().d("Done mbtiles cache in ${file.path}");
}

/// Get the bounds of a mapsforge file (opens and closes the file).
Future<FM.LatLngBounds> getMapsforgeBounds(File file) async {
  var mapsforgeTileProvider =
      MapsforgeTileProvider(file, tileSize: MAPSFORGE_TILESIZE);
  var bounds = await mapsforgeTileProvider.getBounds();
  mapsforgeTileProvider.close();
  return bounds;
}

/// Flutter mapsforge renderer with synched executeJob for
/// concurrent access control.
class SmashMapDataStoreRenderer extends MapDataStoreRenderer {
  var lock = Lock();

  SmashMapDataStoreRenderer(MapDataStore mapDataStore, RenderTheme renderTheme,
      GraphicFactory graphicFactory, bool renderLabels)
      : super(mapDataStore, renderTheme, graphicFactory, renderLabels);

  Future<JobResult> executeJobSync(Job job) async {
    return await lock.synchronized(() async {
      return await executeJob(job);
    });
  }
}

/// Mapsforge tiles provider class.
///
class MapsforgeTileProvider extends FM.TileProvider {
  File _mapsforgeFile;
  DisplayModel _displayModel;
  double tileSize;

//  BitmapCache _bitmapCache;

  MapsforgeTileProvider(this._mapsforgeFile,
      {this.tileSize: MAPSFORGE_TILESIZE});

  MapFile _mapDataStore;
  MBTilesDb _mbtilesCache;
  RenderTheme _renderTheme;
  GraphicFactory _graphicFactory;
  SmashMapDataStoreRenderer dataStoreRenderer;

  Future<void> open() async {
    _displayModel = DisplayModel(
      maxZoomLevel: 24,
    );

    String content;
    var parentFolder = FileUtilities.parentFolderFromFile(_mapsforgeFile.path);
    var nameNoExt = FileUtilities.nameFromFile(_mapsforgeFile.path, false);
    var resourcesFolderPath = FileUtilities.joinPaths(parentFolder, nameNoExt);
    Directory resourcesFolderFile = Directory(resourcesFolderPath);
    File xmlFile;
    String relativePath;
    if (resourcesFolderFile.existsSync()) {
      // check if rendertheme xml exists
      var xmlPath = resourcesFolderPath + ".xml";
      xmlFile = File(xmlPath);
      if (xmlFile.existsSync()) {
        relativePath = resourcesFolderPath;
        content = FileUtilities.readFile(xmlPath);
      }
    }
    SymbolCache symbolCache;
    if (content == null) {
      content = await rootBundle.loadString("assets/defaultrender.xml");
      symbolCache = FileSymbolCache(rootBundle);
    } else {
      symbolCache = FileSymbolCache.withRelativePathPrefix(relativePath);
    }

    _graphicFactory = FlutterGraphicFactory(
      symbolCache,
    );

    RenderThemeBuilder renderThemeBuilder =
        RenderThemeBuilder(_graphicFactory, _displayModel);
    renderThemeBuilder.parseXml(content);
    _renderTheme = renderThemeBuilder.build();

    _mapDataStore = await MapFile.from(_mapsforgeFile.path, 0, "en");

    dataStoreRenderer = SmashMapDataStoreRenderer(
        _mapDataStore, _renderTheme, _graphicFactory, true);

    if (DOCACHE) {
      // create a mbtiles cache
      String cachePath = _mapsforgeFile.path + ".mbtiles";
      if (!File(cachePath).existsSync()) {
        SMLogger().d("Creating mbtiles cache in $cachePath");
      }
      var name = FileUtilities.nameFromFile(cachePath, false);
      _mbtilesCache = MBTilesDb(cachePath);
      _mbtilesCache.open();

      BoundingBox bBox = _mapDataStore.boundingBox;
      _mbtilesCache.fillMetadata(bBox.maxLatitude, bBox.minLatitude,
          bBox.minLongitude, bBox.maxLongitude, name, "png", 8, 22);
    }
  }

  Future<FM.LatLngBounds> getBounds() async {
    if (_mapDataStore == null) {
      _mapDataStore = await MapFile.from(_mapsforgeFile.path, 0, "en");
    }
    BoundingBox bBox = _mapDataStore.boundingBox;
    FM.LatLngBounds bounds = FM.LatLngBounds();
    bounds.extend(LatLng(bBox.minLatitude, bBox.minLongitude));
    bounds.extend(LatLng(bBox.maxLatitude, bBox.maxLongitude));
    return bounds;
  }

  /// Close the mapsforge tile provider.
  void close() {
    _mapDataStore?.close();
    _mbtilesCache?.close();
  }

  /// fill some base cache for the provider.
  Future<void> fillCache() async {
    if (_mbtilesCache != null) {
      BoundingBox bBox = _mapDataStore.boundingBox;
      var userScaleFactor = _displayModel.getUserScaleFactor();
      List<int> zoomLevels = [3, 4, 5, 6, 7, 8, 9];
      int indoorLevel = 0; // TODO take care of indoor if interest is there
      for (var i = 0; i < zoomLevels.length; i++) {
        var z = zoomLevels[i];
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
            Tile tile = new Tile(x, y, z, indoorLevel);
            Job mapGeneratorJob =
                new Job(tile, false, userScaleFactor, tileSize.toInt());
            var resultTile =
                await dataStoreRenderer.executeJobSync(mapGeneratorJob);
            if (resultTile != null) {
              ui.Image img = (resultTile as FlutterTileBitmap).bitmap;
              var byteData = await img.toByteData(format: ImageByteFormat.png);
              var bytes = byteData.buffer.asUint8List();
              _mbtilesCache.addTile(x, y, z, bytes);
            }
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

    // TODO take care of indoor if interest is there (the last 0)
    Tile tile = new Tile(xTile, yTile, zoom, 0);
    var userScaleFactor = _displayModel.getUserScaleFactor();
    Job mapGeneratorJob =
        new Job(tile, false, userScaleFactor, tileSize.toInt());
    // MapDataStoreRenderer dataStoreRenderer = MapDataStoreRenderer(
    //     _mapDataStore, _renderTheme, _graphicFactory, true);
    return MapsforgeImageProvider(
        dataStoreRenderer, mapGeneratorJob, tile, _mbtilesCache);
  }
}

/// Image tiles provider for mapsforge datasets.
class MapsforgeImageProvider extends ImageProvider<MapsforgeImageProvider> {
  SmashMapDataStoreRenderer _dataStoreRenderer;
  var _mapGeneratorJob;
  Tile _tile;
  MBTilesDb _bitmapCache;

  MapsforgeImageProvider(this._dataStoreRenderer, this._mapGeneratorJob,
      this._tile, this._bitmapCache);

  @override
  ImageStreamCompleter load(
      MapsforgeImageProvider key, DecoderCallback decoder) {
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
          _bitmapCache?.getTile(_tile.tileX, _tile.tileY, _tile.zoomLevel);
      if (tileData != null) {
        return await PaintingBinding.instance.instantiateImageCodec(tileData);
      }
    } catch (e) {
      print("ERROR");
      print(e); // ignore later
    }

    JobResult jobresult;
    try {
      jobresult =
          await key._dataStoreRenderer.executeJobSync(key._mapGeneratorJob);
      var resultTile = jobresult?.bitmap;

      // todo make this way better
      Uint8List bytes;
      if (resultTile == null) {
        // String url =
        //     "https://tile.openstreetmap.org/${_tile.zoomLevel}/${_tile.tileX}/${_tile.tileY}.png";
        // var response = await http.get(url);
        // if (response == null) {
        //   return Future<Codec>.error('Failed to load tile for coords: $_tile');
        // }
        // bytes = response.bodyBytes;

        return null;
      } else {
        ui.Image img = (resultTile as FlutterTileBitmap).bitmap;
        var byteData = await img.toByteData(format: ImageByteFormat.png);
        bytes = byteData.buffer.asUint8List();

        _bitmapCache?.addTile(_tile.tileX, _tile.tileY, _tile.zoomLevel, bytes);
      }

      var codec = await PaintingBinding.instance.instantiateImageCodec(bytes);
      return codec;
    } catch (ex, stacktrace) {
      print("ERROR");
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

// class BitmapImageProvider extends ImageProvider<BitmapImageProvider> {
//   TileBitmap _bitmap;

//   var _coords;

//   BitmapImageProvider(this._bitmap, this._coords);

//   @override
//   ImageStreamCompleter load(BitmapImageProvider key, DecoderCallback decoder) {
//     // TODO check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
//     return MultiFrameImageStreamCompleter(
//       codec: _loadAsync(key),
//       scale: 1,
//       informationCollector: () sync* {
//         yield DiagnosticsProperty<ImageProvider>('Image provider', this);
//         yield DiagnosticsProperty<BitmapImageProvider>('Image key', key);
//       },
//     );
//   }

//   Future<Codec> _loadAsync(BitmapImageProvider key) async {
//     assert(key == this);

//     try {
//       ui.Image img = (_bitmap as FlutterTileBitmap).bitmap;
//       var byteData = await img.toByteData(format: ImageByteFormat.png);
//       final Uint8List bytes = byteData.buffer.asUint8List();

//       var codec = await PaintingBinding.instance.instantiateImageCodec(bytes);
//       return codec;
//     } catch (ex, stacktrace) {
//       print(stacktrace);
//     }
//     return Future<Codec>.error('Failed to load tile for coords: $_coords');
//   }

//   @override
//   Future<BitmapImageProvider> obtainKey(ImageConfiguration configuration) {
//     return SynchronousFuture(this);
//   }

//   @override
//   int get hashCode => _coords.hashCode;

//   @override
//   bool operator ==(other) {
//     return other is BitmapImageProvider && _coords == other._coords;
//   }
// }

// class BytesImageProvider extends ImageProvider<BytesImageProvider> {
//   Uint8List _bytes;

//   var _coords;

//   BytesImageProvider(this._bytes, this._coords);

//   @override
//   ImageStreamCompleter load(BytesImageProvider key, DecoderCallback decoder) {
//     // TODO check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
//     return MultiFrameImageStreamCompleter(
//       codec: _loadAsync(key),
//       scale: 1,
//       informationCollector: () sync* {
//         yield DiagnosticsProperty<ImageProvider>('Image provider', this);
//         yield DiagnosticsProperty<BytesImageProvider>('Image key', key);
//       },
//     );
//   }

//   Future<Codec> _loadAsync(BytesImageProvider key) async {
//     assert(key == this);

//     try {
//       var codec = await PaintingBinding.instance.instantiateImageCodec(_bytes);
//       return codec;
//     } catch (ex, stacktrace) {
//       return Future<Codec>.error(
//           'Failed to load tile for coords: $_coords -> ${ex.toString()}');
//     }
//   }

//   @override
//   Future<BytesImageProvider> obtainKey(ImageConfiguration configuration) {
//     return SynchronousFuture(this);
//   }

//   @override
//   int get hashCode => _coords.hashCode;

//   @override
//   bool operator ==(other) {
//     return other is BytesImageProvider && _coords == other._coords;
//   }
// }
