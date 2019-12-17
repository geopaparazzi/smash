/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'geo/geo.dart';

/// Main event handler that takes care of centering on map,
/// updating gps status and reloading projects, layers and
/// map on new center.
class MainEventHandler {
  Function reloadLayersFunction;
  Function reloadProjectFunction;
  Function moveToFunction;

  MainEventHandler(this.reloadLayersFunction, this.reloadProjectFunction,
      this.moveToFunction);

  ValueNotifier<bool> _centerOnGpsStream = ValueNotifier(false);
  ValueNotifier<bool> _insertInGpsPosition = ValueNotifier(true);
  ValueNotifier<bool> _rotateOnHeading = ValueNotifier(false);
  ValueNotifier<LatLng> _mapCenter = ValueNotifier(LatLng(0, 0));
  ValueNotifier<GpsStatus> _gpsStatus = ValueNotifier(GpsStatus.OFF);

  void setCenterOnGpsStream(bool centerOnGps) {
    _centerOnGpsStream.value = centerOnGps;
  }

  bool isCenterOnGpsStream() {
    return _centerOnGpsStream.value;
  }

  void setRotateOnHeading(bool value) {
    _rotateOnHeading.value = value;
  }

  bool isRotateOnHeading() {
    return _rotateOnHeading.value;
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

  bool getInsertInGps() {
    return _insertInGpsPosition.value;
  }

  void setInsertInGps(bool doInsert) {
    _insertInGpsPosition.value = doInsert;
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

  void addInsertInGpsPositionListener(VoidCallback listener) {
    _insertInGpsPosition.addListener(listener);
  }


}
