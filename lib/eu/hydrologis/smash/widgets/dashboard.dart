/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:screen/screen.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => new _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget>
    implements PositionListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _menuKey = GlobalKey();
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

  MapController _mapController;

  List<TileLayerOptions> _activeLayers = [];

  Size _media;

  String _projectName = "No project loaded";
  String _projectDirName;
  int _notesCount = 0;
  int _logsCount = 0;

  @override
  void initState() {
    Screen.keepOn(true);

    if (gpProjectModel != null) {
      _initLon = gpProjectModel.lastCenterLon;
      _initLat = gpProjectModel.lastCenterLat;
      _initZoom = gpProjectModel.lastCenterZoom;
    } else {
      _initLon = 0;
      _initLat = 0;
      _initZoom = 16;
    }
    _mapController = MapController();

    _mainEventsHandler.addMapCenterListener(() {
      var newMapCenter = _mainEventsHandler.getMapCenter();
      if (newMapCenter != null)
        _mapController.move(newMapCenter, _mapController.zoom);
    });

    _checkPermissions().then((allRight) async {
      if (allRight) {
        var directory =
            await WorkspaceUtils.getApplicationConfigurationFolder();
        bool init = await GpLogger().init(directory.path); // init logger
        if (init) GpLogger().d("Db logger initialized.");

        // start gps listening
        GpsHandler().addPositionListener(this);

        // check center on gps
        bool centerOnGps = await GpPreferences().getCenterOnGps();
        _mainEventsHandler.setCenterOnGps(centerOnGps);

        // set initial status
        bool gpsIsOn = await GpsHandler().isGpsOn();
        if (gpsIsOn != null) {
          if (gpsIsOn) {
            _mainEventsHandler.setGpsStatus(GpsStatus.ON_NO_FIX);
          }
        }

        await loadCurrentProject();
        await reloadLayers();
      }
    });

    super.initState();
  }

  _showSnackbar(snackbar) {
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _hideSnackbar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  Future<bool> _checkPermissions() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      GpLogger().d("Storage permission is not granted.");
      Map<PermissionGroup, PermissionStatus> permissionsMap =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissionsMap[PermissionGroup.storage] != PermissionStatus.granted) {
        GpLogger().d("Unable to grant permission: ${PermissionGroup.storage}");
        return false;
      }

      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);
      if (permission != PermissionStatus.granted) {
        GpLogger().d("Location permission is not granted.");
        Map<PermissionGroup, PermissionStatus> permissionsMap =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.location]);
        if (permissionsMap[PermissionGroup.location] !=
            PermissionStatus.granted) {
          GpLogger()
              .d("Unable to grant permission: ${PermissionGroup.location}");
          return false;
        }
      }
    }
    return true;
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

    var bar = new AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Image.asset("assets/smash_text.png", fit: BoxFit.cover),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              String gpsInfo = "";
              if (_lastPosition != null) {
                gpsInfo = '''
Last position:
  Latitude: ${_lastPosition.latitude}
  Longitude: ${_lastPosition.longitude}
  Altitude: ${_lastPosition.altitude.round()} m
  Accuracy: ${_lastPosition.accuracy.round()} m
  Heading: ${_lastPosition.heading}
  Speed: ${_lastPosition.speed} m/s
  Timestamp: ${TimeUtilities.ISO8601_TS_FORMATTER.format(_lastPosition.timestamp)}''';
              }
              showInfoDialog(
                  context,
                  '''Project: $_projectName
${_projectDirName != null ? "Folder: $_projectDirName\n" : ""}
$gpsInfo
'''
                      .trim(),
                  dialogHeight: _media.height / 2);
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
            children: getEndDrawerWidgets(context),
          )),
          bottomNavigationBar: BottomAppBar(
            color: SmashColors.mainDecorations,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                makeToolbarBadge(
                    GestureDetector(
                      child: IconButton(
                        onPressed: () async {
                          PopupMenu.context = context;
                          PopupMenu menu = PopupMenu(
                            backgroundColor: SmashColors.mainBackground,
                            lineColor: SmashColors.mainDecorations,
                            // maxColumn: 2,
                            items: getMenuItems(),
                            onClickMenu: (menuItem) async {
                              if (menuItem.menuTitle == 'Center Note') {
                                _addNote(context, false);
                              } else if (menuItem.menuTitle == 'GPS Note') {
                                _addNote(context, true);
                              } else if (menuItem.menuTitle == 'Center Image') {
                                _addImage(context, false);
                              } else if (menuItem.menuTitle == 'GPS Image') {
                                _addImage(context, true);
                              }
                            },
                            onDismiss: onDismissMenu,
                          );

                          menu.show(widgetKey: _menuKey);
                        },
                        key: _menuKey,
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
                                    NotesListWidget(_mainEventsHandler)));
                      },
                    ),
                    _notesCount),
                makeToolbarBadge(LoggingButton(_mainEventsHandler), _logsCount),
                IconButton(
                  icon: Icon(Icons.layers),
                  onPressed: () => _openLayers(context),
                  color: SmashColors.mainBackground,
                  tooltip: 'Open layers list',
                ),
                Spacer(),
                GpsInfoButton(_mainEventsHandler),
                Spacer(),
                IconButton(
                  // placeholder icon to keep centered
                  onPressed: null,
                  icon: Icon(
                    Icons.center_focus_strong,
                    color: SmashColors.mainDecorations,
                  ),
                ),
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
        });
  }

  List<MenuItem> getMenuItems() {
    var style = TextStyle(fontSize: 10, color: SmashColors.mainTextColor);
    var size = GpConstants.SMALL_DIALOG_ICON_SIZE;
    var list = <MenuItem>[
      MenuItem(
          textStyle: style,
          title: 'Center Note',
          image: Icon(
            Icons.add_comment,
            color: SmashColors.mainDecorations,
            size: size,
          )),
      MenuItem(
          textStyle: style,
          title: 'Center Image',
          image: Icon(
            Icons.add_a_photo,
            color: SmashColors.mainDecorations,
            size: size,
          )),
      MenuItem(
          textStyle: style,
          title: 'Center Forms',
          image: Icon(
            Icons.menu,
            color: SmashColors.mainDecorations,
            size: size,
          )),
    ];
    if (GpsHandler().hasFix()) {
      list.add(
        MenuItem(
            textStyle: style,
            title: 'GPS Note',
            image: Icon(
              Icons.add_comment,
              color: SmashColors.mainSelection,
              size: size,
            )),
      );
      list.add(
        MenuItem(
            textStyle: style,
            title: 'GPS Image',
            image: Icon(
              Icons.add_a_photo,
              color: SmashColors.mainSelection,
              size: size,
            )),
      );
      list.add(
        MenuItem(
            textStyle: style,
            title: 'GPS Forms',
            image: Icon(
              Icons.menu,
              color: SmashColors.mainSelection,
              size: size,
            )),
      );
    }
    return list;
  }

  void onDismissMenu() {}

  void _addNote(BuildContext context, bool doInGps) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    Position pos;
    double lon;
    double lat;
    if (doInGps) {
      pos = GpsHandler().lastPosition;
    } else {
      var center = _mapController.center;
      lon = center.longitude;
      lat = center.latitude;
    }
    Note note = Note()
      ..text = "double tap to change"
      ..description = "POI"
      ..timeStamp = ts
      ..lon = pos != null ? pos.longitude : lon
      ..lat = pos != null ? pos.latitude : lat
      ..altim = pos != null ? pos.altitude : -1;
    if (pos != null) {
      NoteExt next = NoteExt()
        ..speedaccuracy = pos.speedAccuracy
        ..speed = pos.speed
        ..heading = pos.heading
        ..accuracy = pos.accuracy;
      note.noteExt = next;
    }
    var db = await gpProjectModel.getDatabase();
    await db.addNote(note);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotePropertiesWidget(_mainEventsHandler, note)));
  }

  void _addImage(BuildContext context, bool doInGps) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    if (doInGps) {
      var pos = GpsHandler().lastPosition;

      dbImage.lon = pos.longitude;
      dbImage.lat = pos.latitude;
      dbImage.altim = pos.altitude;
      dbImage.azim = pos.heading;
    } else {
      var center = _mapController.center;
      dbImage.lon = center.longitude;
      dbImage.lat = center.latitude;
      dbImage.altim = -1;
      dbImage.azim = -1;
    }

    openCamera(context, (takenImagePath) async {
      Navigator.of(context).pop();
      if (takenImagePath != null) {
        dbImage.text =
            "IMG_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.jpg";
        bool done = await ImageWidgetUtilities.saveImageToSmashDb(
            takenImagePath, dbImage);
        if (done) {
          await reloadProject();
        }
        File file = File(takenImagePath);
        if (file.existsSync()) {
          file.delete();
        }
      }
    });
  }

  Widget makeToolbarBadge(Widget widget, int badgeValue) {
    if (badgeValue > 0) {
      return Badge(
        badgeColor: SmashColors.mainSelection,
        shape: BadgeShape.circle,
        toAnimate: false,
        badgeContent: Text(
          '$badgeValue',
          style: TextStyle(color: Colors.white),
        ),
        child: widget,
      );
    } else {
      return widget;
    }
  }

  getEndDrawerWidgets(BuildContext context) {
    var c = SmashColors.mainDecorations;
    var textStyle = GpConstants.MEDIUM_DIALOG_TEXT_STYLE;
    var iconSize = GpConstants.MEDIUM_DIALOG_ICON_SIZE;
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(child: Image.asset("assets/maptools_icon.png")),
        color: SmashColors.mainBackground,
      ),
      new Container(
        child: new Column(children: [
          ListTile(
            leading: new Icon(
              Icons.navigation,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Go to",
              style: textStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeocodingPage(_mainEventsHandler)));
            },
          ),
          ListTile(
            leading: new Icon(
              Icons.share,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Share position",
              style: textStyle,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: new Icon(
              Icons.center_focus_weak,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "GPS on screen",
              style: textStyle,
            ),
            trailing: Checkbox(
                value: _mainEventsHandler.isKeepGpsOnScreen(),
                onChanged: (value) {
                  _mainEventsHandler.setKeepGpsOnScreen(value);
                  GpPreferences().setBoolean(KEY_CENTER_ON_GPS, value);
//                  Navigator.of(context).pop();
                }),
            onTap: () => _openLayers(context),
          ),
        ]),
      ),
    ];
  }

  _openLayers(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LayersPage(reloadLayers, moveTo)));
  }

  @override
  void dispose() {
    updateCenterPosition();
    GpsHandler().removePositionListener(this);
    if (gpProjectModel != null) {
      _savePosition().then((v) {
        gpProjectModel.close();
        gpProjectModel = null;
        super.dispose();
      });
    } else {
      super.dispose();
    }
  }

  void updateCenterPosition() {
    // save last position
    gpProjectModel.lastCenterLon = _mapController.center.longitude;
    gpProjectModel.lastCenterLat = _mapController.center.latitude;
    gpProjectModel.lastCenterZoom = _mapController.zoom;
  }

  Future<void> reloadProject() async {
    await loadCurrentProject();
    setState(() {});
  }

  Future<void> reloadLayers() async {
    var activeLayersInfos = LayerManager().getActiveLayers();
    _activeLayers = [];
    for (int i = 0; i < activeLayersInfos.length; i++) {
      var tl = await activeLayersInfos[i].toTileLayer();
      _activeLayers.add(tl);
    }
    setState(() {});
  }

  Future<void> moveTo(LatLng position) async {
    _mapController.move(position, _mapController.zoom);
  }

  Future<void> _savePosition() async {
    await GpPreferences().setLastPosition(gpProjectModel.lastCenterLon,
        gpProjectModel.lastCenterLat, gpProjectModel.lastCenterZoom);
  }

  _getDrawerWidgets(BuildContext context) {
//    final String assetName = 'assets/geopaparazzi_launcher_icon.svg';
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
        child: new Column(children: [
          ListTile(
            leading: new Icon(
              Icons.create_new_folder,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "New Project",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _createNewProject(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.folder_open,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Open Project",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openProject(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.file_download,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Import",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: new Icon(
              Icons.file_upload,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Export",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: new Icon(
              Icons.settings,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openSettings(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.info_outline,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "About",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openAbout(context),
          ),
        ]),
      ),
    ];
  }

  Future doExit(BuildContext context) async {
    await gpProjectModel.close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  Future _openSettings(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsWidget()));
  }

  Future _openAbout(BuildContext context) async {}

  Future _openProject(BuildContext context) async {
    File file =
        await FilePicker.getFile(type: FileType.ANY, fileExtension: 'gpap');
    if (file != null && file.existsSync()) {
      gpProjectModel.setNewProject(this, file.path);
      reloadProject();
    }
    Navigator.of(context).pop();
  }

  Future _createNewProject(BuildContext context) async {
    String projectName =
        "geopaparazzi_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

    var userString = await showInputDialog(
      context,
      "New Project",
      "Enter a name for the new project or accept the proposed.",
      hintText: '',
      defaultText: projectName,
      validationFunction: fileNameValidator,
    );
    if (userString != null) {
      if (userString.trim().length == 0) userString = projectName;
      var file = await WorkspaceUtils.getDefaultStorageFolder();
      var newPath = join(file.path, userString);
      if (!newPath.endsWith(".gpap")) {
        newPath = "$newPath.gpap";
      }
      var gpFile = new File(newPath);
      gpProjectModel.setNewProject(this, gpFile.path);
    }

    Navigator.of(context).pop();
  }

  @override
  void onPositionUpdate(Position position) {
    if (_mainEventsHandler.isKeepGpsOnScreen() &&
        !_mapController.bounds
            .contains(LatLng(position.latitude, position.longitude))) {
      _mapController.move(
          LatLng(position.latitude, position.longitude), _mapController.zoom);
    }
    setState(() {
      _lastPosition = position;
    });
  }

  @override
  void setStatus(GpsStatus currentStatus) {
    _mainEventsHandler.setGpsStatus(currentStatus);
  }

  loadCurrentProject() async {
    var db = await gpProjectModel.getDatabase();
    if (db == null) return;
    _projectName = basenameWithoutExtension(db.path);
    _projectDirName = dirname(db.path);
    _notesCount = await db.getNotesCount(false);
    var imageNotescount = await db.getImagesCount(false);
    _notesCount += imageNotescount;
    _logsCount = await db.getGpsLogCount(false);

    List<Marker> tmp = [];
    // IMAGES
    var imagesList = await db.getImages(false);
    imagesList.forEach((image) async {
      var size = 48.0;
      var lat = image.lat;
      var lon = image.lon;
      var label =
          "image: ${image.text}\nlat: ${image.lat}\nlon: ${image.lon}\naltim: ${image.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}";
      tmp.add(Marker(
        width: size,
        height: size,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () async {
            var thumb = await db.getThumbnail(image.imageDataId);
            _showSnackbar(SnackBar(
              backgroundColor: SmashColors.snackBarColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          label,
                          style: GpConstants.MEDIUM_DIALOG_TEXT_STYLE_NEUTRAL,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: SmashColors.mainDecorations)),
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          thumb,
                        ],
                      ),
                      onTap: () async {
                        Navigator.push(
                            ctx,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SmashImageZoomWidget(image)));
                        _hideSnackbar();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () {
                            shareText(label);
                            _hideSnackbar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: SmashColors.mainDanger,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () async {
                            var doRemove = await showConfirmDialog(
                                ctx,
                                "Remove Imadge",
                                "Are you sure you want to remove image ${image.id}?");
                            if (doRemove) {
                              var db = await gpProjectModel.getDatabase();
                              db.deleteImage(image.id);
                              reloadProject();
                            }
                            _hideSnackbar();
                          },
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: SmashColors.mainDecorationsDark,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () {
                            _hideSnackbar();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              duration: Duration(seconds: 5),
            ));
          },
          child: Icon(
            NOTES_ICONDATA['camera'],
            size: size,
            color: Colors.blue,
          ),
        )),
      ));
    });

    // NOTES
    List<Note> notesList = await db.getNotes();
    notesList.forEach((note) {
      var label =
          "note: ${note.text}\nlat: ${note.lat}\nlon: ${note.lon}\naltim: ${note.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp))}";
      NoteExt noteExt = note.noteExt;
      tmp.add(Marker(
        width: noteExt.size,
        height: noteExt.size,
        point: new LatLng(note.lat, note.lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () {
            _showSnackbar(SnackBar(
              backgroundColor: SmashColors.snackBarColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: GpConstants.MEDIUM_DIALOG_TEXT_STYLE_NEUTRAL,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () {
                            shareText(label);
                            _hideSnackbar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () {
                            Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (context) => NotePropertiesWidget(
                                        _mainEventsHandler, note)));
                            _hideSnackbar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: SmashColors.mainDanger,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () async {
                            var doRemove = await showConfirmDialog(
                                ctx,
                                "Remove Note",
                                "Are you sure you want to remove note ${note.id}?");
                            if (doRemove) {
                              var db = await gpProjectModel.getDatabase();
                              db.deleteNote(note.id);
                              reloadProject();
                            }
                            _hideSnackbar();
                          },
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: SmashColors.mainDecorationsDark,
                          ),
                          iconSize: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                          onPressed: () {
                            _hideSnackbar();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              duration: Duration(seconds: 5),
            ));
          },
          child: Icon(
            NOTES_ICONDATA[noteExt.marker],
            size: noteExt.size,
            color: ColorExt(noteExt.color),
          ),
        )),
      ));
    });

    _geopapMarkers = tmp;

    String logsQuery = '''
        select l.$LOGS_COLUMN_ID, p.$LOGSPROP_COLUMN_COLOR, p.$LOGSPROP_COLUMN_WIDTH 
        from $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        where l.$LOGS_COLUMN_ID = p.$LOGSPROP_COLUMN_ID and p.$LOGSPROP_COLUMN_VISIBLE=1
    ''';

    List<Map<String, dynamic>> resLogs = await db.query(logsQuery);
    Map<int, List> logs = Map();
    resLogs.forEach((map) {
      var id = map['_id'];
      var color = map["color"];
      var width = map["width"];

      logs[id] = [color, width, <LatLng>[]];
    });

    addLogLines(logs, db);
  }

  void addLogLines(Map<int, List> logs, var db) async {
    String logDataQuery =
        "select $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LOGID from $TABLE_GPSLOG_DATA order by $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_TS";
    List<Map<String, dynamic>> resLogs = await db.query(logDataQuery);
    resLogs.forEach((map) {
      var logid = map[LOGSDATA_COLUMN_LOGID];
      var log = logs[logid];
      if (log != null) {
        var lat = map[LOGSDATA_COLUMN_LAT];
        var lon = map[LOGSDATA_COLUMN_LON];
        var coordsList = log[2];
        coordsList.add(LatLng(lat, lon));
      }
    });

    List<Polyline> lines = [];
    logs.forEach((key, list) {
      var color = list[0];
      var width = list[1];
      var points = list[2];
      lines.add(
          Polyline(points: points, strokeWidth: width, color: ColorExt(color)));
    });

    _geopapLogs = PolylineLayerOptions(
      polylines: lines,
    );
  }
}

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class GpsInfoButton extends StatefulWidget {
  final MainEventHandler _eventHandler;

  GpsInfoButton(this._eventHandler);

  @override
  State<StatefulWidget> createState() => GpsInfoButtonState();
}

