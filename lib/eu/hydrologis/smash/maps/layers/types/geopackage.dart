/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' as JTS;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' hide TextStyle;
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/util/experimentals.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:image/image.dart' as IMG;

/// Geopackage vector data layer.
class GeopackageSource extends DbVectorLayerSource implements SldLayerSource {
  static final double POINT_SIZE_FACTOR = 3;

  String _absolutePath;
  String _tableName;
  bool isVisible = true;
  String _attribution = "";

  GPQueryResult _tableData;
  JTS.Envelope _tableBounds;
  GeometryColumn _geometryColumn;
  SldObjectParser _style;
  TextStyle _textStyle;

  GeopackageDb _gpkgDb;
  int _srid;

  List<String> alphaFields = [];
  String sldString;
  JTS.EGeometryType geometryType;

  GeopackageSource.fromMap(Map<String, dynamic> map) {
    _tableName = map[LAYERSKEY_LABEL];
    String relativePath = map[LAYERSKEY_FILE];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];

    _srid = map[LAYERSKEY_SRID];
  }

  GeopackageSource(this._absolutePath, this._tableName);

  Future<void> load(BuildContext context) async {
    if (!isLoaded) {
      int maxFeaturesToLoad = GpPreferences()
          .getIntSync(SmashPreferencesKeys.KEY_VECTOR_MAX_FEATURES, -1);
      bool loadOnlyVisible = GpPreferences().getBooleanSync(
          SmashPreferencesKeys.KEY_VECTOR_LOAD_ONLY_VISIBLE, false);

      JTS.Envelope limitBounds;
      if (loadOnlyVisible) {
        var mapState = Provider.of<SmashMapState>(context, listen: false);
        if (mapState.mapController != null) {
          var bounds = mapState.mapController.bounds;
          var n = bounds.north;
          var s = bounds.south;
          var e = bounds.east;
          var w = bounds.west;
          limitBounds = JTS.Envelope.fromCoordinates(
              JTS.Coordinate(w, s), JTS.Coordinate(e, n));
        }
      }

      _getDatabase();
      var sqlName = SqlName(_tableName);
      _geometryColumn = _gpkgDb.getGeometryColumnsForTable(sqlName);
      _srid = _geometryColumn.srid;
      geometryType = _geometryColumn.geometryType;
      var alphaFieldsTmp = _gpkgDb.getTableColumns(sqlName);

      alphaFields = alphaFieldsTmp.map((e) => e[0] as String).toList();
      alphaFields
          .removeWhere((name) => name == _geometryColumn.geometryColumnName);

      sldString = _gpkgDb.getSld(sqlName);
      if (sldString == null) {
        if (_geometryColumn.geometryType.isPoint()) {
          sldString = DefaultSlds.simplePointSld();
          _gpkgDb.updateSld(sqlName, sldString);
        } else if (_geometryColumn.geometryType.isLine()) {
          sldString = DefaultSlds.simpleLineSld();
          _gpkgDb.updateSld(sqlName, sldString);
        } else if (_geometryColumn.geometryType.isPolygon()) {
          sldString = DefaultSlds.simplePolygonSld();
          _gpkgDb.updateSld(sqlName, sldString);
        }
      }
      if (sldString != null) {
        _style = SldObjectParser.fromString(sldString);
        _style.parse();

        if (_style.featureTypeStyles.first.rules.first.textSymbolizers.length >
            0) {
          _textStyle = _style
              .featureTypeStyles.first.rules.first.textSymbolizers.first.style;
        }
      }
      if (maxFeaturesToLoad == -1) {
        maxFeaturesToLoad = null;
      }
      _tableData = _gpkgDb.getTableData(
        SqlName(_tableName),
        limit: maxFeaturesToLoad,
        envelope: limitBounds,
      );

      var fromPrj = SmashPrj.fromSrid(_srid);
      if (fromPrj != null) {
        SmashPrj.transformListToWgs84(fromPrj, _tableData.geoms);
        _tableBounds = JTS.Envelope.empty();
        _tableData.geoms.forEach((g) {
          _tableBounds.expandToIncludeEnvelope(g.getEnvelopeInternal());
        });

        _attribution =
            "${_geometryColumn.geometryType.getTypeName()} (${_tableData.geoms.length}) ";

        isLoaded = true;
      }
    }
  }

  dynamic get db => _gpkgDb;

  _getDatabase() {
    var ch = ConnectionsHandler();
    // ch.doRtreeCheck = DO_RTREE_CHECK;
    if (_gpkgDb == null) {
      _gpkgDb = ch.open(_absolutePath, tableName: _tableName);
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

  IconData getIcon() => SmashIcons.iconTypeGeopackage;

  String getUser() => null;

  String getPassword() => null;

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
        "$LAYERSKEY_LABEL": "$_tableName",
        "$LAYERSKEY_FILE":"$relativePath",
        "$LAYERSKEY_ISVECTOR": true,
        "$LAYERSKEY_SRID": $_srid,
        "$LAYERSKEY_ISVISIBLE": $isVisible 
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    await load(context);

    List<LayerOptions> layers = [];
    if (_tableData.geoms.isNotEmpty) {
      List<List<Marker>> allPoints = [];
      List<Polyline> allLines = [];
      List<Polygon> allPolygons = [];

      Color pointFillColor;
      _style.applyForEachRule((fts, Rule rule) {
        if (geometryType.isPoint()) {
          List<Marker> points = makeMarkersForRule(rule);
          if (rule.pointSymbolizers.isNotEmpty && pointFillColor == null) {
            pointFillColor =
                ColorExt(rule.pointSymbolizers[0].style.fillColorHex);
          }
          allPoints.add(points);
        } else if (geometryType.isLine()) {
          List<Polyline> lines = makeLinesForRule(rule);
          allLines.addAll(lines);
        } else if (geometryType.isPolygon()) {
          List<Polygon> polygons = makePolygonsForRule(rule);
          allPolygons.addAll(polygons);
        }
      });

      if (allPoints.isNotEmpty) {
        addMarkerLayer(allPoints, layers, pointFillColor);
      } else if (allLines.isNotEmpty) {
        var lineLayer = PolylineLayerOptions(
          polylineCulling: true,
          polylines: allLines,
        );
        layers.add(lineLayer);
      } else if (allPolygons.isNotEmpty) {
        var polygonLayer = PolygonLayerOptions(
          polygonCulling: true,
          // simplify: true,
          polygons: allPolygons,
        );
        layers.add(polygonLayer);
      }
    }
    return layers;
  }

  List<Polygon> makePolygonsForRule(Rule rule) {
    List<Polygon> polygons = [];
    var filter = rule.filter;
    var key = filter?.uniqueValueKey;
    var value = filter?.uniqueValueValue;

    var polygonSymbolizersList = rule.polygonSymbolizers;
    if (polygonSymbolizersList == null || polygonSymbolizersList.isEmpty) {
      return [];
    }
    var polygonStyle = polygonSymbolizersList[0].style ??= PolygonStyle();

    var lineWidth = polygonStyle.strokeWidth;
    Color lineStrokeColor = ColorExt(polygonStyle.strokeColorHex);
    var lineOpacity = polygonStyle.strokeOpacity * 255;
    lineStrokeColor = lineStrokeColor.withAlpha(lineOpacity.toInt());

    Color fillColor = ColorExt(polygonStyle.fillColorHex)
        .withAlpha((polygonStyle.fillOpacity * 255).toInt());

    var featureCount = _tableData.geoms.length;
    for (var i = 0; i < featureCount; i++) {
      var geom = _tableData.geoms[i];
      var attributes = _tableData.data[i];
      if (key == null || attributes[key]?.toString() == value) {
        var count = geom.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.Polygon p = geom.getGeometryN(i);
          // ext ring
          var extCoords = p
              .getExteriorRing()
              .getCoordinates()
              .map((c) => LatLng(c.y, c.x))
              .toList();

          // inter rings
          var numInteriorRing = p.getNumInteriorRing();
          List<List<LatLng>> intRingCoords = [];
          for (var i = 0; i < numInteriorRing; i++) {
            var intCoords = p
                .getInteriorRingN(i)
                .getCoordinates()
                .map((c) => LatLng(c.y, c.x))
                .toList();
            intRingCoords.add(intCoords);
          }

          polygons.add(Polygon(
            points: extCoords,
            borderStrokeWidth: lineWidth,
            holePointsList: intRingCoords,
            borderColor: lineStrokeColor,
            color: fillColor,
          ));
        }
      }
    }

    return polygons;
  }

  List<Polyline> makeLinesForRule(Rule rule) {
    List<Polyline> lines = [];
    var filter = rule.filter;
    var key = filter?.uniqueValueKey;
    var value = filter?.uniqueValueValue;

    var lineSymbolizersList = rule.lineSymbolizers;
    if (lineSymbolizersList == null || lineSymbolizersList.isEmpty) {
      return [];
    }
    var lineStyle = lineSymbolizersList[0].style ??= LineStyle();

    var lineWidth = lineStyle.strokeWidth;
    Color lineStrokeColor = ColorExt(lineStyle.strokeColorHex);
    var lineOpacity = lineStyle.strokeOpacity * 255;
    lineStrokeColor = lineStrokeColor.withAlpha(lineOpacity.toInt());

    var featureCount = _tableData.geoms.length;
    for (var i = 0; i < featureCount; i++) {
      var geom = _tableData.geoms[i];
      var attributes = _tableData.data[i];
      if (key == null || attributes[key]?.toString() == value) {
        var count = geom.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.LineString l = geom.getGeometryN(i);
          var linePoints =
              l.getCoordinates().map((c) => LatLng(c.y, c.x)).toList();
          lines.add(Polyline(
              points: linePoints,
              strokeWidth: lineWidth,
              color: lineStrokeColor));
        }
      }
    }

    return lines;
  }

  /// Create markers for a given [Rule].
  List<Marker> makeMarkersForRule(Rule rule) {
    List<Marker> points = [];
    var filter = rule.filter;
    var key = filter?.uniqueValueKey;
    var value = filter?.uniqueValueValue;

    var pointSymbolizersList = rule.pointSymbolizers;
    if (pointSymbolizersList == null || pointSymbolizersList.isEmpty) {
      return [];
    }
    var pointStyle = pointSymbolizersList[0].style ??= PointStyle();
    var iconData = SmashIcons.forSldWkName(pointStyle.markerName);
    var pointsSize = pointStyle.markerSize * 3;
    Color pointFillColor = ColorExt(pointStyle.fillColorHex);
    pointFillColor = pointFillColor.withOpacity(pointStyle.fillOpacity);

    String labelName;
    ColorExt labelColor;
    if (_textStyle != null) {
      labelName = _textStyle.labelName;
      labelColor = ColorExt(_textStyle.textColor);
    }

    var featureCount = _tableData.geoms.length;
    for (var i = 0; i < featureCount; i++) {
      var geom = _tableData.geoms[i];
      var attributes = _tableData.data[i];
      if (key == null || attributes[key]?.toString() == value) {
        var count = geom.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.Point l = geom.getGeometryN(i);
          var labelText = attributes[labelName];
          double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
          String labelTextString;
          if (labelText == null) {
            textExtraHeight = 0;
          } else {
            labelTextString = labelText.toString();
          }

          Marker m = Marker(
              width: pointsSize * MARKER_ICON_TEXT_EXTRA_WIDTH_FACTOR,
              height: pointsSize + textExtraHeight,
              point: LatLng(l.getY(), l.getX()),
              // anchorPos: AnchorPos.exactly(
              //     Anchor(pointsSize / 2, textExtraHeight + pointsSize / 2)),
              builder: (ctx) => MarkerIcon(
                    iconData,
                    pointFillColor,
                    pointsSize,
                    labelTextString,
                    labelColor,
                    pointFillColor.withAlpha(100),
                  ));
          points.add(m);
        }
      }
    }
    return points;
  }

  void addMarkerLayer(List<List<Marker>> allPoints, List<LayerOptions> layers,
      Color pointFillColor) {
    if (allPoints.length == 1) {
      var waypointsCluster = MarkerClusterLayerOptions(
        maxClusterRadius: 20,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: allPoints[0],
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
    } else {
      // in case of multiple rules, we would not know the color for a mixed cluster.
      List<Marker> points = [];
      allPoints.forEach((p) => points.addAll(p));
      layers.add(MarkerLayerOptions(markers: points));
    }
  }

  @override
  Future<LatLngBounds> getBounds() async {
    if (_tableBounds != null) {
      var s = _tableBounds.getMinY();
      var n = _tableBounds.getMaxY();
      var w = _tableBounds.getMinX();
      var e = _tableBounds.getMaxX();
      LatLngBounds b = LatLngBounds(LatLng(s, w), LatLng(n, e));
      return b;
    } else {
      return null;
    }
  }

  @override
  void disposeSource() {
    ConnectionsHandler().close(getAbsolutePath(), tableName: getName());
  }

  @override
  bool hasProperties() {
    return true;
  }

  @override
  bool isZoomable() {
    return _tableBounds != null;
  }

  @override
  int getSrid() {
    return _srid;
  }

  @override
  void calculateSrid() {
    if (_srid == null) {
      if (_gpkgDb == null) {
        _getDatabase();
      }
      if (_srid == null) {
        _geometryColumn =
            _gpkgDb.getGeometryColumnsForTable(SqlName(_tableName));
        _srid = _geometryColumn.srid;
      }
    }
    return;
  }

  Widget getPropertiesWidget() {
    return SldPropertiesEditor(sldString, geometryType,
        alphaFields: alphaFields);
  }

  @override
  void updateStyle(String newSldString) {
    sldString = newSldString;
    var _styleTmp = SldObjectParser.fromString(sldString);
    _styleTmp.parse();

    // check is label has changed, in that case a reload will be necessary
    if (_styleTmp.featureTypeStyles.first.rules.first.textSymbolizers.length >
        0) {
      var textStyleTmp = _styleTmp
          .featureTypeStyles.first.rules.first.textSymbolizers.first.style;

      if (_textStyle?.labelName != textStyleTmp.labelName) {
        isLoaded = false;
      }
      _textStyle = textStyleTmp;
    }
    _style = _styleTmp;
    _gpkgDb.updateSld(SqlName(_tableName), sldString);
  }

  @override
  String getWhere() => "";
}

