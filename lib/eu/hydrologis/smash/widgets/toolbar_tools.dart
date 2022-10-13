/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:badges/badges.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_postgis/dart_postgis.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/maps/feature_attributes_viewer.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/feature_info_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/tools.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class BottomToolsBar extends StatefulWidget {
  final _iconSize;
  BottomToolsBar(this._iconSize, {Key? key}) : super(key: key);

  @override
  _BottomToolsBarState createState() => _BottomToolsBarState();
}

class _BottomToolsBarState extends State<BottomToolsBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GeometryEditorState>(
        builder: (context, geomEditState, child) {
      if (geomEditState.editableGeometry == null) {
        return BottomAppBar(
          color: SmashColors.mainDecorations,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GeomEditorButton(widget._iconSize),
              FeatureQueryButton(widget._iconSize),
              RulerButton(widget._iconSize),
              FenceButton(widget._iconSize),
              Spacer(),
              getZoomIn(),
              getZoomOut(),
            ],
          ),
        );
      } else {
        return BottomAppBar(
          color: SmashColors.mainDecorations,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getRemoveFeatureButton(geomEditState),
              getOpenFeatureAttributesButton(geomEditState),
              if (Provider.of<GpsState>(context, listen: false).hasFix())
                getInsertPointInGpsButton(geomEditState),
              getInsertPointInCenterButton(geomEditState),
              getSaveFeatureButton(geomEditState),
              getCancelEditButton(geomEditState),
              Spacer(),
              getZoomIn(),
              getZoomOut(),
            ],
          ),
        );
      }
    });
  }

  Consumer<SmashMapState> getZoomOut() {
    return Consumer<SmashMapState>(builder: (context, mapState, child) {
      return IconButton(
        onPressed: () {
          mapState.zoomOut();
        },
        tooltip: SL.of(context).toolbarTools_zoomOut, //'Zoom out'
        icon: Icon(
          SmashIcons.zoomOutIcon,
          color: SmashColors.mainBackground,
        ),
        iconSize: widget._iconSize,
      );
    });
  }

  Consumer<SmashMapState> getZoomIn() {
    return Consumer<SmashMapState>(builder: (context, mapState, child) {
      return DashboardUtils.makeToolbarZoomBadge(
        IconButton(
          onPressed: () {
            mapState.zoomIn();
          },
          tooltip: SL.of(context).toolbarTools_zoomIn, //'Zoom in'
          icon: Icon(
            SmashIcons.zoomInIcon,
            color: SmashColors.mainBackground,
          ),
          iconSize: widget._iconSize,
        ),
        mapState.zoom.toInt(),
        iconSize: widget._iconSize,
      );
    });
  }

  Widget getCancelEditButton(GeometryEditorState geomEditState) {
    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_cancelCurrentEdit, //"Cancel current edit."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.markerCancel,
              color: geomEditState.editableGeometry != null
                  ? SmashColors.mainSelection
                  : SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onLongPress: () {
          setState(() {
            geomEditState.editableGeometry = null;
            GeometryEditManager().stopEditing();
            SmashMapBuilder mapBuilder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            mapBuilder.reBuild();
          });
        },
      ),
    );
  }

  Widget getSaveFeatureButton(GeometryEditorState geomEditState) {
    return Tooltip(
      message:
          SL.of(context).toolbarTools_saveCurrentEdit, //"Save current edit."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.contentSaveEdit,
              color: geomEditState.editableGeometry != null
                  ? SmashColors.mainSelection
                  : SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () async {
          var editableGeometry = geomEditState.editableGeometry;
          await GeometryEditManager().saveCurrentEdit(geomEditState);

          // stop editing
          geomEditState.editableGeometry = null;
          GeometryEditManager().stopEditing();

          // reload layer geoms
          await reloadDbLayers(editableGeometry!.db, editableGeometry.table!);
        },
      ),
    );
  }

  Widget getInsertPointInCenterButton(GeometryEditorState geomEditState) {
    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_insertPointMapCenter, //"Insert point in map center."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              SmashIcons.iconInMapCenter,
              color: SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () async {
          SmashMapState mapState =
              Provider.of<SmashMapState>(context, listen: false);
          var center = mapState.center;

          GeometryEditManager().addPoint(LatLng(center.y, center.x));
        },
      ),
    );
  }

  Widget getInsertPointInGpsButton(GeometryEditorState geomEditState) {
    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_insertPointGpsPos, //"Insert point in GPS position."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              SmashIcons.iconInGps,
              color: SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () async {
          GpsState gpsState = Provider.of<GpsState>(context, listen: false);
          var gpsPosition = gpsState.lastGpsPosition;
          if (gpsPosition != null) {
            GeometryEditManager()
                .addPoint(LatLng(gpsPosition.latitude, gpsPosition.longitude));
          }
        },
      ),
    );
  }

  // Widget getAddFeatureButton() {
  //   return Tooltip(
  //     message: "Add a new feature.",
  //     child: GestureDetector(
  //       child: Padding(
  //         padding: SmashUI.defaultPadding(),
  //         child: InkWell(
  //           child: Icon(
  //             MdiIcons.plus,
  //             color: SmashColors.mainBackground,
  //             size: widget._iconSize,
  //           ),
  //         ),
  //       ),
  //       onTap: () {
  //         setState(() {
  //           GeometryEditManager().stopEditing();
  //           GeometryEditManager().startEditing(null, () {
  //             SmashMapBuilder mapBuilder =
  //                 Provider.of<SmashMapBuilder>(context, listen: false);
  //             mapBuilder.reBuild();
  //           });
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget getRemoveFeatureButton(GeometryEditorState geomEditState) {
    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_removeSelectedFeature, //"Remove selected feature."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.trashCan,
              color: SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onLongPress: () async {
          var t = geomEditState.editableGeometry!.table!;
          var db = geomEditState.editableGeometry!.db;
          bool hasDeleted = await GeometryEditManager()
              .deleteCurrentSelection(context, geomEditState);
          if (hasDeleted) {
            // reload layer geoms
            await reloadDbLayers(db, t);
          }
        },
      ),
    );
  }

  Future<void> reloadDbLayers(dynamic db, String table) async {
    // reload layer geoms
    var layerSources = LayerManager().getLayerSources(onlyActive: true);
    var layer = layerSources.firstWhere((layer) {
      var isDbVector = DbVectorLayerSource.isDbVectorLayerSource(layer);
      bool isEqual = isDbVector &&
          layer.getName() == table &&
          (layer as DbVectorLayerSource).db == db;
      return isEqual;
    });
    (layer as LoadableLayerSource).isLoaded = false;

    SmashMapBuilder mapBuilder =
        Provider.of<SmashMapBuilder>(context, listen: false);
    var layers = await LayerManager().loadLayers(mapBuilder.context!);
    mapBuilder.oneShotUpdateLayers = layers;
    mapBuilder.reBuild();
  }

  Widget getOpenFeatureAttributesButton(
      GeometryEditorState geometryEditorState) {
    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_showFeatureAttributes, //"Show feature attributes."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.tableEdit,
              color: SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () async {
          var editableGeometry = geometryEditorState.editableGeometry!;
          var id = editableGeometry.id;
          if (id != null) {
            var table = editableGeometry.table;
            var db = editableGeometry.db;
            var tableName = TableName(table!,
                schemaSupported:
                    db is PostgisDb || db is PostgresqlDb ? true : false);
            var key = await db.getPrimaryKey(tableName);
            var geometryColumn = await db.getGeometryColumnsForTable(tableName);
            var tableColumns = await db.getTableColumns(tableName);
            Map<String, String> typesMap = {};
            tableColumns.forEach((column) {
              typesMap[column[0]] = column[1];
            });

            var tableData = await db.getTableData(tableName, where: "$key=$id");
            if (tableData.data.isNotEmpty) {
              EditableQueryResult totalQueryResult = EditableQueryResult();
              totalQueryResult.editable = [true];
              totalQueryResult.fieldAndTypemap = [];
              totalQueryResult.ids = [];
              totalQueryResult.primaryKeys = [];
              totalQueryResult.dbs = [];
              tableData.geoms.forEach((g) {
                totalQueryResult.ids?.add(table);
                totalQueryResult.primaryKeys?.add(key);
                totalQueryResult.dbs?.add(db);
                totalQueryResult.fieldAndTypemap?.add(typesMap);
                totalQueryResult.editable?.add(true);
                if (geometryColumn.srid != SmashPrj.EPSG4326_INT) {
                  var from = SmashPrj.fromSrid(geometryColumn.srid)!;
                  SmashPrj.transformGeometryToWgs84(from, g);
                }
                totalQueryResult.geoms.add(g);
              });
              tableData.data.forEach((d) {
                totalQueryResult.data.add(d);
              });

              var formHelper = SmashDatabaseFormHelper(totalQueryResult);
              await formHelper.init();
              if (formHelper.hasForm()) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MasterDetailPage(formHelper)));
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeatureAttributesViewer(
                              totalQueryResult,
                              readOnly: false,
                            )));
              }
              // reload layer geoms
              await reloadDbLayers(db, table);
            }
          } else {
            SmashDialogs.showWarningDialog(
                context,
                SL
                    .of(context)
                    .toolbarTools_featureDoesNotHavePrimaryKey); //"The feature does not have a primary key. Editing is not allowed."
          }
        },
      ),
    );
  }
}