class GpsInfoButtonState extends State<GpsInfoButton> {
  GpsStatus _gpsStatus;

  GpsInfoButtonState();

  @override
  void initState() {
    widget._eventHandler.addGpsStatusListener(() {
      setState(() {
        _gpsStatus = widget._eventHandler.getGpsStatus();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: getGpsStatusIcon(_gpsStatus),
        tooltip: "Check GPS Information",
        onPressed: () {
          print("GPS info Pressed...");
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
        });
  }
}

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class LoggingButton extends StatefulWidget {
  final MainEventHandler _eventHandler;

  LoggingButton(this._eventHandler);

  @override
  State<StatefulWidget> createState() => LoggingButtonState();
}

class LoggingButtonState extends State<LoggingButton> {
  GpsStatus _gpsStatus;

  @override
  void initState() {
    widget._eventHandler.addMapCenterListener(() {
      if (this.mounted)
        setState(() {
          _gpsStatus = widget._eventHandler.getGpsStatus();
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
          icon: getLoggingIcon(_gpsStatus),
          onPressed: () {
            toggleLoggingFunction(context);
          }),
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogListWidget(widget._eventHandler)));
      },
    );
  }

  toggleLoggingFunction(BuildContext context) async {
    if (GpsHandler().isLogging) {
      await GpsHandler().stopLogging();
      widget._eventHandler.reloadProjectFunction();
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.now())}";

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
  }
}

Icon getGpsStatusIcon(GpsStatus status) {
  Color color;
  IconData iconData;
  switch (status) {
    case GpsStatus.OFF:
      {
        color = SmashColors.gpsOff;
        iconData = Icons.gps_off;
        break;
      }
    case GpsStatus.ON_WITH_FIX:
      {
        color = SmashColors.gpsOnWithFix;
        iconData = Icons.gps_fixed;
        break;
      }
    case GpsStatus.ON_NO_FIX:
      {
        iconData = Icons.gps_not_fixed;
        color = SmashColors.gpsOnNoFix;
        break;
      }
    case GpsStatus.LOGGING:
      {
        iconData = Icons.gps_fixed;
        color = SmashColors.gpsLogging;
        break;
      }
    case GpsStatus.NOPERMISSION:
      {
        iconData = Icons.gps_off;
        color = SmashColors.gpsNoPermission;
        break;
      }
  }
  return Icon(
    iconData,
    color: color,
  );
}

Icon getLoggingIcon(GpsStatus status) {
  Color color;
  IconData iconData;
  switch (status) {
    case GpsStatus.LOGGING:
      {
        iconData = Icons.timeline;
        color = SmashColors.gpsLogging;
        break;
      }
    case GpsStatus.OFF:
    case GpsStatus.ON_WITH_FIX:
    case GpsStatus.ON_NO_FIX:
    case GpsStatus.NOPERMISSION:
      {
        iconData = Icons.timeline;
        color = SmashColors.mainBackground;
        break;
      }
    default:
      {
        iconData = Icons.timeline;
        color = SmashColors.mainBackground;
      }
  }
  return Icon(
    iconData,
    color: color,
  );
}
