/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
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

  factory GeometryEditManager() {
    return _singleton;
  }

  GeometryEditManager._internal();

  void onMapTap(BuildContext context, LatLng point) {
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
    SmashMapBuilder builder =
        Provider.of<SmashMapBuilder>(context, listen: false);
    builder.reBuild();
  }
}
