/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart';
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

  List<Polyline> polyLines;
  Polyline editPolyline;
  PolyEditor polyEditor;
  bool _isEditing = false;

  factory GeometryEditManager() {
    return _singleton;
  }

  GeometryEditManager._internal();

  void startEditing(EditableGeometry editGeometry, Function callbackRefresh) {
    if (!_isEditing) {
      List<LatLng> geomPoints = [];
      bool addClosePathMarker = true;
      if (editGeometry != null) {
        var gType = EGeometryType.forGeometry(editGeometry.geometry);
        if (gType.isLine()) {
          addClosePathMarker = false;
          geomPoints = editGeometry.geometry
              .getCoordinates()
              .map((c) => LatLng(c.y, c.x))
              .toList();
        }
      }

      polyLines = [];
      editPolyline = new Polyline(color: Colors.deepOrange, points: geomPoints);
      polyEditor = new PolyEditor(
        addClosePathMarker: addClosePathMarker,
        points: editPolyline.points,
        pointIcon: Icon(Icons.crop_square, size: 23),
        intermediateIcon: Icon(Icons.lens, size: 15, color: Colors.grey),
        callbackRefresh: callbackRefresh,
      );

      polyLines.add(editPolyline);
      _isEditing = true;
    }
  }

  void stopEditing() {
    if (_isEditing) {
      polyEditor = null;
      polyLines = null;
      editPolyline = null;
    }
    _isEditing = false;
  }

  void addPoint(LatLng ll) {
    if (_isEditing) {
      polyEditor.add(editPolyline.points, ll);
    }
  }

  void addEditLayers(List<LayerOptions> layers) {
    if (_isEditing) {
      layers.add(PolylineLayerOptions(polylines: polyLines));
      layers.add(DragMarkerPluginOptions(markers: polyEditor.edit()));
    }
  }

  void addEditPlugins(List<MapPlugin> plugins) {
    if (_isEditing) {
      plugins.add(DragMarkerPlugin());
    }
  }

  void onMapTap(BuildContext context, LatLng point) {
    if (_isEditing) {
      addPoint(point);
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
        .where((l) => l is GeopackageSource && l.isActive())
        .toList();

    var env =
        Envelope.fromCoordinate(Coordinate(point.longitude, point.latitude));
    env.expandByDistance(0.0001);

    var touchGeomLL = GeometryUtilities.fromEnvelope(env, makeCircle: false);
    var touchGeom = GeometryUtilities.fromEnvelope(env, makeCircle: false);

    var currentEditing = editorState.editableGeometry;

    for (var vLayer in geopackageLayers) {
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
            if (currentEditing != null && currentEditing.id == id) {
              continue;
            }
            EditableGeometry editGeom = EditableGeometry();
            editGeom.geometry = geometry;
            editGeom.db = db;
            editGeom.id = id;
            editGeom.table = tableName;
            editorState.editableGeometry = editGeom;

            SmashMapBuilder builder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            builder.reBuild();
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
}