class GeopackageLazyTileImageProvider
    extends ImageProvider<GeopackageLazyTileImageProvider> {
  LazyGpkgTile _tile;
  List<int> _rgbToHide;
  GeopackageLazyTileImageProvider(this._tile, this._rgbToHide);

  @override
  ImageStreamCompleter load(
      GeopackageLazyTileImageProvider key, DecoderCallback decoder) {
    return MultiFrameImageStreamCompleter(
      codec: loadAsync(key),
      scale: 1.0,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<GeopackageLazyTileImageProvider>(
            'Image key', key);
      },
    );
  }

  Future<UI.Codec> loadAsync(GeopackageLazyTileImageProvider key) async {
    assert(key == this);

    try {
      _tile.fetch();
      if (_tile.tileImageBytes != null) {
        var finalBytes = _tile.tileImageBytes;
        if (EXPERIMENTAL_HIDE_COLOR_RASTER__ENABLED && _rgbToHide != null) {
          final image = IMG.decodeImage(_tile.tileImageBytes);
          ImageUtilities.colorToAlphaImg(
              image, _rgbToHide[0], _rgbToHide[1], _rgbToHide[2]);
          finalBytes = IMG.encodePng(image);
        }
        return await PaintingBinding.instance.instantiateImageCodec(finalBytes);
      }
    } catch (e) {
      print(e); // ignore later
    }

    return Future<UI.Codec>.error('Failed to load tile: $_tile');
  }

  @override
  Future<GeopackageLazyTileImageProvider> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode {
    var objects = [_tile.tableName, _tile.xTile, _tile.yTile, _tile.zoomLevel];
    if (_rgbToHide != null) {
      objects.addAll(_rgbToHide);
    }
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    return other is GeopackageLazyTileImageProvider &&
        _tile == other._tile &&
        _rgbToHide == other._rgbToHide;
  }
}

