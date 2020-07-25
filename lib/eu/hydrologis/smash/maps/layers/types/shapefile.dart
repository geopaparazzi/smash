/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' as JTS;
import 'package:dart_shp/dart_shp.dart' hide Row;
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class ShapefileSource extends VectorLayerSource {
  String _absolutePath;
  String _name;
  ShapefileFeatureReader _shpReader;

  bool isVisible = true;
  String _attribution = "";
  int _srid = SmashPrj.EPSG4326_INT;

  List<Feature> features = [];
  JTS.STRtree _featureTree;
  JTS.Envelope _shpBounds;
  bool loaded = false;
  SldObjectParser _style;
  TextStyle _textStyle;

  ShapefileSource.fromMap(Map<String, dynamic> map) {
    _name = map[LAYERSKEY_LABEL];
    String relativePath = map[LAYERSKEY_FILE];
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];
    _srid = map[LAYERSKEY_SRID] ?? _srid;
  }

  ShapefileSource(this._absolutePath);

  Future<void> load(BuildContext context) async {
    if (!loaded) {
      _name = FileUtilities.nameFromFile(_absolutePath, false);

      var parentFolder = FileUtilities.parentFolderFromFile(_absolutePath);

      var defaultUtf8Charset = Charset();
      var shpFile = File(_absolutePath);
      _shpReader = ShapefileFeatureReader(shpFile, charset: defaultUtf8Charset);
      await _shpReader.open();

      var fromPrj = SmashPrj.fromImageFile(_absolutePath);

      _shpBounds = JTS.Envelope.empty();
      _featureTree = JTS.STRtree();
      EGeometryType geometryType;
      while (await _shpReader.hasNext()) {
        var feature = await _shpReader.next();
        var geometry = feature.geometry;
        if (geometryType == null) {
          geometryType = EGeometryType.forTypeName(geometry.getGeometryType());
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

      var sldPath = FileUtilities.joinPaths(parentFolder, _name + ".sld");
      var sldFile = File(sldPath);
      if (sldFile.existsSync()) {
        _style = SldObjectParser.fromFile(sldFile);
        _style.parse();
      } else {
        String sldString;
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
      if (_style.featureTypeStyles.first.rules.first.textSymbolizers.length >
          0) {
        _textStyle = _style
            .featureTypeStyles.first.rules.first.textSymbolizers.first.style;
      }

      _attribution = _attribution +
          "${features[0].geometry.getGeometryType()} (${features.length}) ";

      loaded = true;
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
      JTS.Geometry geometry = features[0].geometry;
      if (geometry is JTS.Point || geometry is JTS.MultiPoint) {
        var iconData = MdiIcons.circle;
        double pointsSize = 10;
        Color pointFillColor = Colors.red;
        String labelName;
        Color labelColor = Colors.black;
        if (_style != null) {
          var pSym =
              _style.featureTypeStyles[0].rules[0].pointSymbolizers[0].style;
          iconData = SmashIcons.forSldWkName(pSym.markerName);
          pointsSize = pSym.markerSize * 3;
          pointFillColor = ColorExt(pSym.fillColorHex);

          if (_textStyle != null) {
            labelName = _textStyle.labelName;
            labelColor = ColorExt(_textStyle.textColor);
          }
        }

        List<Marker> waypoints = [];

        features.forEach((f) {
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
                anchorPos: AnchorPos.exactly(
                    Anchor(pointsSize / 2, textExtraHeight + pointsSize / 2)),
                builder: (ctx) => MarkerIcon(
                      iconData,
                      pointFillColor,
                      pointsSize,
                      labelText,
                      labelColor,
                      pointFillColor.withAlpha(80),
                    ));
            waypoints.add(m);
          }
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
      } else if (geometry is JTS.LineString ||
          geometry is JTS.MultiLineString) {
        Color lineStrokeColor = Colors.black;
        double lineWidth = 3;
        double lineOpacity = 1;
        if (_style != null) {
          var pSym =
              _style.featureTypeStyles[0].rules[0].lineSymbolizers[0].style;
          lineWidth = pSym.strokeWidth;
          lineStrokeColor = ColorExt(pSym.strokeColorHex);
          lineOpacity = pSym.strokeOpacity * 255;
          lineStrokeColor = lineStrokeColor.withAlpha(lineOpacity.toInt());
        }

        List<Polyline> lines = [];
        features.forEach((f) {
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
        });

        var lineLayer = PolylineLayerOptions(
          polylineCulling: true,
          polylines: lines,
        );
        layers.add(lineLayer);
      } else if (geometry is JTS.Polygon || geometry is JTS.MultiPolygon) {
        Color lineStrokeColor = Colors.black;
        Color fillColor = Colors.black.withAlpha(100);
        double lineWidth = 3;
        double lineOpacity = 1;
        if (_style != null) {
          var pSym =
              _style.featureTypeStyles[0].rules[0].polygonSymbolizers[0].style;
          lineWidth = pSym.strokeWidth;
          lineStrokeColor = ColorExt(pSym.strokeColorHex);
          lineOpacity = pSym.strokeOpacity * 255;
          lineStrokeColor = lineStrokeColor.withAlpha(lineOpacity.toInt());

          fillColor = ColorExt(pSym.fillColorHex)
              .withAlpha((pSym.fillOpacity * 255).toInt());
        }

        List<Polygon> polygons = [];
        features.forEach((f) {
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
        });

        var polygonLayer = PolygonLayerOptions(
          polygonCulling: true,
          // simplify: true,
          polygons: polygons,
        );
        layers.add(polygonLayer);
      }
    }

    return layers;
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
    loaded = false;
  }

  @override
  bool hasProperties() {
    return false;
  }

  @override
  bool isZoomable() {
    return _shpBounds != null;
  }

  @override
  int getSrid() {
    return _srid;
  }
}

// /// The notes properties page.
// class ShpPropertiesWidget extends StatefulWidget {
//   ShapefileSource _source;

//   ShpPropertiesWidget(this._source);

//   @override
//   State<StatefulWidget> createState() {
//     return ShpPropertiesWidgetState(_source);
//   }
// }

// class ShpPropertiesWidgetState extends State<ShpPropertiesWidget> {
//   // TODO MAKE THIS FOR SHAPEFILES
//   ShapefileSource _source;
//   double _pointSizeSliderValue = 10;
//   double _lineWidthSliderValue = 2;
//   double _maxSize = 100.0;
//   double _maxWidth = 20.0;
//   ColorExt _pointColor;
//   ColorExt _lineColor;
//   bool _somethingChanged = false;

//   ShpPropertiesWidgetState(this._source);

//   @override
//   void initState() {
//     _pointSizeSliderValue = _source.pointsSize;
//     if (_pointSizeSliderValue > _maxSize) {
//       _pointSizeSliderValue = _maxSize;
//     }
//     _pointColor = ColorExt.fromColor(_source.pointFillColor);

//     _lineWidthSliderValue = _source.lineWidth;
//     if (_lineWidthSliderValue > _maxWidth) {
//       _lineWidthSliderValue = _maxWidth;
//     }
//     _lineColor = ColorExt.fromColor(_source.lineStrokeColor);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           if (_somethingChanged) {
//             _source.pointFillColor = _pointColor;
//             _source.pointsSize = _pointSizeSliderValue;
//             _source.lineStrokeColor = _lineColor;
//             _source.lineWidth = _lineWidthSliderValue;
//           }
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text("Shp Properties"),
//           ),
//           body: Center(
//             child: ListView(
//               children: <Widget>[
//                 Padding(
//                   padding: SmashUI.defaultPadding(),
//                   child: Card(
//                     elevation: SmashUI.DEFAULT_ELEVATION,
//                     shape: SmashUI.defaultShapeBorder(),
//                     child: Column(
//                       children: <Widget>[
//                         SmashUI.titleText("Waypoints Color"),
//                         Padding(
//                           padding: SmashUI.defaultPadding(),
//                           child: LimitedBox(
//                             maxHeight: 400,
//                             child: MaterialColorPicker(
//                                 shrinkWrap: true,
//                                 allowShades: false,
//                                 circleSize: 45,
//                                 onColorChange: (Color color) {
//                                   _pointColor = ColorExt.fromColor(color);
//                                   _somethingChanged = true;
//                                 },
//                                 onMainColorChange: (mColor) {
//                                   _pointColor = ColorExt.fromColor(mColor);
//                                   _somethingChanged = true;
//                                 },
//                                 selectedColor: Color(_pointColor.value)),
//                           ),
//                         ),
//                         SmashUI.titleText("Waypoints Size"),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Flexible(
//                                 flex: 1,
//                                 child: Slider(
//                                   activeColor: SmashColors.mainSelection,
//                                   min: 1.0,
//                                   max: _maxSize,
//                                   divisions: 20,
//                                   onChanged: (newRating) {
//                                     _somethingChanged = true;
//                                     setState(() =>
//                                         _pointSizeSliderValue = newRating);
//                                   },
//                                   value: _pointSizeSliderValue,
//                                 )),
//                             Container(
//                               width: 50.0,
//                               alignment: Alignment.center,
//                               child: SmashUI.normalText(
//                                 '${_pointSizeSliderValue.toInt()}',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: SmashUI.defaultPadding(),
//                   child: Card(
//                     elevation: SmashUI.DEFAULT_ELEVATION,
//                     shape: SmashUI.defaultShapeBorder(),
//                     child: Column(
//                       children: <Widget>[
//                         SmashUI.titleText("Tracks/Routes Color"),
//                         Padding(
//                           padding: SmashUI.defaultPadding(),
//                           child: LimitedBox(
//                             maxHeight: 400,
//                             child: MaterialColorPicker(
//                                 shrinkWrap: true,
//                                 allowShades: false,
//                                 circleSize: 45,
//                                 onColorChange: (Color color) {
//                                   _lineColor = ColorExt.fromColor(color);
//                                   _somethingChanged = true;
//                                 },
//                                 onMainColorChange: (mColor) {
//                                   _lineColor = ColorExt.fromColor(mColor);
//                                   _somethingChanged = true;
//                                 },
//                                 selectedColor: Color(_lineColor.value)),
//                           ),
//                         ),
//                         SmashUI.titleText("Tracks/Routes Width"),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Flexible(
//                                 flex: 1,
//                                 child: Slider(
//                                   activeColor: SmashColors.mainSelection,
//                                   min: 1.0,
//                                   max: _maxWidth,
//                                   divisions: 20,
//                                   onChanged: (newRating) {
//                                     _somethingChanged = true;
//                                     setState(() =>
//                                         _lineWidthSliderValue = newRating);
//                                   },
//                                   value: _lineWidthSliderValue,
//                                 )),
//                             Container(
//                               width: 50.0,
//                               alignment: Alignment.center,
//                               child: SmashUI.normalText(
//                                 '${_lineWidthSliderValue.toInt()}',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
