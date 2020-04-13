/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/projection.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/onlinesourcespage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/gpx.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/wms.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/worldimage.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';

class LayersPage extends StatefulWidget {
  LayersPage();

  @override
  State<StatefulWidget> createState() => LayersPageState();
}

class LayersPageState extends State<LayersPage> {
  bool _somethingChanged = false;

  @override
  Widget build(BuildContext context) {
    List<LayerSource> _layersList =
        LayerManager().getLayerSources(onlyActive: false);

    List<Dismissible> listItems = createLayersList(_layersList, context);

    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            setLayersOnChange(_layersList);
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Layer List"),
          ),
          body: ReorderableListView(
            children: listItems,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex != newIndex) {
                setState(() {
                  LayerManager().moveLayer(oldIndex, newIndex);
                  _somethingChanged = true;
                });
              }
            },
          ),
          floatingActionButton: AnimatedFloatingActionButton(
              fabButtons: <Widget>[
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      //Navigator.of(context).pop();
                      var lastUsedFolder = await Workspace.getLastUsedFolder();
                      var allowed = <String>[]
                        ..addAll(FileManager.ALLOWED_VECTOR_DATA_EXT)
                        ..addAll(FileManager.ALLOWED_RASTER_DATA_EXT)
                        ..addAll(FileManager.ALLOWED_TILE_DATA_EXT);
                      var selectedPath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FileBrowser(false, allowed, lastUsedFolder)));

                      if (selectedPath != null) {
                        await loadLayer(context, selectedPath);
                        setState(() {});
                      }
                    },
                    tooltip: "Load spatial datasets",
                    child: Icon(MdiIcons.map),
                    heroTag: null,
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      var wmsLayerSource = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnlineSourcesPage()));

                      if (wmsLayerSource != null) {
                        LayerManager().addLayerSource(wmsLayerSource);
                        setState(() {});
                      }
                    },
                    tooltip: "Online Sources",
                    child: Icon(MdiIcons.earth),
                    heroTag: null,
                  ),
                ),
              ],
              colorStartAnimation: SmashColors.mainSelection,
              colorEndAnimation: SmashColors.mainSelectionBorder,
              animatedIconData: AnimatedIcons.menu_close //To principal button
              ),
        ));
  }

  List<Dismissible> createLayersList(
      List<LayerSource> _layersList, BuildContext context) {
    return _layersList.map((layerSourceItem) {
      var srid = layerSourceItem.getSrid();
      var projection = SmashPrj.fromSrid(srid);
      bool prjSupported = projection != null;

      return Dismissible(
        confirmDismiss: _confirmLogDismiss,
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (layerSourceItem.isActive()) {
            _somethingChanged = true;
          }
          _layersList.remove(layerSourceItem);
          LayerManager().removeLayerSource(layerSourceItem);
        },
        key: ValueKey(layerSourceItem),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: ListTile(
          onTap: () {
            if (!prjSupported) {
              // showWarningDialog(context, "Need to add prj: $srid");

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectionsSettings(
                            epsgToDownload: srid,
                          )));
            }
          },
          leading: Icon(
            SmashIcons.forPath(
                layerSourceItem.getAbsolutePath() ?? layerSourceItem.getUrl()),
            color: SmashColors.mainDecorations,
            size: SmashUI.MEDIUM_ICON_SIZE,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              layerSourceItem.isZoomable()
                  ? IconButton(
                      icon: Icon(MdiIcons.magnifyScan,
                          color: SmashColors.mainDecorations),
                      onPressed: () async {
                        LatLngBounds bb = await layerSourceItem.getBounds();
                        if (bb != null) {
                          setLayersOnChange(_layersList);

                          SmashMapState mapState = Provider.of<SmashMapState>(
                              context,
                              listen: false);
                          mapState.setBounds(new Envelope(
                              bb.west, bb.east, bb.south, bb.north));
                          Navigator.of(context).pop();
                        }
                      })
                  : Container(),
              layerSourceItem.hasProperties()
                  ? IconButton(
                      icon: Icon(MdiIcons.palette,
                          color: SmashColors.mainDecorations),
                      onPressed: () async {
                        if (layerSourceItem is GpxSource) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GpxPropertiesWidget(layerSourceItem)));
                        } else if (layerSourceItem is WorldImageSource) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TiffPropertiesWidget(layerSourceItem)));
                        } else if (layerSourceItem is WmsSource) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WmsPropertiesWidget(layerSourceItem)));
                        } else if (layerSourceItem is TileSource) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TileSourcePropertiesWidget(
                                          layerSourceItem)));
                        }
                      })
                  : Container(),
              Checkbox(
                  value: layerSourceItem.isActive(),
                  onChanged: (isVisible) async {
                    layerSourceItem.setActive(isVisible);
                    _somethingChanged = true;
                    setState(() {});
                  }),
            ],
          ),
          title: SingleChildScrollView(
            child: Text('${layerSourceItem.getName()}'),
            scrollDirection: Axis.horizontal,
          ),
          subtitle: prjSupported
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                      'EPSG:$srid ${layerSourceItem.getAttribution()}'),
                )
              : Text(
                  "The proj is not supported. Tap to solve.",
                  style: TextStyle(color: SmashColors.mainDanger),
                ),
        ),
      );
    }).toList();
  }

  void setLayersOnChange(List<LayerSource> _layersList) {
    List<String> layers = _layersList.map((ls) => ls.toJson()).toList();
    GpPreferences().setLayerInfoList(layers);
  }

  Future<bool> _confirmLogDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove layer'),
            content: Text('Are you sure you want to remove the layer?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
            ],
          );
        });
  }
}

