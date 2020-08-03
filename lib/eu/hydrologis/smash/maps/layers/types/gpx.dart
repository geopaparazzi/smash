/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';

class GpxSource extends VectorLayerSource {
  String _absolutePath;
  String _name;
  Gpx _gpx;
  Color pointFillColor = Colors.red;
  Color lineStrokeColor = Colors.black;
  double pointsSize = 10;
  double lineWidth = 3;
  bool isVisible = true;
  String _attribution = "";
  int _srid = SmashPrj.EPSG4326_INT;

  List<LatLng> _wayPoints = [];
  List<String> _wayPointNames = [];
  List<List<LatLng>> _tracksRoutes = [];
  LatLngBounds _gpxBounds = LatLngBounds();
  bool loaded = false;

  GpxSource.fromMap(Map<String, dynamic> map) {
    _name = map[LAYERSKEY_LABEL];
    String relativePath = map[LAYERSKEY_FILE];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];
    _srid = map[LAYERSKEY_SRID] ?? _srid;
  }

  GpxSource(this._absolutePath);

  Future<void> load(BuildContext context) async {
    if (!loaded) {
      _name = FileUtilities.nameFromFile(_absolutePath, false);
      var xml = FileUtilities.readFile(_absolutePath);
      _gpx = GpxReader().fromString(xml);

      int count = 1;
      _gpx.wpts.forEach((wpt) {
        var latLng = LatLng(wpt.lat, wpt.lon);
        _gpxBounds.extend(latLng);
        _wayPoints.add(latLng);
        var name = wpt.name;
        if (name == null) {
          name = "Point $count";
        }
        count++;
        _wayPointNames.add(name);
      });

      if (_gpx.wpts.isNotEmpty) {
        _attribution = _attribution + "Wpts(${_gpx.wpts.length}) ";
      }

      _gpx.trks.forEach((trk) {
        trk.trksegs.forEach((trkSeg) {
          List<LatLng> points = trkSeg.trkpts.map((wpt) {
            var latLng = LatLng(wpt.lat, wpt.lon);
            _gpxBounds.extend(latLng);
            return latLng;
          }).toList();
          _tracksRoutes.add(points);
        });
      });
      if (_gpx.trks.isNotEmpty) {
        _attribution = _attribution + "Trks(${_gpx.trks.length}) ";
      }
      _gpx.rtes.forEach((rt) {
        List<LatLng> points = rt.rtepts.map((wpt) {
          var latLng = LatLng(wpt.lat, wpt.lon);
          _gpxBounds.extend(latLng);
        }).toList();
        _tracksRoutes.add(points);
      });
      if (_gpx.rtes.isNotEmpty) {
        _attribution = _attribution + "Rtes(${_gpx.rtes.length}) ";
      }
      loaded = true;
    }
  }

  bool hasData() {
    return _wayPoints.isNotEmpty || _tracksRoutes.isNotEmpty;
  }

  String getAbsolutePath() {
    return _absolutePath;
  }

  String getUrl() {
    return null;
  }

  String getName() {
    return _name;
  }

  String getAttribution() {
    return _attribution;
  }

  bool isActive() {
    return isVisible;
  }

  void setActive(bool active) {
    isVisible = active;
  }

  String toJson() {
    var relativePath = Workspace.makeRelative(_absolutePath);
    var json = '''
    {
        "$LAYERSKEY_LABEL": "$_name",
        "$LAYERSKEY_FILE":"$relativePath",
        "$LAYERSKEY_SRID": $_srid,
        "$LAYERSKEY_ISVISIBLE": $isVisible 
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    load(context);

    List<LayerOptions> layers = [];

    if (_tracksRoutes.isNotEmpty) {
      List<Polyline> lines = [];
      _tracksRoutes.forEach((linePoints) {
        lines.add(Polyline(
            points: linePoints,
            strokeWidth: lineWidth,
            color: lineStrokeColor));
      });

      var lineLayer = PolylineLayerOptions(
        polylineCulling: true,
        polylines: lines,
      );
      layers.add(lineLayer);
    }
    if (_wayPoints.isNotEmpty) {
      List<Marker> waypoints = [];
      _wayPoints.forEach((ll) {
        Marker m = Marker(
          width: pointsSize,
          height: pointsSize,
          point: ll,
          builder: (ctx) => new Container(
            child: Icon(
              MdiIcons.circle,
              size: pointsSize,
              color: pointFillColor,
            ),
          ),
        );
        waypoints.add(m);
      });
      var waypointsCluster = MarkerClusterLayerOptions(
        maxClusterRadius: 20,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: waypoints,
        polygonOptions: PolygonOptions(
            borderColor: pointFillColor,
            color: pointFillColor.withOpacity(0.2),
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
            backgroundColor: pointFillColor,
            foregroundColor: SmashColors.mainBackground,
            heroTag: null,
          );
        },
      );
      layers.add(waypointsCluster);
    }
    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() async {
    return _gpxBounds;
  }

  @override
  void disposeSource() {
    _wayPoints = [];
    _wayPointNames = [];
    _tracksRoutes = [];
    _gpxBounds = LatLngBounds();
    _gpx = null;
    _name = null;
    _absolutePath = null;
    loaded = false;
  }

  @override
  bool hasProperties() {
    return true;
  }

  Widget getPropertiesWidget() {
    return GpxPropertiesWidget(this);
  }

  @override
  bool isZoomable() {
    return true;
  }

  @override
  int getSrid() {
    return _srid;
  }
}

/// The notes properties page.
class GpxPropertiesWidget extends StatefulWidget {
  final GpxSource _source;

  GpxPropertiesWidget(this._source);

  @override
  State<StatefulWidget> createState() {
    return GpxPropertiesWidgetState(_source);
  }
}

class GpxPropertiesWidgetState extends State<GpxPropertiesWidget> {
  GpxSource _source;
  double _pointSizeSliderValue = 10;
  double _lineWidthSliderValue = 2;
  double _maxSize = 100.0;
  double _maxWidth = 20.0;
  ColorExt _pointColor;
  ColorExt _lineColor;
  bool _somethingChanged = false;

  GpxPropertiesWidgetState(this._source);

  @override
  void initState() {
    _pointSizeSliderValue = _source.pointsSize;
    if (_pointSizeSliderValue > _maxSize) {
      _pointSizeSliderValue = _maxSize;
    }
    _pointColor = ColorExt.fromColor(_source.pointFillColor);

    _lineWidthSliderValue = _source.lineWidth;
    if (_lineWidthSliderValue > _maxWidth) {
      _lineWidthSliderValue = _maxWidth;
    }
    _lineColor = ColorExt.fromColor(_source.lineStrokeColor);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _source.pointFillColor = _pointColor;
            _source.pointsSize = _pointSizeSliderValue;
            _source.lineStrokeColor = _lineColor;
            _source.lineWidth = _lineWidthSliderValue;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Gpx Properties"),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Column(
                      children: <Widget>[
                        SmashUI.titleText("Waypoints Color"),
                        Padding(
                          padding: SmashUI.defaultPadding(),
                          child: LimitedBox(
                            maxHeight: 400,
                            // child: MaterialColorPicker(
                            //     shrinkWrap: true,
                            //     allowShades: false,
                            //     circleSize: 45,
                            //     onColorChange: (Color color) {
                            //       _pointColor = ColorExt.fromColor(color);
                            //       _somethingChanged = true;
                            //     },
                            //     onMainColorChange: (mColor) {
                            //       _pointColor = ColorExt.fromColor(mColor);
                            //       _somethingChanged = true;
                            //     },
                            //     selectedColor: Color(_pointColor.value)),
                          ),
                        ),
                        SmashUI.titleText("Waypoints Size"),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Slider(
                                  activeColor: SmashColors.mainSelection,
                                  min: 1.0,
                                  max: _maxSize,
                                  divisions: 20,
                                  onChanged: (newRating) {
                                    _somethingChanged = true;
                                    setState(() =>
                                        _pointSizeSliderValue = newRating);
                                  },
                                  value: _pointSizeSliderValue,
                                )),
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: SmashUI.normalText(
                                '${_pointSizeSliderValue.toInt()}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Column(
                      children: <Widget>[
                        SmashUI.titleText("Tracks/Routes Color"),
                        Padding(
                          padding: SmashUI.defaultPadding(),
                          child: LimitedBox(
                            maxHeight: 400,
                            // child: MaterialColorPicker(
                            //     shrinkWrap: true,
                            //     allowShades: false,
                            //     circleSize: 45,
                            //     onColorChange: (Color color) {
                            //       _lineColor = ColorExt.fromColor(color);
                            //       _somethingChanged = true;
                            //     },
                            //     onMainColorChange: (mColor) {
                            //       _lineColor = ColorExt.fromColor(mColor);
                            //       _somethingChanged = true;
                            //     },
                            //     selectedColor: Color(_lineColor.value)),
                          ),
                        ),
                        SmashUI.titleText("Tracks/Routes Width"),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Slider(
                                  activeColor: SmashColors.mainSelection,
                                  min: 1.0,
                                  max: _maxWidth,
                                  divisions: 20,
                                  onChanged: (newRating) {
                                    _somethingChanged = true;
                                    setState(() =>
                                        _lineWidthSliderValue = newRating);
                                  },
                                  value: _lineWidthSliderValue,
                                )),
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: SmashUI.normalText(
                                '${_lineWidthSliderValue.toInt()}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
