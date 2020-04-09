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
import 'package:smash/eu/hydrologis/smash/maps/layers/core/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/geopackage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/gpx.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/worldimage.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';

class LayersPage extends StatefulWidget {
  Function _reloadFunction;

  LayersPage(this._reloadFunction);

  @override
  State<StatefulWidget> createState() => LayersPageState();
}

class LayersPageState extends State<LayersPage> {
  bool _somethingChanged = false;

  @override
  Widget build(BuildContext context) {
    List<LayerSource> _layersList = LayerManager().getLayers(onlyActive: false);

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
          body: ListView.builder(
              itemCount: _layersList.length,
              itemBuilder: (context, index) {
                LayerSource layerSourceItem = _layersList[index];
                return Dismissible(
                  confirmDismiss: _confirmLogDismiss,
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (layerSourceItem.isActive()) {
                      _somethingChanged = true;
                    }
                    _layersList.removeAt(index);
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
                    leading: Icon(
                      SmashIcons.forPath(layerSourceItem.getAbsolutePath() ??
                          layerSourceItem.getUrl()),
                      color: SmashColors.mainDecorations,
                      size: SmashUI.MEDIUM_ICON_SIZE,
                    ),
                    trailing: Checkbox(
                        value: layerSourceItem.isActive(),
                        onChanged: (isVisible) async {
                          layerSourceItem.setActive(isVisible);
                          _somethingChanged = true;
                          setState(() {});
                        }),
                    title: Text('${layerSourceItem.getName()}'),
                    subtitle: Text('${layerSourceItem.getAttribution()}'),
                    onLongPress: () async {
                      LatLngBounds bb = await layerSourceItem.getBounds();
                      if (bb != null) {
                        setLayersOnChange(_layersList);

                        SmashMapState mapState =
                            Provider.of<SmashMapState>(context, listen: false);
                        mapState.setBounds(
                            new Envelope(bb.west, bb.east, bb.south, bb.north));
                        Navigator.of(context).pop();
                      }
                    },
                    onTap: () {
                      if (layerSourceItem is GpxSource) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GpxPropertiesWidget(
                                    layerSourceItem, widget._reloadFunction)));
                      } else if (layerSourceItem is WorldImageSource) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TiffPropertiesWidget(
                                    layerSourceItem, widget._reloadFunction)));
                      }
                    },
                  ),
                );
              }),
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
                      var selected = await showComboDialog(
                          context,
                          "Select online tile source",
                          onlinesTilesSources.map((ts) => ts.name).toList());
                      if (selected != null) {
                        var selectedTs = onlinesTilesSources
                            .where((ts) => ts.name == selected)
                            .first;
                        LayerManager().addLayer(selectedTs);
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

  void setLayersOnChange(List<LayerSource> _layersList) {
    List<String> baseLayers = [];
    List<String> vectorLayers = [];
    _layersList.forEach((layer) {
      if (layer is TileSource || layer is RasterLayerSource) {
        baseLayers.add(layer.toJson());
      }
      if (layer is VectorLayerSource) {
        vectorLayers.add(layer.toJson());
      }
    });

    GpPreferences().setBaseLayerInfoList(baseLayers);
    GpPreferences().setVectorLayerInfoList(vectorLayers);
    widget._reloadFunction();
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
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isMbtiles(filePath)) {
    TileSource ts = TileSource.Mbtiles(filePath);
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isMapurl(filePath)) {
    TileSource ts = TileSource.Mapurl(filePath);
    LayerManager().addLayer(ts);
    return true;
  } else if (FileManager.isGpx(filePath)) {
    GpxSource gpxLayer = GpxSource(filePath);
    await gpxLayer.load(context);
    if (gpxLayer.hasData()) {
      LayerManager().addLayer(gpxLayer);
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
        LayerManager().addLayer(worldLayer);
        return true;
      }
    }
  } else if (FileManager.isGeopackage(filePath)) {
    var ch = ConnectionsHandler();
    try {
      var db = await ch.open(filePath);
      List<FeatureEntry> features = await db.features();
      features.forEach((f) {
        GeopackageSource gps = GeopackageSource(filePath, f.tableName);
        LayerManager().addLayer(gps);
        return true;
      });

      List<TileEntry> tiles = await db.tiles();
      tiles.forEach((t) {
        var ts = TileSource.Geopackage(filePath, t.tableName);
        LayerManager().addLayer(ts);
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
