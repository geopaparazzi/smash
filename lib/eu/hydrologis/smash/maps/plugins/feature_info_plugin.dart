import 'dart:async';

import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/smash/maps/feature_attributes_viewer.dart';
import 'package:smash/eu/hydrologis/smash/maps/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers.dart';
import 'package:smash/eu/hydrologis/smash/models/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_progress_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';

/// A plugin that handles tap info from vector layers
class FeatureInfoPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
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
  final Stream<Null> stream;

  FeatureInfoLayer(this.featureInfoLayerOpts, this.map, this.stream) {}

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
                    Provider.of<MapProgressState>(context, listen: false)
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
                    queryLayers(envelope, infoToolState, projectState, context);
                  },
                )
              : Container(),
        ],
      );
    });
  }

  void queryLayers(Envelope env, InfoToolState state, ProjectState projectState,
      BuildContext context) async {
    var boundsGeom = GeometryUtilities.fromEnvelope(env, makeCircle: true);

    List<LayerSource> visibleVectorLayers = LayerManager()
        .getActiveLayers()
        .where((l) => l is VectorLayerSource && l.isActive())
        .toList();
    QueryResult totalQueryResult = QueryResult();
    totalQueryResult.ids = [];
    for (var vLayer in visibleVectorLayers) {
      if (vLayer is GeopackageSource) {
        var db = await ConnectionsHandler().open(vLayer.getAbsolutePath());
        QueryResult queryResult =
            await db.getTableData(vLayer.getName(), geometry: boundsGeom);
        if (queryResult.data.isNotEmpty) {
          var layerName = vLayer.getName();
          print("Found data for: " + layerName);

          queryResult.geoms.forEach((g) {
            totalQueryResult.ids.add(layerName);
            totalQueryResult.geoms.add(g);
          });
          queryResult.data.forEach((d) {
            totalQueryResult.data.add(d);
          });
        }
      }
    }

    Provider.of<MapProgressState>(context, listen: false).setInProgress(false);
    if (totalQueryResult.data.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FeatureAttributesViewer(totalQueryResult)));
    }
  }
}

class TapSelectionCircle extends StatefulWidget {
  double size;
  var shape;
  var color;

  TapSelectionCircle(
      {this.shape = BoxShape.rectangle,
      this.size = 30,
      this.color = Colors.redAccent});

  @override
  _TapSelectionCircleState createState() => _TapSelectionCircleState();
}

class _TapSelectionCircleState extends State<TapSelectionCircle> {
  double size;
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
    if (Provider.of<MapProgressState>(context).inProgress) {
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
