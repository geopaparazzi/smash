/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:shared_preferences/shared_preferences.dart';

final KEY_LAST_GPAPPROJECT = "lastgpapProject";
final KEY_LAST_LAT = "lastgpap_lat";
final KEY_LAST_LON = "lastgpap_lon";
final KEY_LAST_ZOOM = "lastgpap_zoom";
final KEY_LAST_MAPSFORGEPATH = "lastmapsforge_path";
final KEY_CENTER_ON_GPS = "center_on_gps";
final KEY_NOTEDOGPS = 'KEY_NOTE_DOGPS';

/// Geopaparazzi Preferences singleton.
class GpPreferences {
  static final GpPreferences _instance = GpPreferences._internal();

  factory GpPreferences() => _instance;

  GpPreferences._internal();

  SharedPreferences _preferences;

  Future _checkPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
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

  /// Save a string [value] to the preferences using a preferences [key].
  setString(String key, String value) async {
    await _checkPreferences();
    _preferences.setString(key, value);
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

  /// Save a bool [value] to the preferences using a preferences [key].
  setBoolean(String key, bool value) async {
    await _checkPreferences();
    _preferences.setBool(key, value);
  }

  /// Return last saved position as [lon, lat, zoom] or null.
  Future<List<dynamic>> getLastPosition() async {
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
    _preferences.setDouble(KEY_LAST_LAT, lat);
    _preferences.setDouble(KEY_LAST_LON, lon);
    _preferences.setDouble(KEY_LAST_ZOOM, zoom);
  }

  Future<bool> getCenterOnGps() async {
    return getBoolean(KEY_CENTER_ON_GPS, false);
  }

  void setCenterOnGps(bool centerOnGps) {
    setBoolean(KEY_CENTER_ON_GPS, centerOnGps);
  }
}
