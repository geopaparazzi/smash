/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/database.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/logging.dart';

/// The global reference to the Geopaparazzi Project Model
GPProjectModel gpProjectModel;

/// The Geopaparazzi Project Model
///
/// This contains all information about:
/// * the current project opened
/// * the last center position
/// * the database used
class GPProjectModel extends StateUpdater {
  String _projectPath;
  GeopaparazziProjectDb _db;

  double lastCenterLon = 0;
  double lastCenterLat = 0;
  double lastCenterZoom = 5;

  String get projectPath => _projectPath;

  void setNewProject(state, String path) {
    rebuildWidgets(
        setStates: () {
          _projectPath = path;
          if (_db != null && _db.isOpen()) {
            _db.close();
            _db = null;
          }
        },
        states: [state]);
  }

  Future<GeopaparazziProjectDb> getDatabase() async {
    if (_db == null) {
      if (_projectPath == null) {
        _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
        GpLogger().d("Read db path from preferences: $_projectPath");
      }
      if (_projectPath == null) {
        GpLogger().w("No project path found");
        return null;
      }
      try {
        GpLogger().d("Opening db $_projectPath...");
        _db = GeopaparazziProjectDb(_projectPath);
        await _db.openOrCreate();
        GpLogger().d("Db opened: $_projectPath");
      } catch (e) {
        print(e);
      }

      await _db.createNecessaryExtraTables();
//      await _db.printInfo();

      await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
    }
    return _db;
  }

  void close() {
    if (_db != null) {
      _db.close();
      GpLogger().d("Closed db: ${_db.path}");
    }
    _projectPath = null;
  }
}

/// Class to help update the state around the widget tree.
class StateUpdater extends State {
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
