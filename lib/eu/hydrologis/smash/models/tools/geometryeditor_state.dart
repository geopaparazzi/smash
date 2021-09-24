/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart' hide Polygon;
import 'package:dart_postgis/dart_postgis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/postgis.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/tools.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  dynamic db;

  Geometry geometry;
}

class GeometryEditManager {
  static final GeometryEditManager _singleton = GeometryEditManager._internal();

  static final Color editBorder = Colors.yellow;
  static final Color editBackBorder = Colors.black;
  static final Color editFill = Colors.yellow.withOpacity(0.3);
  static final double editStrokeWidth = 3.0;

  static const List<double> ZOOM2TOUCHRADIUS = [
    2, // zoom 0
    2, // zoom 1
    2, // zoom 2
    2, // zoom 3
    1, // zoom 4
    1, // zoom 5
    1, // zoom 6
    0.1, // zoom 7
    0.1, // zoom 8
    0.01, // zoom 9
    0.01, // zoom 10
    0.001, // zoom 11
    0.001, // zoom 12
    0.001, // zoom 13
    0.0001, // zoom 14
    0.0001, // zoom 15
    0.0001, // zoom 16
    0.0001, // zoom 17
    0.0001, // zoom 18
    0.00001, // zoom 19
    0.00001, // zoom 20
    0.00001, // zoom 21
    0.000001, // zoom 22
    0.000001, // zoom 23
    0.000001, // zoom 24
    0.000001, // zoom 25
  ];

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

