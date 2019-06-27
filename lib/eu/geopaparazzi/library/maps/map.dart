import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/database_widgets.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/geocoding.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/mapsforge.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/share.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';
import 'package:latlong/latlong.dart';
import 'package:screen/screen.dart';
import 'package:sqflite/sqflite.dart';

class GeopaparazziMapWidget extends StatefulWidget {
  GeopaparazziMapWidget({Key key}) : super(key: key);

  @override
  GeopaparazziMapWidgetState createState() => new GeopaparazziMapWidgetState();
}

class GeopaparazziMapWidgetState extends State<GeopaparazziMapWidget>
    with SingleTickerProviderStateMixin
    implements PositionListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> _keepGpsOnScreenNotifier = new ValueNotifier(false);
  ValueNotifier<LatLng> _mapCenterValueNotifier =
      new ValueNotifier(LatLng(0, 0));

  List<Marker> _geopapMarkers;
  PolylineLayerOptions _geopapLogs;
  Polyline _currentGeopapLog =
      Polyline(points: [], strokeWidth: 3, color: ColorExt("red"));
  TileLayerOptions _osmLayer;
  Position _lastPosition;

  double _initLon;
  double _initLat;
  double _initZoom;

  MapController _mapController;

  TileLayerOptions _mapsforgeLayer;

  set geopapMarkers(List<Marker> geopapMarkers) {
    _geopapMarkers = geopapMarkers;
  }

  set geopapLogs(PolylineLayerOptions geopapLogs) {
    _geopapLogs = geopapLogs;
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);

    _initLon = gpProjectModel.lastCenterLon;
    _initLat = gpProjectModel.lastCenterLat;
    _initZoom = gpProjectModel.lastCenterZoom;

    GpsHandler().addPositionListener(this);
    _mapController = MapController();
    _osmLayer = new TileLayerOptions(
      urlTemplate: "https://{s}.tile.openstreetmap.org/"
          "{z}/{x}/{y}.png",
      backgroundColor: SmashColors.mainBackground,
      maxZoom: 19,
      subdomains: ['a', 'b', 'c'],
    );

    _mapCenterValueNotifier.addListener(() {
      _mapController.move(_mapCenterValueNotifier.value, _mapController.zoom);
    });
    load();
  }

  Future load() async {
    bool centerOnGps = await GpPreferences().getCenterOnGps();
    _keepGpsOnScreenNotifier.value = centerOnGps;

    var mapsforgePath = await GpPreferences().getString(KEY_LAST_MAPSFORGEPATH);
    if (mapsforgePath != null) {
      File mapsforgeFile = new File(mapsforgePath);
      if (mapsforgeFile.existsSync()) {
        _mapsforgeLayer = await loadMapsforgeLayer(mapsforgeFile);
      }
    }
    if (gpProjectModel.projectPath != null) {
      await loadCurrentProject();
    }
    setState(() {});
  }

  reloadProject() async {
    await loadCurrentProject();
    setState(() {});
  }

  @override
  void dispose() {
//    _mapCenterValueNotifier.removeListener();
    updateCenterPosition();
    // stop listening to gps
    GpsHandler().removePositionListener(this);
    super.dispose();
  }

  void updateCenterPosition() {
    // save last position
    gpProjectModel.lastCenterLon = _mapController.center.longitude;
    gpProjectModel.lastCenterLat = _mapController.center.latitude;
    gpProjectModel.lastCenterZoom = _mapController.zoom;
  }

  @override
  Widget build(BuildContext context) {
    var layers = <LayerOptions>[];
//    layers.add(_osmLayer);

    if (_mapsforgeLayer != null) {
      layers.add(_mapsforgeLayer);
    }

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

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Map View"),
      ),
      body: Center(
          // here no futurebuilder can be used, because the gps triggers refresh, which makes it cluttered
          child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(_initLat, _initLon),
          zoom: _initZoom,
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: layers,
        mapController: _mapController,
      )),
