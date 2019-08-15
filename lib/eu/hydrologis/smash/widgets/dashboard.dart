/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';
import 'package:path/path.dart';
import 'package:popup_menu/popup_menu.dart';
import 'dashboard_utils.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => new _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget>
    with WidgetsBindingObserver
    implements PositionListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MainEventHandler _mainEventsHandler;

  _DashboardWidgetState() {
    _mainEventsHandler = MainEventHandler(reloadLayers, reloadProject, moveTo);
  }

  List<Marker> _geopapMarkers;
  PolylineLayerOptions _geopapLogs;
  Polyline _currentGeopapLog =
      Polyline(points: [], strokeWidth: 3, color: ColorExt("red"));
  Position _lastPosition;

  double _initLon;
  double _initLat;
  double _initZoom;
  double _currentZoom;

  MapController _mapController;

  List<LayerOptions> _activeLayers = [];

  Size _media;

  String _projectName = "No project loaded";
  String _projectDirName;
  int _simpleNotesCount = 0;
  int _formNotesCount = 0;
  int _logsCount = 0;

  @override
  void initState() {
    var gpProject = GPProject();
    _initLon = gpProject.lastCenterLon;
    _initLat = gpProject.lastCenterLat;
    _initZoom = gpProject.lastCenterZoom;
    _currentZoom = _initZoom;
    _mapController = MapController();

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentZoom != _mapController.zoom) {
        setState(() {
          _currentZoom = _mapController.zoom;
        });
      }
    });

    _mainEventsHandler.addInsertInGpsPositionListener(() {
      bool doNoteInGps = _mainEventsHandler.getInsertInGps();
      GpPreferences().setBoolean(KEY_DO_NOTE_IN_GPS, doNoteInGps);
    });
    _mainEventsHandler.addMapCenterListener(() {
      var newMapCenter = _mainEventsHandler.getMapCenter();
      if (newMapCenter != null) {
        _mapController.move(newMapCenter, _mapController.zoom);
      }
    });

    Future.delayed(Duration(seconds: 0), () async {
      var directory = await Workspace.getConfigurationFolder();
      bool init = await GpLogger().init(directory.path); // init logger
      if (init) GpLogger().d("Db logger initialized.");

      ScreenUtilities.keepScreenOn(await GpPreferences().getKeepScreenOn());

      bool doNoteInGps =
          await GpPreferences().getBoolean(KEY_DO_NOTE_IN_GPS, true);
      _mainEventsHandler.setInsertInGps(doNoteInGps);

      // start gps listening
      GpsHandler().addPositionListener(this);

      // check center on gps
      bool centerOnGps = await GpPreferences().getCenterOnGps();
      _mainEventsHandler.setCenterOnGpsStream(centerOnGps);

      bool rotateOnHeading = await GpPreferences().getRotateOnHeading();
      _mainEventsHandler.setRotateOnHeading(rotateOnHeading);

      // set initial status
      bool gpsIsOn = await GpsHandler().isGpsOn();
      if (gpsIsOn != null) {
        if (gpsIsOn) {
          _mainEventsHandler.setGpsStatus(GpsStatus.ON_NO_FIX);
        }
      }

      await _loadCurrentProject();
      await reloadLayers();
    });

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  _showSnackbar(snackbar) {
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _hideSnackbar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    _media = MediaQuery.of(context).size;

    var layers = <LayerOptions>[];
    layers.addAll(_activeLayers);

    if (_geopapLogs != null) layers.add(_geopapLogs);
    if (_geopapMarkers != null && _geopapMarkers.length > 0) {
      var markerCluster = MarkerClusterLayerOptions(
        maxClusterRadius: 80,
        height: 40,
        width: 40,
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: _geopapMarkers,
        polygonOptions: PolygonOptions(
            borderColor: SmashColors.mainDecorationsDark,
            color: SmashColors.mainDecorations.withOpacity(0.2),
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
            backgroundColor: SmashColors.mainDecorationsDark,
            foregroundColor: SmashColors.mainBackground,
            heroTag: null,
          );
        },
      );
      layers.add(markerCluster);
    }

    if (GpsHandler().currentLogPoints.length > 0) {
      _currentGeopapLog.points.clear();
      _currentGeopapLog.points.addAll(GpsHandler().currentLogPoints);
      layers.add(PolylineLayerOptions(
        polylines: [_currentGeopapLog],
      ));
    }

    if (_lastPosition != null) {
      layers.add(
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              anchorPos: AnchorPos.align(AnchorAlign.center),
              point:
                  new LatLng(_lastPosition.latitude, _lastPosition.longitude),
              builder: (ctx) => new Container(
                child: Icon(
                  Icons.my_location,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    }

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

    var bar = new AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Image.asset("assets/smash_text.png", fit: BoxFit.cover),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showInfoDialog(
                context,
                "Project: $_projectName\n${_projectDirName != null ? "Folder: $_projectDirName\n" : ""}"
                    .trim(),
              );
            })
      ],
    );

    return WillPopScope(
        // check when the app is left
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: bar,
          backgroundColor: SmashColors.mainBackground,
          body: FlutterMap(
            options: new MapOptions(
              center: new LatLng(_initLat, _initLon),
              zoom: _initZoom,
              plugins: [
                MarkerClusterPlugin(),
                ScaleLayerPlugin(),
                CenterCrossPlugin(),
              ],
            ),
            layers: layers,
            mapController: _mapController,
          ),
          drawer: Drawer(
              child: ListView(
            children: _getDrawerWidgets(context),
          )),
          endDrawer: Drawer(
              child: ListView(
            children: _getEndDrawerWidgets(context),
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
                          var doNoteInGps = _mainEventsHandler.getInsertInGps();
                          String pos = doNoteInGps ? " (GPS)" : " (center)";
                          List<String> types = ["note", "image"];
                          var selectedType = await showComboDialog(
                              context, "Simple Notes$pos", types);
                          if (selectedType == types[0]) {
                            DataLoaderUtilities.addNote(context, doNoteInGps,
                                _mapController, _mainEventsHandler);
                          } else if (selectedType == types[1]) {
                            DataLoaderUtilities.addImage(context, doNoteInGps,
                                _mapController, _mainEventsHandler);
                          }
                        },
                        icon: Icon(
                          Icons.note,
                          color: SmashColors.mainBackground,
                        ),
                      ),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotesListWidget(_mainEventsHandler, true)));
                      },
                    ),
                    _simpleNotesCount),
                DashboardUtils.makeToolbarBadge(
                    GestureDetector(
                      child: IconButton(
                        onPressed: () async {
                          var doNoteInGps = _mainEventsHandler.getInsertInGps();
                          String pos = doNoteInGps ? " (GPS)" : " (center)";
                          var sectionNames =
                              TagsManager().sectionsMap.keys.toList();
                          var selectedSection = await showComboDialog(
                              context, "Select form$pos", sectionNames);
                          if (selectedSection != null) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MasterDetailPage(
                                    "$selectedSection$pos", selectedSection);
                              },
                            ));
                          }
                        },
                        icon: Icon(
                          Icons.note_add,
                          color: SmashColors.mainBackground,
                        ),
                      ),
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotesListWidget(
                                    _mainEventsHandler, false)));
                      },
                    ),
                    _formNotesCount),
                DashboardUtils.makeToolbarBadge(
                    LoggingButton(_mainEventsHandler), _logsCount),
                Spacer(),
                GpsInfoButton(_mainEventsHandler),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.layers),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LayersPage(reloadLayers, moveTo)));
                  },
                  color: SmashColors.mainBackground,
                  tooltip: 'Open layers list',
                ),
                DashboardUtils.makeToolbarZoomBadge(
                  IconButton(
                    onPressed: () {
                      setState(() {
                        var zoom = _mapController.zoom + 1;
                        if (zoom > 19) zoom = 19;
                        _mapController.move(_mapController.center, zoom);
                      });
                    },
                    tooltip: 'Zoom in',
                    icon: Icon(
                      Icons.zoom_in,
                      color: SmashColors.mainBackground,
                    ),
                  ),
                  _currentZoom.toInt(),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      var zoom = _mapController.zoom - 1;
                      if (zoom < 0) zoom = 0;
                      _mapController.move(_mapController.center, zoom);
                    });
                  },
                  tooltip: 'Zoom out',
                  icon: Icon(
                    Icons.zoom_out,
                    color: SmashColors.mainBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          bool doExit = await showConfirmDialog(
              context,
              "Are you sure you want to exit?",
              "Active operations will be stopped.");
          if (doExit) {
            dispose();
            return Future.value(true);
          }
          return Future.value(false);
        });
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
            children: DashboardUtils.getDrawerTilesList(
                context, _mapController, _mainEventsHandler)),
      ),
    ];
  }

  _getEndDrawerWidgets(BuildContext context) {
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(child: Image.asset("assets/maptools_icon.png")),
        color: SmashColors.mainBackground,
      ),
      new Container(
        child: new Column(
            children: DashboardUtils.getEndDrawerListTiles(
                context, _mapController, _mainEventsHandler)),
      ),
    ];
  }

  @override
  void dispose() {
    updateCenterPosition();
    WidgetsBinding.instance.removeObserver(this);
    GpsHandler().removePositionListener(this);
    if (GPProject() != null) {
      _savePosition().then((v) {
        GPProject().close();
        super.dispose();
      });
    } else {
      super.dispose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
//      GpLogger().d("Application suspended");
      updateCenterPosition();
    } else if (state == AppLifecycleState.inactive) {
//      GpLogger().d("Application inactived");
      updateCenterPosition();
    } else if (state == AppLifecycleState.suspending) {
//      GpLogger().d("Application suspending");
    } else if (state == AppLifecycleState.resumed) {
//      GpLogger().d("Application resumed");
    }
  }

  void updateCenterPosition() {
    // save last position
    GPProject().lastCenterLon = _mapController.center.longitude;
    GPProject().lastCenterLat = _mapController.center.latitude;
    GPProject().lastCenterZoom = _mapController.zoom;

    GpPreferences().setLastPosition(_mapController.center.longitude,
        _mapController.center.latitude, _mapController.zoom);
  }

  Future<void> reloadProject() async {
    await _loadCurrentProject();
    setState(() {});
  }

  Future<void> reloadLayers() async {
    var activeLayersInfos = LayerManager().getActiveLayers();
    _activeLayers = [];
    for (int i = 0; i < activeLayersInfos.length; i++) {
      var ls = await activeLayersInfos[i].toLayers(_showSnackbar);
      if (ls != null) {
        ls.forEach((l) => _activeLayers.add(l));
      }
      GpLogger().d("Layer loaded: ${activeLayersInfos[i].toJson()}");
    }
    setState(() {});
  }

  Future<void> moveTo(dynamic position) async {
    if (position is LatLng) {
      _mapController.move(position, _mapController.zoom);
    } else if (position is LatLngBounds) {
      _mapController.fitBounds(position);
    }
  }

  Future<void> _savePosition() async {
    await GpPreferences().setLastPosition(GPProject().lastCenterLon,
        GPProject().lastCenterLat, GPProject().lastCenterZoom);
  }

  Future doExit(BuildContext context) async {
    await GPProject().close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  @override
  void onPositionUpdate(Position position) {
    if (_mainEventsHandler.isCenterOnGpsStream()) {
      _mapController.move(
          LatLng(position.latitude, position.longitude), _mapController.zoom);
      _lastPosition = position;
    }
    if (_mainEventsHandler.isRotateOnHeading()) {
      var heading = position.heading;
      if (heading < 0) {
        heading = 360 + heading;
      }
      _mapController.rotate(-heading);
    }

    if (mounted) {
      setState(() {
        _lastPosition = position;
      });
    }
  }

  @override
  void setStatus(GpsStatus currentStatus) {
    _mainEventsHandler.setGpsStatus(currentStatus);
  }

  _loadCurrentProject() async {
    var db = await GPProject().getDatabase();
    if (db == null) return;
    _projectName = basenameWithoutExtension(db.path);
    _projectDirName = dirname(db.path);
    _simpleNotesCount = await db.getSimpleNotesCount(false);
    var imageNotescount = await db.getImagesCount(false);
    _simpleNotesCount += imageNotescount;
    _logsCount = await db.getGpsLogCount(false);
    _formNotesCount = await db.getFormNotesCount(false);

    List<Marker> tmp = [];
    DataLoaderUtilities.loadImageMarkers(
        db, tmp, _mainEventsHandler, _showSnackbar, _hideSnackbar);
    DataLoaderUtilities.loadNotesMarkers(
        db, tmp, _mainEventsHandler, _showSnackbar, _hideSnackbar);
    _geopapMarkers = tmp;
    _geopapLogs = await DataLoaderUtilities.loadLogLinesLayer(db);
  }
}

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class GpsInfoButton extends StatefulWidget {
  final MainEventHandler _eventHandler;

  GpsInfoButton(this._eventHandler);

  @override
  State<StatefulWidget> createState() => _GpsInfoButtonState();
}

