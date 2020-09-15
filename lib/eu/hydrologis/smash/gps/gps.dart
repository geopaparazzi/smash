/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart' as GPS;
import 'package:background_locator/keys.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
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

enum GpsStatus { NOGPS, OFF, NOPERMISSION, ON_NO_FIX, ON_WITH_FIX, LOGGING }
const String ARG_LATITUDE = 'latitude';
const String ARG_LONGITUDE = 'longitude';
const String ARG_ACCURACY = 'accuracy';
const String ARG_ALTITUDE = 'altitude';
const String ARG_SPEED = 'speed';
const String ARG_SPEED_ACCURACY = 'speed_accuracy';
const String ARG_HEADING = 'heading';
const String ARG_TIME = 'time';
const String ARG_MOCKED = 'mocked';
const String ARG_LATITUDE_FILTERED = 'latitude_filtered';
const String ARG_LONGITUDE_FILTERED = 'longitude_filtered';
const String ARG_ACCURACY_FILTERED = 'accuracy_filtered';

class SmashPosition {
  LocationDto _location;
  bool mocked = false;
  double filteredLatitude;
  double filteredLongitude;
  double filteredAccuracy;

  SmashPosition.fromLocation(this._location,
      {this.filteredLatitude, this.filteredLongitude, this.filteredAccuracy});

  SmashPosition.fromJson(Map<String, dynamic> json) {
    _location = LocationDto.fromJson({
      Keys.ARG_LATITUDE: json[ARG_LATITUDE],
      Keys.ARG_LONGITUDE: json[ARG_LONGITUDE],
      Keys.ARG_ALTITUDE: json[ARG_ALTITUDE],
      Keys.ARG_HEADING: json[ARG_HEADING],
      Keys.ARG_ACCURACY: json[ARG_ACCURACY],
      Keys.ARG_TIME: json[ARG_TIME],
      Keys.ARG_SPEED: json[ARG_SPEED],
      Keys.ARG_SPEED_ACCURACY: json[ARG_SPEED_ACCURACY],
    });
    mocked = json[ARG_MOCKED];
    filteredLatitude = json[ARG_LATITUDE_FILTERED];
    filteredLongitude = json[ARG_LONGITUDE_FILTERED];
    filteredAccuracy = json[ARG_ACCURACY_FILTERED];
  }
  SmashPosition.fromCoords(double lon, double lat, double time) {
    _location = LocationDto.fromJson({
      ARG_LATITUDE: lat,
      ARG_LONGITUDE: lon,
      ARG_ALTITUDE: -1.0,
      ARG_HEADING: -1.0,
      ARG_TIME: time,
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
    SMLogger().i("Init GpsHandler");
    if (SmashPlatform.isDesktop()) {
      SMLogger().i("No gps handler active on desktop.");
      return;
    }
    _gpsState = initGpsState;
    _locationServiceEnabled = false;

    GpsFilterManager().setGpsState(_gpsState);

    // first time wait for it
    await initGpsWithCheck();
    // then check regularly
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      await initGpsWithCheck();
    });
  }

  Future initGpsWithCheck() async {
    if (port == null) {
      SMLogger().i("Initialize geolocator");
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
    _timer?.cancel();

    await closeGpsIsolate();

    _locationServiceEnabled = false;
  }

  Future startGpsIsolate(bool isInit) async {
    port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      if (data != null) {
        KalmanFilter kalman = KalmanFilter.getInstance();
        SmashPosition position;
        if (_gpsState.doTestLog) {
          // Use the mocked log
          position = Testlog.getNext(kalman);
        } else {
          kalman.process(data.latitude, data.longitude, data.accuracy,
              data.time, data.speed);
          position = SmashPosition.fromLocation(data,
              filteredLatitude: kalman.latitude,
              filteredLongitude: kalman.longitude,
              filteredAccuracy: kalman.accuracy);
        }
        _onPositionUpdate(position);
      }
    });
    // init platform state
    if (isInit) await GPS.BackgroundLocator.initialize();

    var smashLocationAccuracy = SmashLocationAccuracy.fromPreferences();
    SMLogger().i("Register for location updates.");
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
    SMLogger().i("Geolocator initialized.");
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
