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
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersview.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/current_log_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/fences_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/gps_position_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/util/coachmarks.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_info_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_log_button.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:lat_lon_grid_plugin/lat_lon_grid_plugin.dart';
import 'mainview_utils.dart';

class MainViewWidget extends StatefulWidget {
  MainViewWidget({Key? key}) : super(key: key);

  @override
  MainViewWidgetState createState() => new MainViewWidgetState();
}

enum IconMode { NAVIGATION_MODE, TOOL_MODE }

class MainViewWidgetState extends State<MainViewWidget>
    with WidgetsBindingObserver, AfterLayoutMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainViewCoachMarks coachMarks = MainViewCoachMarks();

  double? _iconSize;

  Timer? _centerOnGpsTimer;

  IconMode _iconMode = IconMode.NAVIGATION_MODE;

  late SmashMapWidget mapView;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    ScreenUtilities.keepScreenOn(GpPreferences().getKeepScreenOn() ?? false);

    SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);

    // create the map widget instance
    mapView = SmashMapWidget();
    mapView.setInitParameters(
      canRotate: EXPERIMENTAL_ROTATION__ENABLED,
      initZoom: mapState.zoom > 0 ? mapState.zoom : 1,
      centerCoordinate: mapState.center,
    );

    mapView.setTapHandlers(
      handleTap: (ll, zoom) async {
        await GeometryEditManager().onMapTap(context, ll);
      },
      handleLongTap: (ll, zoom) {
        GeometryEditManager().onMapLongTap(context, ll, zoom.round());
      },
    );

    mapView.setOnPositionChanged((newPosition, hasGest) {
      mapState.setLastPositionQuiet(
          LatLngExt.fromLatLng(newPosition.center!).toCoordinate(),
          newPosition.zoom!);
    });

    mapState.mapView = mapView;

    int noteInGpsMode = GpPreferences()
            .getIntSync(KEY_DO_NOTE_IN_GPS, POINT_INSERTION_MODE_GPS) ??
        POINT_INSERTION_MODE_GPS;
    gpsState.insertInGpsQuiet = noteInGpsMode;

    // check center on gps
    bool centerOnGps = GpPreferences().getCenterOnGps() ?? false;
    mapState.centerOnGpsQuiet = centerOnGps;
    // check rotate on heading
    bool rotateOnHeading = GpPreferences().getRotateOnHeading() ?? false;
    mapState.rotateOnHeadingQuiet = rotateOnHeading;

    // set initial status
    bool gpsIsOn = GpsHandler().isGpsOn();
    if (gpsIsOn) {
      gpsState.statusQuiet = GpsStatus.ON_NO_FIX;
    }

    coachMarks.initCoachMarks();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    SmashMapBuilder mapBuilder =
        Provider.of<SmashMapBuilder>(context, listen: false);

    // ! TODO check
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      mapBuilder.context = context;
      projectState.reloadProject(context);

      // _activeLayers.clear();
      // var layers = await LayerManager().loadLayers(context);
      // var layers = await LayerManager().getActiveLayers();
      // setState(() {
      //   _activeLayers.addAll(layers);
      // });
    });

    _centerOnGpsTimer =
        Timer.periodic(Duration(milliseconds: 3000), (timer) async {
      if (context.mounted) {
        var mapState = Provider.of<SmashMapState>(context, listen: false);
        if (mapState.centerOnGps) {
          GpsState gpsState = Provider.of<GpsState>(context, listen: false);
          if (gpsState.lastGpsPosition != null) {
            LatLng posLL;
            if (gpsState.useFilteredGps) {
              posLL = LatLng(gpsState.lastGpsPosition!.filteredLatitude,
                  gpsState.lastGpsPosition!.filteredLongitude);
            } else {
              posLL = LatLng(gpsState.lastGpsPosition!.latitude,
                  gpsState.lastGpsPosition!.longitude);
            }
            var bb = mapView.getBounds();
            var doCenter = true;
            if (bb != null) {
              var n = bb.getMaxY();
              var s = bb.getMinY();
              var e = bb.getMaxX();
              var w = bb.getMinX();

              var deltaX = bb.getWidth() / 4;
              var deltaY = bb.getHeight() / 4;
              n -= deltaY;
              s += deltaY;
              e -= deltaX;
              w += deltaX;

              if (posLL.latitude > s &&
                  posLL.latitude < n &&
                  posLL.longitude > w &&
                  posLL.longitude < e) {
                doCenter = false;
              }
            }
            if (doCenter) {
              mapView.centerOn(LatLngExt.fromLatLng(posLL).toCoordinate());
            }
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
    return Consumer<PreferencesState>(builder: (context, prefsState, child) {
      _iconSize = prefsState.iconSize;
      return Consumer<SmashMapBuilder>(builder: (context, mapBuilder, child) {
        mapBuilder.context = context;
        mapBuilder.scaffoldKey = _scaffoldKey;
        return consumeBuild(mapBuilder, prefsState);
      });
    });
  }

  Widget consumeBuild(SmashMapBuilder mapBuilder, PreferencesState prefsState) {
    var width = ScreenUtilities.getWidth(context);
    // check if the 7 icons would fit and give a max icon size
    var maxIconSize = width / 12;
    if (_iconSize! > maxIconSize) {
      _iconSize = maxIconSize;
    }

    var projectState =
        Provider.of<ProjectState>(mapBuilder.context!, listen: false);
    var mapState =
        Provider.of<SmashMapState>(mapBuilder.context!, listen: false);

    mapView.clearLayers();

    if (EXPERIMENTAL_ROTATION__ENABLED && mapView.isMapReady()) {
      // check map centering and rotation
      try {
        if (mapState.rotateOnHeading) {
          GpsState gpsState = Provider.of<GpsState>(context, listen: false);
          var heading = gpsState.lastGpsPosition!.heading;
          if (heading < 0) {
            heading = 360 + heading;
          }
          mapView.rotate(-heading);
        } else {
          mapView.rotate(0);
        }
      } on Exception catch (e, s) {
        SMLogger().e("Error in experimental", e, s);
      }
    }

    // ! TODO check
    // // check if layers have been reloaded from another section
    // // and in case use those
    // var oneShotUpdateLayers = mapBuilder.oneShotUpdateLayers;
    // if (oneShotUpdateLayers != null) {
    //   _activeLayers = oneShotUpdateLayers;
    // }
    // layers.addAll(_activeLayers);

    ProjectData? projectData = addProjectMarkers(projectState);
    addPluginsPreLayers();
    addPluginsPostLayers();

    // GeometryEditorState editorState =
    //     Provider.of<GeometryEditorState>(context, listen: false);
    // if (editorState.isEnabled) {
    //   GeometryEditManager().startEditing(editorState.editableGeometry, () {
    //     setState(() {});
    //   });

    //   GeometryEditManager().addEditLayers(layers);
    // }

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
              mapView,
              mapBuilder.inProgress
                  ? Center(
                      child: SmashCircularProgress(
                        label: SL
                            .of(context)
                            .mainView_loadingData, //"Loading data...",
                      ),
                    )
                  : Container(),
              if (prefsState.showEditingButton && prefsState.showZoomButton)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeEditButton(prefsState),
                    )),
              if (_iconMode != IconMode.NAVIGATION_MODE)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SmashToolsBar(_iconSize),
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
                    children: DashboardUtils.getDrawerTilesList(context)
                      ..add(
                        getExitTile(context, mapBuilder, mapState),
                      )),
              ),
            ],
          )),
          endDrawer: Drawer(
              child: ListView(
            children: DashboardUtils.getEndDrawerListTiles(context),
          )),
          bottomNavigationBar: addBottomNavigationBar(
              mapBuilder, projectData, mapState, prefsState),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  Widget getExitTile(BuildContext context, SmashMapBuilder mapBuilder,
      SmashMapState mapState) {
    if (Platform.isIOS) {
      return Consumer<GpsState>(builder: (context, gpsState, child) {
        ProjectState projectState =
            Provider.of<ProjectState>(context, listen: false);

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
              await GpsHandler().init(gpsState, projectState);

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
                  mapBuilder.context!,
                  SL
                      .of(context)
                      .mainView_areYouSureCloseTheProject, //"Are you sure you want to close the project?",
                  SL
                      .of(context)
                      .mainView_activeOperationsWillBeStopped) //"Active operations will be stopped.",);
              ??
              false;
          if (doExit) {
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
            _scaffoldKey.currentState?.openEndDrawer();
          }),
    ];
  }

  BottomAppBar addBottomNavigationBar(
      SmashMapBuilder mapBuilder,
      ProjectData? projectData,
      SmashMapState mapState,
      PreferencesState prefsState) {
    return BottomAppBar(
      color: SmashColors.mainDecorations,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (prefsState.showAddNoteButton)
            makeSimpleNoteButton(mapBuilder, projectData),
          if (prefsState.showAddFormNoteButton)
            makeFormNotesButton(mapBuilder, projectData),
          if (prefsState.showAddLogButton)
            DashboardUtils.makeToolbarBadge(
              LoggingButton(coachMarks.logsButtonKey, _iconSize!),
              projectData != null ? projectData.logsCount! : 0,
              iconSize: _iconSize,
            ),
          Spacer(),
          if (prefsState.showGpsInfoButton)
            GpsInfoButton(coachMarks.gpsButtonKey, _iconSize!),
          Spacer(),
          if (prefsState.showLayerButton) makeLayersButton(mapBuilder),
          if (prefsState.showZoomButton)
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
          if (prefsState.showZoomButton)
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
          if (prefsState.showEditingButton && !prefsState.showZoomButton)
            makeEditButton(prefsState)
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
        await Navigator.push(mapBuilder.context!,
            MaterialPageRoute(builder: (context) => LayersPage()));

        Provider.of<SmashMapBuilder>(context, listen: false).reBuild();
        // ! TODO
        // var layers = await LayerManager().loadLayers(context);
        // _activeLayers.clear();
        // setState(() {
        //   _activeLayers.addAll(layers);
        // });
      },
    );
  }

  Widget makeEditButton(PreferencesState prefsState) {
    return Container(
      decoration: BoxDecoration(
        color: SmashColors.mainDecorations,
        border: Border.all(
          color: SmashColors.mainDecorations,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(_iconSize!),
      ),
      child: _iconMode == IconMode.NAVIGATION_MODE
          ? InkWell(
              key: coachMarks.toolbarButtonKey,
              child: Icon(
                MdiIcons.pencilCircleOutline,
                color: SmashColors.mainBackground,
                size: _iconSize,
              ),
              onTap: () {
                setState(() {
                  _iconMode = IconMode.TOOL_MODE;
                });
              },
            )
          : InkWell(
              child: Icon(
                MdiIcons.pencilCircleOutline,
                color: SmashColors.mainSelection,
                size: _iconSize,
              ),
              onTap: () {
                BottomToolbarToolsRegistry.disableAll(context);
                setState(() {
                  _iconMode = IconMode.NAVIGATION_MODE;
                });
              },
            ),
    );
  }

  Widget makeFormNotesButton(
      SmashMapBuilder mapBuilder, ProjectData? projectData) {
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
              Provider.of<GpsState>(mapBuilder.context!, listen: false);
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

          var tm = TagsManager();
          await tm.readTags();
          var tags = tm.getTags();
          List<SmashSection> section = tags.getSections();
          List<String> iconNames = [];
          section.forEach((section) {
            iconNames.add(section.getIcon());
          });

          var sectionNames = tags.getSectionNames();
          var selectedSectionName = await SmashDialogs.showComboDialog(
              mapBuilder.context!, titleWithMode, sectionNames,
              iconNames: iconNames);
          // refresh mode
          noteInGpsMode = gpsState.insertInGpsMode;
          if (selectedSectionName != null) {
            Widget appbarWidget = getDialogTitleWithInsertionMode(
                selectedSectionName, noteInGpsMode, SmashColors.mainBackground);

            var selectSection = tags.getSectionByName(selectedSectionName);
            Note note = DataLoaderUtilities.addNote(
                mapBuilder, noteInGpsMode, mapView.getBounds()!.centre()!,
                text: selectedSectionName,
                form: selectSection?.toJson(),
                iconName: selectSection?.getIcon(),
                color: ColorExt.asHex(SmashColors.mainDecorationsDarker));

            var position = noteInGpsMode == POINT_INSERTION_MODE_GPS
                ? gpsState.lastGpsPosition
                : mapView.getBounds()!.centre()!;
            var formHelper = SmashFormHelper(note.id!, selectedSectionName,
                selectSection!, appbarWidget, position);

            Navigator.push(mapBuilder.context!, MaterialPageRoute(
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
              mapBuilder.context!,
              MaterialPageRoute(
                  builder: (context) =>
                      NotesListWidget(false, projectState.projectDb!)));
        },
      ),
      projectData != null ? projectData.formNotesCount! : 0,
      iconSize: _iconSize,
    );
  }

  Widget makeSimpleNoteButton(
      SmashMapBuilder mapBuilder, ProjectData? projectData) {
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
              Provider.of<GpsState>(mapBuilder.context!, listen: false);

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
              mapBuilder.context!, titleWithMode, types);
          var noteInGpsMode = gpsState.insertInGpsMode;
          if (selectedType != null) {
            if (selectedType == types[0]) {
              Note note = DataLoaderUtilities.addNote(
                  mapBuilder, noteInGpsMode, mapView.getBounds()!.centre()!);
              await Navigator.push(
                  mapBuilder.context!,
                  MaterialPageRoute(
                      builder: (context) => NotePropertiesWidget(note)));
            } else if (selectedType == types[1]) {
              await DataLoaderUtilities.addImage(
                  mapBuilder.context!,
                  noteInGpsMode == POINT_INSERTION_MODE_GPS
                      ? gpsState.lastGpsPosition
                      : mapView.getBounds()!.centre()!,
                  gpsState.useFilteredGps);
              ProjectState projectState =
                  Provider.of<ProjectState>(context, listen: false);
              projectState.reloadProject(context);
            }
          }
        },
        onLongPress: () {
          ProjectState projectState =
              Provider.of<ProjectState>(context, listen: false);
          Navigator.push(
              mapBuilder.context!,
              MaterialPageRoute(
                  builder: (context) =>
                      NotesListWidget(true, projectState.projectDb!)));
        },
      ),
      projectData != null ? projectData.simpleNotesCount! : 0,
      iconSize: _iconSize,
    );
  }

  ProjectData? addProjectMarkers(ProjectState projectState) {
    var projectData = projectState.projectData;
    if (projectData != null) {
      if (projectData.geopapLogs != null)
        mapView.addPostLayer(projectData.geopapLogs!);
      if (projectData.geopapMarkers != null) {
        mapView.addPostLayer(projectData.geopapMarkers!);
      }
    }
    return projectData;
  }

  void addPluginsPreLayers() {
    if (PluginsHandler.FENCE.isOn()) {
      mapView.addPostLayer(FencesLayer());
    }
    if (PluginsHandler.GRID.isOn()) {
      var gridLayer = LatLonGridLayer(
          key: ValueKey("SMASH_LATLONGRIDLAYER"),
          options: LatLonGridLayerOptions(
            labelStyle: TextStyle(
              color: SmashColors.mainBackground,
              backgroundColor: SmashColors.mainDecorations.withAlpha(170),
              fontSize: 16.0,
            ),
            lineColor: SmashColors.mainDecorations,
            lineWidth: 0.5,
            showCardinalDirections: true,
            showCardinalDirectionsAsPrefix: false,
            showLabels: true,
            rotateLonLabels: true,
            placeLabelsOnLines: true,
            offsetLonLabelsBottom: 20.0,
            offsetLatLabelsLeft: 20.0,
          ));
      mapView.addPostLayer(gridLayer);
    }
  }

  void addPluginsPostLayers() {
    // if (PluginsHandler.HEATMAP_WORKING && PluginsHandler.LOG_HEATMAP.isOn()) {
    //   layers.add(HeatmapPluginOption());
    // }

    mapView.addPostLayer(CurrentGpsLogLayer(
      logColor: Colors.red,
      logWidth: 5.0,
    ));

    int tapAreaPixels = GpPreferences()
            .getIntSync(SmashPreferencesKeys.KEY_VECTOR_TAPAREA_SIZE, 50) ??
        50;
    mapView.addPostLayer(FeatureInfoLayer(
      tapAreaPixelSize: tapAreaPixels.toDouble(),
    ));

    if (PluginsHandler.GPS.isOn()) {
      mapView.addPostLayer(GpsPositionLayer(
        markerColor: Colors.black,
        markerSize: 32,
      ));
    }

    if (PluginsHandler.CROSS.isOn()) {
      var centerCrossStyle = CenterCrossStyle.fromPreferences();
      if (centerCrossStyle.visible) {
        mapView.addPostLayer(CenterCrossLayer(
          crossColor: ColorExt(centerCrossStyle.color),
          crossSize: centerCrossStyle.size,
          lineWidth: centerCrossStyle.lineWidth,
        ));
      }
    }

    if (PluginsHandler.SCALE.isOn()) {
      mapView.addPostLayer(ScaleLayer(
        key: ValueKey("SMASH_SCALELAYER"),
        lineColor: Colors.black,
        lineWidth: 3,
        textStyle: TextStyle(color: Colors.black, fontSize: 14),
        padding: EdgeInsets.all(10),
      ));
    }

    mapView.addPostLayer(RulerPluginLayer(tapAreaPixelSize: 1));
  }

  Future disposeProject(BuildContext context) async {
    WidgetsBinding.instance.removeObserver(this);
    _centerOnGpsTimer?.cancel();

    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    projectState.close();

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
  GpsInsertionModeSelector({Key? key}) : super(key: key);

  @override
  _GpsInsertionModeSelectorState createState() =>
      _GpsInsertionModeSelectorState();
}

class _GpsInsertionModeSelectorState extends State<GpsInsertionModeSelector> {
  int _mode = POINT_INSERTION_MODE_GPS;

  @override
  Widget build(BuildContext context) {
    _mode = GpPreferences()
            .getIntSync(KEY_DO_NOTE_IN_GPS, POINT_INSERTION_MODE_GPS) ??
        POINT_INSERTION_MODE_GPS;

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
