/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/screen.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/share.dart';
import 'package:smash/eu/hydrologis/smash/forms/forms.dart';
import 'package:smash/eu/hydrologis/smash/forms/forms_widgets.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersview.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/current_log_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/feature_info_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/gps_position_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_progress_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_info_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_log_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';

import 'mainview_utils.dart';

class MainViewWidget extends StatefulWidget {
  MainViewWidget({Key key}) : super(key: key);

  @override
  _MainViewWidgetState createState() => new _MainViewWidgetState();
}

class _MainViewWidgetState extends State<MainViewWidget>
    with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _initLon;
  double _initLat;
  double _initZoom;

  MapController _mapController;

  List<LayerOptions> _activeLayers = [];

  double _iconSize;

  @override
  void initState() {
    super.initState();
    SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);

    _initLon = mapState.center.x;
    _initLat = mapState.center.y;
    _initZoom = mapState.zoom;
    if (_initZoom == 0) _initZoom = 1;
    _mapController = MapController();
    mapState.mapController = _mapController;

    bool doNoteInGps = GpPreferences().getBooleanSync(KEY_DO_NOTE_IN_GPS, true);
    gpsState.insertInGpsQuiet = doNoteInGps;
    // check center on gps
    bool centerOnGps = GpPreferences().getCenterOnGps();
    mapState.centerOnGpsQuiet = centerOnGps;
    // check rotate on heading
    bool rotateOnHeading = GpPreferences().getRotateOnHeading();
    mapState.rotateOnHeadingQuiet = rotateOnHeading;

    ScreenUtilities.keepScreenOn(GpPreferences().getKeepScreenOn());

    _iconSize = GpPreferences()
        .getDoubleSync(KEY_MAPTOOLS_ICON_SIZE, SmashUI.MEDIUM_ICON_SIZE);

    // set initial status
    bool gpsIsOn = GpsHandler().isGpsOn();
    if (gpsIsOn != null) {
      if (gpsIsOn) {
        gpsState.statusQuiet = GpsStatus.ON_NO_FIX;
      }
    }

    Future.delayed(Duration.zero, () async {
      projectState.context = context;
      await projectState.reloadProject();

      _activeLayers.clear();
      var layers = await LayerManager().loadLayers(context);
      setState(() {
        _activeLayers.addAll(layers);
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    print("BUIIIIIILD!!!");

    return Consumer<ProjectState>(builder: (context, projectState, child) {
      projectState.context = context;
      projectState.scaffoldKey = _scaffoldKey;
      return consumeBuild(projectState);
    });
  }

  WillPopScope consumeBuild(ProjectState projectState) {
    var layers = <LayerOptions>[];

    var mapState =
        Provider.of<SmashMapState>(projectState.context, listen: false);
    mapState.mapController = _mapController;

    layers.addAll(_activeLayers);

    var projectData = projectState.projectData;
    if (projectData != null) {
      if (projectData.geopapLogs != null) layers.add(projectData.geopapLogs);
      if (projectData.geopapMarkers != null &&
          projectData.geopapMarkers.length > 0) {
        var markerCluster = MarkerClusterLayerOptions(
          maxClusterRadius: 80,
          //        height: 40,
          //        width: 40,
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: projectData.geopapMarkers,
          polygonOptions: PolygonOptions(
              borderColor: SmashColors.mainDecorationsDarker,
              color: SmashColors.mainDecorations.withOpacity(0.2),
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
              backgroundColor: SmashColors.mainDecorationsDarker,
              foregroundColor: SmashColors.mainBackground,
              heroTag: null,
            );
          },
        );
        layers.add(markerCluster);
      }
    }

    layers.add(CurrentGpsLogPluginOption(
      logColor: Colors.red,
      logWidth: 5.0,
    ));

    layers.add(GpsPositionPluginOption(
      markerColor: Colors.black,
      markerSize: 32,
    ));

    bool showScalebar = GpPreferences().getBooleanSync(KEY_SHOW_SCALEBAR, true);
    if (showScalebar) {
      layers.add(ScaleLayerPluginOption(
        lineColor: Colors.black,
        lineWidth: 3,
        textStyle: TextStyle(color: Colors.black, fontSize: 14),
        padding: EdgeInsets.all(10),
      ));
    }

    var centerCrossStyle = CenterCrossStyle.fromPreferences();
    if (centerCrossStyle.visible) {
      layers.add(CenterCrossPluginOption(
        crossColor: ColorExt(centerCrossStyle.color),
        crossSize: centerCrossStyle.size,
        lineWidth: centerCrossStyle.lineWidth,
      ));
    }

    int tapAreaPixels = GpPreferences().getIntSync(KEY_VECTOR_TAPAREA_SIZE, 50);
    layers.add(FeatureInfoPluginOption(
      tapAreaPixelSize: tapAreaPixels.toDouble(),
    ));

    return WillPopScope(
        // check when the app is left
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Image.asset(
                "assets/smash_text.png",
                fit: BoxFit.cover,
                height: 32,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    String projectPath = projectState.projectPath;
                    if (Platform.isIOS) {
                      projectPath = IOS_DOCUMENTSFOLDER +
                          Workspace.makeRelative(projectPath);
                    }

                    showInfoDialog(
                        projectState.context,
                        "Project: ${projectState.projectName}\nDatabase: $projectPath"
                            .trim(),
                        widgets: [
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: SmashColors.mainDecorations,
                            ),
                            onPressed: () async {
                              ShareHandler.shareProject(projectState.context);
                            },
                          )
                        ]);
                  })
            ],
          ),
          backgroundColor: SmashColors.mainBackground,
          body: Stack(
            children: <Widget>[
              FlutterMap(
                options: new MapOptions(
                  center: new LatLng(_initLat, _initLon),
                  zoom: _initZoom,
                  minZoom: SmashMapState.MINZOOM,
                  maxZoom: SmashMapState.MAXZOOM,
                  plugins: [
                    MarkerClusterPlugin(),
                    ScaleLayerPlugin(),
                    CenterCrossPlugin(),
                    CurrentGpsLogPlugin(),
                    GpsPositionPlugin(),
                    FeatureInfoPlugin(),
                  ],
                  onPositionChanged: (newPosition, hasGesture) {
                    mapState.setLastPosition(
                        Coordinate(newPosition.center.longitude,
                            newPosition.center.latitude),
                        newPosition.zoom);
                  },
                ),
                layers: layers,
                mapController: _mapController,
              ),
              Center(
                child: Provider.of<MapProgressState>(context).inProgress
                    ? SmashCircularProgress(label: "Loading data...")
                    : Container(),
              )
            ],
          ),
          drawer: Drawer(
              child: ListView(
            children: _getDrawerWidgets(projectState.context),
          )),
          endDrawer: Drawer(
              child: ListView(
            children: _getEndDrawerWidgets(projectState.context),
          )),
          bottomNavigationBar: BottomAppBar(
            color: SmashColors.mainDecorations,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DashboardUtils.makeToolbarBadge(
                  GestureDetector(
                    child: IconButton(
                      onPressed: () async {
                        var gpsState = Provider.of<GpsState>(
                            projectState.context,
                            listen: false);
                        var doNoteInGps = gpsState.insertInGps;
                        Widget titleWidget = getDialogTitleWithInsertionMode(
                            "Simple Notes",
                            doNoteInGps,
                            SmashColors.mainSelection);
                        List<String> types = ["note", "image"];
                        var selectedType = await showComboDialog(
                            projectState.context, titleWidget, types);
                        if (selectedType == types[0]) {
                          Note note = await DataLoaderUtilities.addNote(
                              projectState, doNoteInGps, _mapController);
                          Navigator.push(
                              projectState.context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotePropertiesWidget(note)));
                        } else if (selectedType == types[1]) {
                          DataLoaderUtilities.addImage(
                              projectState.context,
                              doNoteInGps
                                  ? gpsState.lastGpsPosition
                                  : _mapController.center);
                        }
                      },
                      icon: Icon(
                        SmashIcons.simpleNotesIcon,
                        color: SmashColors.mainBackground,
                      ),
                      iconSize: _iconSize,
                    ),
                    onLongPress: () {
                      Navigator.push(
                          projectState.context,
                          MaterialPageRoute(
                              builder: (context) => NotesListWidget(true)));
                    },
                  ),
                  projectData != null ? projectData.simpleNotesCount : 0,
                ),
                DashboardUtils.makeToolbarBadge(
                  GestureDetector(
                    child: IconButton(
                      onPressed: () async {
                        var gpsState = Provider.of<GpsState>(
                            projectState.context,
                            listen: false);
                        var doNoteInGps = gpsState.insertInGps;
                        var title = "Select form";
                        Widget titleWidget = getDialogTitleWithInsertionMode(
                            title, doNoteInGps, SmashColors.mainSelection);

                        var allSectionsMap = TagsManager().getSectionsMap();
                        List<String> sectionNames =
                            allSectionsMap.keys.toList();
                        List<String> iconNames = [];
                        sectionNames.forEach((key) {
                          var icon4section =
                              TagsManager.getIcon4Section(allSectionsMap[key]);
                          iconNames.add(icon4section);
                        });

                        var selectedSection = await showComboDialog(
                            projectState.context,
                            titleWidget,
                            sectionNames,
                            iconNames);
                        if (selectedSection != null) {
                          Widget appbarWidget = getDialogTitleWithInsertionMode(
                              selectedSection,
                              doNoteInGps,
                              SmashColors.mainBackground);

                          var selectedIndex =
                              sectionNames.indexOf(selectedSection);
                          var iconName = iconNames[selectedIndex];
                          var sectionMap = allSectionsMap[selectedSection];
                          var jsonString = jsonEncode(sectionMap);
                          Note note = await DataLoaderUtilities.addNote(
                              projectState, doNoteInGps, _mapController,
                              text: selectedSection,
                              form: jsonString,
                              iconName: iconName,
                              color: ColorExt.asHex(
                                  SmashColors.mainDecorationsDarker));

                          Navigator.push(projectState.context,
                              MaterialPageRoute(
                            builder: (context) {
                              return MasterDetailPage(
                                  sectionMap,
                                  appbarWidget,
                                  selectedSection,
                                  doNoteInGps
                                      ? gpsState.lastGpsPosition
                                      : _mapController.center,
                                  note.id);
                            },
                          ));
                        }
                      },
                      icon: Icon(
                        SmashIcons.formNotesIcon,
                        color: SmashColors.mainBackground,
                      ),
                      iconSize: _iconSize,
                    ),
                    onLongPress: () {
                      Navigator.push(
                          projectState.context,
                          MaterialPageRoute(
                              builder: (context) => NotesListWidget(false)));
                    },
                  ),
                  projectData != null ? projectData.formNotesCount : 0,
                ),
                DashboardUtils.makeToolbarBadge(
                  LoggingButton(_iconSize),
                  projectData != null ? projectData.logsCount : 0,
                ),
                Spacer(),
                GpsInfoButton(_iconSize),
                Spacer(),
                IconButton(
                  icon: Icon(
                    SmashIcons.layersIcon,
                    color: SmashColors.mainBackground,
                  ),
                  iconSize: _iconSize,
                  onPressed: () async {
                    await Navigator.push(projectState.context,
                        MaterialPageRoute(builder: (context) => LayersPage()));

                    var layers = await LayerManager().loadLayers(context);
                    _activeLayers.clear();
                    setState(() {
                      _activeLayers.addAll(layers);
                    });
                  },
                  color: SmashColors.mainBackground,
                  tooltip: 'Open layers list',
                ),
                Consumer<SmashMapState>(builder: (context, mapState, child) {
                  return DashboardUtils.makeToolbarZoomBadge(
                    IconButton(
                      onPressed: () {
                        mapState.zoomIn();
                      },
                      tooltip: 'Zoom in',
                      icon: Icon(
                        SmashIcons.zoomInIcon,
                        color: SmashColors.mainBackground,
                      ),
                      iconSize: _iconSize,
                    ),
                    mapState.zoom.toInt(),
                  );
                }),
                IconButton(
                  onPressed: () {
                    mapState.zoomOut();
                  },
                  tooltip: 'Zoom out',
                  icon: Icon(
                    SmashIcons.zoomOutIcon,
                    color: SmashColors.mainBackground,
                  ),
                  iconSize: _iconSize,
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          bool doExit = await showConfirmDialog(
              projectState.context,
              "Are you sure you want to close the project?",
              "Active operations will be stopped.");
          if (doExit) {
            await disposeProject(context);
            GpsHandler().close();
            return Future.value(true);
          }
          return Future.value(false);
        });
  }

  Widget getDialogTitleWithInsertionMode(
      String title, bool doNoteInGps, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultRigthPadding(),
          child: SmashUI.titleText(title, color: color, bold: true),
        ),
        doNoteInGps
            ? Icon(
                Icons.gps_fixed,
                color: color,
              )
            : Icon(
                Icons.center_focus_weak,
                color: color,
              ),
      ],
    );
  }

  _getDrawerWidgets(BuildContext context) {
    double iconSize = 48;
    double textSize = iconSize / 2;
    var c = SmashColors.mainDecorations;
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(child: Image.asset("assets/smash_icon.png")),
        color: SmashColors.mainBackground,
      ),
      new Container(
        child: new Column(
            children:
                DashboardUtils.getDrawerTilesList(context, _mapController)),
      ),
    ];
  }

  _getEndDrawerWidgets(BuildContext context) {
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(
          child: Image.asset(
            "assets/maptools_icon.png",
          ),
        ),
        color: SmashColors.mainBackground,
      ),
      new Container(
        child: new Column(
            children:
                DashboardUtils.getEndDrawerListTiles(context, _mapController)),
      ),
    ];
  }

  Future disposeProject(BuildContext context) async {
    WidgetsBinding.instance.removeObserver(this);

    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    projectState?.close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }
}
