/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart' as GPS;
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:latlong/latlong.dart';
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

class SmashPosition {
  LocationDto _location;

  SmashPosition.fromLocation(this._location);

  double get latitude => _location.latitude;
  double get longitude => _location.longitude;
  double get accuracy => _location.accuracy;
  double get altitude => _location.altitude;
  double get speed => _location.speed;
  double get speedAccuracy => _location.speedAccuracy;
  double get heading => _location.heading;
  double get time => _location.time;

  @override
  String toString() {
    return """SmashPosition{
      latitude: $latitude, 
      longitude: $longitude, 
      accuracy: $accuracy, 
      altitude: $altitude, 
      speed: $speed, 
      speedAccuracy: $speedAccuracy, 
      heading: $heading, 
      time: $time
    }""";
  }

}

/// Interface to handle position updates
abstract class SmashPositionListener {
  /// Launched whenever a new [position] comes in.
  void onPositionUpdate(SmashPosition position);

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
/// * registre for updates through the [SmashPositionListener] interface
/// * handle the GPS logging
///
class GpsHandler {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port;

  static final GpsHandler _instance = GpsHandler._internal();

  bool _locationServiceEnabled;

  Timer _timer;
  GpsState _gpsState;

  /// Accuracy for the location subscription
  var locationAccuracy = LocationAccuracy.NAVIGATION;

  /// Request to reinitialize the location subscription
  bool reInit = false;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    // locationAccuracy =
    // toLocationAccuracy(GpPreferences().getLocationAccuracy());
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  Future<void> init(GpsState initGpsState) async {
    GpLogger().d("init GpsHandler");
    _gpsState = initGpsState;
    _locationServiceEnabled = false;

    GpsFilterManager().setGpsState(_gpsState);

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (port == null) {
        port = ReceivePort();
        if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
          IsolateNameServer.removePortNameMapping(_isolateName);
        }
        IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);

        port.listen((dynamic data) {
          _onPositionUpdate(SmashPosition.fromLocation(data));
        });
        // init platform state
        await GPS.BackgroundLocator.initialize();
        GpLogger().d("Initialize geolocator");

        var locationSettings = LocationSettings(
            //Scroll down to see the different options
            notificationTitle: "SMASH location service is active.",
            notificationMsg: "",
            notificationIcon: "smash_notification",
            wakeLockTime: 20,
            autoStop: false,
            interval: 1);
        await GPS.BackgroundLocator.registerLocationUpdate(
          callback,
          //optional
          androidNotificationCallback: notificationCallback,
          settings: locationSettings,
        );
      }
      _locationServiceEnabled =
          await GPS.BackgroundLocator.isRegisterLocationUpdate();

      if (port == null || !_locationServiceEnabled) {
        if (_gpsState.status != GpsStatus.OFF) {
          _gpsState.status = GpsStatus.OFF;
        }
      } else {
        GpsFilterManager().checkFix();
      }

      if (reInit) {
        if (port != null) {
          // reset the listeners
          await closeGpsIsolate();
          port = null;
        }
        reInit = false;
      }

      // if (_positionStreamSubscription == null) {
      //   GpLogger().d("GpsHandler: subscribe to gps");

      //   LocationOptions locationOptions = LocationOptions(
      //     accuracy: locationAccuracy,
      //     distanceFilter: 0,
      //   );
      //   final Stream<Position> positionStream =
      //       _geolocator.getPositionStream(locationOptions);
      //   _positionStreamSubscription = positionStream
      //       .listen((Position position) => _onPositionUpdate(position));
      // }
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
    if (port == null) return false;
    return _locationServiceEnabled;
  }

  void _onPositionUpdate(SmashPosition position) {
    GpsFilterManager().onNewPositionEvent(position);
  }

  /// Close the handler.
  Future close() async {
    if (_timer != null) _timer.cancel();
    // if (_positionStreamSubscription != null) {
    //   _positionStreamSubscription.cancel();
    //   _positionStreamSubscription = null;
    // }

    await closeGpsIsolate();

    _locationServiceEnabled = false;
  }

  Future closeGpsIsolate() async {
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }
    await GPS.BackgroundLocator.unRegisterLocationUpdate();
  }

  // LocationAccuracy toLocationAccuracy(String locationAccuracy) {
  //   for (var value in LocationAccuracy.values) {
  //     var tmp = value.toString().replaceFirst("LocationAccuracy.", "");
  //     if (tmp == locationAccuracy) {
  //       return value;
  //     }
  //   }
  //   throw ArgumentError("No location accuracy: " + locationAccuracy);
  // }
}