class FeatureQueryButton extends StatefulWidget {
  final _iconSize;

  FeatureQueryButton(this._iconSize, {Key? key}) : super(key: key);

  @override
  _FeatureQueryButtonState createState() => _FeatureQueryButtonState();
}

class _FeatureQueryButtonState extends State<FeatureQueryButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InfoToolState>(builder: (context, infoState, child) {
      return Tooltip(
        message: SL
            .of(context)
            .toolbarTools_queryFeaturesVectorLayers, //"Query features from loaded vector layers."
        child: GestureDetector(
          child: Padding(
            padding: SmashUI.defaultPadding(),
            child: InkWell(
              child: Icon(
                MdiIcons.layersSearch,
                color: infoState.isEnabled
                    ? SmashColors.mainSelection
                    : SmashColors.mainBackground,
                size: widget._iconSize,
              ),
            ),
          ),
          onTap: () {
            setState(() {
              BottomToolbarToolsRegistry.setEnabled(context,
                  BottomToolbarToolsRegistry.FEATUREINFO, !infoState.isEnabled);
            });
          },
        ),
      );
    });
  }
}

class RulerButton extends StatelessWidget {
  final _iconSize;

  RulerButton(this._iconSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RulerState>(builder: (context, rulerState, child) {
      Widget w = InkWell(
        child: Icon(
          MdiIcons.ruler,
          color: rulerState.isEnabled
              ? SmashColors.mainSelection
              : SmashColors.mainBackground,
          size: _iconSize,
        ),
      );
      if (rulerState.lengthMeters != null && rulerState.lengthMeters != 0) {
        w = Badge(
          badgeColor: SmashColors.mainSelection,
          shape: BadgeShape.square,
          borderRadius: BorderRadius.circular(10.0),
          toAnimate: false,
          position: BadgePosition.topStart(
              top: -_iconSize / 2, start: 0.1 * _iconSize),
          badgeContent: Text(
            StringUtilities.formatMeters(rulerState.lengthMeters!),
            style: TextStyle(color: Colors.white),
          ),
          child: w,
        );
      }
      return Tooltip(
        message: SL
            .of(context)
            .toolbarTools_measureDistanceWithFinger, //"Measure distances on the map with your finger."
        child: GestureDetector(
          child: Padding(
            padding: SmashUI.defaultPadding(),
            child: w,
          ),
          onTap: () {
            BottomToolbarToolsRegistry.setEnabled(context,
                BottomToolbarToolsRegistry.RULER, !rulerState.isEnabled);
          },
        ),
      );
    });
  }
}

