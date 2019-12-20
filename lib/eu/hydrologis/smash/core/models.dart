/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/project_tables.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/smash/widgets/dashboard_utils.dart';
import 'package:path/path.dart';

const DEBUG_NOTIFICATIONS = true;

class ChangeNotifierPlus extends ChangeNotifier {
  void notifyListenersMsg([String msg]) {
    if (DEBUG_NOTIFICATIONS) {
      print("${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.now())}:: ${runtimeType.toString()}: ${msg ?? "notify triggered"}");
    }

    notifyListeners();
  }
}

/// Current Gps Status.
///
/// Provides tracking of position and parameters related to GPS state.
class GpsState extends ChangeNotifierPlus {
  GpsStatus _status = GpsStatus.OFF;
  Position _lastPosition;

  bool _isLogging = false;
  int _currentLogId;
  ProjectState _projectState;
  bool _insertInGps = true;

  List<LatLng> _currentLogPoints = [];
  GpsStatus _lastGpsStatusBeforeLogging;

  GpsStatus get status => _status;

  Position get lastPosition => _lastPosition;

  void set lastGpsPosition(Position position) {
    _lastPosition = position;
    notifyListenersMsg("lastGpsPosition");
  }

  void set lastGpsPositionQuiet(Position position) {
    _lastPosition = position;
  }

  /// Set the status without triggering a global notification.
  void set statusQuiet(GpsStatus newStatus) {
    _status = newStatus;
  }

  void set status(GpsStatus newStatus) {
    _status = newStatus;
    notifyListenersMsg("status");
  }

  bool get insertInGps => _insertInGps;

  bool get isLogging => _isLogging;

  int get currentLogId => _currentLogId;

  /// Set the _insertInGps without triggering a global notification.
  void set insertInGpsQuiet(bool newInsertInGps) {
    _insertInGps = newInsertInGps;
    GpPreferences().setBoolean(KEY_DO_NOTE_IN_GPS, newInsertInGps);
  }

  void set insertInGps(bool newInsertInGps) {
    insertInGpsQuiet = newInsertInGps;
    notifyListenersMsg("insertInGps");
  }

  void set projectState(ProjectState state) {
    _projectState = state;
  }

  @override
  Future<void> addLogPoint(double longitude, double latitude, double altitude, int timestamp) async {
    if (_projectState != null) {
      LogDataPoint ldp = LogDataPoint();
      ldp.logid = currentLogId;
      ldp.lon = longitude;
      ldp.lat = latitude;
      ldp.altim = altitude;
      ldp.ts = timestamp;
      await _projectState.projectDb.addGpsLogPoint(currentLogId, ldp);
    }
  }

  @override
  Future<int> addGpsLog(String logName) async {
    if (_projectState != null) {
      Log l = new Log();
      l.text = logName;
      l.startTime = DateTime.now().millisecondsSinceEpoch;
      l.endTime = 0;
      l.isDirty = 0;
      l.lengthm = 0;
      LogProperty lp = new LogProperty();
      lp.isVisible = 1;
      lp.color = "#FF0000";
      lp.width = 3;
      var logId = await _projectState.projectDb.addGpsLog(l, lp);
      return logId;
    } else {
      return -1;
    }
  }

  /// Start logging to database.
  ///
  /// This creates a new log with the name [logName] and returns
  /// the id of the created log.
  ///
  /// Once logging, the [_onPositionUpdate] method adds the
  /// points as the come.
  Future<int> startLogging(String logName) async {
    try {
      var logId = await addGpsLog(logName);
      _currentLogId = logId;
      _isLogging = true;

      _lastGpsStatusBeforeLogging = _status;
      _status = GpsStatus.LOGGING;

      notifyListenersMsg("startLogging");

      return logId;
    } catch (e) {
      GpLogger().e("Error creating log", e);
      return null;
    }
  }

  /// Get the list of current log points.
  List<LatLng> get currentLogPoints => _currentLogPoints;

  /// Stop logging to database.
  ///
  /// This also properly closes the recorded log.
  Future<void> stopLogging() async {
    _isLogging = false;
    _currentLogPoints.clear();

    if (_projectState != null) {
      int endTs = DateTime.now().millisecondsSinceEpoch;
      await _projectState.projectDb.updateGpsLogEndts(_currentLogId, endTs);
    }

    if (_lastGpsStatusBeforeLogging == null) _lastGpsStatusBeforeLogging = GpsStatus.ON_NO_FIX;
    _status = _lastGpsStatusBeforeLogging;
    _lastGpsStatusBeforeLogging = null;
    notifyListenersMsg("stopLogging");
  }
}

/// Current state of the Map view.
///
/// This provides tracking of map view and general status.
class MapState extends ChangeNotifierPlus {
  Coordinate _center = Coordinate(11.33140, 46.47781);
  double _zoom = 16;
  double _heading = 0;
  MapController mapController;

  /// Defines whether the map should center on the gps position
  bool _centerOnGps = true;

  /// Defines whether the map should rotate following the gps heading
  bool _rotateOnHeading = true;

  void init(Coordinate center, double zoom) {
    _center = center;
    _zoom = zoom;
  }

  Coordinate get center => _center;

  /// Set the center of the map.
  ///
  /// Notify anyone that needs to act accordingly.
  set center(Coordinate newCenter) {
    if (_center == newCenter) {
      // trigger a change in the handler
      // which would not if the coord remains the same
      _center = Coordinate(newCenter.x - 0.00000001, newCenter.y - 0.00000001);
    } else {
      _center = newCenter;
    }
    if (mapController != null) {
      mapController.move(LatLng(_center.y, _center.x), mapController.zoom);
    }
    notifyListenersMsg("set center");
  }

