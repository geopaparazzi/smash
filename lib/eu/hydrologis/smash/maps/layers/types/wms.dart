/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class WmsSource extends RasterLayerSource {
  String _getCapabilitiesUrl;
  String _layerName;
  double opacityPercentage = 100;
  String imageFormat;
  bool isVisible = true;
  LatLngBounds _serviceBounds = LatLngBounds();
  bool _hasBounds = false;
  String attribution = "";
  int _srid = SmashPrj.EPSG3857_INT;

  Function errorTileCallback = (tile, exception) {
    // ignore tiles that can't load to avoid
    SMLogger().e("Unable to load WMS tile: ${tile.coordsKey}", exception, null);
  };
  bool overrideTilesOnUrlChange = true;

  WmsSource.fromMap(Map<String, dynamic> map) {
    _getCapabilitiesUrl = map[LAYERSKEY_URL];
    _layerName = map[LAYERSKEY_LABEL];
    isVisible = map[LAYERSKEY_ISVISIBLE] ?? true;
    opacityPercentage = (map[LAYERSKEY_OPACITY] ?? 100).toDouble();
    imageFormat = map[LAYERSKEY_FORMAT] ?? LAYERSTYPE_FORMAT_PNG;
    attribution = map[LAYERSKEY_ATTRIBUTION] ?? "";

    _srid = map[LAYERSKEY_SRID] ?? SmashPrj.EPSG3857_INT;

    // TODO get bounds
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

  String getUser() => null;

  String getPassword() => null;

  String getName() {
    return _layerName;
  }

  String getAttribution() {
    return attribution;
  }

  bool isActive() {
    return isVisible;
  }

  IconData getIcon() => SmashIcons.iconTypeRaster;

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
        "$LAYERSKEY_SRID": $_srid,
        "$LAYERSKEY_TYPE": "$LAYERSTYPE_WMS"
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    await load(context);

    // final resolutions = <double>[
    //   134217728, // 20
    //   67108864,
    //   33554432,
    //   16777216,
    //   8388608,
    //   4194304, //15
    //   2097152,
    //   1048576,
    //   524288,
    //   262144,
    //   131072, // 10
    //   65536,
    //   32768,
    //   16384,
    //   8192,
    //   4096, // 5
    //   2048,
    //   1024,
    //   512,
    //   256,
    //   128, // 0
    // ];
    // var crs = Proj4Crs.fromFactory(
    //     code: 'EPSG:3857',
    //     proj4Projection: SmashPrj.EPSG3857,
    //     resolutions: resolutions);

    List<LayerOptions> layers = [
      TileLayerOptions(
        opacity: opacityPercentage / 100.0,
        backgroundColor: Colors.transparent,
        wmsOptions: WMSTileLayerOptions(
          // Set the WMS layer's CRS
          //crs: crs,
          transparent: true,
          format: imageFormat,
          baseUrl: _getCapabilitiesUrl,
          layers: [_layerName],
        ),
        overrideTilesWhenUrlChanges: overrideTilesOnUrlChange,
        errorTileCallback: errorTileCallback,
      )
    ];

    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() async {
    return _serviceBounds;
  }

  @override
  void disposeSource() {}

  @override
  bool hasProperties() {
    return true;
  }

  Widget getPropertiesWidget() {
    return WmsPropertiesWidget(this);
  }

  @override
  bool isZoomable() {
    return _hasBounds;
  }

  @override
  int getSrid() {
    return _srid;
  }
}

/// The tiff properties page.
class WmsPropertiesWidget extends StatefulWidget {
  final WmsSource _source;
  WmsPropertiesWidget(this._source);

  @override
  State<StatefulWidget> createState() {
    return WmsPropertiesWidgetState(_source);
  }
}

class WmsPropertiesWidgetState extends State<WmsPropertiesWidget> {
  WmsSource _source;
  double _opacitySliderValue = 100;
  bool _somethingChanged = false;

  WmsPropertiesWidgetState(this._source);

  @override
  void initState() {
    _opacitySliderValue = _source.opacityPercentage;
    if (_opacitySliderValue > 100) {
      _opacitySliderValue = 100;
    }
    if (_opacitySliderValue < 0) {
      _opacitySliderValue = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _source.opacityPercentage = _opacitySliderValue;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(SL.of(context).wms_wmsProperties), //"WMS Properties"
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: SmashUI.defaultPadding(),
                child: Card(
                  shape: SmashUI.defaultShapeBorder(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(MdiIcons.opacity),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(SL.of(context).wms_opacity), //"Opacity"
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Slider(
                                  activeColor: SmashColors.mainSelection,
                                  min: 0.0,
                                  max: 100,
                                  divisions: 10,
                                  onChanged: (newRating) {
                                    _somethingChanged = true;
                                    setState(
                                        () => _opacitySliderValue = newRating);
                                  },
                                  value: _opacitySliderValue,
                                )),
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: SmashUI.normalText(
                                '${_opacitySliderValue.toInt()}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
