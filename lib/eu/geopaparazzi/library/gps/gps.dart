/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/logs.dart';
import 'package:latlong/latlong.dart';

enum GpsStatus { OFF, NOPERMISSION, ON_NO_FIX, ON_WITH_FIX, LOGGING }

abstract class PositionListener {
  void onPositionUpdate(Position position);

  void setStatus(GpsStatus currentStatus);
}

class LocationPermissionHandler {
  static bool permissionGranted = false;

  Future<bool> requestPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    permissionGranted = permission == PermissionStatus.granted;
    return permissionGranted;
  }
}

class GpsHandler {
  static final GpsHandler _instance = GpsHandler._internal();
  Geolocator _geolocator;
  StreamSubscription<Position> _positionStreamSubscription;
  GpsStatus _gpsStatus = GpsStatus.OFF;

  Position _lastPosition;

  List<PositionListener> positionListeners = [];

  bool _locationDisabled;
  bool _isLogging = false;
  int _currentLogId;
  List<LatLng> _currentLogPoints = [];
  Timer _timer;

  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _init();

    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
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
    if (LocationPermissionHandler.permissionGranted) {
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
            .listen((Position position) => onPositionUpdate(position));
      }
      _locationDisabled = false;
    } else {
      _locationDisabled = true;
      _gpsStatus = GpsStatus.NOPERMISSION;
    }
  }

  void onPositionUpdate(Position position) {
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

          addGpsLogPoint(db, _currentLogId, ldp);
        });
      }
    } else {
      tmpStatus = GpsStatus.ON_NO_FIX;
    }
    if (tmpStatus != _gpsStatus) {
      _gpsStatus = tmpStatus;
    } else {
      tmpStatus = null;
    }
    positionListeners.forEach((PositionListener pl) {
      pl.onPositionUpdate(position);
      if (tmpStatus != null) pl.setStatus(tmpStatus);
    });

    _lastPosition = position;
  }

  void addPositionListener(PositionListener listener) {
    if (_locationDisabled) return;
    if (!positionListeners.contains(listener)) {
      positionListeners.add(listener);
    }
  }

  void removePositionListener(PositionListener listener) {
    if (positionListeners.contains(listener)) {
      positionListeners.remove(listener);
    }
  }

  void close() {
    if (_timer != null) _timer.cancel();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    if (_locationDisabled) return;
  }

  void startLogging(String logName) {
    gpProjectModel.getDatabase().then((db) {
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

      addGpsLog(db, l, lp).then((logId) {
        _currentLogId = logId;
        _isLogging = true;
      });
    });
  }

  bool get isLogging => _isLogging;

  List<LatLng> get currentLogPoints => _currentLogPoints;

  void stopLogging() {
    gpProjectModel.getDatabase().then((db) {
      _isLogging = false;
      _currentLogPoints.clear();
      int endTs = DateTime.now().millisecondsSinceEpoch;
      updateGpsLogEndts(db, _currentLogId, endTs);
    });
  }
}
