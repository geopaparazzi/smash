/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:latlong/latlong.dart';
import 'package:location_permissions/location_permissions.dart';

enum GpsStatus { OFF, NOPERMISSION, ON_NO_FIX, ON_WITH_FIX, LOGGING }

/// Interface to handle position updates
abstract class PositionListener {
  /// Launched whenever a new [position] comes in.
  void onPositionUpdate(Position position);

  // Launched whenever a new gps status is triggered.
  void setStatus(GpsStatus currentStatus);
}

/// A central GPS handling class.
///
/// This is used to:
/// * initialize and terminate the location service
/// * registre for updates through the [PositionListener] interface
/// * handle the GPS logging
///
class GpsHandler {
  static final GpsHandler _instance = GpsHandler._internal();
  Geolocator _geolocator;
  StreamSubscription<Position> _positionStreamSubscription;
  GpsStatus _gpsStatus = GpsStatus.OFF;
  GpsStatus _lastGpsStatusBeforeLogging;

  Position _lastPosition;

  List<PositionListener> positionListeners = [];

  bool _locationDisabled;
  bool _isLogging = false;
  int _currentLogId;
  List<LatLng> _currentLogPoints = [];
  Timer _timer;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _init();

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) async {
      if (_geolocator != null &&
          !await _geolocator.isLocationServiceEnabled()) {
        if (GpsStatus.OFF != _gpsStatus) {
          _gpsStatus = GpsStatus.OFF;
          positionListeners.forEach((PositionListener pl) {
            pl.setStatus(_gpsStatus);
          });
        }
      }
    });
  }

  void _init() async {
    _geolocator = Geolocator();
    if (Platform.isAndroid) {
      _geolocator.forceAndroidLocationManager = true;
    }

    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0);
      final Stream<Position> positionStream =
          _geolocator.getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream
          .listen((Position position) => _onPositionUpdate(position));
    }
    _locationDisabled = false;
  }

  /// Returns true if the gps currently has a fix or is logging.
  bool hasFix() {
    var hasFix = _gpsStatus == GpsStatus.ON_WITH_FIX;
    var isLogging = _gpsStatus == GpsStatus.LOGGING;
    return hasFix || isLogging;
  }

  // Getter for the last available position.
  Position get lastPosition => _lastPosition;

  // Checks if the gps is on or off.
  Future<bool> isGpsOn() async {
    if (_geolocator == null) return null;
    return await _geolocator.isLocationServiceEnabled();
  }

  void _onPositionUpdate(Position position) {
    if (_locationDisabled) return;
    GpsStatus tmpStatus;
    if (position != null) {
      tmpStatus = GpsStatus.ON_WITH_FIX;

      if (_isLogging && _currentLogId != null) {
        tmpStatus = GpsStatus.LOGGING;
//        if(_lastPosition!=null && _geolocator.distanceBetween(_lastPosition.latitude, _lastPosition.longitude, position.latitude,
//            position.longitude) > 1)
        _currentLogPoints.add(LatLng(position.latitude, position.longitude));
        gpProjectModel.getDatabase().then((db) {
          LogDataPoint ldp = new LogDataPoint();
          ldp.logid = _currentLogId;
          ldp.lon = position.longitude;
          ldp.lat = position.latitude;
          ldp.altim = position.altitude;
          ldp.ts = DateTime.now().millisecondsSinceEpoch;

          db.addGpsLogPoint(_currentLogId, ldp);
        });
      }
    } else {
      tmpStatus = GpsStatus.ON_NO_FIX;
    }

    if (tmpStatus != null) {
      _gpsStatus = tmpStatus;
      positionListeners.forEach((PositionListener pl) {
        pl.onPositionUpdate(position);
        pl.setStatus(_gpsStatus);
      });
    }

    _lastPosition = position;
  }

  /// Registers a new listener to position updates.
  void addPositionListener(PositionListener listener) {
    if (_locationDisabled) return;
    if (!positionListeners.contains(listener)) {
      positionListeners.add(listener);
    }
  }

  /// Unregisters a listener from position updates.
  void removePositionListener(PositionListener listener) {
    if (positionListeners.contains(listener)) {
      positionListeners.remove(listener);
    }
  }

  /// Close the handler.
  void close() {
    if (_timer != null) _timer.cancel();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    if (_locationDisabled) return;
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
      var db = await gpProjectModel.getDatabase();
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

      var logId = await db.addGpsLog(l, lp);
      _currentLogId = logId;
      _isLogging = true;

      _lastGpsStatusBeforeLogging = _gpsStatus;
      _gpsStatus = GpsStatus.LOGGING;
      positionListeners.forEach((PositionListener pl) {
        pl.setStatus(_gpsStatus);
      });

      return logId;
    } catch (e) {
      return null;
    }
  }

  /// Checks if the application is currently logging.
  bool get isLogging => _isLogging;

  /// Get the list of current log points.
  List<LatLng> get currentLogPoints => _currentLogPoints;

  /// Stop logging to database.
  ///
  /// This also properly closes the recorded log.
  void stopLogging() async {
    var db = await gpProjectModel.getDatabase();
    _isLogging = false;
    _currentLogPoints.clear();
    int endTs = DateTime.now().millisecondsSinceEpoch;
    await db.updateGpsLogEndts(_currentLogId, endTs);

    if (_lastGpsStatusBeforeLogging == null)
      _lastGpsStatusBeforeLogging = GpsStatus.ON_NO_FIX;
    _gpsStatus = _lastGpsStatusBeforeLogging;
    _lastGpsStatusBeforeLogging = null;
    positionListeners.forEach((PositionListener pl) {
      pl.setStatus(_gpsStatus);
    });
  }

  Future<double> getDistanceMeters(Position p1, Position p2) async {
    if (_geolocator != null) {
      var distanceBetween = await _geolocator.distanceBetween(
          p1.latitude, p1.longitude, p2.latitude, p2.longitude);
      return distanceBetween;
    } else {
      return null;
    }
  }
}
