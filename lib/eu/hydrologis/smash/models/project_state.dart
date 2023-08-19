/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

/// The provider object of the current project status
///
/// This provides the project database and triggers notification when that changes.
class ProjectState extends ChangeNotifierPlus {
  String _projectName = "No project loaded";
  String? _projectPath;
  GeopaparazziProjectDb? _db;
  ProjectData? _projectData;

  String? get projectPath => _projectPath;

  String get projectName => _projectName;

  GeopaparazziProjectDb? get projectDb => _db;

  ProjectData? get projectData => _projectData;

  bool _isLogging = false;
  int? _currentLogId;

  List<Coordinate> _currentLogPoints = [];
  double? _currentLogProgressive;
  double? _currentFilteredLogProgressive;
  int? _currentLogTimeDeltaMillis;
  int? _currentLogTimeInitMillis;
  double? _currentSpeedInMs;
  List<dynamic> _lastProgAndAltitudes = [];
  List<Coordinate> _currentFilteredLogPoints = [];
  GpsStatus? _lastGpsStatusBeforeLogging;

  Future<void> setNewProject(String path, BuildContext context) async {
    SMLogger().i("Set new project: $path");
    close();
    _projectPath = path;
    await openDb(_projectPath!);
    await GpPreferences().addRecentProject(path);
    reloadProject(context);
  }

  Future<void> openDb([String? projectPath]) async {
    _projectPath = projectPath;
    if (_projectPath == null) {
      _projectPath = await GpPreferences()
          .getString(SmashPreferencesKeys.KEY_LAST_GPAPPROJECT);
      SMLogger().i("Read db path from preferences: $_projectPath");
    }
    if (_projectPath == null) {
      SMLogger().w("No project path found creating default");
      var projectsFolder = await Workspace.getProjectsFolder();
      _projectPath = FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
    }
    try {
      SMLogger().i("Opening db $_projectPath...");
      _db = GeopaparazziProjectDb(_projectPath);
      _db?.open();
      SMLogger().i("Db opened: $_projectPath");
    } on Exception catch (e, s) {
      SMLogger().e("Error opening project db: ", e, s);
    }

    _db?.createNecessaryExtraTables();
    await GpPreferences()
        .setString(SmashPreferencesKeys.KEY_LAST_GPAPPROJECT, _projectPath!);
    _projectName = FileUtilities.nameFromFile(_projectPath!, false);
  }

  void close() {
    if (_db != null && _db!.isOpen()) {
      _db!.close();
      SMLogger().i("Closed db: ${_db!.path}");
    }
    _db = null;
    _projectPath = null;
  }

  void reloadProject(BuildContext context) {
    if (projectDb == null) return;
    var mapBuilder = Provider.of<SmashMapBuilder>(context, listen: false);
    mapBuilder.context = context;
    reloadProjectQuiet(mapBuilder);
    mapBuilder.reBuild();
  }

  /// Reloads the project data but doesn't tigger a map build
  void reloadProjectQuiet(SmashMapBuilder mapBuilder) {
    if (projectDb == null) return;
    ProjectData tmp = ProjectData();
    tmp.projectName = basenameWithoutExtension(projectDb!.path!);
    tmp.projectDirName = dirname(projectDb!.path!);
    tmp.simpleNotesCount = projectDb!.getSimpleNotesCount(false);
    int imageNotescount = projectDb!.getImagesCount(false);
    tmp.simpleNotesCount = tmp.simpleNotesCount! + imageNotescount;
    tmp.logsCount = projectDb!.getGpsLogCount(false);
    tmp.formNotesCount = projectDb!.getFormNotesCount(false);

    List<Marker> tmpList = [];
    DataLoaderUtilities.loadImageMarkers(projectDb!, tmpList, mapBuilder);
    var notesMode = GpPreferences().getStringSync(
            SmashPreferencesKeys.KEY_NOTES_VIEW_MODE,
            SmashPreferencesKeys.NOTESVIEWMODES[0]) ??
        SmashPreferencesKeys.NOTESVIEWMODES[0];
    DataLoaderUtilities.loadNotesMarkers(
        projectDb!, tmpList, mapBuilder, notesMode);

    var markerCluster = MarkerClusterLayerWidget(
      key: ValueKey("SMASH_NOTES_MARKERCLUSTER"),
      options: MarkerClusterLayerOptions(
        zoomToBoundsOnClick: false,
        // spiderfyCircleRadius: 150,
        disableClusteringAtZoom: 16,
        maxClusterRadius: 80,
        //        height: 40,
        //        width: 40,
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(180),
        ),
        markers: tmpList,
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
      ),
    );
    tmp.geopapMarkers = markerCluster;

