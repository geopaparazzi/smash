/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:lat_lon_grid_plugin/lat_lon_grid_plugin.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersview.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/current_log_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/feature_info_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/gps_position_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/heatmap.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/pluginshandler.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/util/coachmarks.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_info_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_log_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smashlibs/smashlibs.dart';

import 'mainview_utils.dart';

class MainViewWidget extends StatefulWidget {
  MainViewWidget({Key key}) : super(key: key);

  @override
  MainViewWidgetState createState() => new MainViewWidgetState();
}

class MainViewWidgetState extends State<MainViewWidget>
    with WidgetsBindingObserver, AfterLayoutMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainViewCoachMarks coachMarks = MainViewCoachMarks();

  double _initLon;
  double _initLat;
  double _initZoom;

  MapController _mapController;

  List<LayerOptions> _activeLayers = [];

  double _iconSize;

  Timer _centerOnGpsTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    ScreenUtilities.keepScreenOn(GpPreferences().getKeepScreenOn());

    SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);

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

    // set initial status
    bool gpsIsOn = GpsHandler().isGpsOn();
    if (gpsIsOn != null) {
      if (gpsIsOn) {
        gpsState.statusQuiet = GpsStatus.ON_NO_FIX;
      }
    }

    coachMarks.initCoachMarks();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SmashMapBuilder mapBuilder =
        Provider.of<SmashMapBuilder>(context, listen: false);

    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      mapBuilder.context = context;
      await projectState.reloadProject(context);

      _activeLayers.clear();
      var layers = await LayerManager().loadLayers(context);
      setState(() {
        _activeLayers.addAll(layers);
      });
    });

    _centerOnGpsTimer =
        Timer.periodic(Duration(milliseconds: 3000), (timer) async {
      if (context != null && _mapController != null) {
        var mapState = Provider.of<SmashMapState>(context, listen: false);
        if (mapState.centerOnGps) {
          GpsState gpsState = Provider.of<GpsState>(context, listen: false);
          if (gpsState.lastGpsPosition != null) {
            LatLng posLL = LatLng(gpsState.lastGpsPosition.latitude,
                gpsState.lastGpsPosition.longitude);
            _mapController?.move(posLL, _mapController?.zoom);
          }
        }
      }
    });

    var keyCoach = "key_did_show_main_view_coach_marks";
    var didShowCoachMarks = GpPreferences().getBooleanSync(keyCoach, false);
    if (!didShowCoachMarks) {
      coachMarks.showTutorial(context);
      GpPreferences().setBoolean(keyCoach, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BUIIIIIILD!!!");
    return Consumer<SmashMapBuilder>(builder: (context, mapBuilder, child) {
      mapBuilder.context = context;
      mapBuilder.scaffoldKey = _scaffoldKey;
      return consumeBuild(mapBuilder);
    });
  }

  WillPopScope consumeBuild(SmashMapBuilder mapBuilder) {
    var layers = <LayerOptions>[];
    _iconSize = GpPreferences()
        .getDoubleSync(KEY_MAPTOOLS_ICON_SIZE, SmashUI.MEDIUM_ICON_SIZE);
    var projectState =
        Provider.of<ProjectState>(mapBuilder.context, listen: false);
    var mapState =
        Provider.of<SmashMapState>(mapBuilder.context, listen: false);

    if (_mapController != null && _mapController.ready) {
      if (EXPERIMENTAL_ROTATION_ENABLED) {
        // check map centering and rotation
        if (mapState.rotateOnHeading) {
          GpsState gpsState = Provider.of<GpsState>(context, listen: false);
          var heading = gpsState.lastGpsPosition.heading;
          if (heading < 0) {
            heading = 360 + heading;
          }
          _mapController.rotate(-heading);
        } else {
          _mapController.rotate(0);
        }
      }
    }

    layers.addAll(_activeLayers);

    var pluginsList = <MapPlugin>[];
    addPluginsPreLayers(pluginsList, layers);
    ProjectData projectData = addProjectMarkers(projectState, layers);
    addPluginsPostLayers(pluginsList, layers);

    return WillPopScope(
        // check when the app is left
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  key: coachMarks.drawerButtonKey,
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Image.asset(
                "assets/smash_text.png",
                fit: BoxFit.cover,
                height: 32,
              ),
            ),
            actions: addActionBarButtons(),
          ),
          // backgroundColor: SmashColors.mainBackground,
          body: Stack(
            children: <Widget>[
              FlutterMap(
                options: new MapOptions(
                  center: new LatLng(_initLat, _initLon),
                  zoom: _initZoom,
                  minZoom: SmashMapState.MINZOOM,
                  maxZoom: SmashMapState.MAXZOOM,
                  plugins: pluginsList,
                  onPositionChanged: (newPosition, hasGesture) {
                    mapState.setLastPositionQuiet(
                        Coordinate(newPosition.center.longitude,
                            newPosition.center.latitude),
                        newPosition.zoom);
                  },
                ),
                layers: layers,
                mapController: _mapController,
              ),
              Center(
                child: mapBuilder.inProgress
                    ? SmashCircularProgress(label: "Loading data...")
                    : Container(),
              )
            ],
          ),
          drawer: Drawer(
              child: ListView(
            children: [
              new Container(
                margin: EdgeInsets.only(bottom: 20),
                child: new DrawerHeader(
                    child: Image.asset("assets/smash_icon.png")),
                color: SmashColors.mainBackground,
              ),
              new Container(
                child: new Column(
                    children: DashboardUtils.getDrawerTilesList(
                        context, _mapController)
                      ..add(
                        getExitTile(context, mapBuilder, mapState),
                      )),
              ),
            ],
          )),
          endDrawer: Drawer(
              child: ListView(
            children:
                DashboardUtils.getEndDrawerListTiles(context, _mapController),
          )),
          // Theme(
          //   data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          //   child: Drawer(
          //       child: Container(
          //     color: Colors.transparent,
          //     child: ListView(
          //       children: DashboardUtils.getEndDrawerListTiles(
          //           context, _mapController),
          //     ),
          //   )),
          // ),

          bottomNavigationBar:
              addBottomToolBar(mapBuilder, projectData, mapState),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Widget getExitTile(BuildContext context, SmashMapBuilder mapBuilder,
      SmashMapState mapState) {
    if (Platform.isIOS) {
      return Consumer<GpsState>(builder: (context, gpsState, child) {
        var gpsStatusIcon = DashboardUtils.getGpsStatusIcon(
            gpsState.status, SmashUI.MEDIUM_ICON_SIZE);
        var gpsIsOff = gpsState.status == GpsStatus.OFF;
        return ListTile(
          leading: gpsStatusIcon,
          title: SmashUI.normalText(
            gpsIsOff ? "Turn GPS on" : "Turn GPS off",
            bold: true,
            color: SmashColors.mainDecorations,
          ),
          onTap: () async {
            if (gpsIsOff) {
              gpsState.status = GpsStatus.ON_NO_FIX;
              await GpsHandler().init(gpsState);
            } else {
              gpsState.status = GpsStatus.OFF;
              await mapState.persistLastPosition();
              await GpsHandler().close();
            }
          },
        );
      });
    } else {
      return ListTile(
        leading: new Icon(
          MdiIcons.exitRun,
          color: SmashColors.mainDecorations,
          size: SmashUI.MEDIUM_ICON_SIZE,
        ),
        title: SmashUI.normalText(
          "Exit",
          bold: true,
          color: SmashColors.mainDecorations,
        ),
        onTap: () async {
          bool doExit = await showConfirmDialog(
              mapBuilder.context,
              "Are you sure you want to close the project?",
              "Active operations will be stopped.");
          if (doExit) {
            await mapState.persistLastPosition();
            await disposeProject(context);
            await GpsHandler().close();
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        },
      );
    }
  }

  List<Widget> addActionBarButtons() {
    return <Widget>[
      IconButton(
          key: coachMarks.coachMarkButtonKey,
          tooltip: "Show interactive coach marks.",
          icon: Icon(MdiIcons.helpCircleOutline),
          onPressed: () {
            coachMarks.showTutorial(context);
          }),
      IconButton(
          key: coachMarks.toolsButtonKey,
          tooltip: "Open tools drawer.",
          icon: Icon(MdiIcons.tools),
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          }),
    ];
  }

  BottomAppBar addBottomToolBar(SmashMapBuilder mapBuilder,
      ProjectData projectData, SmashMapState mapState) {
    return BottomAppBar(
      color: SmashColors.mainDecorations,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DashboardUtils.makeToolbarBadge(
            GestureDetector(
              child: IconButton(
                key: coachMarks.simpleNotesButtonKey,
                onPressed: () async {
                  var gpsState =
                      Provider.of<GpsState>(mapBuilder.context, listen: false);

                  var titleWithMode = Column(
                    children: [
                      SmashUI.titleText("Simple Notes",
                          color: SmashColors.mainSelection, bold: true),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GpsInsertionModeSelector(),
                      ),
                    ],
                  );
                  List<String> types = ["note", "image"];
                  var selectedType = await showComboDialog(
                      mapBuilder.context, titleWithMode, types);
                  var doNoteInGps = gpsState.insertInGps;
                  if (selectedType == types[0]) {
                    Note note = await DataLoaderUtilities.addNote(
                        mapBuilder, doNoteInGps, _mapController);
                    Navigator.push(
                        mapBuilder.context,
                        MaterialPageRoute(
                            builder: (context) => NotePropertiesWidget(note)));
                  } else if (selectedType == types[1]) {
                    DataLoaderUtilities.addImage(
                        mapBuilder.context,
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
                ProjectState projectState =
                    Provider.of<ProjectState>(context, listen: false);
                Navigator.push(
                    mapBuilder.context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotesListWidget(true, projectState.projectDb)));
              },
              onDoubleTap: () async {
                await openNotesViewSettings();
              },
            ),
            projectData != null ? projectData.simpleNotesCount : 0,
          ),
          DashboardUtils.makeToolbarBadge(
            GestureDetector(
              child: IconButton(
                key: coachMarks.formsButtonKey,
                onPressed: () async {
                  var gpsState =
                      Provider.of<GpsState>(mapBuilder.context, listen: false);
                  var doNoteInGps = gpsState.insertInGps;
                  var titleWithMode = Column(
                    children: [
                      SmashUI.titleText("Form Notes",
                          color: SmashColors.mainSelection, bold: true),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GpsInsertionModeSelector(),
                      ),
                    ],
                  );

                  var allSectionsMap = TagsManager().getSectionsMap();
                  List<String> sectionNames = allSectionsMap.keys.toList();
                  List<String> iconNames = [];
                  sectionNames.forEach((key) {
                    var icon4section =
                        TagsManager.getIcon4Section(allSectionsMap[key]);
                    iconNames.add(icon4section);
                  });

                  var selectedSection = await showComboDialog(
                      mapBuilder.context,
                      titleWithMode,
                      sectionNames,
                      iconNames);
                  // refresh mode
                  doNoteInGps = gpsState.insertInGps;
                  if (selectedSection != null) {
                    Widget appbarWidget = getDialogTitleWithInsertionMode(
                        selectedSection,
                        doNoteInGps,
                        SmashColors.mainBackground);

                    var selectedIndex = sectionNames.indexOf(selectedSection);
                    var iconName = iconNames[selectedIndex];
                    var sectionMap = allSectionsMap[selectedSection];
                    var jsonString = jsonEncode(sectionMap);
                    Note note = await DataLoaderUtilities.addNote(
                        mapBuilder, doNoteInGps, _mapController,
                        text: selectedSection,
                        form: jsonString,
                        iconName: iconName,
                        color:
                            ColorExt.asHex(SmashColors.mainDecorationsDarker));

                    Navigator.push(mapBuilder.context, MaterialPageRoute(
                      builder: (context) {
                        return MasterDetailPage(
                          sectionMap,
                          appbarWidget,
                          selectedSection,
                          doNoteInGps
                              ? gpsState.lastGpsPosition
                              : _mapController.center,
                          note.id,
                          SmashFormHelper(),
                        );
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
                ProjectState projectState =
                    Provider.of<ProjectState>(context, listen: false);

                Navigator.push(
                    mapBuilder.context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotesListWidget(false, projectState.projectDb)));
              },
              onDoubleTap: () async {
                await openNotesViewSettings();
              },
            ),
            projectData != null ? projectData.formNotesCount : 0,
          ),
          DashboardUtils.makeToolbarBadge(
            LoggingButton(coachMarks.logsButtonKey, _iconSize),
            projectData != null ? projectData.logsCount : 0,
          ),
          Spacer(),
          GpsInfoButton(coachMarks.gpsButtonKey, _iconSize),
          Spacer(),
          GestureDetector(
            child: IconButton(
              key: coachMarks.layersButtonKey,
              icon: Icon(
                SmashIcons.layersIcon,
                color: SmashColors.mainBackground,
              ),
              iconSize: _iconSize,
              color: SmashColors.mainBackground,
              tooltip: 'Open layers list',
            ),
            onTap: () async {
              await Navigator.push(mapBuilder.context,
                  MaterialPageRoute(builder: (context) => LayersPage()));

              var layers = await LayerManager().loadLayers(context);
              _activeLayers.clear();
              setState(() {
                _activeLayers.addAll(layers);
              });
            },
            onDoubleTap: () async {
              await openPluginsViewSettings();
            },
          ),
          Consumer<SmashMapState>(builder: (context, mapState, child) {
            return DashboardUtils.makeToolbarZoomBadge(
              IconButton(
                key: coachMarks.zoomInButtonKey,
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
            key: coachMarks.zoomOutButtonKey,
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
    );
  }

  Future openNotesViewSettings() async {
    Dialog settingsDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: NotesViewSetting(),
      ),
    );
    await showDialog(
        context: context, builder: (BuildContext context) => settingsDialog);
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

  void addPluginsPreLayers(
      List<MapPlugin> pluginsList, List<LayerOptions> layers) {
    if (PluginsHandler.GRID.isOn()) {
      var gridLayer = MapPluginLatLonGridOptions(
        lineColor: SmashColors.mainDecorations,
        textColor: SmashColors.mainBackground,
        lineWidth: 0.5,
        textBackgroundColor: SmashColors.mainDecorations.withAlpha(170),
        showCardinalDirections: true,
        showCardinalDirectionsAsPrefix: false,
        textSize: 12.0,
        showLabels: true,
        rotateLonLabels: true,
        placeLabelsOnLines: true,
        offsetLonTextBottom: 20.0,
        offsetLatTextLeft: 20.0,
      );
      layers.add(gridLayer);
      pluginsList.add(MapPluginLatLonGrid());
    }
  }

  void addPluginsPostLayers(
      List<MapPlugin> pluginsList, List<LayerOptions> layers) {
    if (PluginsHandler.HEATMAP_WORKING && PluginsHandler.LOG_HEATMAP.isOn()) {
      layers.add(HeatmapPluginOption());
      pluginsList.add(HeatmapPlugin());
    }

    pluginsList.add(MarkerClusterPlugin());

    layers.add(CurrentGpsLogPluginOption(
      logColor: Colors.red,
      logWidth: 5.0,
    ));
    pluginsList.add(CurrentGpsLogPlugin());

    int tapAreaPixels = GpPreferences().getIntSync(KEY_VECTOR_TAPAREA_SIZE, 50);
    layers.add(FeatureInfoPluginOption(
      tapAreaPixelSize: tapAreaPixels.toDouble(),
    ));
    pluginsList.add(FeatureInfoPlugin());

    if (PluginsHandler.GPS.isOn()) {
      layers.add(GpsPositionPluginOption(
        markerColor: Colors.black,
        markerSize: 32,
      ));
      pluginsList.add(GpsPositionPlugin());
    }

    if (PluginsHandler.CROSS.isOn()) {
      var centerCrossStyle = CenterCrossStyle.fromPreferences();
      if (centerCrossStyle.visible) {
        layers.add(CenterCrossPluginOption(
          crossColor: ColorExt(centerCrossStyle.color),
          crossSize: centerCrossStyle.size,
          lineWidth: centerCrossStyle.lineWidth,
        ));
        pluginsList.add(CenterCrossPlugin());
      }
    }

    if (PluginsHandler.SCALE.isOn()) {
      layers.add(ScaleLayerPluginOption(
        lineColor: Colors.black,
        lineWidth: 3,
        textStyle: TextStyle(color: Colors.black, fontSize: 14),
        padding: EdgeInsets.all(10),
      ));
      pluginsList.add(ScaleLayerPlugin());
    }
  }

  ProjectData addProjectMarkers(
      ProjectState projectState, List<LayerOptions> layers) {
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
    return projectData;
  }

  Future disposeProject(BuildContext context) async {
    WidgetsBinding.instance.removeObserver(this);
    _centerOnGpsTimer.cancel();

    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    projectState?.close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }
}

Widget getDialogTitleWithInsertionMode(
    String title, bool doNoteInGps, Color color) {
  return Row(
    children: [
      Expanded(
          child: Padding(
        padding: SmashUI.defaultRigthPadding(),
        child: SmashUI.titleText(title, color: color, bold: true),
      )),
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

class GpsInsertionModeSelector extends StatefulWidget {
  GpsInsertionModeSelector({Key key}) : super(key: key);

  @override
  _GpsInsertionModeSelectorState createState() =>
      _GpsInsertionModeSelectorState();
}

class _GpsInsertionModeSelectorState extends State<GpsInsertionModeSelector> {
  bool _doInGps = true;

  @override
  Widget build(BuildContext context) {
    _doInGps = GpPreferences().getBooleanSync(KEY_DO_NOTE_IN_GPS, true);

    var sel = [_doInGps, !_doInGps];

    return Container(
      child: ToggleButtons(
        color: SmashColors.mainDecorations,
        fillColor: SmashColors.mainSelectionMc[100],
        selectedColor: SmashColors.mainSelection,
        renderBorder: true,
        borderRadius: BorderRadius.circular(15),
        borderWidth: 3,
        borderColor: SmashColors.mainDecorationsDarker,
        selectedBorderColor: SmashColors.mainSelection,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmashUI.smallText("GPS", bold: true),
                Icon(SmashIcons.locationIcon),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(MdiIcons.imageFilterCenterFocus),
                SmashUI.smallText("Map Center", bold: true),
              ],
            ),
          ),
        ],
        isSelected: sel,
        onPressed: (index) async {
          print("${sel[0]}   ${sel[1]}");
          var doGps = !sel[0];
          var gpsState = Provider.of<GpsState>(context, listen: false);
          gpsState.insertInGpsQuiet = doGps;

          await GpPreferences().setBoolean(KEY_DO_NOTE_IN_GPS, doGps);

          setState(() {});
        },
      ),
    );
  }
}
