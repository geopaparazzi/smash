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
import 'package:smashlibs/smashlibs.dart';

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
  SmashPosition.fromCoords(double lon, double lat, double time) {
    _location = LocationDto.fromJson({
      "latitude": lat,
      "longitude": lon,
      "altitude": -1.0,
      "heading": -1.0,
      "time": time,
    });
  }

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

class SmashLocationAccuracy {
  final int code;
  final LocationAccuracy accuracy;
  final String label;

  const SmashLocationAccuracy._internal(this.code, this.accuracy, this.label);

  static const POWERSAVE = SmashLocationAccuracy._internal(
      0, LocationAccuracy.POWERSAVE, "Powersave");
  static const LOW =
      SmashLocationAccuracy._internal(1, LocationAccuracy.LOW, "Low");
  static const BALANCED =
      SmashLocationAccuracy._internal(2, LocationAccuracy.BALANCED, "Balanced");
  static const HIGH =
      SmashLocationAccuracy._internal(3, LocationAccuracy.HIGH, "High");
  static const NAVIGATION = SmashLocationAccuracy._internal(
      4, LocationAccuracy.NAVIGATION, "Navigation");

  static List<SmashLocationAccuracy> values() {
    return [POWERSAVE, LOW, BALANCED, HIGH, NAVIGATION];
  }

  static SmashLocationAccuracy fromCode(int code) {
    for (var item in values()) {
      if (item.code == code) {
        return item;
      }
    }
    return NAVIGATION;
  }

  static SmashLocationAccuracy fromLabel(String label) {
    for (var item in values()) {
      if (item.label == label) {
        return item;
      }
    }
    return NAVIGATION;
  }

  static SmashLocationAccuracy fromPreferences() {
    int prefCode =
        GpPreferences().getIntSync(KEY_GPS_ACCURACY, NAVIGATION.code);
    return fromCode(prefCode);
  }

  static Future<void> toPreferences(SmashLocationAccuracy accuracy) async {
    await GpPreferences().setInt(KEY_GPS_ACCURACY, accuracy.code);
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
  int allPointsCount = 0;
  int filteredPointsCount = 0;

  static final GpsHandler _instance = GpsHandler._internal();

  bool _locationServiceEnabled;

  Timer _timer;
  GpsState _gpsState;
  bool initialized = false;

  /// Accuracy for the location subscription
  var locationAccuracy = SmashLocationAccuracy.NAVIGATION;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal();

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  Future<void> init(GpsState initGpsState) async {
    GpLogger().i("Init GpsHandler");
    _gpsState = initGpsState;
    _locationServiceEnabled = false;

    GpsFilterManager().setGpsState(_gpsState);

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (port == null) {
        GpLogger().i("Initialize geolocator");
        await closeGpsIsolate();

        await startGpsIsolate(!initialized);
        initialized = true;
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
    });
  }

  void restartLocationsService() {
    port = null;
    allPointsCount = 0;
    filteredPointsCount = 0;
    _gpsState.status = GpsStatus.ON_NO_FIX;
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
    allPointsCount++;
    var notBlocked = GpsFilterManager().onNewPositionEvent(position);
    if (notBlocked) {
      filteredPointsCount++;
    }
  }

  /// Close the handler.
  Future close() async {
    if (_timer != null) _timer.cancel();

    await closeGpsIsolate();

    _locationServiceEnabled = false;
  }

  Future startGpsIsolate(bool isInit) async {
    port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      _onPositionUpdate(SmashPosition.fromLocation(data));
    });
    // init platform state
    if (isInit) await GPS.BackgroundLocator.initialize();

    var smashLocationAccuracy = SmashLocationAccuracy.fromPreferences();
    GpLogger().i("Register for location updates.");
    var locationSettings = LocationSettings(
        notificationTitle: "SMASH location service is active.",
        notificationMsg: "",
        notificationIcon: "smash_notification",
        wakeLockTime: 20,
        autoStop: false,
        accuracy: smashLocationAccuracy.accuracy,
        interval: 1);
    GPS.BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: locationSettings,
    );
    GpLogger().i("Geolocator initialized.");
  }

  Future closeGpsIsolate() async {
    port = null;
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }
    if (await GPS.BackgroundLocator.isRegisterLocationUpdate()) {
      await GPS.BackgroundLocator.unRegisterLocationUpdate();
    }
  }
}
