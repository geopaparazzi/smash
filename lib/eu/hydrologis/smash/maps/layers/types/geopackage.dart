/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:dart_jts/dart_jts.dart' hide Polygon;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/projection.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';

class GeopackageSource extends VectorLayerSource {
  static final bool DO_RTREE_CHECK = false;

  static final double POINT_SIZE_FACTOR = 2;

  String _absolutePath;
  String _tableName;
  bool isVisible = true;
  String _attribution = "";

  List<Geometry> _tableGeoms;
  Envelope _tableBounds;
  GeometryColumn _geometryColumn;
  BasicStyle _basicStyle;

  bool loaded = false;
  GeopackageDb db;
  int _srid;

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
        var mapState = Provider.of<SmashMapState>(context);
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

      await getDatabase();
      _geometryColumn = await db.getGeometryColumnsForTable(_tableName);
      _srid = _geometryColumn.srid;

//      _tableBounds = db.getTableBounds(_tableName);

      _tableGeoms = await db.getGeometriesIn(_tableName,
          limit: maxFeaturesToLoad, envelope: limitBounds);

      var fromPrj = SmashPrj.fromSrid(_srid);
      SmashPrj.transformListToWgs84(fromPrj, _tableGeoms);
      _tableBounds = Envelope.empty();
      _tableGeoms.forEach((g) {
        _tableBounds.expandToIncludeEnvelope(g.getEnvelopeInternal());
      });

      _attribution = _attribution +
          "${_geometryColumn.geometryType.getTypeName()} (${_tableGeoms.length}) ";

      _basicStyle = await db.getBasicStyle(_tableName);

