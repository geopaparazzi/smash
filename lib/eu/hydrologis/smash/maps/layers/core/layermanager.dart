/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';

class LayerManager {
  static final LayerManager _instance = LayerManager._internal();

  factory LayerManager() => _instance;

  List<LayerSource> _layerSources = [onlinesTilesSources[0]];

  LayerManager._internal();

  /// Initialize the LayerManager by retrieving the layers from teh preferences.
  Future<void> initialize() async {
    List<String> layerSourcesList = await GpPreferences().getLayerInfoList();
    if (layerSourcesList.isNotEmpty) {
      _layerSources = [];
      for (var json in layerSourcesList) {
        var fromJson = LayerSource.fromJson(json);
        for (var source in fromJson) {
          if (source.getSrid() == null) {
            source.calculateSrid();
          }
        }
        _layerSources.addAll(fromJson);
      }
      ;
    } else {
      _layerSources = [TileSource.Open_Street_Map_Standard()..isVisible = true];
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
      //SLogger().d("Layer loaded: ${activeLayersInfos[i].toJson()}");
    }
    return layerOptions;
  }
}
