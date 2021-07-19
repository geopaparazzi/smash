/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' as JTS;
import 'package:dart_shp/dart_shp.dart' hide Row;
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter_map/flutter_map.dart' hide Projection;
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class ShapefileSource extends VectorLayerSource implements SldLayerSource {
  String _absolutePath;
  String _name;
  ShapefileFeatureReader _shpReader;
  String sldPath;

  bool isVisible = true;
  String _attribution = "";
  int _srid; //SmashPrj.EPSG4326_INT;

  List<Feature> features = [];
  JTS.STRtree _featureTree;
  JTS.Envelope _shpBounds;
  SldObjectParser _style;
  TextStyle _textStyle;

  List<String> alphaFields = [];
  String sldString;
  JTS.EGeometryType geometryType;

  ShapefileSource.fromMap(Map<String, dynamic> map) {
    _name = map[LAYERSKEY_LABEL];
    String relativePath = map[LAYERSKEY_FILE];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];
    _srid = map[LAYERSKEY_SRID] ?? _srid;
  }

  ShapefileSource(this._absolutePath);

  Future<void> load(BuildContext context) async {
    if (!isLoaded) {
      _name = FileUtilities.nameFromFile(_absolutePath, false);

      var parentFolder = FileUtilities.parentFolderFromFile(_absolutePath);

      var defaultUtf8Charset = Charset();
      var shpFile = File(_absolutePath);
      _shpReader = ShapefileFeatureReader(shpFile, charset: defaultUtf8Charset);
      await _shpReader.open();

      var numFields = _shpReader.header.getNumFields();
      for (var i = 0; i < numFields; i++) {
        alphaFields.add(_shpReader.header.getFieldName(i));
      }

      Projection fromPrj = SmashPrj.fromDataFile(_absolutePath);
      if (fromPrj != null) {
        var srid = SmashPrj.getSrid(fromPrj);
        if (srid == null) {
          srid = SmashPrj.getSridFromDataFile(_absolutePath);
        }
        if (srid == null) {
          _srid = await SmashPrj.getSridFromMatchingInPreferences(fromPrj);
        } else {
          _srid = srid;
        }
      }

      _shpBounds = JTS.Envelope.empty();
      _featureTree = JTS.STRtree();

      while (await _shpReader.hasNext()) {
        var feature = await _shpReader.next();
        var geometry = feature.geometry;
        if (geometryType == null) {
          geometryType =
              JTS.EGeometryType.forTypeName(geometry.getGeometryType());
        }
        SmashPrj.transformGeometryToWgs84(fromPrj, geometry);
        var envLL = geometry.getEnvelopeInternal();
        _shpBounds.expandToIncludeEnvelope(envLL);
        features.add(feature);
        _featureTree.insert(envLL, feature);
      }
      SMLogger()
          .d("Loaded ${features.length} Shp features of envelope: $_shpBounds");

      _shpReader.close();

      sldPath = FileUtilities.joinPaths(parentFolder, _name + ".sld");
      var sldFile = File(sldPath);

      if (sldFile.existsSync()) {
        sldString = FileUtilities.readFile(sldPath);
        _style = SldObjectParser.fromString(sldString);
        _style.parse();
      } else {
        if (geometryType.isPoint()) {
          sldString = DefaultSlds.simplePointSld();
        } else if (geometryType.isLine()) {
          sldString = DefaultSlds.simpleLineSld();
        } else if (geometryType.isPolygon()) {
          sldString = DefaultSlds.simplePolygonSld();
        }
        if (sldString != null) {
          FileUtilities.writeStringToFile(sldPath, sldString);
          _style = SldObjectParser.fromString(sldString);
          _style.parse();
        }
      }
      _textStyle = _style.getFirstTextStyle(false);

      _attribution = _attribution +
          "${features[0].geometry.getGeometryType()} (${features.length}) ";

      isLoaded = true;
    }
  }

  bool hasData() {
    return features.isNotEmpty;
  }

  String getAbsolutePath() {
    return _absolutePath;
  }

  String getUrl() {
    return null;
  }

  String getUser() => null;

  String getPassword() => null;

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

  IconData getIcon() => SmashIcons.iconTypeShp;

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

  List<Feature> getInRoi({JTS.Geometry roiGeom, JTS.Envelope roiEnvelope}) {
    if (roiEnvelope != null || roiGeom != null) {
      if (roiEnvelope == null) {
        roiEnvelope = roiGeom.getEnvelopeInternal();
      }
      List<Feature> result = _featureTree.query(roiEnvelope).cast();
      if (roiGeom != null) {
        result.removeWhere((f) => !f.geometry.intersects(roiGeom));
      }
      return result;
    } else {
      return features;
    }
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    await load(context);

    List<LayerOptions> layers = [];

    if (features.isNotEmpty) {
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

    features.forEach((f) {
      if (key == null || f.attributes[key]?.toString() == value) {
        var count = f.geometry.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.Polygon p = f.geometry.getGeometryN(i);
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
    });

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

    features.forEach((f) {
      if (key == null || f.attributes[key]?.toString() == value) {
        var count = f.geometry.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.LineString l = f.geometry.getGeometryN(i);
          var linePoints =
              l.getCoordinates().map((c) => LatLng(c.y, c.x)).toList();
          lines.add(Polyline(
              points: linePoints,
              strokeWidth: lineWidth,
              color: lineStrokeColor));
        }
      }
    });

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

    features.forEach((f) {
      if (key == null || f.attributes[key]?.toString() == value) {
        var count = f.geometry.getNumGeometries();
        for (var i = 0; i < count; i++) {
          JTS.Point l = f.geometry.getGeometryN(i);
          var labelText = f.attributes[labelName];
          double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
          if (labelText == null) {
            textExtraHeight = 0;
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
                    labelText.toString(),
                    labelColor,
                    pointFillColor.withAlpha(100),
                  ));
          points.add(m);
        }
      }
    });

    return points;
  }

  @override
  Future<LatLngBounds> getBounds() async {
    if (_shpBounds != null) {
      var s = _shpBounds.getMinY();
      var n = _shpBounds.getMaxY();
      var w = _shpBounds.getMinX();
      var e = _shpBounds.getMaxX();
      LatLngBounds b = LatLngBounds(LatLng(s, w), LatLng(n, e));
      return b;
    } else {
      return null;
    }
  }

  @override
  void disposeSource() {
    features = [];
    _shpBounds = null;
    _shpReader = null;
    _name = null;
    _absolutePath = null;
    isLoaded = false;
  }

  @override
  bool hasProperties() {
    return true;
  }

  Widget getPropertiesWidget() {
    return SldPropertiesEditor(sldString, geometryType,
        alphaFields: alphaFields);
  }

  @override
  bool isZoomable() {
    return _shpBounds != null;
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
    if (_style.featureTypeStyles.first.rules.first.textSymbolizers.length > 0) {
      _textStyle = _style
          .featureTypeStyles.first.rules.first.textSymbolizers.first.style;
    }
    FileUtilities.writeStringToFile(sldPath, sldString);
  }
}
