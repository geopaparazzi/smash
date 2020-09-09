/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' hide Polygon;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' hide TextStyle;
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/util/experimentals.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:image/image.dart' as IMG;

/// Geopackage vector data layer.
class GeopackageSource extends VectorLayerSource implements SldLayerSource {
  static final bool DO_RTREE_CHECK = false;

  static final double POINT_SIZE_FACTOR = 3;

  String _absolutePath;
  String _tableName;
  bool isVisible = true;
  String _attribution = "";

  List<Geometry> _tableGeoms;
  Envelope _tableBounds;
  GeometryColumn _geometryColumn;
  SldObjectParser _style;
  TextStyle _textStyle;

  bool loaded = false;
  GeopackageDb db;
  int _srid;

  List<String> alphaFields = [];
  String sldString;
  EGeometryType geometryType;

  GeopackageSource.fromMap(Map<String, dynamic> map) {
    _tableName = map[LAYERSKEY_LABEL];
    String relativePath = map[LAYERSKEY_FILE];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];

    _srid = map[LAYERSKEY_SRID];
  }

  GeopackageSource(this._absolutePath, this._tableName);

  Future<void> load(BuildContext context) async {
    if (!loaded) {
      int maxFeaturesToLoad =
          GpPreferences().getIntSync(KEY_VECTOR_MAX_FEATURES, -1);
      bool loadOnlyVisible =
          GpPreferences().getBooleanSync(KEY_VECTOR_LOAD_ONLY_VISIBLE, false);

      Envelope limitBounds;
      if (loadOnlyVisible) {
        var mapState = Provider.of<SmashMapState>(context, listen: false);
        if (mapState.mapController != null) {
          var bounds = mapState.mapController.bounds;
          var n = bounds.north;
          var s = bounds.south;
          var e = bounds.east;
          var w = bounds.west;
          limitBounds =
              Envelope.fromCoordinates(Coordinate(w, s), Coordinate(e, n));
        }
      }

      getDatabase();
      _geometryColumn = db.getGeometryColumnsForTable(_tableName);
      _srid = _geometryColumn.srid;
      geometryType = _geometryColumn.geometryType;
      var alphaFieldsTmp = db.getTableColumns(_tableName);

      alphaFields = alphaFieldsTmp.map((e) => e[0] as String).toList();
      alphaFields
          .removeWhere((name) => name == _geometryColumn.geometryColumnName);

      sldString = db.getSld(_tableName);
      if (sldString == null) {
        if (_geometryColumn.geometryType.isPoint()) {
          sldString = DefaultSlds.simplePointSld();
          db.updateSld(_tableName, sldString);
        } else if (_geometryColumn.geometryType.isLine()) {
          sldString = DefaultSlds.simpleLineSld();
          db.updateSld(_tableName, sldString);
        } else if (_geometryColumn.geometryType.isPolygon()) {
          sldString = DefaultSlds.simplePolygonSld();
          db.updateSld(_tableName, sldString);
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

//      _tableBounds = db.getTableBounds(_tableName);

      String userDataField = _textStyle != null
          ? _textStyle.labelName.length > 0 ? _textStyle.labelName : null
          : null;
      _tableGeoms = db.getGeometriesIn(_tableName,
          limit: maxFeaturesToLoad,
          envelope: limitBounds,
          userDataField: userDataField);

      var fromPrj = SmashPrj.fromSrid(_srid);
      SmashPrj.transformListToWgs84(fromPrj, _tableGeoms);
      _tableBounds = Envelope.empty();
      _tableGeoms.forEach((g) {
        _tableBounds.expandToIncludeEnvelope(g.getEnvelopeInternal());
      });

      _attribution =
          "${_geometryColumn.geometryType.getTypeName()} (${_tableGeoms.length}) ";

      loaded = true;
    }
  }

  getDatabase() {
    var ch = ConnectionsHandler();
    // ch.doRtreeCheck = DO_RTREE_CHECK;
    if (db == null) {
      db = ch.open(_absolutePath, tableName: _tableName);
    }
  }

  bool hasData() {
    return _tableGeoms != null && _tableGeoms.length > 0;
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
    load(context);

    List<LayerOptions> layers = [];

    switch (_geometryColumn.geometryType) {
      case EGeometryType.LINESTRING:
      case EGeometryType.MULTILINESTRING:
        List<Polyline> lines = [];

        var lineStyle = _style
            .featureTypeStyles.first.rules.first.lineSymbolizers.first.style;
        _tableGeoms.forEach((lineGeom) {
          Color strokeColor = ColorExt(lineStyle.strokeColorHex)
              .withOpacity(lineStyle.strokeOpacity);
          for (int i = 0; i < lineGeom.getNumGeometries(); i++) {
            var geometryN = lineGeom.getGeometryN(i);
            List<LatLng> linePoints = geometryN
                .getCoordinates()
                .map((c) => LatLng(c.y, c.x))
                .toList();
            lines.add(Polyline(
                points: linePoints,
                strokeWidth: lineStyle.strokeWidth,
                color: strokeColor));
          }
        });
        var lineLayer = PolylineLayerOptions(
          polylineCulling: true,
          polylines: lines,
        );
        layers.add(lineLayer);
        break;
      case EGeometryType.POINT:
      case EGeometryType.MULTIPOINT:
        var pointStyle = _style
            .featureTypeStyles.first.rules.first.pointSymbolizers.first.style;
        var iconData = SmashIcons.forSldWkName(pointStyle.markerName);
        double pointsSize = pointStyle.markerSize * POINT_SIZE_FACTOR;

        bool doLabels = _textStyle != null &&
            _textStyle.labelName != null &&
            _textStyle.labelName.trim().isNotEmpty;

        Color fillColor = ColorExt(pointStyle.fillColorHex)
            .withOpacity(pointStyle.fillOpacity);
        Color textColor = doLabels ? ColorExt(_textStyle.textColor) : null;

        List<Marker> points = [];
        var dataSize = _tableGeoms.length;
        for (int j = 0; j < dataSize; j++) {
          var pointGeom = _tableGeoms[j];
          for (int i = 0; i < pointGeom.getNumGeometries(); i++) {
            var geometryN = pointGeom.getGeometryN(i);
            var c = geometryN.getCoordinate();
            String labelText =
                doLabels ? geometryN.getUserData()?.toString() ?? "" : null;
            double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
            if (labelText == null) {
              textExtraHeight = 0;
            }
            Marker m = Marker(
                width: pointsSize * MARKER_ICON_TEXT_EXTRA_WIDTH_FACTOR,
                height: pointsSize + textExtraHeight,
                point: LatLng(c.y, c.x),
                // anchorPos: AnchorPos.exactly(
                //     Anchor(pointsSize / 2, textExtraHeight + pointsSize / 2)),
                builder: (ctx) => MarkerIcon(
                      iconData,
                      fillColor,
                      pointsSize,
                      labelText,
                      textColor,
                      fillColor.withAlpha(100),
                    ));
            points.add(m);
            // Widget widget;
            // if (textColor != null) {
            //   widget = MarkerIcon(iconData, fillColor, size,
            //       userData.toString(), textColor, fillColor);
            // } else {
            //   widget = Container(
            //     child: Icon(
            //       iconData,
            //       size: size,
            //       color: fillColor,
            //     ),
            //   );
            // }
            // Marker m = Marker(
            //   width: size,
            //   height: size,
            //   point: LatLng(c.y, c.x),
            //   builder: (ctx) {
            //     return widget;
            //   },
            // );
            // points.add(m);
          }
        }
        var waypointsCluster = MarkerClusterLayerOptions(
          maxClusterRadius: 20,
          size: Size(40, 40),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: points,
          polygonOptions: PolygonOptions(
              borderColor: fillColor, color: fillColor, borderStrokeWidth: 3),
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
        var polygonStyle = _style
            .featureTypeStyles.first.rules.first.polygonSymbolizers.first.style;
        List<Polygon> polygons = [];
        Color strokeColor = ColorExt(polygonStyle.strokeColorHex)
            .withOpacity(polygonStyle.strokeOpacity);
        Color fillColor = ColorExt(polygonStyle.fillColorHex)
            .withOpacity(polygonStyle.fillOpacity);
        _tableGeoms.forEach((polyGeom) {
          for (int i = 0; i < polyGeom.getNumGeometries(); i++) {
            var geometryN = polyGeom.getGeometryN(i);
            List<LatLng> polyPoints = geometryN
                .getCoordinates()
                .map((c) => LatLng(c.y, c.x))
                .toList();
            polygons.add(Polygon(
                points: polyPoints,
                borderStrokeWidth: polygonStyle.strokeWidth,
                borderColor: strokeColor,
                color: fillColor));
          }
        });
        var polyLayer = PolygonLayerOptions(
          polygonCulling: true,
          polygons: polygons,
        );
        layers.add(polyLayer);
        break;
      default:
    }

    return layers;
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
      if (db == null) {
        getDatabase();
      }
      if (_srid == null) {
        _geometryColumn = db.getGeometryColumnsForTable(_tableName);
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
        loaded = false;
      }
      _textStyle = textStyleTmp;
    }
    _style = _styleTmp;
    db.updateSld(_tableName, sldString);
  }
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
      scale: 1,
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
          ImageUtilities.colorToAlphaBlend(
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
  String _tableName;

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
  String tableName;
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