var _emptyImageBytes;

/// Tile image provider for geopackage raster tiles.
///
/// This works different than the overlay image version (which could make things go OOM).
class GeopackageTileImageProvider extends TileProvider {
  GeopackageDb _loadedDb;
  SqlName _tableName;

  GeopackageTileImageProvider(this._loadedDb, this._tableName);

  @override
  void dispose() {
    // dispose of db connections is done when layers are removed
  }

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    var x = coords.x.round();
    var y = options.tms
        ? invertY(coords.y.round(), coords.z.round())
        : coords.y.round();
    var z = coords.z.round();

    return GeopackageTileImage(_loadedDb, _tableName, Coords<int>(x, y)..z = z);
  }
}

class GeopackageTileImage extends ImageProvider<GeopackageTileImage> {
  final GeopackageDb database;
  SqlName tableName;
  final Coords<int> coords;
  GeopackageTileImage(this.database, this.tableName, this.coords);

  @override
  ImageStreamCompleter load(GeopackageTileImage key, DecoderCallback decoder) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<ImageProvider>('Image key', key);
        });
  }

  Future<UI.Codec> _loadAsync(GeopackageTileImage key) async {
    assert(key == this);

    var tileBytes = database.getTile(tableName, coords.x, coords.y, coords.z);
    if (tileBytes != null) {
      Uint8List bytes = tileBytes;
      return await PaintingBinding.instance.instantiateImageCodec(bytes);
    } else {
      // TODO get from other zoomlevels
      if (_emptyImageBytes == null) {
        ByteData imageData = await rootBundle.load('assets/emptytile256.png');
        _emptyImageBytes = imageData.buffer.asUint8List();
      }
      if (_emptyImageBytes != null) {
        var bytes = _emptyImageBytes;
        return await PaintingBinding.instance.instantiateImageCodec(bytes);
      } else {
        return Future<UI.Codec>.error(
            'Failed to load tile for coords: $coords');
      }
    }
  }

  @override
  Future<GeopackageTileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(other) {
    return other is GeopackageTileImage && coords == other.coords;
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
