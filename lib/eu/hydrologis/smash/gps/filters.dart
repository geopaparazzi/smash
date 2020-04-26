import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
class GpsFilterManagerMessage {
  /// Time in milliseconds from the last position event.
  var lastFixDelta;
  bool isLogging = false;
  bool blockedByFilter = true;

  LatLng previousPosLatLon;
  LatLng newPosLatLon;

  double distanceLastEvent;
  int maxAllowedDistanceLastEvent;
  int minAllowedDistanceLastEvent;

  int timeDeltaLastEvent;
  int minAllowedTimeDeltaLastEvent;

  var timestamp;
  bool mocked;
  double accuracy;
  double altitude;
  double heading;
  double speed;
  double speedAccuracy;

  @override
  bool operator ==(Object other) =>
      other is GpsFilterManagerMessage && other.timestamp == timestamp;

  @override
  int get hashCode => HashUtilities.hashObjects([timestamp]);
}

class GpsFilterManager {
  static final GpsFilterManager _instance = GpsFilterManager._internal();

  factory GpsFilterManager() => _instance;

  static const MAX_DELTA_FOR_FIX = 15000.0;
  int _lastGpsEventTs;
  bool filtersEnabled = true;

  /// The previous VALID position recorded.
  ///
  /// In the case the position is discarded due to [isValid]
  /// or [passesFilters] returning false, the point is not updated.
  LocationDto _previousLogPosition;
  GpsState _gpsState;

  GpsFilterManagerMessage currentMessage;

  /// Last recorded delta from the last position event in milliseconds.
  var _lastFixDelta;

  GpsFilterManager._internal() {
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
  }

  void setGpsState(GpsState gpsState) {
    _gpsState = gpsState;
  }

  /// Check if the GPS has a fix based on the time passed from the last gps position event.
  void checkFix() {
    var currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    _lastFixDelta = currentTimeMillis - _lastGpsEventTs;
    if (_lastFixDelta > MAX_DELTA_FOR_FIX) {
      // if for so many seconds there is no gps event, we can assume it has no fix
      if (_gpsState.status != GpsStatus.ON_NO_FIX) {
        _gpsState.status = GpsStatus.ON_NO_FIX;
      }
    }
  }

  /// New position event coming in from the location service.
  ///
  /// In here all the filtering happens.
  void onNewPositionEvent(LocationDto position) {
    GpsFilterManagerMessage msg = GpsFilterManagerMessage();
    msg.lastFixDelta = _lastFixDelta;

    // set last event ts that is used to define the 'no fix' interval
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;

    position = GpsFilterManager().checkTestMock() ?? position;

    if (position != null) {
      msg.timestamp = position.time;//stamp;
      msg.mocked = false;//position.mocked;
      msg.accuracy = position.accuracy;
      msg.altitude = position.altitude;
      msg.heading = position.heading;
      msg.speed = position.speed;
      msg.speedAccuracy = position.speedAccuracy;

      bool setGpsState = false;
      var tmpStatus =
          _gpsState.isLogging ? GpsStatus.LOGGING : GpsStatus.ON_WITH_FIX;
      var newPosLatLon = LatLng(position.latitude, position.longitude);
      if (_previousLogPosition != null) {
        var previousPosLatLon = LatLng(
            _previousLogPosition.latitude, _previousLogPosition.longitude);
        msg.previousPosLatLon = previousPosLatLon;
        msg.newPosLatLon = newPosLatLon;
        var ts = position.time.round();//timestamp.millisecondsSinceEpoch;

        // find values for filter checks
        var distanceLastLogged =
            CoordinateUtilities.getDistance(previousPosLatLon, newPosLatLon);
        var deltaSecondsLastLogged =
            ((ts - _previousLogPosition.time) /
                    1000)
                .round();
        var valid = isValid(distanceLastLogged, msg);
        var isPassingFilters =
            passesFilters(distanceLastLogged, deltaSecondsLastLogged, msg);
        msg.blockedByFilter = !valid || !isPassingFilters;
        if (filtersEnabled) {
          if (valid) {
            if (isPassingFilters) {
              // if logging add to visible log and into db
              if (_gpsState.isLogging && _gpsState.currentLogId != null) {
                msg.isLogging = true;
                _gpsState.currentLogPoints.add(newPosLatLon);
                _gpsState.addLogPoint(position.longitude, position.latitude,
                    position.altitude, ts);
              }
              // TODO check what to do for filters. They do not work!
              _previousLogPosition = position;
              setGpsState = true;
            }
          }
        } else {
          _previousLogPosition = position;
          setGpsState = true;
        }
      } else {
        // set first 'previous'
        _previousLogPosition = position;
      }

      if (setGpsState) {
        // gps information is set at every event
        _gpsState.statusQuiet = tmpStatus;
        _gpsState.lastGpsPosition = position;
      }
    }
    currentMessage = msg;
  }

  bool isValid(var distanceLastEvent, GpsFilterManagerMessage msg) {
    var isAtValidDistance = distanceLastEvent < _gpsState.gpsMaxDistance;
    msg.distanceLastEvent = distanceLastEvent;
    msg.maxAllowedDistanceLastEvent = _gpsState.gpsMaxDistance;

    if (!isAtValidDistance) {
      GpLogger().d(
          "Ignoring GPS point jump: $distanceLastEvent > ${_gpsState.gpsMaxDistance}");
    }
    return isAtValidDistance;
  }

  bool passesFilters(var distanceLastEvent, var deltaSecondsLastEvent,
      GpsFilterManagerMessage msg) {
    msg.minAllowedDistanceLastEvent = _gpsState.gpsMinDistance;
    msg.timeDeltaLastEvent = deltaSecondsLastEvent;
    msg.minAllowedTimeDeltaLastEvent = _gpsState.gpsTimeInterval;

    return distanceLastEvent > _gpsState.gpsMinDistance &&
        deltaSecondsLastEvent > _gpsState.gpsTimeInterval;
  }

  LocationDto checkTestMock() {
    // if (_gpsState.doTestLog) {
    //   // Use the mocked log
    //   var c = Testlog.getNext();
    //   LocationDto newP = LocationDto(
    //     latitude: c.y,
    //     longitude: c.x,
    //     heading: c.z,
    //     accuracy: 2,
    //     altitude: 100,
    //     speed: 2,
    //     timestamp: DateTime.now(),
    //     mocked: true,
    //   );
    //   return newP;
    // }
    return null;
  }
}
