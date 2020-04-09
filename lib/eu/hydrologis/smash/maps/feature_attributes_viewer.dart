/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:ui';

import 'package:dart_jts/dart_jts.dart' as DJ;
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart' as FM;
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/tables.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/screen.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';

class FeatureAttributesViewer extends StatefulWidget {
  final QueryResult features;

  FeatureAttributesViewer(this.features, {Key key}) : super(key: key);

  @override
  _FeatureAttributesViewerState createState() =>
      _FeatureAttributesViewerState();
}

class _FeatureAttributesViewerState extends State<FeatureAttributesViewer> {
  int _index = 0;
  int _total;
  MapController _mapController;
  var _baseLayer;

  @override
  void initState() {
    _total = widget.features.geoms.length;

    _mapController = MapController();
    super.initState();
  }

  Future<LayerOptions> getBaseLayer() async {
    var activeBaseLayers = LayerManager().getActiveBaseLayerSources();
    if (activeBaseLayers.isNotEmpty) {
      var baseLayers = await activeBaseLayers[0].toLayers(context);
      if (baseLayers.isNotEmpty) {
        _baseLayer = baseLayers[0];
        return _baseLayer;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_baseLayer == null) {
      return FutureBuilder<LayerOptions>(
        future: getBaseLayer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildInFuture(snapshot.data, context);
          } else {
            return Center(
                child: SmashCircularProgress(label: "Loading data..."));
          }
        },
      );
    } else {
      return buildInFuture(_baseLayer, context);
    }
  }

  Scaffold buildInFuture(LayerOptions baseLayer, BuildContext context) {
    var isLandscape = ScreenUtilities.isLandscape(context);

    Color border = Colors.black;
    Color borderFill = Colors.yellow;
    Color fillPoly = Colors.yellow.withOpacity(0.3);

    QueryResult f = widget.features;
    var layers = <LayerOptions>[];

    if (baseLayer != null) {
      layers.add(baseLayer);
    }
    _total = f.geoms.length;
    var geometry = f.geoms[_index];
    Map<String, dynamic> data = f.data[_index];
    var centroid = geometry.getCentroid().getCoordinate();

    var geometryType = geometry.getGeometryType();
    var gType = EGeometryType.forTypeName(geometryType);
    if (gType.isPoint()) {
      double size = 30;

      var layer = new MarkerLayerOptions(
        markers: [
          new Marker(
            width: size,
            height: size,
            point: LatLng(centroid.y, centroid.x),
            builder: (ctx) => new Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    MdiIcons.circle,
                    color: border,
                    size: size,
                  ),
                ),
                Center(
                  child: Icon(
                    MdiIcons.circle,
                    color: borderFill,
                    size: size * 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      layers.add(layer);
    } else if (gType.isLine()) {
      List<Polyline> lines = [];
      for (int i = 0; i < geometry.getNumGeometries(); i++) {
        var geometryN = geometry.getGeometryN(i);
        List<LatLng> linePoints =
            geometryN.getCoordinates().map((c) => LatLng(c.y, c.x)).toList();
        lines.add(Polyline(points: linePoints, strokeWidth: 5, color: border));
        lines.add(
            Polyline(points: linePoints, strokeWidth: 3, color: borderFill));
      }
      var lineLayer = PolylineLayerOptions(
        polylines: lines,
      );
      layers.add(lineLayer);
    } else if (gType.isPolygon()) {
      List<FM.Polygon> polygons = [];
      for (int i = 0; i < geometry.getNumGeometries(); i++) {
        var geometryN = geometry.getGeometryN(i);
        if (geometryN is DJ.Polygon) {
          var exteriorRing = geometryN.getExteriorRing();
          List<LatLng> polyPoints = exteriorRing
              .getCoordinates()
              .map((c) => LatLng(c.y, c.x))
              .toList();
          polygons.add(FM.Polygon(
              points: polyPoints,
              borderStrokeWidth: 5,
              borderColor: border,
              color: border.withOpacity(0)));
          polygons.add(FM.Polygon(
              points: polyPoints,
              borderStrokeWidth: 3,
              borderColor: borderFill,
              color: fillPoly));
        }
      }
      var polyLayer = PolygonLayerOptions(
        polygons: polygons,
      );
      layers.add(polyLayer);
    }

    var env = geometry.getEnvelopeInternal();
    var latLngBounds = LatLngBounds(LatLng(env.getMinY(), env.getMinX()),
        LatLng(env.getMaxY(), env.getMaxX()));

    Timer(Duration(milliseconds: 300), () {
      _mapController.fitBounds(latLngBounds);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.features.ids[_index]),
        actions: _total > 1
            ? <Widget>[
                IconButton(
                  icon: Icon(MdiIcons.arrowLeftBoldOutline),
                  onPressed: () {
                    var newIndex = _index - 1;
                    if (newIndex < 0) {
                      newIndex = _total - 1;
                    }
                    setState(() {
                      _index = newIndex;
                      var env = f.geoms[_index].getEnvelopeInternal();
                      _mapController.fitBounds(LatLngBounds(
                          LatLng(env.getMinY(), env.getMinX()),
                          LatLng(env.getMaxY(), env.getMaxX())));
                    });
                  },
                ),
                Text("${_index + 1}/${_total}"),
                IconButton(
                  icon: Icon(MdiIcons.arrowRightBoldOutline),
                  onPressed: () {
                    var newIndex = _index + 1;
                    if (newIndex >= _total) {
                      newIndex = 0;
                    }
                    setState(() {
                      _index = newIndex;
                      var env = f.geoms[_index].getEnvelopeInternal();
                      _mapController.fitBounds(LatLngBounds(
                          LatLng(env.getMinY(), env.getMinX()),
                          LatLng(env.getMaxY(), env.getMaxX())));
                    });
                  },
                ),
              ]
            : [],
      ),
      body: isLandscape
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SmashColors.tableBorder,
                      width: 2,
                    ),
                  ),
                  width: MediaQuery.of(context).size.height / 2,
                  height: double.infinity,
                  child: FlutterMap(
                    options: new MapOptions(
                      center: LatLng(centroid.y, centroid.x),
                      // TODO getCenterFromBounds(latLngBounds, mapState),
                      zoom: 15,
                      // TODO getZoomFromBounds(latLngBounds, mapState),
                      minZoom: 7,
                      maxZoom: 19,
                    ),
                    layers: layers,
                    mapController: _mapController,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: TableUtilities.fromMap(data,
                        withBorder: true, borderColor: SmashColors.tableBorder),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SmashColors.tableBorder,
                      width: 2,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: FlutterMap(
                    options: new MapOptions(
                      center: LatLng(centroid.y, centroid.x),
                      // TODO getCenterFromBounds(latLngBounds, mapState),
                      zoom: 15,
                      // TODO getZoomFromBounds(latLngBounds, mapState),
                      minZoom: 7,
                      maxZoom: 19,
                    ),
                    layers: layers,
                    mapController: _mapController,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: TableUtilities.fromMap(data,
                        withBorder: true, borderColor: SmashColors.tableBorder),
                  ),
                ),
              ],
            ),
    );
  }

  LatLng getCenterFromBounds(LatLngBounds bounds, MapState mapState) {
    var centerZoom = mapState.getBoundsCenterZoom(bounds, FitBoundsOptions());
    return centerZoom.center;
  }

  double getZoomFromBounds(LatLngBounds bounds, MapState mapState) {
    var centerZoom = mapState.getBoundsCenterZoom(bounds, FitBoundsOptions());
    return centerZoom.zoom;
  }
}
