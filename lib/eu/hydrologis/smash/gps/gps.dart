/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:dart_jts/dart_jts.dart' hide Position, Distance;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_progress_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';

/// Utilities to work with coordinates.
class CoordinateUtilities {
  /// Get the distance between two latlong coordinates in meters, if not otherwise specified by [unit].
  static double getDistance(LatLng ll1, LatLng ll2, {unit: LengthUnit.Meter}) {
    final Distance distance = Distance();
    return distance.as(unit, ll1, ll2);
  }

  /// Get the offset coordinate given a starting point, a distance in meters and an azimuth angle.
  static LatLng getAtOffset(
      LatLng coordinate, double distanceInMeter, double azimuth) {
    final Distance distance = Distance();
    return distance.offset(coordinate, distanceInMeter, azimuth);
  }
}

enum GpsStatus { OFF, NOPERMISSION, ON_NO_FIX, ON_WITH_FIX, LOGGING }

const MAX_DELTA_FOR_FIX = 15000.0;

/// Interface to handle position updates
abstract class PositionListener {
  /// Launched whenever a new [position] comes in.
  void onPositionUpdate(Position position);

  // Launched whenever a new gps status is triggered.
  void setStatus(GpsStatus currentStatus);
}

abstract class GpsLoggingHandler {
  void addLogPoint(int logId, double longitude, double latitude,
      double altitude, int timestamp);

  Future<int> addGpsLog(String logName);

  Future<void> stopLogging(int logId);
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

  bool _locationServiceEnabled;

  Timer _timer;
  GpsState _gpsState;
  Position _previousLogPosition;

  int _lastGpsEventTs;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
  }

  void init(GpsState initGpsState) async {
    printGps("init GpsHandler");
    _gpsState = initGpsState;
    _locationServiceEnabled = false;

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (_geolocator == null) {
        _geolocator = Geolocator();
        printGps("Initialize geolocator");
      }
      _locationServiceEnabled = await _geolocator.isLocationServiceEnabled();
      var currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
//      printGps("Current time: $currentTimeMillis");

      if (_geolocator == null || !_locationServiceEnabled) {
        if (_gpsState.status != GpsStatus.OFF) {
          _gpsState.status = GpsStatus.OFF;
        }
      } else if (currentTimeMillis - _lastGpsEventTs > MAX_DELTA_FOR_FIX) {
//        printGps("Setting NO FIX due to delta: ${currentTimeMillis - _lastGpsEventTs}");
        // if for 5 seconds there is no gps event, we can assume it has no fix
        if (_gpsState.status != GpsStatus.ON_NO_FIX) {
          _gpsState.status = GpsStatus.ON_NO_FIX;
        }
      }

      if (_positionStreamSubscription == null) {
        printGps("GpsHandler: subscribe to gps");
        const LocationOptions locationOptions = LocationOptions(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        );
        final Stream<Position> positionStream =
            _geolocator.getPositionStream(locationOptions);
        _positionStreamSubscription = positionStream
            .listen((Position position) => _onPositionUpdate(position));
      }

//      GpLogger().d(
//          "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(currentTimeMillis))}: Timer.periodic -> enabled: $_locationServiceEnabled; geoloc null: ${_geolocator == null}; gpsState: ${_gpsState.status}");
      // other status cases are handled by the events themselves in _onPositionUpdate
    });

    // TODO check back on this
//    if (Platform.isAndroid) {
//      _geolocator.forceAndroidLocationManager = true;
//    }
  }

  /// Returns true if the gps currently has a fix or is logging.
  bool hasFix() {
    var hasFix = _gpsState.status == GpsStatus.ON_WITH_FIX;
    var isLogging = _gpsState.status == GpsStatus.LOGGING;
    return hasFix || isLogging;
  }

  // Checks if the gps is on or off.
  bool isGpsOn() {
    if (_geolocator == null) return false;
    return _locationServiceEnabled;
  }

  void _onPositionUpdate(Position position) {
//    printGps("Incoming position $position");

    if (_gpsState.doTestLog) {
      var c = Testlog.getNext();
      Position newP = Position(
        latitude: c.y,
        longitude: c.x,
        heading: c.z,
        accuracy: 2,
        altitude: 100,
        speed: 2,
        timestamp: DateTime.now(),
        mocked: true,
      );
      position = newP;
//      printGps("Modify with testing position: $position");
    }

    if (!_locationServiceEnabled) {
      printGps("Location service is disabled.");
      return;
    }

    // set last event ts that is used to define the 'no fix' interval
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
//    printGps("Setting _lastGpsEventTs: $_lastGpsEventTs");

    if (position != null) {
      var tmpStatus =
          _gpsState.isLogging ? GpsStatus.LOGGING : GpsStatus.ON_WITH_FIX;
//      printGps("Tmp status: $tmpStatus");

      var newPosLatLon = LatLng(position.latitude, position.longitude);

      if (_previousLogPosition != null) {
        // first filter out jumps using the max distance.
        // Those points are defined as invalid and are ignored in general
        var previousPosLatLon = LatLng(_gpsState.lastGpsPosition.latitude,
            _gpsState.lastGpsPosition.longitude);
        var distanceLastEvent =
            CoordinateUtilities.getDistance(previousPosLatLon, newPosLatLon);
        if (distanceLastEvent > _gpsState.gpsMaxDistance) {
          printGps(
              "Ignoring GPS point jump: $distanceLastEvent > ${_gpsState.gpsMaxDistance}");
          _gpsState.lastGpsPosition = position;
          return;
        }

        // find values for filter checks
        var previousLoggedPosLatLon = LatLng(
            _previousLogPosition.latitude, _previousLogPosition.longitude);
        var distanceLastLogged = CoordinateUtilities.getDistance(
            previousLoggedPosLatLon, newPosLatLon);
        var deltaSecondsLastLogged =
            (position.timestamp.millisecondsSinceEpoch -
                    _previousLogPosition.timestamp.millisecondsSinceEpoch) /
                1000;

//        GpLogger().d(
//            "distanceLastLogged > _gpsState.gpsMinDistance && deltaSeconds > _gpsState.gpsTimeInterval\n--> $distanceLastLogged > ${_gpsState.gpsMinDistance} && $deltaSecondsLastLogged > ${_gpsState.gpsTimeInterval}");

        // apply filters and if ok, add point to log
        if (distanceLastLogged > _gpsState.gpsMinDistance &&
            deltaSecondsLastLogged > _gpsState.gpsTimeInterval) {
          if (_gpsState.isLogging && _gpsState.currentLogId != null) {
            _gpsState.currentLogPoints.add(newPosLatLon);
            _gpsState.addLogPoint(position.longitude, position.latitude,
                position.altitude, position.timestamp.millisecondsSinceEpoch);
            _previousLogPosition = position;
          }
        }
      } else {
        // set first 'previous'
        _previousLogPosition = position;
      }

      // gps information is set at every event
      _gpsState.status = tmpStatus;
      _gpsState.lastGpsPosition = position;
    }
  }

  /// Close the handler.
  void close() {
    if (_timer != null) _timer.cancel();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    if (_locationServiceEnabled) return;
  }

  printGps(String msg) {
    GpLogger().d(msg);
  }
}