class FenceButton extends StatelessWidget {
  final _iconSize;

  FenceButton(this._iconSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget w = InkWell(
      child: Icon(
        MdiIcons.gate,
        color: SmashColors.mainBackground,
        size: _iconSize,
      ),
    );

    return Tooltip(
      message: SL
          .of(context)
          .toolbarTools_toggleFenceMapCenter, //"Toggle fence in map center."
      child: GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: w,
        ),
        onTap: () async {
          var mapState = Provider.of<SmashMapState>(context, listen: false);

          Fence tmpfence = Fence(context)
            ..lat = mapState.center.y
            ..lon = mapState.center.x;

          Fence? newFence = await FenceMaster()
              .showFencePropertiesDialog(context, tmpfence, false);
          if (newFence != null) {
            FenceMaster().addFence(newFence);
            var mapBuilder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            mapBuilder.reBuild();
          }
        },
        onLongPress: () async {
          var mapState = Provider.of<SmashMapState>(context, listen: false);
          var editFence = FenceMaster()
              .findIn(LatLng(mapState.center.y, mapState.center.x));
          if (editFence != null) {
            await FenceMaster()
                .showFencePropertiesDialog(context, editFence, true);
            var mapBuilder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            mapBuilder.reBuild();
          }
        },
      ),
    );
    ;
  }
}

class GeomEditorButton extends StatefulWidget {
  final _iconSize;

  GeomEditorButton(this._iconSize, {Key? key}) : super(key: key);

  @override
  _GeomEditorButtonState createState() => _GeomEditorButtonState();
}

class _GeomEditorButtonState extends State<GeomEditorButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GeometryEditorState>(
        builder: (context, editorState, child) {
      return Tooltip(
        message: SL
            .of(context)
            .toolbarTools_modifyGeomVectorLayers, //"Modify geometries in editable vector layers."
        child: GestureDetector(
          child: Padding(
            padding: SmashUI.defaultPadding(),
            child: InkWell(
              child: Icon(
                MdiIcons.vectorLine,
                color: editorState.isEnabled
                    ? SmashColors.mainSelection
                    : SmashColors.mainBackground,
                size: widget._iconSize,
              ),
            ),
          ),
          onTap: () {
            setState(() {
              BottomToolbarToolsRegistry.setEnabled(
                  context,
                  BottomToolbarToolsRegistry.GEOMEDITOR,
                  !editorState.isEnabled);
              SmashMapBuilder mapBuilder =
                  Provider.of<SmashMapBuilder>(context, listen: false);
              mapBuilder.reBuild();
            });
          },
        ),
      );
    });
  }
}
