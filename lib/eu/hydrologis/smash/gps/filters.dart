import 'dart:math' as math;

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smashlibs/smashlibs.dart';

class GpsFilterManagerMessage {
  /// Time in milliseconds from the last position event.
  var lastFixDelta;
  bool isLogging = false;
  bool blockedByFilter = false;

  Coordinate? previousPosLatLon;
  Coordinate? newPosLatLon;

  double? distanceLastEvent;
  int? maxAllowedDistanceLastEvent;
  int? minAllowedDistanceLastEvent;

  int? timeDeltaLastEvent;
  int? minAllowedTimeDeltaLastEvent;

  var timestamp;
  bool? mocked;
  double? accuracy;
  double? altitude;
  double? heading;
  double? speed;
  double? speedAccuracy;

  @override
  bool operator ==(Object other) =>
      other is GpsFilterManagerMessage && other.timestamp == timestamp;

  @override
  int get hashCode => HashUtilities.hashObjects([timestamp]);
}

class GpsFilterManager {
  static final GpsFilterManager _instance = GpsFilterManager._internal();

  factory GpsFilterManager() => _instance;

  static const MAX_DELTA_FOR_FIX = 60000.0;
  late int _lastGpsEventTs;
  bool filtersEnabled = true;

  /// The previous VALID position recorded.
  ///
  /// In the case the position is discarded due to [isValid]
  /// or [passesFilters] returning false, the point is not updated.
  SmashPosition? _previousLogPosition;
  late GpsState _gpsState;
  late ProjectState _projectState;

  GpsFilterManagerMessage? currentMessage;

  /// Last recorded delta from the last position event in milliseconds.
  var _lastFixDelta;

  GpsFilterManager._internal() {
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
  }

  void setStates(GpsState gpsState, ProjectState projectState) {
    _gpsState = gpsState;
    _projectState = projectState;
  }

  /// Check if the GPS has a fix based on the time passed from the last gps position event.
  void checkFix() {
    if (TestLogStream().isActive) {
      var status =
          _projectState.isLogging ? GpsStatus.LOGGING : GpsStatus.ON_WITH_FIX;
      if (_gpsState.status != status) {
        _gpsState.status = status;
      }
    } else {
      var currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      _lastFixDelta = currentTimeMillis - _lastGpsEventTs;
      if (_lastFixDelta > MAX_DELTA_FOR_FIX) {
        // if for so many seconds there is no gps event, we can assume it has no fix
        if (_gpsState.status != GpsStatus.ON_NO_FIX) {
          _gpsState.status = GpsStatus.ON_NO_FIX;
        }
      }
    }
  }

  /// New position event coming in from the location service.
  ///
  /// In here all the filtering happens.
  ///
  /// Returns true if the point was not blocked.
  bool onNewPositionEvent(SmashPosition? position) {
    if (position != null && position.mocked) {
      if (_projectState.isLogging && _projectState.currentLogId != null) {
        _projectState.addLogPoint(
          position.longitude,
          position.latitude,
          position.altitude,
          position.time.round(),
          position.accuracy,
          position.speed,
          accuracyFiltered: position.filteredAccuracy,
          latitudeFiltered: position.filteredLatitude,
          longitudeFiltered: position.filteredLongitude,
        );
      }
      _previousLogPosition = position;
      _gpsState.statusQuiet =
          _projectState.isLogging ? GpsStatus.LOGGING : GpsStatus.ON_WITH_FIX;
      _gpsState.lastGpsPosition = position;
      return true;
    }

    GpsFilterManagerMessage msg = GpsFilterManagerMessage();
    msg.lastFixDelta = _lastFixDelta;

    // set last event ts that is used to define the 'no fix' interval
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;

    if (position != null) {
      msg.timestamp = position.time; //stamp;
      msg.mocked = false; //position.mocked;
      msg.accuracy = position.accuracy;
      msg.altitude = position.altitude;
      msg.heading = position.heading;
      msg.speed = position.speed;
      msg.speedAccuracy = position.speedAccuracy;

      bool setGpsState = false;
      var tmpStatus =
          _projectState.isLogging ? GpsStatus.LOGGING : GpsStatus.ON_WITH_FIX;

      var newPosLatLon =
          Coordinate.fromYX(position.latitude, position.longitude);
      if (_previousLogPosition != null) {
        var previousPosLatLon = Coordinate.fromYX(
            _previousLogPosition!.latitude, _previousLogPosition!.longitude);
        msg.previousPosLatLon = previousPosLatLon;
        msg.newPosLatLon = newPosLatLon;
        var ts = position.time.round();

        // find values for filter checks
        var distanceLastLogged =
            CoordinateUtilities.getDistance(previousPosLatLon, newPosLatLon);
        var deltaSecondsLastLogged =
            ((ts - _previousLogPosition!.time) / 1000).round();
        if (deltaSecondsLastLogged < 0) {
          deltaSecondsLastLogged = 0;
        }
        msg.distanceLastEvent = distanceLastLogged;
        var isPassingFilters =
            passesFilters(distanceLastLogged, deltaSecondsLastLogged, msg);
        msg.blockedByFilter = !isPassingFilters;
        if (filtersEnabled) {
          if (isPassingFilters) {
            // if logging add to visible log and into db
            if (_projectState.isLogging && _projectState.currentLogId != null) {
              msg.isLogging = true;
              _projectState.addLogPoint(
                position.longitude,
                position.latitude,
                position.altitude,
                ts,
                position.accuracy,
                position.speed,
                accuracyFiltered: position.filteredAccuracy,
                latitudeFiltered: position.filteredLatitude,
                longitudeFiltered: position.filteredLongitude,
              );
            }
            _previousLogPosition = position;
            setGpsState = true;
          }
        } else {
          _previousLogPosition = position;
          setGpsState = true;
        }
      } else {
        // set first 'previous'
        _previousLogPosition = position;
      }

      if (setGpsState || _gpsState.status != tmpStatus) {
        _gpsState.statusQuiet = tmpStatus;
        _gpsState.lastGpsPosition = position;
      }
    }
    currentMessage = msg;
    return !msg.blockedByFilter;
  }

