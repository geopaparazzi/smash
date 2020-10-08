/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart' hide Polygon;
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/tools.dart';
import 'package:smashlibs/smashlibs.dart';

class GeometryEditorState extends ChangeNotifier {
  static final type = BottomToolbarToolsRegistry.GEOMEDITOR;

  bool _isEnabled = false;
  EditableGeometry _editableItem;

  bool get isEnabled => _isEnabled;

  void setEnabled(bool isEnabled) {
    this._isEnabled = isEnabled;

    if (!_isEnabled) {
      _editableItem = null;
    }
    notifyListeners();
  }

  EditableGeometry get editableGeometry => _editableItem;

  set editableGeometry(EditableGeometry editableGeometry) {
    _editableItem = editableGeometry;
    notifyListeners();
  }
}

class EditableGeometry {
  int id;
  String table;
  GeopackageDb db;

  Geometry geometry;
}

class GeometryEditManager {
  static final GeometryEditManager _singleton = GeometryEditManager._internal();

  static final Icon dragHandlerIcon = Icon(Icons.crop_square, size: 23);
  static final Icon intermediateHandlerIcon =
      Icon(Icons.lens, size: 15, color: Colors.grey);
  static final Color editBorder = Colors.yellow;
  static final Color editFill = Colors.yellow.withOpacity(0.3);
  static final double editStrokeWidth = 3.0;

  PolyEditor polyEditor;
  List<Polyline> polyLines;
  Polyline editPolyline;

  List<Polygon> polygons;
  Polygon editPolygon;

  DragMarker pointEditor;

  bool _isEditing = false;

  factory GeometryEditManager() {
    return _singleton;
  }

  GeometryEditManager._internal();

  void startEditing(EditableGeometry editGeometry, Function callbackRefresh,
      {EGeometryType geomType}) {
    if (!_isEditing) {
      if (editGeometry != null) {
        resetToNulls();

        geomType = EGeometryType.forGeometry(editGeometry.geometry);
        if (geomType.isLine()) {
          var geomPoints = editGeometry.geometry
              .getCoordinates()
              .map((c) => LatLng(c.y, c.x))
              .toList();
          polyLines = [];
          editPolyline = new Polyline(
              color: editBorder,
              strokeWidth: editStrokeWidth,
              points: geomPoints);
          polyEditor = new PolyEditor(
            addClosePathMarker: false,
            points: geomPoints,
            pointIcon: dragHandlerIcon,
            intermediateIcon: intermediateHandlerIcon,
            callbackRefresh: callbackRefresh,
          );
          polyLines.add(editPolyline);
        } else if (geomType.isPolygon()) {
          var geomPoints = editGeometry.geometry
              .getCoordinates()
              .map((c) => LatLng(c.y, c.x))
              .toList();
          geomPoints.removeLast();

          polygons = [];
          editPolygon = new Polygon(
            color: editFill,
            borderColor: editBorder,
            borderStrokeWidth: editStrokeWidth,
            points: geomPoints,
          );
          polyEditor = new PolyEditor(
            addClosePathMarker: true,
            points: geomPoints,
            pointIcon: dragHandlerIcon,
            intermediateIcon: intermediateHandlerIcon,
            callbackRefresh: callbackRefresh,
          );

          polygons.add(editPolygon);
        } else if (geomType.isPoint()) {
          var coord = editGeometry.geometry.getCoordinate();

          pointEditor = DragMarker(
            point: LatLng(coord.y, coord.x),
            width: 80.0,
            height: 80.0,
            builder: (ctx) => Container(child: dragHandlerIcon),
            onDragEnd: (details, point) {},
            updateMapNearEdge: false,
          );
        }
      }
      _isEditing = true;
    }
  }

  void stopEditing() {
    if (_isEditing) {
      resetToNulls();
    }
    _isEditing = false;
  }

  void resetToNulls() {
    polyEditor = null;
    polyLines = null;
    editPolyline = null;
    polygons = null;
    editPolygon = null;
    pointEditor = null;
  }

  void addPoint(LatLng ll) {
    if (_isEditing) {
      if (polyEditor != null) {
        if (editPolyline != null) {
          polyEditor.add(editPolyline.points, ll);
        } else if (editPolygon != null) {
          polyEditor.add(editPolygon.points, ll);
        }
      }
    }
  }

  void addEditLayers(List<LayerOptions> layers) {
    if (_isEditing) {
      if (polyEditor != null) {
        if (editPolyline != null) {
          layers.add(PolylineLayerOptions(polylines: polyLines));
        } else if (editPolygon != null) {
          layers.add(PolygonLayerOptions(polygons: polygons));
        }
        layers.add(DragMarkerPluginOptions(markers: polyEditor.edit()));
      } else if (pointEditor != null) {
        layers.add(DragMarkerPluginOptions(markers: [pointEditor]));
      }
    }
  }

