/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';
import 'package:sqflite/sqflite.dart';


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