  double get zoom => _zoom;

  /// Set the zoom of the map.
  ///
  /// Notify anyone that needs to act accordingly.
  set zoom(double newZoom) {
    _zoom = newZoom;
    if (mapController != null) {
      mapController.move(mapController.center, newZoom);
    }
    notifyListenersMsg("set zoom");
  }

  /// Set the center and zoom of the map.
  ///
  /// Notify anyone that needs to act accordingly.
  void setCenterAndZoom(Coordinate newCenter, double newZoom) {
    _center = newCenter;
    _zoom = newZoom;
    if (mapController != null) {
      mapController.move(LatLng(newCenter.y, newCenter.x), newZoom);
    }
    notifyListenersMsg("setCenterAndZoom");
  }

  /// Set the map bounds to a given envelope.
  ///
  /// Notify anyone that needs to act accordingly.
  void setBounds(Envelope envelope) {
    if (mapController != null) {
      mapController.fitBounds(LatLngBounds(
        LatLng(envelope.getMinY(), envelope.getMinX()),
        LatLng(envelope.getMaxY(), envelope.getMaxX()),
      ));
      notifyListenersMsg("setBounds");
    }
  }

  double get heading => _heading;

  set heading(double heading) {
    _heading = heading;
    if (mapController != null) {
      if (rotateOnHeading) {
        if (heading < 0) {
          heading = 360 + heading;
        }
        mapController.rotate(-heading);
      } else {
        mapController.rotate(0);
      }
    }
    notifyListenersMsg("set heading");
  }

  /// Store the last position in memory and to the preferences.
  void setLastPosition(Coordinate newCenter, double newZoom) {
    _center = newCenter;
    _zoom = newZoom;
    GpPreferences().setLastPosition(_center.x, _center.y, newZoom);
  }

  bool get centerOnGps => _centerOnGps;

  set centerOnGpsQuiet(bool newCenterOnGps) {
    _centerOnGps = newCenterOnGps;
    GpPreferences().setCenterOnGps(newCenterOnGps);
  }

  set centerOnGps(bool newCenterOnGps) {
    centerOnGpsQuiet = newCenterOnGps;
    notifyListenersMsg("centerOnGps");
  }

  bool get rotateOnHeading => _rotateOnHeading;

  set rotateOnHeadingQuiet(bool newRotateOnHeading) {
    _rotateOnHeading = newRotateOnHeading;
    GpPreferences().setRotateOnHeading(newRotateOnHeading);
  }

  set rotateOnHeading(bool newRotateOnHeading) {
    rotateOnHeadingQuiet = newRotateOnHeading;
    notifyListenersMsg("rotateOnHeading");
  }
}

/// The provider object of the current project status
///
/// This provides the project database and triggers notification when that changes.
class ProjectState extends ChangeNotifierPlus {
  String _projectPath;
  GeopaparazziProjectDb _db;
  ProjectData _projectData;

  String get projectPath => _projectPath;

  GeopaparazziProjectDb get projectDb => _db;

  ProjectData get projectData => _projectData;

  void setNewProject(String path) async {
    GpLogger().d("Set new project: $path");
    await close();
    _projectPath = path;
    await openDb(_projectPath);

    notifyListenersMsg("setNewProject");
  }

  Future<void> openDb([String projectPath]) async {
    _projectPath = projectPath;
    if (_projectPath == null) {
      _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
      GpLogger().d("Read db path from preferences: $_projectPath");
    }
    if (_projectPath == null) {
      GpLogger().w("No project path found creating default");
      var projectsFolder = await Workspace.getProjectsFolder();
      _projectPath = FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
    }
    try {
      GpLogger().d("Opening db $_projectPath...");
      _db = GeopaparazziProjectDb(_projectPath);
      await _db.openOrCreate();
      GpLogger().d("Db opened: $_projectPath");
    } catch (e) {
      GpLogger().e("Error opening project db: ", e);
    }

    await _db.createNecessaryExtraTables();
    await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
  }

  Future<void> close() async {
    if (_db != null && _db.isOpen()) {
      await _db.close();
      GpLogger().d("Closed db: ${_db.path}");
    }
    _db = null;
    _projectPath = null;
  }

  Future<void> reloadProject(BuildContext context) async {
    if (projectDb == null) return;
    await reloadProjectQuiet(context);
    notifyListenersMsg('reloadProject');
  }

  Future<void> reloadProjectQuiet(BuildContext context) async {
    if (projectDb == null) return;
    ProjectData tmp = ProjectData();
    tmp.projectName = basenameWithoutExtension(projectDb.path);
    tmp.projectDirName = dirname(projectDb.path);
    tmp.simpleNotesCount = await projectDb.getSimpleNotesCount(false);
    var imageNotescount = await projectDb.getImagesCount(false);
    tmp.simpleNotesCount += imageNotescount;
    tmp.logsCount = await projectDb.getGpsLogCount(false);
    tmp.formNotesCount = await projectDb.getFormNotesCount(false);

    List<Marker> tmpList = [];
    DataLoaderUtilities.loadImageMarkers(projectDb, tmpList, this, context);
    DataLoaderUtilities.loadNotesMarkers(projectDb, tmpList, this, context);
    tmp.geopapMarkers = tmpList;
    tmp.geopapLogs = await DataLoaderUtilities.loadLogLinesLayer(projectDb);
    _projectData = tmp;
  }
}

class ProjectData {
  String projectName;
  String projectDirName;
  int simpleNotesCount;
  int logsCount;
  int formNotesCount;
  List<Marker> geopapMarkers;
  PolylineLayerOptions geopapLogs;
}
