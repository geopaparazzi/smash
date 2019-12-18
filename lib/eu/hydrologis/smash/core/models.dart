/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/smash/widgets/dashboard_utils.dart';

/// Current GPS Logging to database Status.
///
class GpsLoggingState extends ChangeNotifier {
  bool _isLogging = false;
  int _currentLogId;

  bool get isLogging => _isLogging;

  int get currentLogId => _currentLogId;

  Future<void> stopLogging() async {}


}

/// Current Gps Status.
///
/// Provides tracking of position and parameters related to GPS state.
class GpsState extends ChangeNotifier {
  bool _insertInGps = true;

  GpsStatus _status = GpsStatus.OFF;

  bool get insertInGps => _insertInGps;

  /// Set the _insertInGps without triggering a global notification.
  void set insertInGpsQuiet(bool newInsertInGps) {
    _insertInGps = newInsertInGps;
    GpPreferences().setBoolean(KEY_DO_NOTE_IN_GPS, newInsertInGps);
  }

  void set insertInGps(bool newInsertInGps) {
    insertInGpsQuiet = newInsertInGps;
    notifyListeners();
  }

  GpsStatus get status => _status;

  /// Set the status without triggering a global notification.
  void set statusQuiet(GpsStatus newStatus) {
    _status = newStatus;
  }

  void set status(GpsStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}

/// Current state of the Map view.
///
/// This provides tracking of map view and general status.
class MapState extends ChangeNotifier {
  Coordinate _center = Coordinate(11.33140, 46.47781);
  double _zoom = 16;

  /// Defines whether the map should center on the gps position
  bool _centerOnGps = true;

  /// Defines whether the map should rotate following the gps heading
  bool _rotateOnHeading = true;

  void init(Coordinate center, double zoom) {
    _center = center;
    _zoom = zoom;
  }

  Coordinate get center => _center;

  void set center(Coordinate newCenter) {
    if (_center == newCenter) {
      // trigger a change in the handler
      // which would not if the coord remains the same
      _center = Coordinate(newCenter.x - 0.00000001, newCenter.y - 0.00000001);
    } else {
      _center = newCenter;
    }
    notifyListeners();
  }

  double get zoom => _zoom;

  void set zoom(double newZoom) {
    _zoom = newZoom;
    notifyListeners();
  }

  void setCenterAndZoom(Coordinate newCenter, double newZoom) {
    _center = newCenter;
    _zoom = newZoom;
    notifyListeners();
  }

  void setLastPosition(Coordinate newCenter, double newZoom) {
    _center = newCenter;
    _zoom = newZoom;
    GpPreferences().setLastPosition(_center.x, _center.y, newZoom);
  }

  bool get centerOnGps => _centerOnGps;

  void set centerOnGpsQuiet(bool newCenterOnGps) {
    _centerOnGps = newCenterOnGps;
    GpPreferences().setCenterOnGps(newCenterOnGps);
  }

  void set centerOnGps(bool newCenterOnGps) {
    centerOnGpsQuiet = newCenterOnGps;
    notifyListeners();
  }

  bool get rotateOnHeading => _rotateOnHeading;

  void set rotateOnHeadingQuiet(bool newRotateOnHeading) {
    _rotateOnHeading = newRotateOnHeading;
    GpPreferences().setRotateOnHeading(newRotateOnHeading);
  }

  void set rotateOnHeading(bool newRotateOnHeading) {
    rotateOnHeadingQuiet = newRotateOnHeading;
    notifyListeners();
  }
}

/// The provider object of the current project status
///
/// This provides the project database and triggers notification when that changes.
class ProjectState extends ChangeNotifier {
  String _projectPath;
  GeopaparazziProjectDb _db;

  ProjectState() {
    openDb();
  }

  String get projectPath => _projectPath;

  GeopaparazziProjectDb get projectDb => _db;

  void setNewProject(String path) async {
    GpLogger().d("Set new project: $path");
    await close();
    _projectPath = path;
    await openDb(_projectPath);

    notifyListeners();
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
}
