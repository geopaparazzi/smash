/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';

class GpxSource extends VectorLayerSource implements SldLayerSource {
  String _absolutePath;
  String _name;
  Gpx _gpx;
  bool isVisible = true;
  String _attribution = "";
  int _srid = SmashPrj.EPSG4326_INT;
  String sldPath;

  List<LatLng> _wayPoints = [];
  List<String> _wayPointNames = [];
  List<List<LatLng>> _tracksRoutes = [];
  LatLngBounds _gpxBounds = LatLngBounds();
  bool loaded = false;

  String sldString;
  SldObjectParser _style;

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
      var parentFolder = FileUtilities.parentFolderFromFile(_absolutePath);

      var fileName = FileUtilities.nameFromFile(_absolutePath, false);
      _name ??= fileName;

      sldPath = FileUtilities.joinPaths(parentFolder, fileName + ".sld");
      var sldFile = File(sldPath);

      if (sldFile.existsSync()) {
        sldString = FileUtilities.readFile(sldPath);
        _style = SldObjectParser.fromString(sldString);
        _style.parse();
      } else {
        // create style for points, lines and text
        sldString = DefaultSlds.simplePointSld();
        _style = SldObjectParser.fromString(sldString);
        _style.parse();
        _style.featureTypeStyles.first.rules.first.addLineStyle(LineStyle());
        _style.featureTypeStyles.first.rules.first.addTextStyle(TextStyle());
        sldString = _style.toSldString();
        FileUtilities.writeStringToFile(sldPath, sldString);
      }

      var xml = FileUtilities.readFile(_absolutePath);
      try {
        _gpx = GpxReader().fromString(xml);
      } catch (e) {
        SLogger().e("Error reading GPX file.", e);
        throw e;
      }

      var tmp = _gpx.metadata?.name;
      if (tmp != null && tmp.isNotEmpty) {
        _name = tmp;
      }

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
          return latLng;
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

    LineStyle lineStyle;
    PointStyle pointStyle;
    TextStyle textStyle;
    if (_style.featureTypeStyles.isNotEmpty) {
      var fts = _style.featureTypeStyles.first;
      if (fts.rules.isNotEmpty) {
        var rule = fts.rules.first;

        if (rule.lineSymbolizers.isNotEmpty) {
          lineStyle = rule.lineSymbolizers.first.style;
        }
        if (rule.pointSymbolizers.isNotEmpty) {
          pointStyle = rule.pointSymbolizers.first.style;
        }
        if (rule.textSymbolizers.isNotEmpty) {
          textStyle = rule.textSymbolizers.first.style;
        }
      }
    }
    lineStyle ??= LineStyle();
    pointStyle ??= PointStyle();
    textStyle ??= TextStyle();

    List<LayerOptions> layers = [];

