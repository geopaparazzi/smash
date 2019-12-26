/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:math';
import 'package:dart_jts/dart_jts.dart' hide Position, Distance;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';
import 'package:smash/eu/hydrologis/flutterlibs/eventhandlers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:provider/provider.dart';

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

  int _lastGpsEventTs;

  /// internal handler singleton
  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
  }

  void init(GpsState initGpsState) async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      _locationServiceEnabled = await _geolocator.isLocationServiceEnabled();
      if (_geolocator == null || !_locationServiceEnabled) {
        if (_gpsState.status != GpsStatus.OFF) {
          _gpsState.status = GpsStatus.OFF;
        }
      } else if (DateTime.now().millisecondsSinceEpoch - _lastGpsEventTs > 5000) {
        // if for 5 seconds there is no gps event, we can assume it has no fix
        if (_gpsState.status != GpsStatus.ON_NO_FIX) {
          _gpsState.status = GpsStatus.ON_NO_FIX;
        }
      }
      // other status cases are handled by the events themselves in _onPositionUpdate
    });

    _gpsState = initGpsState;
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
    _locationServiceEnabled = false;
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
    if (!_locationServiceEnabled) return;
    _lastGpsEventTs = DateTime.now().millisecondsSinceEpoch;
    GpsStatus tmpStatus;
    if (position != null) {
      tmpStatus = GpsStatus.ON_WITH_FIX;

      if (_gpsState.isLogging && _gpsState.currentLogId != null) {
        tmpStatus = GpsStatus.LOGGING;
//        if(_lastPosition!=null && _geolocator.distanceBetween(_lastPosition.latitude, _lastPosition.longitude, position.latitude,
//            position.longitude) > 1)
        _gpsState.currentLogPoints.add(LatLng(position.latitude, position.longitude));

        _gpsState.addLogPoint(position.longitude, position.latitude, position.altitude, DateTime.now().millisecondsSinceEpoch);
      }
    } else {
      tmpStatus = GpsStatus.ON_NO_FIX;
    }

    if (tmpStatus != null) {
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
}

/// Geocoding widget that makes use of the [MainEventHandler] to move to the
/// chosen location.
class GeocodingPage extends StatefulWidget {
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
            SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
            mapState.center = Coordinate(address.coordinates.longitude, address.coordinates.latitude);
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
