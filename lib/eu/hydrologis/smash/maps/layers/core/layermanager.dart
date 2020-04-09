/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/worldimage.dart';

class LayerManager {
  static final LayerManager _instance = LayerManager._internal();

  factory LayerManager() => _instance;

  List<LayerSource> _baseLayers = onlinesTilesSources;
  List<LayerSource> _vectorLayers = [];

  LayerManager._internal();

  /// Initialize the LayerManager by retrieving the layers from teh preferences.
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

  /// Get the list of layer sources. Note that this doesn't call the load of actual data.
  ///
  /// By default only the active list is supplied.
  List<LayerSource> getLayerSources({onlyActive: true}) {
    var list = <LayerSource>[];
    if (onlyActive) {
      var activeBaseLayers = getActiveBaseLayerSources();
      list.addAll(activeBaseLayers);
      List<LayerSource> where =
          _vectorLayers.where((ts) => ts.isActive()).toList();
      if (where.isNotEmpty) list.addAll(where.toList());
    } else {
      list.addAll(_baseLayers);
      list.addAll(_vectorLayers);
    }
    return list;
  }

  /// Get the list of active base layer sources.
  List<LayerSource> getActiveBaseLayerSources() {
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

  /// Add a new layersource to the layer list.
  void addLayerSource(LayerSource layerData) {
    if ((layerData is TileSource || layerData is WorldImageSource) &&
        !_baseLayers.contains(layerData)) {
      _baseLayers.add(layerData);
    } else if (layerData is VectorLayerSource &&
        !_vectorLayers.contains(layerData)) {
      _vectorLayers.add(layerData);
    }
  }

  /// Remove a layersource form the available layers list.
  void removeLayerSource(LayerSource sourceItem) {
    sourceItem.disposeSource();
    if (_baseLayers.contains(sourceItem)) {
      _baseLayers.remove(sourceItem);
    }
    if (_vectorLayers.contains(sourceItem)) {
      _vectorLayers.remove(sourceItem);
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
      //GpLogger().d("Layer loaded: ${activeLayersInfos[i].toJson()}");
    }
    return layerOptions;
  }
}
