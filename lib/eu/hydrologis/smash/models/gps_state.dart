/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:collection';
import 'dart:math';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/util/notifier.dart';

/// Current Gps Status.
///
/// Provides tracking of position and parameters related to GPS state.
class GpsState extends ChangeNotifierPlus {
  GpsStatus _status = GpsStatus.NOGPS;
  SmashPosition _lastPosition;

  bool _isLogging = false;
  int _currentLogId;
  ProjectState _projectState;

  /// the gps insertion mode for notes. This can be GPS or map center.
  int _insertInGpsMode = POINT_INSERTION_MODE_GPS;

  /// Use the iltered GPS instead of the original GPS.
  bool _useFilteredGps;

  int gpsMinDistance = 1;
  int gpsTimeInterval = 1;
  bool doTestLog = false;

  List<LatLng> _currentLogPoints = [];
  double _currentLogProgressive;
  double _currentFilteredLogProgressive;
  int _currentLogTimeDeltaMillis;
  int _currentLogTimeInitMillis;
  double _currentSpeedInMs;
  List<dynamic> _lastProgAndAltitudes = [];
  List<LatLng> _currentFilteredLogPoints = [];

  String logMode;
  String filteredLogMode;
  String notesMode;

  GpsStatus _lastGpsStatusBeforeLogging;

  void init() {
    gpsMinDistance = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_GPS_MIN_DISTANCE, 1);
    gpsTimeInterval = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_GPS_TIMEINTERVAL, 1);
    doTestLog = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_GPS_TESTLOG, false);

    List<String> currentLogViewModes = GpPreferences().getStringListSync(
        SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE, [
      SmashPreferencesKeys.LOGVIEWMODES[0],
      SmashPreferencesKeys.LOGVIEWMODES[1]
    ]);
    logMode = currentLogViewModes[0];
    filteredLogMode = currentLogViewModes[1];
    notesMode = GpPreferences().getStringSync(
        SmashPreferencesKeys.KEY_NOTES_VIEW_MODE,
        SmashPreferencesKeys.NOTESVIEWMODES[0]);
  }

  GpsStatus get status => _status;

  SmashPosition get lastGpsPosition => _lastPosition;

  set lastGpsPosition(SmashPosition position) {
    _lastPosition = position;
    notifyListeners(); //Msg("lastGpsPosition");
  }

  set lastGpsPositionQuiet(SmashPosition position) {
    _lastPosition = position;
  }

  /// Set the status without triggering a global notification.
  set statusQuiet(GpsStatus newStatus) {
    _status = newStatus;
  }

  set status(GpsStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners(); //Msg("status");
    }
  }

  int get insertInGpsMode => _insertInGpsMode;

  bool get useFilteredGps {
    if (_useFilteredGps == null) {
      _useFilteredGps = GpPreferences().getBooleanSync(
          SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, false);
    }
    return _useFilteredGps;
  }

  bool get isLogging => _isLogging;

  int get currentLogId => _currentLogId;

  /// Set the _insertInGps without triggering a global notification.
  set useFilteredGpsQuiet(bool newUseFilteredGps) {
    _useFilteredGps = newUseFilteredGps;
  }

  /// Set the _insertInGps without triggering a global notification.
  set insertInGpsQuiet(int newInsertInGpsMode) {
    if (_insertInGpsMode != newInsertInGpsMode) {
      _insertInGpsMode = newInsertInGpsMode;
    }
  }

  set insertInGpsMode(int newInsertInGpsMode) {
    if (_insertInGpsMode != newInsertInGpsMode) {
      insertInGpsQuiet = newInsertInGpsMode;
      notifyListenersMsg("insertInGps");
    }
  }

  set projectState(ProjectState state) {
    _projectState = state;
  }

  void addLogPoint(double longitude, double latitude, double altitude,
      int timestamp, double accuracy, double speed,
      {double longitudeFiltered,
      double latitudeFiltered,
      double accuracyFiltered}) {
    if (_projectState != null) {
      LogDataPoint ldp = LogDataPoint();
      ldp.logid = currentLogId;
      ldp.lon = longitude;
      ldp.lat = latitude;
      ldp.altim = altitude;
      ldp.ts = timestamp;
      ldp.accuracy = accuracy;
      ldp.filtered_accuracy = accuracyFiltered;
      ldp.filtered_lat = latitudeFiltered;
      ldp.filtered_lon = longitudeFiltered;
      ldp.speed = speed;
      _projectState.projectDb.addGpsLogPoint(currentLogId, ldp);
    }

    if (_currentLogProgressive == null) {
      _currentLogProgressive = 0.0;
      _currentFilteredLogProgressive = 0.0;
    }
    // original log
    var newPosLatLon = LatLng(latitude, longitude);
    if (_currentLogPoints.isNotEmpty) {
      var distanceMeters =
          CoordinateUtilities.getDistance(_currentLogPoints.last, newPosLatLon);
      _currentLogProgressive += distanceMeters;
    }
    _currentLogPoints.add(newPosLatLon);

    // filtered log
    if (latitudeFiltered != null) {
      var newFilteredPosLatLon = LatLng(latitudeFiltered, longitudeFiltered);
      if (_currentFilteredLogPoints.isNotEmpty) {
        var distanceMeters = CoordinateUtilities.getDistance(
            _currentFilteredLogPoints.last, newFilteredPosLatLon);
        _currentFilteredLogProgressive += distanceMeters;
      }
      _currentFilteredLogPoints.add(newFilteredPosLatLon);
    }

    // time delta
    if (_currentLogTimeInitMillis == null) {
      _currentLogTimeInitMillis = timestamp;
    }
    _currentLogTimeDeltaMillis = timestamp - _currentLogTimeInitMillis;

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
    if (_projectState != null) {
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
      var logId = _projectState.projectDb.addGpsLog(l, lp);
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
  int startLogging(String logName) {
    try {
      var logId = addGpsLog(logName);
      _currentLogId = logId;
      _isLogging = true;

      _lastGpsStatusBeforeLogging = _status;
      _status = GpsStatus.LOGGING;

      notifyListenersMsg("startLogging");

      return logId;
    } on Exception catch (e, s) {
      SMLogger().e("Error creating new gps log", e, s);
      return null;
    }
  }

  /// Get the list of current log points.
  List<LatLng> get currentLogPoints => _currentLogPoints;
  List<LatLng> get currentFilteredLogPoints => _currentFilteredLogPoints;

  /// Stop logging to database.
  ///
  /// This also properly closes the recorded log.
  void stopLogging() {
    _isLogging = false;
    _currentLogPoints.clear();
    _currentFilteredLogPoints.clear();
    _currentLogProgressive = null;
    _currentFilteredLogProgressive = null;
    _currentLogTimeDeltaMillis = null;
    _currentLogTimeInitMillis = null;

    if (_projectState != null) {
      int endTs = DateTime.now().millisecondsSinceEpoch;
      _projectState.projectDb.updateGpsLogEndts(_currentLogId, endTs);
    }

    if (_lastGpsStatusBeforeLogging == null)
      _lastGpsStatusBeforeLogging = GpsStatus.ON_NO_FIX;
    _status = _lastGpsStatusBeforeLogging;
    _lastGpsStatusBeforeLogging = null;
    notifyListenersMsg("stopLogging");
  }

  bool hasFix() {
    return _status == GpsStatus.ON_WITH_FIX || _status == GpsStatus.LOGGING;
  }
}
