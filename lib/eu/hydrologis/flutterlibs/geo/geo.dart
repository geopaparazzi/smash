/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';
import 'package:smash/eu/hydrologis/flutterlibs/eventhandlers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';

/// Utilities to work with coordinates.
class CoordinateUtilities {
  /// Get the distance between two latlong coordinates in meters, if not otherwise specified by [unit].
  static double getDistance(LatLng ll1, LatLng ll2, {unit: LengthUnit.Meter}) {
    final Distance distance = Distance();
    return distance.as(unit, ll1, ll2);
  }

  /// Get the offset coordinate given a starting point, a distance in meters and an azimuth angle.
  static LatLng getAtOffset(LatLng coordinate, double distanceInMeter, double azimuth) {
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
  void addLogPoint(int logId, double longitude, double latitude, double altitude, int timestamp);

  Future<int> addGpsLog(String logName);

  Future<void> stopLogging(int logId);
}

GpsLoggingHandler appGpsLoggingHandler;

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
  GpsLoggingHandler _loggingHandler;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _init(appGpsLoggingHandler);

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) async {
      if (_geolocator != null && !await _geolocator.isLocationServiceEnabled()) {
        if (GpsStatus.OFF != _gpsStatus) {
          _gpsStatus = GpsStatus.OFF;
          positionListeners.forEach((PositionListener pl) {
            pl.setStatus(_gpsStatus);
          });
        }
      }
    });
  }

  void _init([GpsLoggingHandler loggingHandler]) async {
    if (loggingHandler != null) _loggingHandler = loggingHandler;
    _geolocator = Geolocator();

    // TODO check back on this
//    if (Platform.isAndroid) {
//      _geolocator.forceAndroidLocationManager = true;
//    }

    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0);
      final Stream<Position> positionStream = _geolocator.getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen((Position position) => _onPositionUpdate(position));
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

        _loggingHandler?.addLogPoint(_currentLogId, position.longitude, position.latitude, position.altitude, DateTime.now().millisecondsSinceEpoch);
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
      var logId = await _loggingHandler?.addGpsLog(logName);
      _currentLogId = logId;
      _isLogging = true;

      _lastGpsStatusBeforeLogging = _gpsStatus;
      _gpsStatus = GpsStatus.LOGGING;
      positionListeners.forEach((PositionListener pl) {
        pl.setStatus(_gpsStatus);
      });

      return logId;
    } catch (e) {
      GpLogger().e("Error creating log", e);
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
  Future<void> stopLogging() async {
    _isLogging = false;
    _currentLogPoints.clear();

    await _loggingHandler?.stopLogging(_currentLogId);

    if (_lastGpsStatusBeforeLogging == null) _lastGpsStatusBeforeLogging = GpsStatus.ON_NO_FIX;
    _gpsStatus = _lastGpsStatusBeforeLogging;
    _lastGpsStatusBeforeLogging = null;
    positionListeners.forEach((PositionListener pl) {
      pl.setStatus(_gpsStatus);
    });
  }
}

/// Geocoding widget that makes use of the [MainEventHandler] to move to the
/// chosen location.
class GeocodingPage extends StatefulWidget {
  MainEventHandler _eventsHandler;

  GeocodingPage(this._eventsHandler);

  @override
  State<StatefulWidget> createState() => GeocodingPageState();
}

class GeocodingPageState extends State<GeocodingPage> {
  List<Address> _addresses = List();
  var textEditingController = TextEditingController();
  TextFormField textField;
  bool searching = false;

  @override
  void initState() {
    var inputDecoration = InputDecoration(labelText: "Enter search address", hintText: "Via Ipazia, 2");
    textField = TextFormField(
      controller: textEditingController,
      decoration: inputDecoration,
    );
    super.initState();
  }

  Future<void> search(BuildContext context, String query) async {
    List<Address> addresses;
    try {
      addresses = await Geocoder.local.findAddressesFromQuery(query);
    } catch (e) {
      print(e);
    }
    searching = false;
    if (addresses == null || addresses.isEmpty) {
      showWarningDialog(context, "Could not find any address.");
    } else {
      setState(() {
        _addresses.clear();
        _addresses.addAll(addresses);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> _list = List.from(_addresses.map((address) {
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.navigation),
          onPressed: () {
            widget._eventsHandler.setMapCenter(LatLng(address.coordinates.latitude, address.coordinates.longitude));
            Navigator.pop(context);
          },
        ),
        title: Text("${address.addressLine}"),
        subtitle: Text("Lat: ${address.coordinates.latitude} Lon: ${address.coordinates.longitude}"),
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Geocoding"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String query = textEditingController.text;
              if (query.trim().isEmpty) {
                showWarningDialog(context, "Nothing to look for. Insert an address.");
                return;
              }
              search(context, query);
              setState(() {
                searching = true;
              });
            },
            icon: Icon(Icons.refresh),
            tooltip: "Launch Geocoding",
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: textField,
                ),
              ),
            ),
            searching
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: _list),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
