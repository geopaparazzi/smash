/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'gp_database.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';

/// The global reference to the Geopaparazzi Project.
///
/// This contains all information about:
/// * the current project opened
/// * the last center position
/// * the database used
class GPProject {
  static final GPProject _instance = GPProject._internal();

  factory GPProject() => _instance;

  GPProject._internal();

  String _projectPath;
  GeopaparazziProjectDb _db;

  double lastCenterLon = 0;
  double lastCenterLat = 0;
  double lastCenterZoom = 16;

  String get projectPath => _projectPath;

  void setNewProject(String path) async {
    GpLogger().d("Set new project: $path");
    await close();
    _projectPath = path;
  }

  Future<GeopaparazziProjectDb> getDatabase() async {
    if (_db == null) {
      if (_projectPath == null) {
        _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
        GpLogger().d("Read db path from preferences: $_projectPath");
      }
      if (_projectPath == null) {
        GpLogger().w("No project path found creating default");
        var projectsFolder = await Workspace.getProjectsFolder();
        _projectPath =
            FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
      }
      try {
        GpLogger().d("Opening db $_projectPath...");
        _db = GeopaparazziProjectDb(_projectPath);
        await _db.openOrCreate();
        GpLogger().d("Db opened: $_projectPath");
      } catch (e) {
        GpLogger().e("Error opening project db: ", e);
      }

      await _db.createNecessaryExtraTables();
//      await _db.printInfo();

      await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
    }
    return _db;
  }

  Future<void> close() async {
    if (_db != null && _db.isOpen()) {
      await _db.close();
      GpLogger().d("Closed db: ${_db.path}");
    }
    _db = null;
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
