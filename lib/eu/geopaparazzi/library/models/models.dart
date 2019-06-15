/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';

class BloCSetting extends State {
  rebuildWidgets({VoidCallback setStates, List<State> states}) {
    if (states != null) {
      states.forEach((s) {
        if (s != null && s.mounted) s.setState(setStates ?? () {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "This build function will never be called. it has to be overriden here because State interface requires this");
    return null;
  }
}

GPProjectModel gpProjectModel;

class GPProjectModel extends BloCSetting {
  String _projectPath;
  Database _db;

  double lastCenterLon = 0;
  double lastCenterLat = 0;
  double lastCenterZoom = 5;

  String get projectPath => _projectPath;

  void setNewProject(state, String path) {
    rebuildWidgets(
        setStates: () {
          _projectPath = path;
          if (_db != null && _db.isOpen) {
            _db.close();
            _db = null;
          }
        },
        states: [state]);
  }

  Future<Database> getDatabase() async {
    if (_db == null) {
      if (_projectPath == null) {
        _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
      }
      if (_projectPath == null) {
        return null;
      }
      _db = await openDatabase(_projectPath);
      await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
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
      if (_projectPath == null) {
        _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
      }
      if (_projectPath == null) {
        return null;
      }
      _db = await openDatabase(_projectPath);
      await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
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
