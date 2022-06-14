/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';

class LayerManager {
  static final LayerManager _instance = LayerManager._internal();

  factory LayerManager() => _instance;

  List<LayerSource> _layerSources = [onlinesTilesSources[0]];

  LayerManager._internal();

  /// Initialize the LayerManager by retrieving the layers from teh preferences.
  Future<void> initialize(BuildContext context) async {
    SMLogger().d("START: Initializing layer manager.");
    try {
      List<String> layerSourcesList = await GpPreferences().getLayerInfoList();
      SMLogger()
          .d("--> Sources found in preferences: ${layerSourcesList.length}");
      if (layerSourcesList.isNotEmpty) {
        _layerSources = [];
        var json;
        try {
          for (json in layerSourcesList) {
            var fromJson = LayerSource.fromJson(json);
            for (var source in fromJson) {
              SMLogger().d("--> loading: ${source.getName()}");
              var absolutePath = source.getAbsolutePath();
              var url = source.getUrl();
              bool isFile =
                  absolutePath != null && File(absolutePath).existsSync();
              bool isurl = url != null && url.trim().isNotEmpty;
              if (isFile || isurl) {
                if (source is LoadableLayerSource && source.isActive()) {
                  await source.load(context);
                }
                if (source.getSrid() == null) {
                  source.calculateSrid();
                }
                _layerSources.add(source);
              }
            }
          }
        } on Exception catch (e, s) {
          SMLogger().e("An error occurred while loading layer: $json", e, s);
        }
      } else {
        _layerSources = [
          TileSource.Open_Street_Map_Standard()..isVisible = true
        ];
      }
    } finally {
      SMLogger().d("END: Initializing layer manager.");
    }
  }

  /// Get the list of layer sources. Note that this doesn't call the load of actual data.
  ///
  /// By default only the active list is supplied.
  List<LayerSource> getLayerSources({onlyActive: true}) {
    var list = <LayerSource>[];
    if (!onlyActive) {
      list.addAll(_layerSources.where((ts) => ts != null));
    } else {
      List<LayerSource> where = _layerSources.where((ts) {
        if (ts != null && ts.isActive()) {
          String? file = ts.getAbsolutePath();
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
    }
    return list;
  }

  /// Add a new layersource to the layer list.
  void addLayerSource(LayerSource layerData) {
    if (!_layerSources.contains(layerData)) {
      _layerSources.add(layerData);
    }
  }

  /// Remove a layersource form the available layers list.
  void removeLayerSource(LayerSource sourceItem) {
    sourceItem.disposeSource();
    if (_layerSources.contains(sourceItem)) {
      _layerSources.remove(sourceItem);
    }
  }

  /// Move a layer from its previous order to a new one.
  void moveLayer(int oldIndex, int newIndex) {
    var removed = _layerSources.removeAt(oldIndex);
    if (newIndex < oldIndex) {
      _layerSources.insert(newIndex, removed);
    } else if (newIndex > oldIndex) {
      _layerSources.insert(newIndex - 1, removed);
    }
  }

  /// Load the layers as map [LayerOptions]. This reads and load the data.
  Future<List<LayerOptions>> loadLayers(BuildContext context) async {
    List<LayerSource> activeLayerSources = LayerManager().getLayerSources();
    List<LayerOptions> layerOptions = [];
    for (int i = 0; i < activeLayerSources.length; i++) {
      var ls = await activeLayerSources[i].toLayers(context);
      if (ls != null) {
        ls.forEach((l) => layerOptions.add(l));
      }
      //SMLogger().d("Layer loaded: ${activeLayersInfos[i].toJson()}");
    }
    return layerOptions;
  }
}