  bool passesFilters(var distanceLastEvent, var deltaSecondsLastEvent,
      GpsFilterManagerMessage msg) {
    msg.minAllowedDistanceLastEvent = _gpsState.gpsMinDistance;
    msg.timeDeltaLastEvent = deltaSecondsLastEvent;
    msg.minAllowedTimeDeltaLastEvent = _gpsState.gpsTimeInterval;

    return distanceLastEvent > _gpsState.gpsMinDistance &&
        deltaSecondsLastEvent > _gpsState.gpsTimeInterval;
  }
}

/// Original code by https://github.com/Bresiu/KalmanFilter
class KalmanFilter {
  static KalmanFilter? instance;
  static getInstance() {
    if (instance == null) {
      instance = KalmanFilter();
    }
    return instance;
  }

  final double _minAccuracy = 1;

  late double _timeStampMilliseconds;
  late double _lat;
  late double _lng;
  late double _variance;

  KalmanFilter() {
    this._variance = -1;
  }

  double get timeStamp {
    return this._timeStampMilliseconds;
  }

  double get latitude {
    return this._lat;
  }

  double get longitude {
    return this._lng;
  }

  double get accuracy {
    return math.sqrt(this._variance);
  }

  void setState(
      double lat, double lng, double accuracy, double timeStampMilliseconds) {
    this._lat = lat;
    this._lng = lng;
    this._variance = accuracy * accuracy;
    this._timeStampMilliseconds = timeStampMilliseconds;
  }

  void process(double latMeasurement, double lngMeasurement, double accuracy,
      double timeStampMilliseconds, double speedMs) {
    if (accuracy < this._minAccuracy) accuracy = this._minAccuracy;
    if (this._variance < 0) {
      // if variance < 0, object is unitialised, so initialise with current values
      this._timeStampMilliseconds = timeStampMilliseconds;
      this._lat = latMeasurement;
      this._lng = lngMeasurement;
      this._variance = accuracy * accuracy;
    } else {
      // else apply Kalman filter methodology

      double duration = timeStampMilliseconds - this._timeStampMilliseconds;
      if (duration > 0) {
        // time has moved on, so the uncertainty in the current position increases
        this._variance += duration * speedMs * speedMs / 1000;
        this._timeStampMilliseconds = timeStampMilliseconds;
        // TO DO: USE VELOCITY INFORMATION HERE TO GET A BETTER ESTIMATE OF CURRENT POSITION
      }

      // Kalman gain matrix K = Covarariance * Inverse(Covariance + MeasurementVariance)
      // NB: because K is dimensionless, it doesn't matter that variance has different units to lat and lng
      double K = this._variance / (this._variance + accuracy * accuracy);
      // apply K
      this._lat += K * (latMeasurement - this._lat);
      this._lng += K * (lngMeasurement - this._lng);
      // new Covarariance  matrix is (IdentityMatrix - K) * Covarariance
      this._variance = (1 - K) * this._variance;
    }
  }
}
