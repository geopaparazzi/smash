/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geoimage/geoimage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/onlinesourcespage.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/remotedbpage.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class LayersPage extends StatefulWidget {
  LayersPage();

  @override
  State<StatefulWidget> createState() => LayersPageState();
}

class LayersPageState extends State<LayersPage> {
  bool _somethingChanged = false;

  bool isLoadingData = false;

  @override
  Widget build(BuildContext context) {
    List<LayerSource?> _layersList =
        LayerManager().getLayerSources(onlyActive: false);

    // revert order
    _layersList = _layersList.reversed.toList();

    List<Widget> listItems = createLayersList(_layersList, context);

    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, res) {
          if (didPop && _somethingChanged) {
            setLayersOnChange(_layersList);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(SL.of(context).layersView_layerList), //"Layer List"
            actions: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.earth),
                onPressed: () async {
                  var wmsLayerSource = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnlineSourcesPage()));

                  if (wmsLayerSource != null) {
                    LayerManager().addLayerSource(wmsLayerSource);
                    _somethingChanged = true;
                    setState(() {});
                  }
                },
                tooltip: SL
                    .of(context)
                    .layersView_loadOnlineSources, //"Load online sources"
              ),
              IconButton(
                icon: Icon(MdiIcons.map),
                onPressed: () async {
                  setState(() {
                    isLoadingData = true;
                  });
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

                  loadSelectedFile(selectedPath, context);
                },
                tooltip: SL
                    .of(context)
                    .layersView_loadLocalDatasets, //"Load local datasets"
              ),
              PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 1) {
                    setState(() {
                      isLoadingData = true;
                    });

                    var source = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RemoteDbsWidget(),
                        ));
                    if (source != null) {
                      await source.load(context);
                      LayerManager().addLayerSource(source);
                      _somethingChanged = true;
                    }

                    setState(() {
                      isLoadingData = false;
                    });
                  } else if (value == 2) {
                    setState(() {
                      isLoadingData = true;
                    });
                    selectGssLayers();
                  } else if (value == 3) {
                    openPluginsViewSettings();
                  }
                },
                itemBuilder: (BuildContext context) {
                  var txt1 = SL.of(context).layersView_loadRemoteDatabase;
                  var txt2 = SL.of(context).layersView_selectGssLayers;
                  var txt3 = SL.of(context).settings_SETTING;
                  return [
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(txt1),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text(txt2),
                    ),
                    PopupMenuItem<int>(
                      value: 3,
                      child: Text(txt3),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: isLoadingData
              ? SmashCircularProgress(
                  label: SL.of(context).layersView_loading, //"Loading..."
                )
              : ReorderableListView(
                  children: listItems,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex != newIndex) {
                      setState(() {
                        LayerManager().moveLayer(oldIndex, newIndex, true);
                        _somethingChanged = true;
                      });
                    }
                  },
                ),
        ));
  }

  Future openPluginsViewSettings() async {
    Dialog settingsDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: PluginsViewSetting(),
      ),
    );
    await showDialog(
        context: context, builder: (BuildContext context) => settingsDialog);
  }

  Future selectGssLayers() async {
    try {
      // get loaded layers to check if they are already loaded
      List<LayerSource?> _layersList =
          LayerManager().getLayerSources(onlyActive: false);
      List<String> loadedLayerNames = _layersList
          .where((ls) => ls != null)
          .map((ls) => ls!.getName()!)
          .toList();

      // get the list of gss layers from the server
      var gssLayersList = await GssUtilities.getGssLayersFromServer();
      if (gssLayersList == null || gssLayersList.isEmpty) {
        SmashDialogs.showWarningDialog(
            context, SL.of(context).layersView_noGssLayersFound);
        return;
      }

      Map<String, GssLayerDescription> gssLayerDescriptionsMap =
          GssUtilities.getGssLayerDescriptionsMap(gssLayersList);
      // remove the ones that are already loaded
      gssLayerDescriptionsMap
          .removeWhere((key, value) => loadedLayerNames.contains(key));

      if (gssLayerDescriptionsMap.isEmpty) {
        SmashDialogs.showWarningDialog(
            context, SL.of(context).layersView_noGssLayersAvailable);
        return;
      }

      var selectedLayersAndConfigs = await GssUtilities.selectGssLayerDialog(
          context, null, gssLayerDescriptionsMap.keys.toList());
      List<String> selectedLayerNames = selectedLayersAndConfigs[0];
      bool downloadAll = selectedLayersAndConfigs[1];
      bool downloadUser = selectedLayersAndConfigs[2];

      if (selectedLayerNames.isNotEmpty) {
        var unableToLoad = <String>[];
        for (var selectedLayerName in selectedLayerNames) {
          var gssLayerDescription = gssLayerDescriptionsMap[selectedLayerName]!;
          var formDefinition = gssLayerDescription.formDefinition;
          var geometryType = gssLayerDescription.geometryType;
          if (formDefinition != null && geometryType != null) {
            // check if file altready exists
            var gssFolder = await GssUtilities.getGssFolder();
            var layerFilePath = FileUtilities.joinPaths(
                gssFolder.path, selectedLayerName + ".geojson");

            if (File(layerFilePath).existsSync()) {
              var doOverwrite = await SmashDialogs.showConfirmDialog(
                  context,
                  SL.of(context).layersView_layerExists +
                      ": " +
                      selectedLayerName,
                  SL.of(context).layersView_layerAlreadyExists);
              if (!doOverwrite!) {
                continue;
              }
            }

            var downloadMode = downloadAll
                ? 0
                : downloadUser
                    ? 1
                    : 2;

            String? geojsonPath = await ServerApi.downloadDynamicLayerToDevice(
                selectedLayerName,
                formDefinition: formDefinition,
                geometryType: geometryType,
                downloadMode: downloadMode);
            if (geojsonPath != null) {
              var layerSource = GeojsonSource(geojsonPath);
              // await layerSource.load(context);
              LayerManager().addLayerSource(layerSource);
              _somethingChanged = true;
            } else {
              unableToLoad.add(selectedLayerName);
            }
          }
        }
        if (unableToLoad.isNotEmpty) {
          SmashDialogs.showWarningDialog(
              context,
              SL.of(context).layersView_unableToLoadGssLayers +
                  unableToLoad.join(", "));
        }
      }
    } finally {
      setState(() {
        isLoadingData = false;
      });
    }
  }

  Future loadSelectedFile(selectedPath, BuildContext context) async {
    if (selectedPath != null) {
      await loadLayer(context, selectedPath);
      _somethingChanged = true;
    }
    setState(() {
      isLoadingData = false;
    });
  }

  List<Widget> createLayersList(
      List<LayerSource?> _layersList, BuildContext context) {
    // revert prder of _layersList
    final List fixedList = Iterable<int>.generate(_layersList.length).toList();
    return fixedList.where((idx) => _layersList[idx] != null).map((idx) {
      var layerSourceItem = _layersList[idx]!;
      var srid = layerSourceItem.getSrid();
      bool? prjSupported;
      if (srid != null) {
        var projection = SmashPrj.fromSrid(srid);
        prjSupported = projection != null;
      }
      List<Widget> startActions = [];
      List<Widget> endActions = [];

      if (layerSourceItem.isZoomable()) {
        startActions.add(SlidableAction(
            label: SL.of(context).layersView_zoomTo, //'Zoom to'
            foregroundColor: SmashColors.mainDecorations,
            icon: MdiIcons.magnifyScan,
            onPressed: (context) async {
              LatLngBounds? bb = await layerSourceItem.getBounds(context);
              if (bb != null) {
                setLayersOnChange(_layersList);

                SmashMapState mapState =
                    Provider.of<SmashMapState>(context, listen: false);
                mapState.setBounds(
                    new Envelope(bb.west, bb.east, bb.south, bb.north));
                Navigator.of(context).pop();
              }
            }));
      }
      if (layerSourceItem.hasProperties()) {
        startActions.add(SlidableAction(
            label: SL.of(context).layersView_properties, //'Properties'
            foregroundColor: SmashColors.mainDecorations,
            icon: MdiIcons.palette,
            onPressed: (context) async {
              var propertiesWidget = layerSourceItem.getPropertiesWidget();
              String? newSldString = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => propertiesWidget));
              if (newSldString != null) {
                if (layerSourceItem is SldLayerSource) {
                  (layerSourceItem as SldLayerSource).updateStyle(newSldString);
                }
                if (layerSourceItem is LoadableLayerSource) {
                  layerSourceItem.isLoaded = false;
                }
              }
              _somethingChanged = true;
            }));
      }
      if (layerSourceItem is FilterableLayerSource) {
        // add where filter
        startActions.add(SlidableAction(
            label: SL.of(context).gss_layerview_filter,
            foregroundColor: SmashColors.mainDecorations,
            icon: MdiIcons.filter,
            onPressed: (tmpcontext) async {
              var filter =
                  (layerSourceItem as FilterableLayerSource).getFilter();
              if (filter == null) {
                filter = "";
              }
              var newFilter = await SmashDialogs.showInputDialog(
                context,
                SL.of(context).gss_layerview_filter,
                "",
                defaultText: filter,
              );
              if (newFilter != null) {
                (layerSourceItem as FilterableLayerSource).setFilter(newFilter);
                if (layerSourceItem is LoadableLayerSource) {
                  layerSourceItem.isLoaded = false;
                }
                _somethingChanged = true;
              }
            }));
      }
      if (layerSourceItem is GssLayerSource &&
          (layerSourceItem as GssLayerSource).canUpload()) {
        startActions.add(SlidableAction(
            label: SL.of(context).gss_layerview_upload_changes,
            foregroundColor: SmashColors.mainDecorations,
            icon: MdiIcons.upload,
            onPressed: (tmpcontext) async {
              await (layerSourceItem as GssLayerSource).upload(context);
              _somethingChanged = true;
            }));
      }
      endActions.add(SlidableAction(
          label: SL.of(context).layersView_delete, //'Delete'
          foregroundColor: SmashColors.mainDanger,
          icon: MdiIcons.delete,
          onPressed: (context) {
            if (layerSourceItem.isActive()) {
              _somethingChanged = true;
            }
            _layersList.remove(layerSourceItem);
            LayerManager().removeLayerSource(layerSourceItem);
            setState(() {});
          }));

      var key = "$idx-${layerSourceItem.getName()}";
      return Slidable(
        key: Key(key),
        closeOnScroll: false,
        startActionPane: ActionPane(
          extentRatio: 0.35,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: startActions,
        ),
        endActionPane: ActionPane(
          extentRatio: 0.35,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: endActions,
        ),
        child: ListTile(
          title: SingleChildScrollView(
            child: Text('${layerSourceItem.getName()}'),
            scrollDirection: Axis.horizontal,
          ),
          subtitle: prjSupported == null
              ? TextButton(
                  child: Text(
                    SL
                        .of(context)
                        .layersView_projCouldNotBeRecognized, //"The proj could not be recognised. Tap to enter epsg manually."
                    style: TextStyle(color: SmashColors.mainDanger),
                  ),
                  onPressed: () async {
                    await fixMissingPrj(prjSupported, srid);
                  },
                )
              : !prjSupported
                  ? TextButton(
                      child: Text(
                        SL
                            .of(context)
                            .layersView_projNotSupported, //"The proj is not supported. Tap to solve."
                        style: TextStyle(color: SmashColors.mainDanger),
                      ),
                      onPressed: () async {
                        await fixMissingPrj(prjSupported, srid);
                      },
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                          'EPSG:$srid ${layerSourceItem.getAttribution()}'),
                    ),
          leading: Icon(
            SmashIcons.forPath(
                layerSourceItem.getAbsolutePath() ?? layerSourceItem.getUrl()!),
            color: SmashColors.mainDecorations,
            size: SmashUI.MEDIUM_ICON_SIZE,
          ),
          trailing: Padding(
            padding:
                EdgeInsets.only(right: SmashPlatform.isDesktop() ? 10.0 : 0.0),
            child: IconButton(
              icon: Icon(MdiIcons.eye,
                  color: layerSourceItem.isActive()
                      ? SmashColors.mainDecorations
                      : SmashColors.disabled),
              onPressed: () {
                var isVisible = !layerSourceItem.isActive();
                layerSourceItem.setActive(isVisible);
                _somethingChanged = true;
                if (isVisible &&
                    layerSourceItem is LoadableLayerSource &&
                    !layerSourceItem.isLoaded) {
                  setState(() {
                    isLoadingData = true;
                    loadLayerWithProgressEnd(layerSourceItem, context);
                  });
                } else {
                  setState(() {});
                }
              },
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> fixMissingPrj(var prjSupported, var srid) async {
    if (prjSupported == null || !prjSupported) {
      bool goToPrjPage = true;
      if (prjSupported == null && srid == null) {
        int? epsg = await SmashDialogs.showEpsgInputDialog(context);
        if (epsg != null) {
          srid = epsg;
        } else {
          goToPrjPage = false;
        }
      }

      if (goToPrjPage) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectionsSettings(
                      epsgToDownload: srid,
                    )));
        setState(() {});
      }
    }
  }

  Future<void> loadLayerWithProgressEnd(
      LoadableLayerSource layerSourceItem, BuildContext context) async {
    await layerSourceItem.load(context);
    setState(() {
      isLoadingData = false;
    });
  }

  void setLayersOnChange(List<LayerSource?> _layersList) {
    List<String> layers =
        _layersList.reversed // need to reverse it back again to how it is saved
            .where((ls) => ls != null)
            .map((ls) => ls!.toJson())
            .toList();
    GpPreferences().setLayerInfoList(layers);
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
  } else if (FileManager.isGeojson(filePath)) {
    GeojsonSource geojsonLayer = GeojsonSource(filePath);
    await geojsonLayer.load(context);
    if (geojsonLayer.hasData()) {
      geojsonLayer.isLoaded =
          false; // TODO this should be solved for efficiency
      LayerManager().addLayerSource(geojsonLayer);
      return true;
    }
  } else if (FileManager.isGeocaching(filePath)) {
    GeocachingSource geocachingLayer = GeocachingSource(filePath);
    await geocachingLayer.load(context);
    if (geocachingLayer.hasData()) {
      LayerManager().addLayerSource(geocachingLayer);
      return true;
    }
  } else if (FileManager.isShp(filePath)) {
    ShapefileSource shpLayer = ShapefileSource(filePath);
    await shpLayer.load(context);
    if (shpLayer.hasData()) {
      LayerManager().addLayerSource(shpLayer);
      return true;
    }
  } else if (GeoimageUtils.isGeoImage(filePath)) {
    bool canLoad = true;
    if (!GeoimageUtils.isTiff(filePath)) {
      var worldFile = GeoimageUtils.getWorldFile(filePath);
      var prjFile = GeoimageUtils.getPrjFile(filePath);
      if (worldFile == null) {
        canLoad = false;
        SmashDialogs.showWarningDialog(
            context,
            SL
                .of(context)
                .layersView_onlyImageFilesWithWorldDef); //"Only image files with world file definition are supported."
      } else if (prjFile == null) {
        canLoad = false;
        SmashDialogs.showWarningDialog(
            context,
            SL
                .of(context)
                .layersView_onlyImageFileWithPrjDef); //"Only image files with prj file definition are supported."
      }
    }
    if (canLoad) {
      GeoImageSource worldLayer = GeoImageSource(filePath);
      await worldLayer.load(context);
      if (worldLayer.hasData()) {
        LayerManager().addLayerSource(worldLayer);
        return true;
      }
    }
  } else if (FileManager.isGeopackage(filePath)) {
    var ch = ConnectionsHandler();
    ch.forceRasterMobileCompatibility = false;
    try {
      var db = ch.open(filePath);

      // do features
      List<FeatureEntry> features = db.features();
      List<TileEntry> tiles = db.tiles();

      List<String>? selectedTables = [];
      List<String> allTables = [];
      List<String> featureTables = [];
      List<String> tilesTables = [];
      List<IconData> iconDataList = [];

      var featuresList = features.map((f) => f.tableName.name).toList();
      featuresList.forEach((elem) {
        featureTables.add(elem);
        iconDataList.add(SmashIcons.iconTypeShp);
      });
      allTables.addAll(featuresList);
      var tilesList = tiles.map((t) => t.tableName.name).toList();
      tilesList.forEach((elem) {
        tilesTables.add(elem);
        iconDataList.add(SmashIcons.iconTypeRaster);
      });
      allTables.addAll(tilesList);

      if (allTables.length == 1) {
        selectedTables.add(allTables.first);
      } else if (allTables.length > 1) {
        selectedTables = await SmashDialogs.showMultiSelectionComboDialog(
            context,
            SL
                .of(context)
                .layersView_selectTableToLoad, //"Select table to load."
            allTables,
            iconDataList: iconDataList);
      }

      bool oneLoaded = false;
      if (selectedTables != null && selectedTables.isNotEmpty) {
        for (var selectedTable in selectedTables) {
          // check if features
          if (featureTables.contains(selectedTable)) {
            GeopackageSource gps = GeopackageSource(filePath, selectedTable);
            await gps.load(context);
            gps.calculateSrid();
            LayerManager().addLayerSource(gps);
            oneLoaded = true;
          } else if (tilesTables.contains(selectedTable)) {
            var ts = TileSource.Geopackage(filePath, selectedTable);
            LayerManager().addLayerSource(ts);
            oneLoaded = true;
          }
        }
      }
      if (oneLoaded) {
        return true;
      }
    } finally {
      ch.close(filePath);
    }
  } else {
    SmashDialogs.showWarningDialog(
        context,
        SL
            .of(context)
            .layersView_fileFormatNotSUpported); //"File format not supported."
  }
  return false;
}