      loaded = true;
    }
  }

  Future getDatabase() async {
    var ch = ConnectionsHandler();
    ch.doRtreeCheck = DO_RTREE_CHECK;
    if (db == null) {
      db = await ch.open(_absolutePath, tableName: _tableName);
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
    await load(context);

    List<LayerOptions> layers = [];

    switch (_geometryColumn.geometryType) {
      case EGeometryType.LINESTRING:
      case EGeometryType.MULTILINESTRING:
        List<Polyline> lines = [];
        _tableGeoms.forEach((lineGeom) {
          Color strokeColor = ColorExt(_basicStyle.strokecolor)
              .withOpacity(_basicStyle.strokealpha);
          for (int i = 0; i < lineGeom.getNumGeometries(); i++) {
            var geometryN = lineGeom.getGeometryN(i);
            List<LatLng> linePoints = geometryN
                .getCoordinates()
                .map((c) => LatLng(c.y, c.x))
                .toList();
            lines.add(Polyline(
                points: linePoints,
                strokeWidth: _basicStyle.width,
                color: strokeColor));
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
        Color fillColorAlpha =
            ColorExt(_basicStyle.fillcolor).withOpacity(_basicStyle.fillalpha);
        Color fillColor = ColorExt(_basicStyle.fillcolor);
        double size = _basicStyle.size * POINT_SIZE_FACTOR;
        var dataSize = _tableGeoms.length;
        for (int j = 0; j < dataSize; j++) {
          var pointGeom = _tableGeoms[j];
          for (int i = 0; i < pointGeom.getNumGeometries(); i++) {
            var geometryN = pointGeom.getGeometryN(i);
            var c = geometryN.getCoordinate();
            Marker m = Marker(
              width: size,
              height: size,
              point: LatLng(c.y, c.x),
              builder: (ctx) => new Container(
                child: Icon(
                  MdiIcons.circle,
                  size: size,
                  color: fillColorAlpha,
                ),
              ),
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
          polygonOptions: PolygonOptions(
              borderColor: fillColor,
              color: fillColorAlpha,
              borderStrokeWidth: 3),
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
        Color strokeColor = ColorExt(_basicStyle.strokecolor)
            .withOpacity(_basicStyle.strokealpha);
        Color fillColor =
            ColorExt(_basicStyle.fillcolor).withOpacity(_basicStyle.fillalpha);
        _tableGeoms.forEach((polyGeom) {
          for (int i = 0; i < polyGeom.getNumGeometries(); i++) {
            var geometryN = polyGeom.getGeometryN(i);
            List<LatLng> polyPoints = geometryN
                .getCoordinates()
                .map((c) => LatLng(c.y, c.x))
                .toList();
            polygons.add(Polygon(
                points: polyPoints,
                borderStrokeWidth: _basicStyle.width,
                borderColor: strokeColor,
                color: fillColor));
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
    if (_tableBounds != null) {
      var s = _tableBounds.getMinY();
      var n = _tableBounds.getMaxY();
      var w = _tableBounds.getMinX();
      var e = _tableBounds.getMaxX();
      LatLngBounds b = LatLngBounds(LatLng(s, w), LatLng(n, e));
      return Future.value(b);
    } else {
      Future.value(null);
    }
  }

  @override
  void disposeSource() {
    ConnectionsHandler().close(getAbsolutePath(), tableName: getName());
  }

  @override
  bool hasProperties() {
    return false; // TODO at the moment they are fixed.
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
  Future<void> calculateSrid() async {
    if (_srid == null) {
      if (db == null) {
        await getDatabase();
      }
      if (_srid == null) {
        _geometryColumn = await db.getGeometryColumnsForTable(_tableName);
        _srid = _geometryColumn.srid;
      }
    }
    return;
  }
}

class GeopackageImageProvider extends TileProvider {
  final File geopackageFile;
  final String tableName;

  GeopackageDb _loadedDb;
  bool isDisposed = true;
  LatLngBounds _bounds;
  Uint8List _emptyImageBytes;

  GeopackageImageProvider(this.geopackageFile, this.tableName);

  Future<GeopackageDb> open() async {
    if (_loadedDb == null || !_loadedDb.isOpen()) {
      var ch = ConnectionsHandler();
      _loadedDb = await ch.open(geopackageFile.path, tableName: tableName);
    }
    if (isDisposed) {
      await _loadedDb.openOrCreate();

      try {
        TileEntry tile = await _loadedDb.tile(tableName);
        Envelope bounds = tile.getBounds();
        Envelope bounds4326 = MercatorUtils.convert3857To4326Env(bounds);
        var w = bounds4326.getMinX();
        var e = bounds4326.getMaxX();
        var s = bounds4326.getMinY();
        var n = bounds4326.getMaxY();

        LatLngBounds b = LatLngBounds();
        b.extend(LatLng(s, w));
        b.extend(LatLng(n, e));
        _bounds = b;

        ByteData imageData = await rootBundle.load('assets/emptytile256.png');
        _emptyImageBytes = imageData.buffer.asUint8List();

//        UI.Image _emptyImage = await ImageWidgetUtilities.transparentImage();
//        var byteData = await _emptyImage.toByteData(format: UI.ImageByteFormat.png);
//        _emptyImageBytes = byteData.buffer.asUint8List();

      } catch (e) {
        GpLogger().err("Error getting geopackage bounds or empty image.", e);
      }

      isDisposed = false;
    }

    return _loadedDb;
  }

  LatLngBounds get bounds => this._bounds;

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

    return GeopackageImage(geopackageFile.path, tableName,
        Coords<int>(x, y)..z = z, _emptyImageBytes);
  }
}

class GeopackageImage extends ImageProvider<GeopackageImage> {
  final String databasePath;
  String tableName;
  final Coords<int> coords;
  Uint8List _emptyImageBytes;

  GeopackageImage(
      this.databasePath, this.tableName, this.coords, this._emptyImageBytes);

  @override
  ImageStreamCompleter load(GeopackageImage key, DecoderCallback decoder) {
    // TODo check on new DecoderCallBack that was added ( PaintingBinding.instance.instantiateImageCodec ? )
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<ImageProvider>('Image key', key);
        });
  }

  Future<UI.Codec> _loadAsync(GeopackageImage key) async {
    assert(key == this);

    final db = await ConnectionsHandler()
        .open(key.databasePath, tableName: key.tableName);
    var tileBytes = await db.getTile(tableName, coords.x, coords.y, coords.z);
    if (tileBytes != null) {
      Uint8List bytes = tileBytes;
      return await PaintingBinding.instance.instantiateImageCodec(bytes);
    } else {
      // TODO get from other zoomlevels
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
  Future<GeopackageImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(other) {
    return other is GeopackageImage && coords == other.coords;
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
