/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';

/// Main event handler that takes care of centering on map,
/// updating gps status and reloading projects, layers and
/// map on new center.
class MainEventHandler {
  Function reloadLayersFunction;
  Function reloadProjectFunction;
  Function moveToFunction;

  MainEventHandler(this.reloadLayersFunction, this.reloadProjectFunction,
      this.moveToFunction);

  ValueNotifier<bool> _keepGpsOnScreen = new ValueNotifier(false);
  ValueNotifier<LatLng> _mapCenter = new ValueNotifier(LatLng(0, 0));
  ValueNotifier<GpsStatus> _gpsStatus = new ValueNotifier(GpsStatus.OFF);

  void setCenterOnGps(bool centerOnGps) {
    _keepGpsOnScreen.value = centerOnGps;
  }

  bool isKeepGpsOnScreen() {
    return _keepGpsOnScreen.value;
  }

  void setGpsStatus(GpsStatus status) {
    _gpsStatus.value = status;
  }

  GpsStatus getGpsStatus() {
    return _gpsStatus.value;
  }

  LatLng getMapCenter() {
    return _mapCenter.value;
  }

  void setMapCenter(LatLng newCenter) {
    _mapCenter.value = newCenter;
  }

  void addMapCenterListener(VoidCallback listener) {
    _mapCenter.addListener(listener);
  }

  void addGpsStatusListener(VoidCallback listener) {
    _gpsStatus.addListener(listener);
  }

  void setKeepGpsOnScreen(bool value) {
    _keepGpsOnScreen.value = value;
  }
}
