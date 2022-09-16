/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:dart_postgis/dart_postgis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/feature_attributes_viewer.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/shapefile.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/info_tool_state.dart';
import 'package:smashlibs/smashlibs.dart';

/// A plugin that handles tap info from vector layers
class FeatureInfoPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is FeatureInfoPluginOption) {
      return FeatureInfoLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for FeatureInfoPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is FeatureInfoPluginOption;
  }
}

class FeatureInfoPluginOption extends LayerOptions {
  Color tapAreaColor = SmashColors.mainSelectionBorder;
  double tapAreaPixelSize;

  FeatureInfoPluginOption({this.tapAreaPixelSize = 10});
}

class FeatureInfoLayer extends StatelessWidget {
  final FeatureInfoPluginOption featureInfoLayerOpts;
  final MapState map;
  final Stream<void> stream;

  FeatureInfoLayer(this.featureInfoLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoToolState>(builder: (context, infoToolState, child) {
      double radius = featureInfoLayerOpts.tapAreaPixelSize / 2.0;

      ProjectState projectState =
          Provider.of<ProjectState>(context, listen: false);

      return Stack(
        children: <Widget>[
          infoToolState.isEnabled && infoToolState.xTapPosition != null
              ? Positioned(
                  child: TapSelectionCircle(
                    size: featureInfoLayerOpts.tapAreaPixelSize,
                    color: featureInfoLayerOpts.tapAreaColor.withAlpha(128),
                    shape: BoxShape.circle,
                  ),
                  left: infoToolState.xTapPosition,
                  bottom: infoToolState.yTapPosition,
                )
              : Container(),
          infoToolState.isEnabled
              ? GestureDetector(
                  child: InkWell(),
                  onTapUp: (e) async {
                    Provider.of<SmashMapBuilder>(context, listen: false)
                        .setInProgress(true);
                    var p = e.localPosition;
                    var pixelBounds = map.getLastPixelBounds();

                    CustomPoint pixelOrigin = map.getPixelOrigin();
                    var ll = map.unproject(CustomPoint(
                        pixelOrigin.x + p.dx - radius,
                        pixelOrigin.y + (p.dy - radius)));
                    var ur = map.unproject(CustomPoint(
                        pixelOrigin.x + p.dx + radius,
                        pixelOrigin.y + (p.dy + radius)));
                    var envelope = Envelope.fromCoordinates(
                        Coordinate(ll.longitude, ll.latitude),
                        Coordinate(ur.longitude, ur.latitude));

                    var height =
                        pixelBounds.bottomLeft.y - pixelBounds.topLeft.y;
                    infoToolState.isSearching = true;
                    infoToolState.setTapAreaCenter(
                        p.dx - radius, height - p.dy - radius);
                    await queryLayers(
                        envelope, infoToolState, projectState, context);
                  },
                )
              : Container(),
        ],
      );
    });
  }

  Future<void> queryLayers(Envelope env, InfoToolState state,
      ProjectState projectState, BuildContext context) async {
    var boundsGeom = GeometryUtilities.fromEnvelope(env, makeCircle: true);
    boundsGeom.setSRID(4326);
    var boundMap = {4326: boundsGeom};

    List<LayerSource> visibleVectorLayers = LayerManager()
        .getLayerSources()
        .where((l) => l is VectorLayerSource && l.isActive())
        .toList();
    EditableQueryResult totalQueryResult = EditableQueryResult();
    totalQueryResult.editable = [];
    totalQueryResult.fieldAndTypemap = [];
    totalQueryResult.ids = [];
    totalQueryResult.primaryKeys = [];
    totalQueryResult.dbs = [];
    for (var vLayer in visibleVectorLayers) {
      if (DbVectorLayerSource.isDbVectorLayerSource(vLayer)) {
        var db = await DbVectorLayerSource.getDb(vLayer);

        var srid = vLayer.getSrid()!;
        var boundsGeomInSrid = boundMap[srid];
        if (boundsGeomInSrid == null) {
          // create the env
          var tmp = GeometryUtilities.fromEnvelope(env, makeCircle: true);
          var dataPrj = SmashPrj.fromSrid(srid)!;
          SmashPrj.transformGeometry(SmashPrj.EPSG4326, dataPrj, tmp);
          boundsGeomInSrid = tmp;
          boundsGeomInSrid.setSRID(srid);
          boundMap[srid] = boundsGeomInSrid;
        }
        var layerName = TableName(vLayer.getName()!,
            schemaSupported:
                db is PostgisDb || db is PostgresqlDb ? true : false);
        var tableColumns = await db.getTableColumns(layerName);
        Map<String, String> typesMap = {};
        tableColumns.forEach((column) {
          typesMap[column[0]] = column[1];
        });
        dynamic queryResult =
            await db.getTableData(layerName, geometry: boundsGeomInSrid);
        if (queryResult.data.isNotEmpty) {
          print("Found data for: " + layerName.name);

          var pk = await db.getPrimaryKey(layerName);

          var dataPrj = SmashPrj.fromSrid(srid);
          queryResult.geoms.forEach((g) {
            totalQueryResult.ids!.add(layerName.name);
            totalQueryResult.primaryKeys!.add(pk);
            totalQueryResult.dbs!.add(db);
            totalQueryResult.fieldAndTypemap!.add(typesMap);
            totalQueryResult.editable!.add(pk != null);
            if (srid != SmashPrj.EPSG4326_INT) {
              SmashPrj.transformGeometry(dataPrj!, SmashPrj.EPSG4326, g);
            }
            totalQueryResult.geoms.add(g);
          });
          queryResult.data.forEach((d) {
            totalQueryResult.data.add(d);
          });
        }
      } else if (vLayer is ShapefileSource) {
        var features = vLayer.getInRoi(roiGeom: boundsGeom);
        features.forEach((f) {
          totalQueryResult.ids!.add(vLayer.getName()!);
          totalQueryResult.primaryKeys?.add(null);
          totalQueryResult.editable!.add(false);
          totalQueryResult.geoms.add(f.geometry!);
          totalQueryResult.data.add(f.attributes);
        });
      }
    }

    Provider.of<SmashMapBuilder>(context, listen: false).setInProgress(false);
    if (totalQueryResult.data.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FeatureAttributesViewer(totalQueryResult)));
    }
  }
}

class EditableQueryResult {
  List<String>? ids;
  List<Geometry> geoms = [];
  List<Map<String, dynamic>> data = [];

  List<bool>? editable;
  List<String?>? primaryKeys;
  List<dynamic>? dbs;
  List<Map<String, dynamic>>? attributes;
  List<Map<String, String>>? fieldAndTypemap;
}

class TapSelectionCircle extends StatefulWidget {
  final double size;
  final shape;
  final color;

  TapSelectionCircle(
      {this.shape = BoxShape.rectangle,
      this.size = 30,
      this.color = Colors.redAccent});

  @override
  _TapSelectionCircleState createState() => _TapSelectionCircleState();
}

class _TapSelectionCircleState extends State<TapSelectionCircle> {
  double? size;
  var shape;
  var color;

  @override
  void initState() {
    size = widget.size;
    shape = widget.shape;
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<SmashMapBuilder>(context).inProgress) {
      size = widget.size;
    } else {
      size = 0;
    }

    return AnimatedContainer(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}
