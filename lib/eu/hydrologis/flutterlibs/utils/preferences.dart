/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

const KEY_LAST_USED_FOLDER = "KEY_LAST_USED_FOLDER";

const KEY_LAST_GPAPPROJECT = "lastgpapProject";
const KEY_LAST_LAT = "lastgpap_lat";
const KEY_LAST_LON = "lastgpap_lon";
const KEY_LAST_ZOOM = "lastgpap_zoom";
const KEY_CENTER_ON_GPS = "center_on_gps";
const KEY_ROTATE_ON_HEADING = "rotate_on_heading";
const KEY_LAST_BASEMAP = "lastbasemapinfo";
const KEY_LAYERINFO_LIST = 'KEY_LAYERINFO_LIST';
const KEY_MBTILES_LIST = 'KEY_MBTILES_LIST';
const KEY_KEEP_SCREEN_ON = 'KEY_KEEP_SCREEN_ON';
const KEY_CAMERA_RESOLUTION = 'KEY_CAMERA_RESOLUTION';
const KEY_ENABLE_DIAGNOSTICS = 'KEY_ENABLE_DIAGNOSTICS';
const KEY_RECENTSPROJECTS_LIST = 'KEY_RECENTSPROJECTS_LIST';

const KEY_SAVED_TMS_LIST = 'KEY_SAVED_TMS_LIST';
const KEY_SAVED_WMS_LIST = 'KEY_SAVED_WMS_LIST';

const KEY_GPS_MIN_DISTANCE = 'KEY_GPS_MIN_DISTANCE';
const KEY_GPS_MAX_DISTANCE = 'KEY_GPS_MAX_DISTANCE';
const KEY_GPS_TIMEINTERVAL = 'KEY_GPS_TIMEINTERVAL';
const KEY_GPS_TESTLOG = 'KEY_GPS_TESTLOG';
const KEY_GPS_SHOW_ALL_POINTS = 'KEY_GPS_SHOW_ALL_POINTS';
const KEY_GPS_SHOW_VALID_POINTS = 'KEY_GPS_SHOW_VALID_POINTS';

const KEY_VECTOR_MAX_FEATURES = 'KEY_VECTOR_MAX_FEATURES';
const KEY_VECTOR_LOAD_ONLY_VISIBLE = 'KEY_VECTOR_LOAD_ONLY_VISIBLE';
const KEY_VECTOR_TAPAREA_SIZE = 'KEY_VECTOR_TAPAREA_SIZE';

const KEY_THEME = 'KEY_THEME';

const KEY_CENTERCROSS_STYLE = 'KEY_CENTERCROSS_STYLE';
const KEY_MAPTOOLS_ICON_SIZE = 'KEY_MAPTOOLS_ICON_SIZE';
const KEY_ICONS_LIST = 'KEY_ICONS_LIST';

const DEVICE_ID = 'DEVICE_ID';
const DEVICE_ID_OVERRIDE = 'DEVICE_ID_OVERRIDE';

const KEY_GSS_SERVER_URL = 'KEY_GSS_SERVER_URL';
const KEY_GSS_SERVER_USER = 'KEY_GSS_SERVER_USER';
const KEY_GSS_SERVER_PWD = 'KEY_GSS_SERVER_PWD';

const KEY_PROJECTIONS = 'KEY_PROJECTIONS';

const KEY_GPS_ACCURACY = 'KEY_GPS_ACCURACY';

const KEY_LATLONG_DECIMALS = 6;
const KEY_ELEV_DECIMALS = 0;

const TIMEINTERVALS = [0, 1, 3, 5, 10, 15, 20, 30, 60];
const MINDISTANCES = [0, 1, 3, 5, 10, 15, 20, 50, 100];
const MAXDISTANCES = [100, 150, 200, 500, 1000, 5000, 10000, 100000];
const MAXFEATURESTOLOAD = [50, 100, 200, 500, 1000, 5000, 10000, -1];
const TAPAREASIZES = [10, 20, 30, 40, 50, 100, 200, 500];