  void addEditPlugins(List<MapPlugin> plugins) {
    if (_isEditing) {
      plugins.add(DragMarkerPlugin());
    }
  }

  void onMapTap(BuildContext context, LatLng point) {
    if (_isEditing) {
      if (polyEditor != null) {
        addPoint(point);
      }
    }
  }

  /// On map long tap, if the editor state is on, the feature is selected or deselected.
  void onMapLongTap(BuildContext context, LatLng point) {
    GeometryEditorState editorState =
        Provider.of<GeometryEditorState>(context, listen: false);
    if (!editorState.isEnabled) {
      return;
    }

    List<LayerSource> geopackageLayers = LayerManager()
        .getLayerSources()
        .reversed
        .where((l) => l is GeopackageSource && l.isActive())
        .toList();

    var env =
        Envelope.fromCoordinate(Coordinate(point.longitude, point.latitude));
    env.expandByDistance(0.001);

    var touchGeomLL = GeometryUtilities.fromEnvelope(env, makeCircle: false);
    var touchGeom = GeometryUtilities.fromEnvelope(env, makeCircle: false);

    var currentEditing = editorState.editableGeometry;

    for (LayerSource vLayer in geopackageLayers) {
      var srid = vLayer.getSrid();
      var db = ConnectionsHandler().open(vLayer.getAbsolutePath());
      // create the env
      var dataPrj = SmashPrj.fromSrid(srid);
      SmashPrj.transformGeometry(SmashPrj.EPSG4326, dataPrj, touchGeom);

      var tableName = vLayer.getName();
      var primaryKey = db.getPrimaryKey(SqlName(tableName));
      var geomsIntersected = db.getGeometriesIn(SqlName(tableName),
          envelope: touchGeom.getEnvelopeInternal(), userDataField: primaryKey);
      if (geomsIntersected.isNotEmpty) {
        // find touching
        for (var geometry in geomsIntersected) {
          // project to lat/long for editing
          SmashPrj.transformGeometry(dataPrj, SmashPrj.EPSG4326, geometry);
          if (geometry.intersects(touchGeomLL)) {
            var id = int.parse(geometry.getUserData().toString());
            // if (currentEditing != null && currentEditing.id == id) {
            //   continue;
            // }

            if (geometry.getNumGeometries() > 1) {
              SmashDialogs.showWarningDialog(context,
                  "Selected multi-Geometry, which is not supported for editing.");
            } else {
              EditableGeometry editGeom = EditableGeometry();
              editGeom.geometry = geometry;
              editGeom.db = db;
              editGeom.id = id;
              editGeom.table = tableName;
              editorState.editableGeometry = editGeom;
              _isEditing = false;

              SmashMapBuilder builder =
                  Provider.of<SmashMapBuilder>(context, listen: false);
              builder.reBuild();
            }
            return;
          }
        }
      }
    }

    // if it arrives here, no geom is selected
    editorState.editableGeometry = null;
    stopEditing();
    SmashMapBuilder builder =
        Provider.of<SmashMapBuilder>(context, listen: false);
    builder.reBuild();
  }

  void saveCurrentEdit(GeometryEditorState geomEditState) {
    var editableGeometry = geomEditState.editableGeometry;
    GeopackageDb db = editableGeometry.db;

    var tableName = SqlName(editableGeometry.table);
    var primaryKey = db.getPrimaryKey(tableName);
    var geometryColumn = db.getGeometryColumnsForTable(tableName);
    var gType = geometryColumn.geometryType;
    var gf = GeometryFactory.defaultPrecision();
    Geometry geom;
    if (gType.isLine()) {
      var newPoints = editPolyline.points;
      geom = gf.createLineString(
          newPoints.map((c) => Coordinate(c.longitude, c.latitude)).toList());
    } else if (gType.isPolygon()) {
      var newPoints = editPolygon.points;
      newPoints.add(newPoints[0]);
      var linearRing = gf.createLinearRing(
          newPoints.map((c) => Coordinate(c.longitude, c.latitude)).toList());
      geom = gf.createPolygon(linearRing, null);
    } else if (gType.isPoint()) {
      var newPoint = pointEditor.point;
      geom = gf.createPoint(Coordinate(newPoint.longitude, newPoint.latitude));
    }

    if (geometryColumn.srid != SmashPrj.EPSG4326_INT) {
      var to = SmashPrj.fromSrid(geometryColumn.srid);
      SmashPrj.transformGeometry(SmashPrj.EPSG4326, to, geom);
    }

    var geomBytes = GeoPkgGeomWriter().write(geom);

    var newRow = {geometryColumn.geometryColumnName: geomBytes};
    db.updateMap(tableName, newRow, "$primaryKey=${editableGeometry.id}");
  }
}
