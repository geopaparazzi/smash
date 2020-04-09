/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';

class WmsSource extends RasterLayerSource {
  String _getCapabilitiesUrl;
  String _layerName;
  double opacityPercentage = 100;
  String imageFormat;
  bool isVisible = true;
  LatLngBounds _serviceBounds = LatLngBounds();
  String attribution = "";

  bool loaded = false;

  WmsSource.fromMap(Map<String, dynamic> map) {
    _getCapabilitiesUrl = map[LAYERSKEY_URL];
    _layerName = map[LAYERSKEY_LABEL];
    isVisible = map[LAYERSKEY_ISVISIBLE] ?? true;
    opacityPercentage = map[LAYERSKEY_OPACITY] ?? 100;
    imageFormat = map[LAYERSKEY_FORMAT] ?? LAYERSTYPE_FORMAT_JPG;
    attribution = map[LAYERSKEY_ATTRIBUTION] ?? "";
  }

  WmsSource(this._getCapabilitiesUrl, this._layerName,
      {this.imageFormat, this.opacityPercentage, this.isVisible});

  Future<void> load(BuildContext context) async {}

  bool hasData() {
    return true;
  }

  String getAbsolutePath() {
    return null;
  }

  String getUrl() {
    return _getCapabilitiesUrl;
  }

  String getName() {
    return _layerName;
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

  String toJson() {
    var json = '''
    {
        "$LAYERSKEY_LABEL": "$_layerName",
        "$LAYERSKEY_URL":"$_getCapabilitiesUrl",
        "$LAYERSKEY_ISVISIBLE": $isVisible,
        "$LAYERSKEY_OPACITY": $opacityPercentage,
        "$LAYERSKEY_FORMAT": "$imageFormat",
        "$LAYERSKEY_ATTRIBUTION": "$attribution",
        "$LAYERSKEY_TYPE": "$LAYERSTYPE_WMS"
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    await load(context);

    List<LayerOptions> layers = [
      TileLayerOptions(
        opacity: opacityPercentage / 100,
        backgroundColor: Colors.transparent,
        wmsOptions: WMSTileLayerOptions(
          // Set the WMS layer's CRS
          // crs: epsg3413CRS,
          transparent: true,
          format: imageFormat,
          baseUrl: _getCapabilitiesUrl,
          layers: [_layerName],
        ),
      )
    ];

    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() {
    return Future.value(_serviceBounds);
  }

  @override
  void disposeSource() {
  }
}

class WmsLayersPage extends StatefulWidget {
  WmsLayersPage({Key key}) : super(key: key);

  @override
  _WmsLayersPageState createState() => _WmsLayersPageState();
}

class _WmsLayersPageState extends State<WmsLayersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Container(),
    );
  }
}