Future<bool> loadLayer(BuildContext context, String filePath) async {
  if (FileManager.isMapsforge(filePath)) {
    TileSource ts = TileSource.Mapsforge(filePath);
    LayerManager().addLayerSource(ts);
    return true;
  } else if (FileManager.isMbtiles(filePath)) {
    TileSource ts = TileSource.Mbtiles(filePath);
    LayerManager().addLayerSource(ts);
    return true;
  } else if (FileManager.isMapurl(filePath)) {
    TileSource ts = TileSource.Mapurl(filePath);
    LayerManager().addLayerSource(ts);
    return true;
  } else if (FileManager.isGpx(filePath)) {
    GpxSource gpxLayer = GpxSource(filePath);
    await gpxLayer.load(context);
    if (gpxLayer.hasData()) {
      LayerManager().addLayerSource(gpxLayer);
      return true;
    }
  } else if (FileManager.isWorldImage(filePath)) {
    var worldFile = WorldImageSource.getWorldFile(filePath);
    var prjFile = SmashPrj.getPrjForImage(filePath);
    if (worldFile == null) {
      showWarningDialog(context,
          "Only image files with world file definition are supported.");
    } else if (prjFile == null) {
      showWarningDialog(
          context, "Only image files with prj file definition are supported.");
    } else {
      WorldImageSource worldLayer = WorldImageSource(filePath);
      await worldLayer.load(context);
      if (worldLayer.hasData()) {
        LayerManager().addLayerSource(worldLayer);
        return true;
      }
    }
  } else if (FileManager.isGeopackage(filePath)) {
    var ch = ConnectionsHandler();
    try {
      var db = await ch.open(filePath);
      List<FeatureEntry> features = await db.features();
      for (var f in features) {
        GeopackageSource gps = GeopackageSource(filePath, f.tableName);
        await gps.calculateSrid();
        LayerManager().addLayerSource(gps);
      }

      List<TileEntry> tiles = await db.tiles();
      tiles.forEach((t) {
        var ts = TileSource.Geopackage(filePath, t.tableName);
        LayerManager().addLayerSource(ts);
        return true;
      });
    } finally {
      await ch?.close(filePath);
    }
  } else {
    showWarningDialog(context, "File format not supported.");
  }
  return false;
}