class _GpsInfoButtonState extends State<GpsInfoButton> {
  GpsStatus _gpsStatus;

  _GpsInfoButtonState();

  @override
  void initState() {
    widget._eventHandler.addGpsStatusListener(() {
      if (this.mounted) {
        setState(() {
          _gpsStatus = widget._eventHandler.getGpsStatus();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          var isLandscape = ScreenUtilities.isLandscape(context);
          var pos = GpsHandler().lastPosition;

          if (isLandscape) {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: SmashColors.mainDecorations,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: getGpsInfoContainer(pos),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: GpsToolsWidget(widget._eventHandler),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: getBottomButtons(context, pos),
                  ),
                ],
              ),
              duration: Duration(seconds: 5),
            ));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: SmashColors.mainDecorations,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: getGpsInfoContainer(pos),
                  ),
                  Divider(
                    color: SmashColors.mainBackground,
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: GpsToolsWidget(widget._eventHandler),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: getBottomButtons(context, pos),
                  ),
                ],
              ),
              duration: Duration(seconds: 5),
            ));
          }
        },
        child: IconButton(
          icon: DashboardUtils.getGpsStatusIcon(_gpsStatus),
          onPressed: () {
            var pos = GpsHandler().lastPosition;
            if (pos != null) {
              var newCenter = LatLng(pos.latitude, pos.longitude);
              if (widget._eventHandler.getMapCenter() == newCenter) {
                // trigger a change in the handler
                // which would not is the coord remains the same
                widget._eventHandler.setMapCenter(LatLng(
                    pos.latitude - 0.00000001, pos.longitude - 0.00000001));
              }
              widget._eventHandler.setMapCenter(newCenter);
            }
          },
        ));
  }

  Widget getBottomButtons(BuildContext context, var pos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.content_copy,
            color: SmashColors.mainBackground,
          ),
          tooltip: "Copy position to clipboard.",
          iconSize: SmashUI.MEDIUM_ICON_SIZE,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: pos.toString()));
          },
        ),
        Spacer(
          flex: 1,
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: SmashColors.mainBackground,
          ),
          iconSize: SmashUI.MEDIUM_ICON_SIZE,
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    );
  }

  Widget getGpsInfoContainer(var pos) {
    var color = SmashColors.mainBackground;

    Widget gpsInfo;
    if (GpsHandler().hasFix() && pos != null) {
      gpsInfo = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SmashUI.titleText(
              "Last GPS position",
              textAlign: TextAlign.center,
              bold: true,
              color: color,
            ),
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(0.4),
              1: FlexColumnWidth(0.6),
            },
            children: [
              TableRow(
                children: [
                  TableUtilities.cellForString("Latitude", color: color),
                  TableUtilities.cellForString("${pos.latitude}", color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Longitude", color: color),
                  TableUtilities.cellForString("${pos.longitude}",
                      color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Altitude", color: color),
                  TableUtilities.cellForString("${pos.altitude.round()} m",
                      color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Accuracy", color: color),
                  TableUtilities.cellForString("${pos.accuracy.round()} m",
                      color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Heading", color: color),
                  TableUtilities.cellForString("${pos.heading} m",
                      color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Speed", color: color),
                  TableUtilities.cellForString("${pos.speed.toInt()} m/s",
                      color: color),
                ],
              ),
              TableRow(
                children: [
                  TableUtilities.cellForString("Timestamp", color: color),
                  TableUtilities.cellForString(
                      "${TimeUtilities.ISO8601_TS_FORMATTER.format(pos.timestamp)}",
                      color: color),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      gpsInfo = SmashUI.titleText(
        "No GPS information available...",
        color: color,
      );
    }

    return Container(
      child: gpsInfo,
    );
  }
}

class GpsToolsWidget extends StatefulWidget {
  final MainEventHandler _eventHandler;

  GpsToolsWidget(this._eventHandler);

  @override
  State<StatefulWidget> createState() => _GpsToolsWidgetState();
}

class _GpsToolsWidgetState extends State<GpsToolsWidget> {
  @override
  Widget build(BuildContext context) {
    Widget toolsWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SmashUI.titleText(
            "Tools",
            textAlign: TextAlign.center,
            color: SmashColors.mainBackground,
            bold: true,
          ),
        ),
        CheckboxListTile(
          value: GpPreferences().getBooleanSync(KEY_CENTER_ON_GPS, false),
          title: SmashUI.normalText("Center map on GPS position",
              color: SmashColors.mainBackground),
          onChanged: (value) async {
            await GpPreferences().setBoolean(KEY_CENTER_ON_GPS, value);
            widget._eventHandler.setCenterOnGpsStream(value);
            setState(() {});
          },
        ),
        Platform.isAndroid
            ? CheckboxListTile(
                value: GpPreferences()
                    .getBooleanSync(KEY_ROTATE_ON_HEADING, false),
                title: SmashUI.normalText("Rotate map with GPS heading",
                    color: SmashColors.mainBackground),
                onChanged: (value) async {
                  await GpPreferences()
                      .setBoolean(KEY_ROTATE_ON_HEADING, value);
                  widget._eventHandler.setRotateOnHeading(value);
                  setState(() {});
                },
              )
            : Container(),
      ],
    );
    return Container(
      child: toolsWidget,
    );
  }
}

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class LoggingButton extends StatefulWidget {
  final MainEventHandler _eventHandler;

  LoggingButton(this._eventHandler);

  @override
  State<StatefulWidget> createState() => _LoggingButtonState();
}

class _LoggingButtonState extends State<LoggingButton> {
  GpsStatus _gpsStatus;

  @override
  void initState() {
    widget._eventHandler.addGpsStatusListener(() {
      if (this.mounted) {
        setState(() {
          _gpsStatus = widget._eventHandler.getGpsStatus();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
          icon: DashboardUtils.getLoggingIcon(_gpsStatus),
          onPressed: () {
            _toggleLoggingFunction(context);
          }),
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogListWidget(widget._eventHandler)));
      },
    );
  }

  _toggleLoggingFunction(BuildContext context) async {
    if (GpsHandler().isLogging) {
      var stopLogging = await showConfirmDialog(context, "Stop Logging?",
          "Stop logging and close the current GPS log?");
      if (stopLogging) {
        await GpsHandler().stopLogging();
        widget._eventHandler.reloadProjectFunction();
      }
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

        String userString = await showInputDialog(
          context,
          "New Log",
          "Enter a name for the new log",
          hintText: '',
          defaultText: logName,
          validationFunction: noEmptyValidator,
        );

        if (userString != null) {
          if (userString.trim().length == 0) userString = logName;
          int logId = await GpsHandler().startLogging(logName);
          if (logId == null) {
            // TODO show error
          }
        }
      } else {
        showOperationNeedsGps(context);
      }
    }
    setState(() {});
  }
}