        double handleIconSize = GpPreferences()
            .getIntSync(SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE, 25)
            .toDouble();
        double intermediateHandleIconSize = GpPreferences()
            .getIntSync(SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE, 20)
            .toDouble();
        Widget dragHandlerIcon = Container(
          decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius:
                  BorderRadius.all(Radius.circular(handleIconSize / 4)),
              border: Border.all(color: Colors.black, width: 2)),
        );
        Widget intermediateHandlerIcon = Container(
          child: Icon(
            MdiIcons.plus,
            size: intermediateHandleIconSize / 2,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius:
                  BorderRadius.all(Radius.circular(intermediateHandleIconSize)),
              border: Border.all(color: Colors.black, width: 2)),
        );

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
            pointIconSize: Size(handleIconSize, handleIconSize),
            intermediateIconSize:
                Size(intermediateHandleIconSize, intermediateHandleIconSize),
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
          var backEditPolygon = new Polygon(
            color: editFill.withAlpha(0),
            borderColor: editBackBorder,
            borderStrokeWidth: editStrokeWidth + 3,
            points: geomPoints,
          );
          polyEditor = new PolyEditor(
            addClosePathMarker: true,
            points: geomPoints,
            pointIcon: dragHandlerIcon,
            intermediateIcon: intermediateHandlerIcon,
            pointIconSize: Size(handleIconSize, handleIconSize),
            intermediateIconSize:
                Size(intermediateHandleIconSize, intermediateHandleIconSize),
            callbackRefresh: callbackRefresh,
          );

          polygons.add(backEditPolygon);
          polygons.add(editPolygon);
        } else if (geomType.isPoint()) {
          var coord = editGeometry.geometry.getCoordinate();

          pointEditor = DragMarker(
            point: LatLng(coord.y, coord.x),
            width: handleIconSize,
            height: handleIconSize,
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
          List<Polyline> checkedLines =
              []; // TODO remove this when it is handled in  flutter_map (see issues https://github.com/fleaflet/flutter_map/issues/1037)
          polyLines.forEach((element) {
            var tmp = new Polyline(
                color: element.color,
                strokeWidth: element.strokeWidth,
                points: element.points);
            checkedLines.add(tmp);
          });
          layers.add(PolylineLayerOptions(
            polylineCulling: true,
            polylines: checkedLines,
          ));
        } else if (editPolygon != null) {
          List<Polygon> checkedPolys =
              []; // TODO remove this when it is handled in  flutter_map (see issues https://github.com/fleaflet/flutter_map/issues/1037)
          polygons.forEach((element) {
            var tmp = new Polygon(
              color: element.color,
              borderColor: element.borderColor,
              borderStrokeWidth: element.borderStrokeWidth,
              points: element.points,
            );
            checkedPolys.add(tmp);
          });
          layers.add(PolygonLayerOptions(
            polygonCulling: true,
            polygons: checkedPolys,
          ));
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
  Future<void> onMapLongTap(
      BuildContext context, LatLng point, int zoom) async {
    GeometryEditorState editorState =
        Provider.of<GeometryEditorState>(context, listen: false);
    if (!editorState.isEnabled) {
      return;
    }

    List<LayerSource> editableLayers = LayerManager()
        .getLayerSources()
        .reversed
        .where((l) => l is DbVectorLayerSource && l.isActive())
        .toList();

    var radius = ZOOM2TOUCHRADIUS[zoom];

    var env =
        Envelope.fromCoordinate(Coordinate(point.longitude, point.latitude));
    env.expandByDistance(radius);

    var currentEditing = editorState.editableGeometry;

    EditableGeometry editGeom;
    double minDist = 1000000000;
    for (LayerSource vLayer in editableLayers) {
      var srid = vLayer.getSrid();
      var db = await DbVectorLayerSource.getDb(vLayer);
      // create the env
      var dataPrj = SmashPrj.fromSrid(srid);

      // create the touch point and buffer in the current layer prj
      var touchBufferLayerPrj =
          GeometryUtilities.fromEnvelope(env, makeCircle: false);
      touchBufferLayerPrj.setSRID(srid);
      var touchPointLayerPrj = GeometryFactory.defaultPrecision()
          .createPoint(Coordinate(point.longitude, point.latitude));
      touchPointLayerPrj.setSRID(srid);
      if (srid != SmashPrj.EPSG4326_INT) {
        SmashPrj.transformGeometry(
            SmashPrj.EPSG4326, dataPrj, touchBufferLayerPrj);
        SmashPrj.transformGeometry(
            SmashPrj.EPSG4326, dataPrj, touchPointLayerPrj);
      }
      var tableName = vLayer.getName();
      var sqlName = SqlName(tableName);
      var gc = await db.getGeometryColumnsForTable(sqlName);
      var primaryKey = await db.getPrimaryKey(sqlName);
      // if polygon, then it has to be inside,
      // for other types we use the buffer
      Envelope checkEnv;
      Geometry checkGeom;
      if (gc.geometryType.isPolygon()) {
        checkEnv = touchPointLayerPrj.getEnvelopeInternal();
        checkGeom = touchPointLayerPrj;
      } else {
        checkEnv = touchBufferLayerPrj.getEnvelopeInternal();
        checkGeom = touchBufferLayerPrj;
      }
      var geomsIntersected = await db.getGeometriesIn(
        sqlName,
        intersectionGeometry: checkGeom,
        // envelope: checkEnv,
        userDataField: primaryKey,
      );

      if (geomsIntersected.isNotEmpty) {
        // find touching
        for (var geometry in geomsIntersected) {
          if (geometry.intersects(checkGeom)) {
            var id = int.parse(geometry.getUserData().toString());
            // distance always from touch center
            double distance = geometry.distance(touchPointLayerPrj);
            if (distance < minDist) {
              // transform to 4326 for editing
              SmashPrj.transformGeometry(dataPrj, SmashPrj.EPSG4326, geometry);
              minDist = distance;
              editGeom = EditableGeometry();
              editGeom.geometry = geometry;
              editGeom.db = db;
              editGeom.id = id;
              editGeom.table = tableName;
            }
          }
        }
      }
    }
    if (editGeom != null) {
      if (editGeom.geometry.getNumGeometries() > 1) {
        SmashDialogs.showWarningDialog(context,
            "Selected multi-Geometry, which is not supported for editing.");
      } else {
        editorState.editableGeometry = editGeom;
        _isEditing = false;
        SmashMapBuilder builder =
            Provider.of<SmashMapBuilder>(context, listen: false);
        builder.reBuild();
      }
      return;
    }

    // if it arrives here, no geom is selected
    editorState.editableGeometry = null;
    stopEditing();

    // propose to add a new geometry here if no geometry was selected
    if (currentEditing == null) {
      Map<String, DbVectorLayerSource> name2SourceMap = {};
      editableLayers.forEach((element) {
        if (element is DbVectorLayerSource) {
          name2SourceMap[element.getName()] = element;
        }
      });
      if (name2SourceMap.length == 0) {
        await SmashDialogs.showWarningDialog(
            context, "No editable layer is currently loaded.");
      } else {
        var selectedName = await SmashDialogs.showComboDialog(
            context,
            "Create a new feature in the selected layer?",
            name2SourceMap.keys.toList(),
            allowCancel: true);
        if (selectedName != null) {
          var vectorLayer = name2SourceMap[selectedName];
          var db = await DbVectorLayerSource.getDb(vectorLayer);
          var table = vectorLayer.getName();
          var tableColumns = await db.getTableColumns(SqlName(table));

          // check if there is a pk and if the columns are set to be non null in other case
          bool hasPk = false;
          bool hasNonNull = false;
          tableColumns.forEach((tc) {
            var pk = tc[2];
            if (pk == 1) {
              hasPk = true;
            } else {
              var nonNull = tc[3];
              if (nonNull == 1) {
                hasNonNull = true;
              }
            }
          });
          if (!hasPk || hasNonNull) {
            await SmashDialogs.showWarningDialog(context,
                "Currently only editing of tables with a primary key and nullable columns is supported.");
            return;
          }

          // create a minimal geometry to work on
          var tableName = SqlName(table);
          var gc = await db.getGeometryColumnsForTable(tableName);
          var gType = gc.geometryType;
          Geometry geometry;
          var gf = GeometryFactory.defaultPrecision();
          var dataPrj = SmashPrj.fromSrid(vectorLayer.getSrid());
          var d = 0.0001;
          if (gType.isPoint()) {
            geometry =
                gf.createPoint(Coordinate(point.longitude, point.latitude));
          } else if (gType.isLine()) {
            geometry = gf.createLineString([
              Coordinate(point.longitude, point.latitude),
              Coordinate(point.longitude + d, point.latitude)
            ]);
          } else if (gType.isPolygon()) {
            geometry = gf.createPolygonFromCoords([
              Coordinate(point.longitude, point.latitude),
              Coordinate(point.longitude + d, point.latitude),
              Coordinate(point.longitude, point.latitude + d),
              Coordinate(point.longitude, point.latitude),
            ]);
          }
          SmashPrj.transformGeometry(SmashPrj.EPSG4326, dataPrj, geometry);
          var sql =
              "INSERT INTO ${tableName.fixedName} (${gc.geometryColumnName}) VALUES (?);";
          var lastId;
          if (vectorLayer is DbVectorLayerSource) {
            var sqlObj = db.geometryToSql(geometry);
            lastId =
                db.execute(sql, arguments: [sqlObj], getLastInsertId: true);
          }

          EditableGeometry editGeom2 = EditableGeometry();
          editGeom2.geometry = geometry;
          editGeom2.db = db;
          editGeom2.id = lastId;
          editGeom2.table = table;
          editorState.editableGeometry = editGeom;

          // reload layer geoms
          vectorLayer.isLoaded = false;
          SmashMapBuilder mapBuilder =
              Provider.of<SmashMapBuilder>(context, listen: false);
          var layers = await LayerManager().loadLayers(mapBuilder.context);
          mapBuilder.oneShotUpdateLayers = layers;
          mapBuilder.reBuild();
        }
      }
    } else {
      SmashMapBuilder builder =
          Provider.of<SmashMapBuilder>(context, listen: false);
      builder.reBuild();
    }
  }

  Future<void> saveCurrentEdit(GeometryEditorState geomEditState) async {
    if (editPolyline != null || editPolygon != null || pointEditor != null) {
      var editableGeometry = geomEditState.editableGeometry;
      var db = editableGeometry.db;

      var tableName = SqlName(editableGeometry.table);
      var primaryKey = await db.getPrimaryKey(tableName);
      var geometryColumn = await db.getGeometryColumnsForTable(tableName);
      EGeometryType gType = geometryColumn.geometryType;
      var gf = GeometryFactory.defaultPrecision();
      Geometry geom;
      if (gType.isLine()) {
        var newPoints = editPolyline.points;
        geom = gf.createLineString(
            newPoints.map((c) => Coordinate(c.longitude, c.latitude)).toList());
        if (gType.isMulti()) {
          geom = gf.createMultiLineString([geom]);
        }
      } else if (gType.isPolygon()) {
        var newPoints = editPolygon.points;
        newPoints.add(newPoints[0]);
        var linearRing = gf.createLinearRing(
            newPoints.map((c) => Coordinate(c.longitude, c.latitude)).toList());
        geom = gf.createPolygon(linearRing, null);
        if (gType.isMulti()) {
          geom = gf.createMultiPolygon([geom]);
        }
      } else if (gType.isPoint()) {
        var newPoint = pointEditor.point;
        geom =
            gf.createPoint(Coordinate(newPoint.longitude, newPoint.latitude));
        if (gType.isMulti()) {
          geom = gf.createMultiPoint([geom]);
        }
      }

      geom.setSRID(geometryColumn.srid);
      if (geometryColumn.srid != SmashPrj.EPSG4326_INT) {
        var to = SmashPrj.fromSrid(geometryColumn.srid);
        SmashPrj.transformGeometry(SmashPrj.EPSG4326, to, geom);
      }

      dynamic sqlObj = db.geometryToSql(geom);
      Map<String, dynamic> newRow = {geometryColumn.geometryColumnName: sqlObj};
      await db.updateMap(
          tableName, newRow, "$primaryKey=${editableGeometry.id}");
    }
  }

  /// Deletes the feature of the currentl selected geometry from the database.
  Future<bool> deleteCurrentSelection(GeometryEditorState geomEditState) async {
    var editableGeometry = geomEditState.editableGeometry;
    if (editableGeometry != null) {
      var id = editableGeometry.id;
      if (id != null) {
        var table = SqlName(editableGeometry.table);
        var db = editableGeometry.db;
        var pk = await db.getPrimaryKey(table);
        var sql = "delete from ${table.fixedName} where $pk=$id";
        await db.execute(sql);

        geomEditState.editableGeometry = null;
        return true;
      }
    }
    return false;
  }
}

/// Clip widget in triangle shape
class PlusClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height * .8);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}
