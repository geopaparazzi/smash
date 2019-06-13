import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

abstract class PositionListener {
  void onPositionUpdate(Position position);
}

class LocationPermissionHandler {
  static bool permissionGranted = false;

  Future<bool> requestPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    permissionGranted = permission == PermissionStatus.granted;
    return permissionGranted;
  }
}

class GpsHandler {
  static final GpsHandler _instance = GpsHandler._internal();

  StreamSubscription<Position> _positionStreamSubscription;

  List<PositionListener> positionListeners = [];

  bool _locationDisabled;

  factory GpsHandler() => _instance;

  GpsHandler._internal() {
    _init();
  }

  void _init() async {
    if (LocationPermissionHandler.permissionGranted) {
      Geolocator geolocator = Geolocator();
      if (Platform.isAndroid) {
        geolocator.forceAndroidLocationManager = true;
      }
      if (_positionStreamSubscription == null) {
        const LocationOptions locationOptions =
            LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0);
        final Stream<Position> positionStream =
            geolocator.getPositionStream(locationOptions);
        _positionStreamSubscription = positionStream
            .listen((Position position) => onPositionUpdate(position));
      }
      _locationDisabled = false;
    } else {
      _locationDisabled = true;
    }
  }

  void onPositionUpdate(Position position) {
    if (_locationDisabled) return;
    positionListeners
        .forEach((PositionListener pl) => pl.onPositionUpdate(position));
  }

  void addPositionListener(PositionListener listener) {
    if (_locationDisabled) return;
    if (!positionListeners.contains(listener)) {
      positionListeners.add(listener);
    }
  }

  void removePositionListener(PositionListener listener) {
    if (positionListeners.contains(listener)) {
      positionListeners.remove(listener);
    }
  }

  void close() {
    if (_locationDisabled) return;
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
  }
}