    if (_tracksRoutes.isNotEmpty) {
      List<Polyline> lines = [];
      _tracksRoutes.forEach((linePoints) {
        lines.add(Polyline(
            points: linePoints,
            strokeWidth: lineStyle.strokeWidth,
            color: ColorExt(lineStyle.strokeColorHex)));
      });

      var lineLayer = PolylineLayerOptions(
        polylineCulling: true,
        polylines: lines,
      );
      layers.add(lineLayer);
    }
    if (_wayPoints.isNotEmpty) {
      var colorExt = ColorExt(pointStyle.fillColorHex);
      var labelcolorExt = ColorExt(textStyle.textColor);
      List<Marker> waypoints = [];

      for (var i = 0; i < _wayPoints.length; i++) {
        var ll = _wayPoints[i];
        var name = _wayPointNames[i];
        if (textStyle.size == 0) {
          name = null;
        }

        double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
        if (name == null) {
          textExtraHeight = 0;
        }
        var pointsSize = pointStyle.markerSize;
        Marker m = Marker(
            width: pointsSize * MARKER_ICON_TEXT_EXTRA_WIDTH_FACTOR,
            height: pointsSize + textExtraHeight,
            point: ll,
            // anchorPos: AnchorPos.exactly(
            //     Anchor(pointsSize / 2, textExtraHeight + pointsSize / 2)),
            builder: (ctx) => MarkerIcon(
                  MdiIcons.circle,
                  colorExt,
                  pointsSize,
                  name,
                  labelcolorExt,
                  colorExt.withAlpha(100),
                ));
        waypoints.add(m);
      }
      var waypointsCluster = MarkerClusterLayerOptions(
        maxClusterRadius: 20,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: waypoints,
        polygonOptions: PolygonOptions(
            borderColor: colorExt,
            color: colorExt.withOpacity(0.2),
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
            backgroundColor: colorExt,
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

  @override
  void updateStyle(String newSldString) {
    sldString = newSldString;
    _style = SldObjectParser.fromString(sldString);
    _style.parse();
    FileUtilities.writeStringToFile(sldPath, sldString);
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
  double _maxSize = SmashUI.MAX_MARKER_SIZE;
  double _minSize = SmashUI.MIN_MARKER_SIZE;
  double _maxWidth = SmashUI.MAX_STROKE_SIZE;
  double _minWidth = SmashUI.MIN_STROKE_SIZE;
  LineStyle lineStyle;
  PointStyle pointStyle;
  TextStyle textStyle;

  GpxPropertiesWidgetState(this._source);

  @override
  Widget build(BuildContext context) {
    if (textStyle == null && _source._style.featureTypeStyles.isNotEmpty) {
      var fts = _source._style.featureTypeStyles.first;
      if (fts.rules.isNotEmpty) {
        var rule = fts.rules.first;

        if (rule.lineSymbolizers.isNotEmpty) {
          lineStyle = rule.lineSymbolizers.first.style;
        }
        if (rule.pointSymbolizers.isNotEmpty) {
          pointStyle = rule.pointSymbolizers.first.style;
        }
        if (rule.textSymbolizers.isNotEmpty) {
          textStyle = rule.textSymbolizers.first.style;
        }
      }
    }
    lineStyle ??= LineStyle();
    pointStyle ??= PointStyle();
    textStyle ??= TextStyle();

    double _pointSizeSliderValue = pointStyle.markerSize;
    if (_pointSizeSliderValue > _maxSize) {
      _pointSizeSliderValue = _maxSize;
    } else if (_pointSizeSliderValue < _minSize) {
      _pointSizeSliderValue = _minSize;
    }
    ColorExt _pointColor = ColorExt(pointStyle.fillColorHex);

    double _lineWidthSliderValue = lineStyle.strokeWidth;
    if (_lineWidthSliderValue > _maxWidth) {
      _lineWidthSliderValue = _maxWidth;
    } else if (_lineWidthSliderValue < _minWidth) {
      _lineWidthSliderValue = _minWidth;
    }
    ColorExt _lineColor = ColorExt(lineStyle.strokeColorHex);

    return WillPopScope(
        onWillPop: () async {
          var sldString = SldObjectBuilder.buildFromFeatureTypeStyles(
              _source._style.featureTypeStyles);

          _source.updateStyle(sldString);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Gpx Properties"),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                _source._wayPoints.isEmpty
                    ? Container()
                    : Padding(
                        padding: SmashUI.defaultPadding(),
                        child: Card(
                          elevation: SmashUI.DEFAULT_ELEVATION,
                          shape: SmashUI.defaultShapeBorder(),
                          child: Padding(
                            padding: SmashUI.defaultPadding(),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: SmashUI.defaultPadding(),
                                  child: SmashUI.normalText(
                                    "WAYPOINTS",
                                    bold: true,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: SmashUI.normalText("Color"),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: SmashUI.DEFAULT_PADDING,
                                              right: SmashUI.DEFAULT_PADDING),
                                          child: ColorPickerButton(_pointColor,
                                              (newColor) {
                                            pointStyle.fillColorHex =
                                                ColorExt.asHex(newColor);
                                          }),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: SmashUI.normalText("Size"),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Slider(
                                          activeColor:
                                              SmashColors.mainSelection,
                                          min: _minSize,
                                          max: _maxSize,
                                          divisions:
                                              SmashUI.MINMAX_MARKER_DIVISIONS,
                                          onChanged: (newSize) {
                                            setState(() => pointStyle
                                                .markerSize = newSize);
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
                                CheckboxListTile(
                                    title: SmashUI.normalText(
                                        "View labels if available?"),
                                    value: textStyle.size > 0,
                                    onChanged: (newValue) {
                                      setState(() => textStyle.size = newValue
                                          ? 10
                                          : 0); // to view label, size needs to be >0
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                _source._tracksRoutes.isEmpty
                    ? Container()
                    : Padding(
                        padding: SmashUI.defaultPadding(),
                        child: Card(
                          elevation: SmashUI.DEFAULT_ELEVATION,
                          shape: SmashUI.defaultShapeBorder(),
                          child: Padding(
                            padding: SmashUI.defaultPadding(),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: SmashUI.defaultPadding(),
                                  child: SmashUI.normalText(
                                    "TRACKS/ROUTES",
                                    bold: true,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: SmashUI.normalText("Color"),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: SmashUI.DEFAULT_PADDING,
                                              right: SmashUI.DEFAULT_PADDING),
                                          child: ColorPickerButton(_lineColor,
                                              (newColor) {
                                            lineStyle.strokeColorHex =
                                                ColorExt.asHex(newColor);
                                          }),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: SmashUI.normalText("Width"),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Slider(
                                          activeColor:
                                              SmashColors.mainSelection,
                                          min: _minWidth,
                                          max: _maxWidth,
                                          divisions:
                                              SmashUI.MINMAX_STROKE_DIVISIONS,
                                          onChanged: (newRating) {
                                            setState(() => lineStyle
                                                .strokeWidth = newRating);
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
                      ),
              ],
            ),
          ),
        ));
  }
}
