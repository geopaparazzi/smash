/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeopaparazziProjectModel extends Model {
  final KEY_LAST_GPAPPROJECT = "lastgpapProject";

  String _projectPath;
  Database _db;

  String get projectPath => _projectPath;

  void set projectPath(String path) {
    _projectPath = path;
    if (_db != null && _db.isOpen) {
      _db.close();
      _db = null;
    }
  }

  Future<Database> getDatabase() async {
    if (_db == null) {
      var _prefs = await SharedPreferences.getInstance();
      if (_projectPath == null) {
        _projectPath = _prefs.getString(KEY_LAST_GPAPPROJECT);
      }
      if (_projectPath == null) {
        return null;
      }
      _db = await openDatabase(_projectPath);
      _prefs.setString(KEY_LAST_GPAPPROJECT, _projectPath);
    }
    return _db;
  }

  void close() {
    if (_db != null) {
      _db.close();
    }
    _projectPath = null;
  }
}

