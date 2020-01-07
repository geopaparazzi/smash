/*
 * Copyright (c) 2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:core';

import 'package:dart_jts/dart_jts.dart' hide Polygon;
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:gpx/gpx.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/layers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';

class GeopackageSource extends VectorLayerSource {
  static final bool DO_RTREE_CHECK = false;

  static final double POINT_SIZE_FACTOR = 2;

  String _absolutePath;
  String _tableName;
  bool isVisible = true;
  String _attribution = "";

  QueryResult _tableData;
  Envelope _tableBounds;
  GeometryColumn _geometryColumn;
  BasicStyle _basicStyle;

  bool loaded = false;
  GeopackageDb db;

  GeopackageSource.fromMap(Map<String, dynamic> map) {
    _tableName = map['label'];
    String relativePath = map['file'];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map['isvisible'];
  }

  GeopackageSource(this._absolutePath, this._tableName);

  Future<void> load() async {
    if (!loaded) {
      db = new GeopackageDb(_absolutePath);
      db.doRtreeTestCheck = DO_RTREE_CHECK;
      await db.openOrCreate();

      _geometryColumn = await db.getGeometryColumnsForTable(_tableName);

//      _tableBounds = db.getTableBounds(_tableName);

      _tableData = await db.getTableData(_tableName);
      _tableBounds = Envelope.empty();
      _tableData.geoms.forEach((g) {
        _tableBounds.expandToIncludeEnvelope(g.getEnvelopeInternal());
      });

      _attribution = _attribution + "${_geometryColumn.geometryType.getTypeName()} (${_tableData.geoms.length}) ";

      _basicStyle = await db.getBasicStyle(_tableName);

      loaded = true;
    }
  }

  bool hasData() {
    return _tableData != null && _tableData.geoms.length > 0;
  }

  String getAbsolutePath() {
    return _absolutePath;
  }

  String getUrl() {
    return null;
  }

  String getName() {
    return _tableName;
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
        "label": "$_tableName",
        "file":"$relativePath",
        "isvisible": $isVisible 
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(Function showSnackbar) async {
    await load();

    List<LayerOptions> layers = [];

    switch (_geometryColumn.geometryType) {
      case EGeometryType.LINESTRING:
      case EGeometryType.MULTILINESTRING:
        List<Polyline> lines = [];
        _tableData.geoms.forEach((lineGeom) {
          Color strokeColor = ColorExt(_basicStyle.strokecolor).withOpacity(_basicStyle.strokealpha);
          for (int i = 0; i < lineGeom.getNumGeometries(); i++) {
            var geometryN = lineGeom.getGeometryN(i);
            List<LatLng> linePoints = geometryN.getCoordinates().map((c) => LatLng(c.y, c.x)).toList();
            lines.add(Polyline(points: linePoints, strokeWidth: _basicStyle.width, color: strokeColor));
          }
        });
        var lineLayer = PolylineLayerOptions(
          polylines: lines,
        );
        layers.add(lineLayer);
        break;
      case EGeometryType.POINT:
      case EGeometryType.MULTIPOINT:
        List<Marker> points = [];
        Color fillColorAlpha = ColorExt(_basicStyle.fillcolor).withOpacity(_basicStyle.fillalpha);
        Color fillColor = ColorExt(_basicStyle.fillcolor);
        double size = _basicStyle.size * POINT_SIZE_FACTOR;
        var dataSize = _tableData.geoms.length;
        for (int j = 0; j < dataSize; j++) {
          var pointGeom = _tableData.geoms[j];
          for (int i = 0; i < pointGeom.getNumGeometries(); i++) {
            var geometryN = pointGeom.getGeometryN(i);
            var c = geometryN.getCoordinate();
            Marker m = Marker(
              width: size,
              height: size,
              point: LatLng(c.y, c.x),
              builder: (ctx) => new Container(
                  child: GestureDetector(
                onTap: () async {
                  var dataMap = _tableData.data[j];
                  var snack = SnackBar(
                    backgroundColor: SmashColors.mainDecorations,
                    content: TableUtilities.fromMap(dataMap),
                    duration: Duration(seconds: 5),
                  );
                  showSnackbar(snack);
                },
                child: Icon(
                  MdiIcons.circle,
                  size: size,
                  color: fillColorAlpha,
                ),
              )),
            );
            points.add(m);
          }
        }
        var waypointsCluster = MarkerClusterLayerOptions(
          maxClusterRadius: 20,
          size: Size(40, 40),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: points,
          polygonOptions: PolygonOptions(borderColor: fillColor, color: fillColorAlpha, borderStrokeWidth: 3),
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
              backgroundColor: fillColor,
              foregroundColor: SmashColors.mainBackground,
              heroTag: null,
            );
          },
        );
        layers.add(waypointsCluster);

        break;
      case EGeometryType.POLYGON:
      case EGeometryType.MULTIPOLYGON:
        List<Polygon> polygons = [];
        Color strokeColor = ColorExt(_basicStyle.strokecolor).withOpacity(_basicStyle.strokealpha);
        Color fillColor = ColorExt(_basicStyle.fillcolor).withOpacity(_basicStyle.fillalpha);
        _tableData.geoms.forEach((polyGeom) {
          for (int i = 0; i < polyGeom.getNumGeometries(); i++) {
            var geometryN = polyGeom.getGeometryN(i);
            List<LatLng> polyPoints = geometryN.getCoordinates().map((c) => LatLng(c.y, c.x)).toList();
            polygons.add(Polygon(points: polyPoints, borderStrokeWidth: _basicStyle.width, borderColor: strokeColor, color: fillColor));
          }
        });
        var polyLayer = PolygonLayerOptions(
          polygons: polygons,
        );
        layers.add(polyLayer);
        break;
      default:
    }

    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() {
    var s = _tableBounds.getMinY();
    var n = _tableBounds.getMaxY();
    var w = _tableBounds.getMinX();
    var e = _tableBounds.getMaxX();
    LatLngBounds b = LatLngBounds(LatLng(s, w), LatLng(n, e));
    return Future.value(b);
  }
}

///// The notes properties page.
//class GeopackagePropertiesWidget extends StatefulWidget {
//  GeopackageSource _source;
//  Function _reloadLayersFunction;
//
//  GeopackagePropertiesWidget(this._source, this._reloadLayersFunction);
//
//  @override
//  State<StatefulWidget> createState() {
//    return GeopackagePropertiesWidgetState(_source);
//  }
//}
//
//class GeopackagePropertiesWidgetState extends State<GeopackagePropertiesWidget> {
//  GeopackageSource _source;
//  double _pointSizeSliderValue = 10;
//  double _lineWidthSliderValue = 2;
//  double _maxSize = 100.0;
//  double _maxWidth = 20.0;
//  ColorExt _pointColor;
//  ColorExt _lineColor;
//  bool _somethingChanged = false;
//
//  GeopackagePropertiesWidgetState(this._source);
//
//  @override
//  void initState() {
//    _pointSizeSliderValue = _source.pointsSize;
//    if (_pointSizeSliderValue > _maxSize) {
//      _pointSizeSliderValue = _maxSize;
//    }
//    _pointColor = ColorExt.fromColor(_source.pointFillColor);
//
//    _lineWidthSliderValue = _source.lineWidth;
//    if (_lineWidthSliderValue > _maxWidth) {
//      _lineWidthSliderValue = _maxWidth;
//    }
//    _lineColor = ColorExt.fromColor(_source.lineStrokeColor);
//
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: () async {
//          if (_somethingChanged) {
//            _source.pointFillColor = _pointColor;
//            _source.pointsSize = _pointSizeSliderValue;
//            _source.lineStrokeColor = _lineColor;
//            _source.lineWidth = _lineWidthSliderValue;
//
//            widget._reloadLayersFunction();
//          }
//          return true;
//        },
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text("Geopackage Properties"),
//          ),
//          body: Center(
//            child: ListView(
//              children: <Widget>[
//                Padding(
//                  padding: SmashUI.defaultPadding(),
//                  child: Card(
//                    elevation: SmashUI.DEFAULT_ELEVATION,
//                    shape: SmashUI.defaultShapeBorder(),
//                    child: Column(
//                      children: <Widget>[
//                        SmashUI.titleText("Waypoints Color"),
//                        Padding(
//                          padding: SmashUI.defaultPadding(),
//                          child: LimitedBox(
//                            maxHeight: 400,
//                            child: MaterialColorPicker(
//                                shrinkWrap: true,
//                                allowShades: false,
//                                circleSize: 45,
//                                onColorChange: (Color color) {
//                                  _pointColor = ColorExt.fromColor(color);
//                                  _somethingChanged = true;
//                                },
//                                onMainColorChange: (mColor) {
//                                  _pointColor = ColorExt.fromColor(mColor);
//                                  _somethingChanged = true;
//                                },
//                                selectedColor: Color(_pointColor.value)),
//                          ),
//                        ),
//                        SmashUI.titleText("Waypoints Size"),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Flexible(
//                                flex: 1,
//                                child: Slider(
//                                  activeColor: SmashColors.mainSelection,
//                                  min: 1.0,
//                                  max: _maxSize,
//                                  divisions: 20,
//                                  onChanged: (newRating) {
//                                    _somethingChanged = true;
//                                    setState(() => _pointSizeSliderValue = newRating);
//                                  },
//                                  value: _pointSizeSliderValue,
//                                )),
//                            Container(
//                              width: 50.0,
//                              alignment: Alignment.center,
//                              child: SmashUI.normalText(
//                                '${_pointSizeSliderValue.toInt()}',
//                              ),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: SmashUI.defaultPadding(),
//                  child: Card(
//                    elevation: SmashUI.DEFAULT_ELEVATION,
//                    shape: SmashUI.defaultShapeBorder(),
//                    child: Column(
//                      children: <Widget>[
//                        SmashUI.titleText("Tracks/Routes Color"),
//                        Padding(
//                          padding: SmashUI.defaultPadding(),
//                          child: LimitedBox(
//                            maxHeight: 400,
//                            child: MaterialColorPicker(
//                                shrinkWrap: true,
//                                allowShades: false,
//                                circleSize: 45,
//                                onColorChange: (Color color) {
//                                  _lineColor = ColorExt.fromColor(color);
//                                  _somethingChanged = true;
//                                },
//                                onMainColorChange: (mColor) {
//                                  _lineColor = ColorExt.fromColor(mColor);
//                                  _somethingChanged = true;
//                                },
//                                selectedColor: Color(_lineColor.value)),
//                          ),
//                        ),
//                        SmashUI.titleText("Tracks/Routes Width"),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Flexible(
//                                flex: 1,
//                                child: Slider(
//                                  activeColor: SmashColors.mainSelection,
//                                  min: 1.0,
//                                  max: _maxWidth,
//                                  divisions: 20,
//                                  onChanged: (newRating) {
//                                    _somethingChanged = true;
//                                    setState(() => _lineWidthSliderValue = newRating);
//                                  },
//                                  value: _lineWidthSliderValue,
//                                )),
//                            Container(
//                              width: 50.0,
//                              alignment: Alignment.center,
//                              child: SmashUI.normalText(
//                                '${_lineWidthSliderValue.toInt()}',
//                              ),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ));
//  }
//}
