/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart' as GPS;
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:geodesy/geodesy.dart' as GEOD;
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/l10n/localization.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

/// Utilities to work with coordinates.
class CoordinateUtilities {
  static final geodesy = GEOD.Geodesy();

  /// Get the distance between two latlong coordinates in meters, if not otherwise specified by [unit].
  static double getDistance(LatLng ll1, LatLng ll2) {
    return geodesy.distanceBetweenTwoGeoPoints(ll1, ll2).toDouble();
  }

  /// Get the offset coordinate given a starting point, a distance in meters and an azimuth angle.
  static LatLng getAtOffset(
      LatLng coordinate, double distanceInMeter, double azimuth) {
    return geodesy.destinationPointByDistanceAndBearing(
        coordinate, distanceInMeter, azimuth);
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

  static SmashLocationAccuracy fromCode(int? code) {
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
    int? prefCode = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_GPS_ACCURACY, NAVIGATION.code);
    return fromCode(prefCode);
  }

  static Future<void> toPreferences(SmashLocationAccuracy accuracy) async {
    await GpPreferences()
        .setInt(SmashPreferencesKeys.KEY_GPS_ACCURACY, accuracy.code);
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
@pragma('vm:entry-point')
class GpsHandler with Localization {
  static const GPS_FORCED_OFF_KEY = "GPS_FORCED_OFF";
  static const String _isolateName = "LocatorIsolate";
  ReceivePort? port;
  int allPointsCount = 0;
  int filteredPointsCount = 0;

  static final GpsHandler _instance = GpsHandler._internal();

  late bool _locationServiceEnabled;

  Timer? _timer;
  late GpsState _gpsState;
  late ProjectState _projectState;
  bool initialized = false;

  /// Accuracy for the location subscription
  var locationAccuracy = SmashLocationAccuracy.NAVIGATION;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal();

  @pragma('vm:entry-point')
  static void callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto.toJson());
  }

