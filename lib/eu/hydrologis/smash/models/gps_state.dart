/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:background_locator/location_dto.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';
import 'package:smash/eu/hydrologis/smash/util/notifier.dart';

/// Current Gps Status.
///
/// Provides tracking of position and parameters related to GPS state.
class GpsState extends ChangeNotifierPlus {
  GpsStatus _status = GpsStatus.OFF;
  SmashPosition _lastPosition;

  bool _isLogging = false;
  int _currentLogId;
  ProjectState _projectState;
  bool _insertInGps = true;

  int gpsMinDistance = 1;
  int gpsMaxDistance = 100;
  int gpsTimeInterval = 1;
  bool doTestLog = false;

  List<LatLng> _currentLogPoints = [];
  GpsStatus _lastGpsStatusBeforeLogging;

  void init() {
    gpsMinDistance = GpPreferences().getIntSync(KEY_GPS_MIN_DISTANCE, 1);
    gpsMaxDistance = GpPreferences().getIntSync(KEY_GPS_MAX_DISTANCE, 100);
    gpsTimeInterval = GpPreferences().getIntSync(KEY_GPS_TIMEINTERVAL, 1);
    doTestLog = GpPreferences().getBooleanSync(KEY_GPS_TESTLOG, false);
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

  bool get insertInGps => _insertInGps;

  bool get isLogging => _isLogging;

  int get currentLogId => _currentLogId;

  /// Set the _insertInGps without triggering a global notification.
  set insertInGpsQuiet(bool newInsertInGps) {
    if (_insertInGps != newInsertInGps) {
      _insertInGps = newInsertInGps;
      GpPreferences().setBoolean(KEY_DO_NOTE_IN_GPS, newInsertInGps);
    }
  }

  set insertInGps(bool newInsertInGps) {
    if (_insertInGps != newInsertInGps) {
      insertInGpsQuiet = newInsertInGps;
      notifyListenersMsg("insertInGps");
    }
  }

  set projectState(ProjectState state) {
    _projectState = state;
  }

  Future<void> addLogPoint(
      double longitude, double latitude, double altitude, int timestamp) async {
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
