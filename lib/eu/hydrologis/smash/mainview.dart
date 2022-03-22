/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:lat_lon_grid_plugin/lat_lon_grid_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersview.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/current_log_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/feature_info_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/fences_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/gps_position_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/heatmap.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/pluginshandler.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/ruler_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/scale_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/tools.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/util/coachmarks.dart';
import 'package:smash/eu/hydrologis/smash/util/experimentals.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_info_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_log_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/image_widgets.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/toolbar_tools.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

import 'mainview_utils.dart';

class MainViewWidget extends StatefulWidget {
  MainViewWidget({Key key}) : super(key: key);

  @override
  MainViewWidgetState createState() => new MainViewWidgetState();
}

enum IconMode { NAVIGATION_MODE, TOOL_MODE }

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

  IconMode _iconMode = IconMode.NAVIGATION_MODE;

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

    int noteInGpsMode = GpPreferences()
        .getIntSync(KEY_DO_NOTE_IN_GPS, POINT_INSERTION_MODE_GPS);
    gpsState.insertInGpsQuiet = noteInGpsMode;

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
      projectState.reloadProject(context);

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
            LatLng posLL;
            if (gpsState.useFilteredGps) {
              posLL = LatLng(gpsState.lastGpsPosition.filteredLatitude,
                  gpsState.lastGpsPosition.filteredLongitude);
            } else {
              posLL = LatLng(gpsState.lastGpsPosition.latitude,
                  gpsState.lastGpsPosition.longitude);
            }
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
    return Consumer<SmashMapBuilder>(builder: (context, mapBuilder, child) {
      mapBuilder.context = context;
      mapBuilder.scaffoldKey = _scaffoldKey;
      return consumeBuild(mapBuilder);
    });
  }

  WillPopScope consumeBuild(SmashMapBuilder mapBuilder) {
    var layers = <LayerOptions>[];
    _iconSize = GpPreferences().getDoubleSync(
        SmashPreferencesKeys.KEY_MAPTOOLS_ICON_SIZE, SmashUI.MEDIUM_ICON_SIZE);
    var projectState =
        Provider.of<ProjectState>(mapBuilder.context, listen: false);
    var mapState =
        Provider.of<SmashMapState>(mapBuilder.context, listen: false);

    if (_mapController != null) {
      //&& _mapController.ready) {
      if (EXPERIMENTAL_ROTATION__ENABLED) {
        // check map centering and rotation
        try {
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
        } on Exception catch (e, s) {
          SMLogger().e("Error in experimental", e, s);
        }
      }
    }
    // check if layers have been reloaded from another section
    // and in case use those
    var oneShotUpdateLayers = mapBuilder.oneShotUpdateLayers;
    if (oneShotUpdateLayers != null) {
      _activeLayers = oneShotUpdateLayers;
    }
    layers.addAll(_activeLayers);

    var pluginsList = <MapPlugin>[];
    addPluginsPreLayers(pluginsList, layers);
    ProjectData projectData = addProjectMarkers(projectState, layers);
    addPluginsPostLayers(pluginsList, layers);

    GeometryEditorState editorState =
        Provider.of<GeometryEditorState>(context, listen: false);
    if (editorState.isEnabled) {
      GeometryEditManager().startEditing(editorState.editableGeometry, () {
        setState(() {});
      });

      GeometryEditManager().addEditPlugins(pluginsList);
      GeometryEditManager().addEditLayers(layers);
    }

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
                  allowPanningOnScrollingParent: false,
                  onTap: _handleTap,
                  onLongPress: _handleLongTap,
                  interactiveFlags: InteractiveFlag.all &
                      ~InteractiveFlag.flingAnimation &
                      ~InteractiveFlag.pinchMove &
                      ~InteractiveFlag.rotate,
                ),
                layers: layers,
                mapController: _mapController,
              ),
              mapBuilder.inProgress
                  ? Center(
                      child: SmashCircularProgress(
                        label: SL
                            .of(context)
                            .mainView_loadingData, //"Loading data...",
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.bottomRight,
                child: _iconMode == IconMode.NAVIGATION_MODE
                    ? IconButton(
                        key: coachMarks.toolbarButtonKey,
                        icon: Icon(
                          MdiIcons.forwardburger,
                          color: SmashColors.mainDecorations,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _iconMode = IconMode.TOOL_MODE;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          MdiIcons.backburger,
                          color: SmashColors.mainDecorations,
                          size: 32,
                        ),
                        onPressed: () {
                          BottomToolbarToolsRegistry.disableAll(context);
                          setState(() {
                            _iconMode = IconMode.NAVIGATION_MODE;
                          });
                        },
                      ),
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

          bottomNavigationBar: _iconMode == IconMode.NAVIGATION_MODE
              ? addBottomNavigationBar(mapBuilder, projectData, mapState)
              : BottomToolsBar(_iconSize),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Future<void> _handleTap(TapPosition tapPosition, LatLng latlng) async {
    if (_iconMode == IconMode.NAVIGATION_MODE) {
      // just center on the tapped position
      _mapController.move(latlng, _mapController.zoom);
    } else {
      await GeometryEditManager().onMapTap(context, latlng);
    }
  }

  void _handleLongTap(TapPosition tapPosition, LatLng latlng) {
    GeometryEditManager()
        .onMapLongTap(context, latlng, _mapController.zoom.round());
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
            gpsIsOff
                ? SL.of(context).mainView_turnGpsOn //"Turn GPS on"
                : SL.of(context).mainView_turnGpsOff, //"Turn GPS off",
            bold: true,
            color: SmashColors.mainDecorations,
          ),
          onTap: () async {
            await FenceMaster().writeFences();
            if (gpsIsOff) {
              gpsState.status = GpsStatus.ON_NO_FIX;
              await GpsHandler().init(gpsState);

              await GpPreferences()
                  .setBoolean(GpsHandler.GPS_FORCED_OFF_KEY, false);
            } else {
              gpsState.status = GpsStatus.OFF;
              await mapState.persistLastPosition();

              await GpPreferences()
                  .setBoolean(GpsHandler.GPS_FORCED_OFF_KEY, true);
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
          SL.of(context).mainView_exit, //"Exit",
          bold: true,
          color: SmashColors.mainDecorations,
        ),
        onTap: () async {
          bool doExit = await SmashDialogs.showConfirmDialog(
              mapBuilder.context,
              SL
                  .of(context)
                  .mainView_areYouSureCloseTheProject, //"Are you sure you want to close the project?",
              SL
                  .of(context)
                  .mainView_activeOperationsWillBeStopped); //"Active operations will be stopped.",);
          if (doExit != null && doExit) {
            await FenceMaster().writeFences();
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
          tooltip: SL
              .of(context)
              .mainView_showInteractiveCoachMarks, //"Show interactive coach marks.",
          icon: Icon(MdiIcons.helpCircleOutline),
          onPressed: () {
            coachMarks.showTutorial(context);
          }),
      IconButton(
          key: coachMarks.toolsButtonKey,
          tooltip:
              SL.of(context).mainView_openToolsDrawer, //"Open tools drawer.",
          icon: Icon(MdiIcons.tools),
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          }),
    ];
  }

  BottomAppBar addBottomNavigationBar(SmashMapBuilder mapBuilder,
      ProjectData projectData, SmashMapState mapState) {
    return BottomAppBar(
      color: SmashColors.mainDecorations,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          makeSimpleNoteButton(mapBuilder, projectData),
          makeFormNotesButton(mapBuilder, projectData),
          DashboardUtils.makeToolbarBadge(
            LoggingButton(coachMarks.logsButtonKey, _iconSize),
            projectData != null ? projectData.logsCount : 0,
            iconSize: _iconSize,
          ),
          Spacer(),
          GpsInfoButton(coachMarks.gpsButtonKey, _iconSize),
          Spacer(),
          makeLayersButton(mapBuilder),
          Consumer<SmashMapState>(builder: (context, mapState, child) {
            return DashboardUtils.makeToolbarZoomBadge(
              IconButton(
                key: coachMarks.zoomInButtonKey,
                onPressed: () {
                  mapState.zoomIn();
                },
                tooltip: SL.of(context).mainView_zoomIn, //'Zoom in',
                icon: Icon(
                  SmashIcons.zoomInIcon,
                  color: SmashColors.mainBackground,
                ),
                iconSize: _iconSize,
              ),
              mapState.zoom.toInt(),
              iconSize: _iconSize,
            );
          }),
          IconButton(
            key: coachMarks.zoomOutButtonKey,
            onPressed: () {
              mapState.zoomOut();
            },
            tooltip: SL.of(context).mainView_zoomOut, //'Zoom out',
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

  GestureDetector makeLayersButton(SmashMapBuilder mapBuilder) {
    return GestureDetector(
      child: Padding(
        padding: SmashUI.defaultPadding(),
        child: InkWell(
          key: coachMarks.layersButtonKey,
          child: Icon(
            SmashIcons.layersIcon,
            color: SmashColors.mainBackground,
            size: _iconSize,
          ),
          // tooltip: 'Open layers list',
        ),
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
    );
  }

  Widget makeFormNotesButton(
      SmashMapBuilder mapBuilder, ProjectData projectData) {
    return DashboardUtils.makeToolbarBadge(
      GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            key: coachMarks.formsButtonKey,
            child: Icon(
              SmashIcons.formNotesIcon,
              color: SmashColors.mainBackground,
              size: _iconSize,
            ),
          ),
        ),
        onTap: () async {
          var gpsState =
              Provider.of<GpsState>(mapBuilder.context, listen: false);
          var noteInGpsMode = gpsState.insertInGpsMode;
          var titleWithMode = Column(
            children: [
              SmashUI.titleText(
                  SL.of(context).mainView_formNotes, //"Form Notes",
                  color: SmashColors.mainSelection,
                  bold: true),
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
            var icon4section = TagsManager.getIcon4Section(allSectionsMap[key]);
            iconNames.add(icon4section);
          });

          var selectedSection = await SmashDialogs.showComboDialog(
              mapBuilder.context, titleWithMode, sectionNames,
              iconNames: iconNames);
          // refresh mode
          noteInGpsMode = gpsState.insertInGpsMode;
          if (selectedSection != null) {
            Widget appbarWidget = getDialogTitleWithInsertionMode(
                selectedSection, noteInGpsMode, SmashColors.mainBackground);

            var selectedIndex = sectionNames.indexOf(selectedSection);
            var iconName = iconNames[selectedIndex];
            var sectionMap = allSectionsMap[selectedSection];
            var jsonString = jsonEncode(sectionMap);
            Note note = DataLoaderUtilities.addNote(
                mapBuilder, noteInGpsMode, _mapController,
                text: selectedSection,
                form: jsonString,
                iconName: iconName,
                color: ColorExt.asHex(SmashColors.mainDecorationsDarker));

            var position = noteInGpsMode == POINT_INSERTION_MODE_GPS
                ? gpsState.lastGpsPosition
                : _mapController.center;
            var formHelper = SmashFormHelper(
                note.id, selectedSection, sectionMap, appbarWidget, position);

            Navigator.push(mapBuilder.context, MaterialPageRoute(
              builder: (context) {
                return MasterDetailPage(formHelper);
              },
            ));
          }
        },
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
      iconSize: _iconSize,
    );
  }

  Widget makeSimpleNoteButton(
      SmashMapBuilder mapBuilder, ProjectData projectData) {
    return DashboardUtils.makeToolbarBadge(
      GestureDetector(
        child: InkWell(
          key: coachMarks.simpleNotesButtonKey,
          child: Padding(
            padding: SmashUI.defaultPadding(),
            child: Icon(
              SmashIcons.simpleNotesIcon,
              color: SmashColors.mainBackground,
              size: _iconSize,
            ),
          ),
        ),
        onTap: () async {
          var gpsState =
              Provider.of<GpsState>(mapBuilder.context, listen: false);

          var titleWithMode = Column(
            children: [
              SmashUI.titleText(
                  SL.of(context).mainView_simpleNotes, //"Simple Notes",
                  color: SmashColors.mainSelection,
                  bold: true),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GpsInsertionModeSelector(),
              ),
            ],
          );
          List<String> types = ["note"];
          if (!SmashPlatform.isDesktop()) {
            types.add("image");
          }
          var selectedType = await SmashDialogs.showComboDialog(
              mapBuilder.context, titleWithMode, types);
          var noteInGpsMode = gpsState.insertInGpsMode;
          if (selectedType == types[0]) {
            Note note = DataLoaderUtilities.addNote(
                mapBuilder, noteInGpsMode, _mapController);
            await Navigator.push(
                mapBuilder.context,
                MaterialPageRoute(
                    builder: (context) => NotePropertiesWidget(note)));
          } else if (selectedType == types[1]) {
            await DataLoaderUtilities.addImage(
                mapBuilder.context,
                noteInGpsMode == POINT_INSERTION_MODE_GPS
                    ? gpsState.lastGpsPosition
                    : _mapController.center,
                gpsState.useFilteredGps);
            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.reloadProject(context);
          }
        },
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
      iconSize: _iconSize,
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
    if (PluginsHandler.FENCE.isOn()) {
      layers.add(FencesPluginOption());
      pluginsList.add(FencesPlugin());
    }
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

    int tapAreaPixels = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_VECTOR_TAPAREA_SIZE, 50);
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

    layers.add(RulerPluginOptions(tapAreaPixelSize: 1));
    pluginsList.add(RulerPlugin());
  }

  ProjectData addProjectMarkers(
      ProjectState projectState, List<LayerOptions> layers) {
    var projectData = projectState.projectData;
    if (projectData != null) {
      if (projectData.geopapLogs != null) layers.add(projectData.geopapLogs);
      if (projectData.geopapMarkers != null &&
          projectData.geopapMarkers.length > 0) {
        var markerCluster = MarkerClusterLayerOptions(
          zoomToBoundsOnClick: true,
          // spiderfyCircleRadius: 150,
          disableClusteringAtZoom: 16,
          maxClusterRadius: 80,
          //        height: 40,
          //        width: 40,
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(180),
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
    String title, int noteInGpsMode, Color color) {
  return Row(
    children: [
      Expanded(
          child: Padding(
        padding: SmashUI.defaultRigthPadding(),
        child: SmashUI.titleText(title, color: color, bold: true),
      )),
      noteInGpsMode == POINT_INSERTION_MODE_GPS
          ? Icon(
              MdiIcons.crosshairsGps,
              color: color,
            )
          : Icon(
              MdiIcons.imageFilterCenterFocus,
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
  int _mode = POINT_INSERTION_MODE_GPS;

  @override
  Widget build(BuildContext context) {
    _mode = GpPreferences()
        .getIntSync(KEY_DO_NOTE_IN_GPS, POINT_INSERTION_MODE_GPS);

    var gpsState = Provider.of<GpsState>(context, listen: false);

    if (!gpsState.hasFix()) {
      _mode = POINT_INSERTION_MODE_MAPCENTER;
      gpsState.insertInGpsQuiet = _mode;
    }

    List<bool> sel = [];

    List<Widget> buttons = [];
    if (gpsState.hasFix()) {
      buttons.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Tooltip(
            message: "Enter note in GPS position.",
            child: Icon(SmashIcons.locationIcon)),
      ));
      sel.add(_mode == POINT_INSERTION_MODE_GPS);
    }
    buttons.add(Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Tooltip(
          message: "Enter note in the map center.",
          child: Icon(MdiIcons.imageFilterCenterFocus)),
    ));
    sel.add(_mode == POINT_INSERTION_MODE_MAPCENTER);

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
        children: buttons,
        isSelected: sel,
        onPressed: !gpsState.hasFix()
            ? null
            : (index) async {
                int selMode;
                if (index == 0) {
                  selMode = POINT_INSERTION_MODE_GPS;
                } else {
                  //if (index == 1) {
                  selMode = POINT_INSERTION_MODE_MAPCENTER;
                }
                var gpsState = Provider.of<GpsState>(context, listen: false);
                gpsState.insertInGpsQuiet = selMode;

                await GpPreferences().setInt(KEY_DO_NOTE_IN_GPS, selMode);
                _mode = selMode;
                setState(() {});
              },
      ),
    );
  }
}