    List<String> currentLogViewModes = GpPreferences().getStringListSync(
            SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE, [
          SmashPreferencesKeys.LOGVIEWMODES[0],
          SmashPreferencesKeys.LOGVIEWMODES[1]
        ]) ??
        [
          SmashPreferencesKeys.LOGVIEWMODES[0],
          SmashPreferencesKeys.LOGVIEWMODES[1]
        ];
    var logMode = currentLogViewModes[0];
    var filteredLogMode = currentLogViewModes[1];
    tmp.geopapLogs = DataLoaderUtilities.loadLogLinesLayer(
      projectDb!,
      logMode != SmashPreferencesKeys.LOGVIEWMODES[0],
      filteredLogMode != SmashPreferencesKeys.LOGVIEWMODES[0],
      logMode == SmashPreferencesKeys.LOGVIEWMODES[2],
      filteredLogMode == SmashPreferencesKeys.LOGVIEWMODES[2],
    );
    _projectData = tmp;
  }

  bool get isLogging => _isLogging;

  int? get currentLogId => _currentLogId;

  void addLogPoint(double longitude, double latitude, double altitude,
      int timestamp, double accuracy, double speed,
      {double? longitudeFiltered,
      double? latitudeFiltered,
      double? accuracyFiltered}) {
    LogDataPoint ldp = LogDataPoint();
    ldp.logid = currentLogId;

    /// Update the project's dirtyness state.
    ///
    /// The notes, images and logs are set to be dirty (i.e. synched)
    /// if [doDirty] is true. They are set to be clean (i.e. ignored
    /// by synch), is false.
    ldp.lon = longitude;
    ldp.lat = latitude;
    ldp.altim = altitude;
    ldp.ts = timestamp;
    ldp.accuracy = accuracy;
    ldp.filtered_accuracy = accuracyFiltered;
    ldp.filtered_lat = latitudeFiltered;
    ldp.filtered_lon = longitudeFiltered;
    ldp.speed = speed;
    projectDb?.addGpsLogPoint(currentLogId!, ldp);

    if (_currentLogProgressive == null) {
      _currentLogProgressive = 0.0;
      _currentFilteredLogProgressive = 0.0;
    }
    // original log
    var newPosLatLon = Coordinate.fromYX(latitude, longitude);
    if (_currentLogPoints.isNotEmpty) {
      var distanceMeters =
          CoordinateUtilities.getDistance(_currentLogPoints.last, newPosLatLon);
      _currentLogProgressive = _currentLogProgressive! + distanceMeters;
    }
    _currentLogPoints.add(newPosLatLon);

    // filtered log
    if (latitudeFiltered != null) {
      var newFilteredPosLatLon =
          Coordinate.fromYX(latitudeFiltered, longitudeFiltered!);
      if (_currentFilteredLogPoints.isNotEmpty) {
        var distanceMeters = CoordinateUtilities.getDistance(
            _currentFilteredLogPoints.last, newFilteredPosLatLon);
        _currentFilteredLogProgressive =
            _currentFilteredLogProgressive! + distanceMeters;
      }
      _currentFilteredLogPoints.add(newFilteredPosLatLon);
    }

    // time delta
    if (_currentLogTimeInitMillis == null) {
      _currentLogTimeInitMillis = timestamp;
    }
    _currentLogTimeDeltaMillis = timestamp - _currentLogTimeInitMillis!;

    _currentSpeedInMs = speed;

    _lastProgAndAltitudes.add([_currentLogProgressive, altitude]);
    if (_lastProgAndAltitudes.length > 100) {
      _lastProgAndAltitudes.removeAt(0);
    }
  }

  /// Get the stats of the current log.
  List<dynamic> getCurrentLogStats() {
    return [
      _currentLogProgressive,
      _currentFilteredLogProgressive,
      _currentLogTimeDeltaMillis,
      _currentSpeedInMs,
      _lastProgAndAltitudes,
    ];
  }

  int addGpsLog(String logName) {
    _currentLogProgressive = null;
    _currentFilteredLogProgressive = null;
    _currentLogTimeDeltaMillis = null;
    _currentLogTimeInitMillis = null;
    _currentSpeedInMs = null;
    Log l = new Log();
    l.text = logName;
    l.startTime = DateTime.now().millisecondsSinceEpoch;
    l.endTime = 0;
    l.isDirty = 1;
    l.lengthm = 0;
    LogProperty lp = new LogProperty();
    lp.isVisible = 1;
    lp.color = "#FF0000";
    lp.width = 3;
    var logId = projectDb?.addGpsLog(l, lp);
    if (logId != null) {
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
  int? startLogging(String logName, GpsState gpsState) {
    try {
      var logId = addGpsLog(logName);
      _currentLogId = logId;
      _isLogging = true;

      _lastGpsStatusBeforeLogging = gpsState.status;
      gpsState.status = GpsStatus.LOGGING;

      notifyListenersMsg("startLogging");

      return logId;
    } on Exception catch (e, s) {
      SMLogger().e("Error creating new gps log", e, s);
      return null;
    }
  }

  /// Get the list of current log points.
  List<Coordinate> get currentLogPoints => _currentLogPoints;
  List<Coordinate> get currentFilteredLogPoints => _currentFilteredLogPoints;

  /// Stop logging to database.
  ///
  /// This also properly closes the recorded log.
  void stopLogging(GpsState gpsState) {
    _isLogging = false;
    _currentLogPoints.clear();
    _currentFilteredLogPoints.clear();
    _currentLogProgressive = null;
    _currentFilteredLogProgressive = null;
    _currentLogTimeDeltaMillis = null;
    _currentLogTimeInitMillis = null;

    int endTs = DateTime.now().millisecondsSinceEpoch;
    projectDb?.updateGpsLogEndts(_currentLogId!, endTs);

    if (_lastGpsStatusBeforeLogging == null)
      _lastGpsStatusBeforeLogging = GpsStatus.ON_NO_FIX;
    gpsState.status = _lastGpsStatusBeforeLogging!;
    _lastGpsStatusBeforeLogging = null;
    notifyListenersMsg("stopLogging");
  }
}

class ProjectData {
  String? projectName;
  String? projectDirName;
  int? simpleNotesCount;
  int? logsCount;
  int? formNotesCount;
  MarkerClusterLayerWidget? geopapMarkers;
  PolylineLayer? geopapLogs;
}