//      floatingActionButton: AnimatedFloatingActionButton(
//          //Fab list
//          fabButtons: <Widget>[zoomIn(), zoomOut(), centerOnGps()],
//          colorStartAnimation: GeopaparazziColors.mainDecorations,
//          colorEndAnimation: GeopaparazziColors.mainSelection,
//          animatedIconData: AnimatedIcons.menu_close),
      endDrawer: Drawer(
          child: ListView(
        children: getDrawerWidgets(context),
      )),
      bottomNavigationBar: BottomAppBar(
        color: SmashColors.mainDecorations,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              tooltip: 'Add note',
              icon: Icon(
                Icons.note_add,
                color: SmashColors.mainBackground,
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Notes list',
              icon: Icon(
                Icons.list,
                color: SmashColors.mainBackground,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogWidget(reloadProject)));
              },
              tooltip: 'Logs list',
              icon: Icon(
                Icons.timeline,
                color: SmashColors.mainBackground,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_lastPosition != null)
                    _mapController.move(
                        LatLng(_lastPosition.latitude, _lastPosition.longitude),
                        _mapController.zoom);
                });
              },
              tooltip: 'Center on GPS',
              icon: Icon(
                Icons.center_focus_strong,
                color: SmashColors.mainBackground,
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
    );
  }

  @override
  void onPositionUpdate(Position position) {
    if (_keepGpsOnScreenNotifier.value &&
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
  void setStatus(GpsStatus currentStatus) {}

  getDrawerWidgets(BuildContext context) {
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
                      builder: (context) =>
                          GeocodingPage(_mapCenterValueNotifier)));
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
              Icons.layers,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Layers",
              style: textStyle,
            ),
            onTap: () => _openLayers(context),
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
                value: _keepGpsOnScreenNotifier.value,
                onChanged: (value) {
                  _keepGpsOnScreenNotifier.value = value;
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
    File file =
        await FilePicker.getFile(type: FileType.ANY, fileExtension: 'map');
    if (file != null) {
      if (file.path.endsWith(".map")) {
//                GeopaparazziMapLoader loader =
//                    new GeopaparazziMapLoader(file, this);
//                loader.loadNotes();
        _mapsforgeLayer = await loadMapsforgeLayer(file);
        await GpPreferences().setString(KEY_LAST_MAPSFORGEPATH, file.path);
        setState(() {});
      } else {
        showWarningDialog(context, "File format not supported.");
      }
    }
  }

  loadCurrentProject() async {
    var db = await gpProjectModel.getDatabase();

    List<Marker> tmp = [];
    // IMAGES
//    List<Map<String, dynamic>> resImages =
//        await db.query("images", columns: ['lat', 'lon']);
//    resImages.forEach((map) {
//      var lat = map["lat"];
//      var lon = map["lon"];
//      tmp.add(Marker(
//        width: 80.0,
//        height: 80.0,
//        point: new LatLng(lat, lon),
//        builder: (ctx) => new Container(
//              child: Icon(
//                Icons.image,
//                size: 32,
//                color: Colors.blue,
//              ),
//            ),
//      ));
//    });

    // NOTES
    List<Note> notesList = await db.getNotes(false);
    notesList.forEach((note) {
      var label =
          "note: ${note.text}\nlat: ${note.lat}\nlon: ${note.lon}\naltim: ${note.altim}\nts: ${GpConstants.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp))}";
      NoteExt noteExt = note.noteExt;
      tmp.add(Marker(
        width: 80,
        height: 80,
        point: new LatLng(note.lat, note.lon),
        builder: (ctx) => new Container(
                child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
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
                                _scaffoldKey.currentState.hideCurrentSnackBar();
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
                                _scaffoldKey.currentState.hideCurrentSnackBar();
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
                                _scaffoldKey.currentState.hideCurrentSnackBar();
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
                Icons.note,
                size: noteExt.size,
                color: ColorExt(noteExt.color),
              ),
            )),
      ));
    });

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

    addLogLines(tmp, logs, db);
  }

  void addLogLines(List<Marker> markers, Map<int, List> logs, var db) async {
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
    _geopapMarkers = markers;
  }
}
