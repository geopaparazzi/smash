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

class GpPreferences {
  static final GpPreferences _instance = GpPreferences._internal();

  factory GpPreferences() => _instance;

  GpPreferences._internal();

  SharedPreferences _preferences;

  Future checkPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  Future<String> getString(String key, [String defaultValue]) async {
    await checkPreferences();
    String prefValue = _preferences.getString(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  setString(String key, String value) async {
    await checkPreferences();
    _preferences.setString(key, value);
  }

  Future<bool> getBoolean(String key, [bool defaultValue]) async {
    await checkPreferences();
    bool prefValue = _preferences.getBool(key);
    if (prefValue == null) return defaultValue;
    return prefValue;
  }

  setBoolean(String key, bool value) async {
    await checkPreferences();
    _preferences.setBool(key, value);
  }

  /// Return last saved position as [lon, lat, zoom] or null.
  Future<List<dynamic>> getLastPosition() async {
    await checkPreferences();
    var lat = _preferences.getDouble(KEY_LAST_LAT);
    var lon = _preferences.getDouble(KEY_LAST_LON);
    var zoom = _preferences.getDouble(KEY_LAST_ZOOM);
    if (lat == null) return null;
    return [lon, lat, zoom];
  }

  /// Save last position to preferences.
  setLastPosition(double lon, double lat, double zoom) async {
    await checkPreferences();
    _preferences.setDouble(KEY_LAST_LAT, lat);
    _preferences.setDouble(KEY_LAST_LON, lon);
    _preferences.setDouble(KEY_LAST_ZOOM, zoom);
  }
}