  Future<void> init(GpsState initGpsState, ProjectState projectState) async {
    SMLogger().i("Init GpsHandler");
    if (SmashPlatform.isDesktop()) {
      SMLogger().i("No gps handler active on desktop.");
      return;
    }
    _gpsState = initGpsState;
    _projectState = projectState;
    _locationServiceEnabled = false;

    GpsFilterManager().setStates(_gpsState, _projectState);

    // first time wait for it
    await initGpsWithCheck();
    // then check regularly
    _timer = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      await initGpsWithCheck();
    });

    // activate test stream, even if it will be silent
    TestLogStream().streamSubscription!.onData((SmashPosition pos) {
      _onPositionUpdate(pos);
    });
  }

  Future initGpsWithCheck() async {
    if (_gpsState.doTestLog) {
      TestLogStream().start();
    } else {
      TestLogStream().stop();
    }

    if (_gpsState.status == GpsStatus.OFF) {
      _gpsState.status = GpsStatus.ON_NO_FIX;
    }

    var gpsForcedOff =
        await GpPreferences().getBoolean(GPS_FORCED_OFF_KEY, false);

    if (!gpsForcedOff!) {
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
  }

  void restartLocationsService() {
    port = null;
    allPointsCount = 0;
    filteredPointsCount = 0;
    _gpsState.status = GpsStatus.ON_NO_FIX;
  }

  /// Returns true if the gps currently has a fix or is logging.
  bool hasFix() {
    var hasFix =
        _gpsState.status == GpsStatus.ON_WITH_FIX || TestLogStream().isActive;
    var isLogging = _gpsState.status == GpsStatus.LOGGING;
    return hasFix || isLogging;
  }

  // Checks if the gps is on or off.
  bool isGpsOn() {
    if (TestLogStream().isActive) return true;
    if (port == null) return false;
    return _locationServiceEnabled;
  }

  void _onPositionUpdate(SmashPosition position) {
    allPointsCount++;
    var notBlocked = GpsFilterManager().onNewPositionEvent(position);
    if (notBlocked) {
      filteredPointsCount++;
    }

    if (FenceMaster().hasFences) {
      FenceMaster()
          .onPositionUpdate(LatLng(position.latitude, position.longitude));
    }
  }

  /// Close the handler.
  Future close() async {
    _timer?.cancel();
    _gpsState.stopAllGpsTimers();

    await closeGpsIsolate();

    _locationServiceEnabled = false;
  }

  Future startGpsIsolate(bool isInit) async {
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }

    port = ReceivePort();
    IsolateNameServer.registerPortWithName(port!.sendPort, _isolateName);
    port!.listen((dynamic json) {
      if (TestLogStream().isActive || json == null) {
        return;
      }
      LocationDto data = LocationDto.fromJson(json);
      if (data != null) {
        KalmanFilter kalman = KalmanFilter.getInstance();
        kalman.process(data.latitude, data.longitude, data.accuracy, data.time,
            data.speed);
        var position = SmashPosition.fromLocation(data,
            filteredLatitude: kalman.latitude,
            filteredLongitude: kalman.longitude,
            filteredAccuracy: kalman.accuracy);
        _onPositionUpdate(position);

        var pos =
            "lat: ${position.latitude}, lon: ${position.longitude}, acc: ${position.accuracy.round()}m";
        var posLines =
            "lat: ${position.latitude}\nlon: ${position.longitude}\nacc: ${position.accuracy.round()}m";
        var extraPos = """altitude: ${position.altitude.round()}m
speed: ${(position.speed * 3.6).toStringAsFixed(0)}km/h
heading: ${position.heading.round()}
time: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(position.time.toInt()))}""";

        var title = loc.gps_smashIsActive; //"SMASH is active"
        var msg = pos;
        var bigMsg = posLines + "\n" + extraPos;
        if (_projectState.isLogging) {
          title = loc.gps_smashIsLogging; //"SMASH is logging"

          var currentLogStats = _projectState.getCurrentLogStats();
          if (currentLogStats[0] != null &&
              currentLogStats[1] != null &&
              currentLogStats[2] != null) {
            double distanceMeter = currentLogStats[0] as double;
            double distanceMeterFiltered = currentLogStats[1] as double;
            int timestampDelta = currentLogStats[2] as int;

            var timeStr = StringUtilities.formatDurationMillis(timestampDelta);
            var distStr = StringUtilities.formatMeters(distanceMeter);
            var distFilteredStr =
                StringUtilities.formatMeters(distanceMeterFiltered);

            msg = "$timeStr, $distStr ($distFilteredStr)";
            bigMsg = msg + "\n" + bigMsg;
          }

          GPS.BackgroundLocator.updateNotificationText(
              title: title, msg: msg, bigMsg: bigMsg);
        }
      }
    });
    // init platform state
    if (isInit) await GPS.BackgroundLocator.initialize();

    var smashLocationAccuracy = SmashLocationAccuracy.fromPreferences();
    SMLogger().i("Register for location updates.");
    var androidNotificationSettings = AndroidNotificationSettings(
      notificationChannelName: loc.gps_locationTracking, //"Location tracking"
      notificationTitle:
          loc.gps_smashLocServiceIsActive, //"SMASH location service is active."
      notificationMsg: "",
      notificationBigMsg: loc
          .gps_backgroundLocIsOnToKeepRegistering, //"Background location is on to keep the app registering the location even when the app is in background."
      notificationIcon: "smash_notification",
      notificationIconColor: SmashColors.mainDecorations,
    );

    bool useGpsGoogleServices = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_GOOGLE_SERVICES, false);
    var clientType = LocationClient.android;
    if (useGpsGoogleServices) {
      clientType = LocationClient.google;
    }
    GPS.BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      autoStop: false,
      androidSettings: AndroidSettings(
          client: clientType,
          accuracy: smashLocationAccuracy.accuracy,
          interval: 1,
          distanceFilter: 0,
          wakeLockTime: 20,
          androidNotificationSettings: androidNotificationSettings),
      iosSettings: IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
      ),
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
