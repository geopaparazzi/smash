/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
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

  /// Accuracy for the location subscription
  var locationAccuracy = LocationAccuracy.best;

  /// Request to reinitialize the location subscription
  bool reInit = false;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    locationAccuracy =
        toLocationAccuracy(GpPreferences().getLocationAccuracy());
  }

  Future<void> init(GpsState initGpsState) async {
    GpLogger().d("init GpsHandler");
    _gpsState = initGpsState;
    _locationServiceEnabled = false;

    GpsFilterManager().setGpsState(_gpsState);

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (_geolocator == null) {
        _geolocator = Geolocator();
        GpLogger().d("Initialize geolocator");
      }
      _locationServiceEnabled = await _geolocator.isLocationServiceEnabled();

      if (_geolocator == null || !_locationServiceEnabled) {
        if (_gpsState.status != GpsStatus.OFF) {
          _gpsState.status = GpsStatus.OFF;
        }
      } else {
        GpsFilterManager().checkFix();
      }

      if (reInit) {
        if (_positionStreamSubscription != null) {
          // reset the listeners
          _positionStreamSubscription.cancel();
          _positionStreamSubscription = null;
        }
        reInit = false;
      }

      if (_positionStreamSubscription == null) {
        GpLogger().d("GpsHandler: subscribe to gps");

        LocationOptions locationOptions = LocationOptions(
          accuracy: locationAccuracy,
          distanceFilter: 0,
        );
        final Stream<Position> positionStream =
            _geolocator.getPositionStream(locationOptions);
        _positionStreamSubscription = positionStream
            .listen((Position position) => _onPositionUpdate(position));
      }
      // other status cases are handled by the events themselves in _onPositionUpdate
    });
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
    if (!_locationServiceEnabled) {
      GpLogger().d("Location service is disabled.");
      return;
    }
    GpsFilterManager().onNewPositionEvent(position);
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

  LocationAccuracy toLocationAccuracy(String locationAccuracy) {
    for (var value in LocationAccuracy.values) {
      var tmp = value.toString().replaceFirst("LocationAccuracy.", "");
      if ( tmp == locationAccuracy) {
        return value;
      }
    }
    throw ArgumentError("No location accuracy: " + locationAccuracy);
  }
}