class CameraResolutions {
  static const HIGH = "high";
  static const MEDIUM = "medium";
  static const LOW = "low";
}

/// Geopaparazzi Preferences singleton.
class GpPreferences {
  static final GpPreferences _instance = GpPreferences._internal();

  factory GpPreferences() => _instance;

  GpPreferences._internal();

  SharedPreferences _preferences;

  Future<void> initialize() async {
    await _checkPreferences();
  }

  Future _checkPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  void _checkPreferencesOrThrow() {
    if (_preferences == null) {
      throw Exception("Need to call initialize to use sync methods.");
    }
  }

  /// Get a string from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  Future<String> getString(String key, [String defaultValue]) async {
    await _checkPreferences();
    String prefValue = _preferences.getString(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Get a string sync from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  String getStringSync(String key, [String defaultValue]) {
    _checkPreferencesOrThrow();
    String prefValue = _preferences.getString(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Save a string [value] to the preferences using a preferences [key].
  setString(String key, String value) async {
    await _checkPreferences();
    await _preferences.setString(key, value);
  }

  List<String> getStringListSync(String key, [List<String> defaultValue]) {
    _checkPreferencesOrThrow();
    List<String> prefValue = _preferences.getStringList(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  Future<List<String>> getStringList(String key,
      [List<String> defaultValue]) async {
    await _checkPreferences();
    List<String> prefValue = _preferences.getStringList(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  setStringList(String key, List<String> value) async {
    await _checkPreferences();
    await _preferences.setStringList(key, value);
  }

  /// Get a boolean from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  Future<bool> getBoolean(String key, [bool defaultValue]) async {
    await _checkPreferences();
    bool prefValue = _preferences.getBool(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Get a boolean sync from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  bool getBooleanSync(String key, [bool defaultValue]) {
    _checkPreferencesOrThrow();
    bool prefValue = _preferences.getBool(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Save a bool [value] to the preferences using a preferences [key].
  Future<void> setBoolean(String key, bool value) async {
    await _checkPreferences();
    await _preferences.setBool(key, value);
  }

  /// Get a double sync from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  double getDoubleSync(String key, [double defaultValue]) {
    _checkPreferencesOrThrow();
    double prefValue = _preferences.getDouble(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Save a double [value] to the preferences using a preferences [key].
  setDouble(String key, double value) async {
    await _checkPreferences();
    await _preferences.setDouble(key, value);
  }

  /// Get a int sync from the preferences.
  ///
  /// The method takes the preferences [key] and an optional [defaultValue]
  /// which can be returned in case the preference doesn't exist.
  int getIntSync(String key, [int defaultValue]) {
    _checkPreferencesOrThrow();
    int prefValue = _preferences.getInt(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  /// Save an int [value] to the preferences using a preferences [key].
  setInt(String key, int value) async {
    await _checkPreferences();
    await _preferences.setInt(key, value);
  }

  List<String> getTmsListSync() {
    var list = _preferences.getStringList(KEY_SAVED_TMS_LIST);
    if (list == null) list = [];
    return list;
  }

  Future setTmsList(List<String> list) async {
    await _preferences.setStringList(KEY_SAVED_TMS_LIST, list);
  }

  Future addNewTms(String jsonDefinition) async {
    var tmsList = getTmsListSync();
    if (!tmsList.contains(jsonDefinition)) {
      tmsList.add(jsonDefinition);
      await _preferences.setStringList(KEY_SAVED_TMS_LIST, tmsList);
    }
  }

  List<String> getWmsListSync() {
    var list = _preferences.getStringList(KEY_SAVED_WMS_LIST);
    if (list == null) list = [];
    return list;
  }

  Future setWmsList(List<String> list) async {
    await _preferences.setStringList(KEY_SAVED_WMS_LIST, list);
  }

  Future addNewWms(String jsonDefinition) async {
    var wmsList = getWmsListSync();
    if (!wmsList.contains(jsonDefinition)) {
      wmsList.add(jsonDefinition);
      await _preferences.setStringList(KEY_SAVED_WMS_LIST, wmsList);
    }
  }

  List<String> getRecentProjectsListSync() {
    var list = _preferences.getStringList(KEY_RECENTSPROJECTS_LIST);
    if (list == null) list = [];
    // remove non existing files
    list.removeWhere((p) => !new File(p).existsSync());
    return list;
  }

  Future addRecentProject(String projectPath) async {
    await _checkPreferences();
    var list = _preferences.getStringList(KEY_RECENTSPROJECTS_LIST);
    if (list == null) list = [];
    list.removeWhere((p) => p == projectPath);
    if (list.length >= 10) {
      list.removeLast();
    }
    list.insert(0, projectPath);
    await _preferences.setStringList(KEY_RECENTSPROJECTS_LIST, list);
  }

  /// Return last saved position as [lon, lat, zoom] or null.
  Future<List<double>> getLastPosition() async {
    await _checkPreferences();
    var lat = _preferences.getDouble(KEY_LAST_LAT);
    var lon = _preferences.getDouble(KEY_LAST_LON);
    var zoom = _preferences.getDouble(KEY_LAST_ZOOM);
    if (lat == null) return null;
    return [lon, lat, zoom];
  }

  /// Save last position to preferences.
  setLastPosition(double lon, double lat, double zoom) async {
    await _checkPreferences();
    await _preferences.setDouble(KEY_LAST_LAT, lat);
    await _preferences.setDouble(KEY_LAST_LON, lon);
    await _preferences.setDouble(KEY_LAST_ZOOM, zoom);
  }

  bool getCenterOnGps() {
    return getBooleanSync(KEY_CENTER_ON_GPS, false);
  }

  Future<void> setCenterOnGps(bool centerOnGps) async {
    await _checkPreferences();
    await setBoolean(KEY_CENTER_ON_GPS, centerOnGps);
  }

  bool getRotateOnHeading() {
    return getBooleanSync(KEY_ROTATE_ON_HEADING, false);
  }

  Future<void> setRotateOnHeading(bool rotateOnHeading) async {
    await _checkPreferences();
    await setBoolean(KEY_ROTATE_ON_HEADING, rotateOnHeading);
  }

  bool getKeepScreenOn() {
    return getBooleanSync(KEY_KEEP_SCREEN_ON, true);
  }

  Future<void> setKeepScreenOn(bool keepScreenOn) async {
    await _checkPreferences();
    await setBoolean(KEY_KEEP_SCREEN_ON, keepScreenOn);
  }

  Future<List<String>> getLayerInfoList() async {
    await _checkPreferences();
    var list = _preferences.getStringList(KEY_LAYERINFO_LIST);
    if (list == null) list = [];
    return list;
  }

  void setLayerInfoList(List<String> layerInfoList) async {
    await _checkPreferences();
    if (layerInfoList == null) layerInfoList = [];
    await _preferences.setStringList(KEY_LAYERINFO_LIST, layerInfoList);
  }

  Future<List<String>> getProjections() async {
    await _checkPreferences();
    var list = _preferences.getStringList(KEY_PROJECTIONS);
    if (list == null) list = [];
    return list;
  }

  Future<void> setProjections(List<String> projectionsList) async {
    await _checkPreferences();
    if (projectionsList == null) projectionsList = [];
    await _preferences.setStringList(KEY_PROJECTIONS, projectionsList);
  }

  String getLocationAccuracy() {
    return getStringSync(KEY_GPS_ACCURACY);
  }

  Future<void> setLocationAccuracy(String accuracy) async {
    await _checkPreferences();
    await setString(KEY_GPS_ACCURACY, accuracy);
  }
}
