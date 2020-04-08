/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';
import 'package:smash/eu/hydrologis/smash/util/notifier.dart';

/// The provider object of the current project status
///
/// This provides the project database and triggers notification when that changes.
class ProjectState extends ChangeNotifierPlus {
  String _projectName = "No project loaded";
  String _projectPath;
  GeopaparazziProjectDb _db;
  ProjectData _projectData;

  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  String get projectPath => _projectPath;

  String get projectName => _projectName;

  GeopaparazziProjectDb get projectDb => _db;

  ProjectData get projectData => _projectData;

  Future<void> setNewProject(String path) async {
    GpLogger().d("Set new project: $path");
    await close();
    _projectPath = path;
    await openDb(_projectPath);
    GpPreferences().addRecentProject(path);
    notifyListenersMsg("setNewProject");
  }

  Future<void> openDb([String projectPath]) async {
    _projectPath = projectPath;
    if (_projectPath == null) {
      _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
      GpLogger().d("Read db path from preferences: $_projectPath");
    }
    if (_projectPath == null) {
      GpLogger().w("No project path found creating default");
      var projectsFolder = await Workspace.getProjectsFolder();
      _projectPath = FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
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
    await GpPreferences().setString(KEY_LAST_GPAPPROJECT, _projectPath);
    _projectName = FileUtilities.nameFromFile(_projectPath, false);
  }

  Future<void> close() async {
    if (_db != null && _db.isOpen()) {
      await _db.close();
      GpLogger().d("Closed db: ${_db.path}");
    }
    _db = null;
    _projectPath = null;
    context = null;
    scaffoldKey = null;
  }

  Future<void> reloadProject() async {
    if (projectDb == null) return;
    await reloadProjectQuiet();
    notifyListenersMsg('reloadProject');
  }

  Future<void> reloadProjectQuiet() async {
    if (projectDb == null) return;
    ProjectData tmp = ProjectData();
    tmp.projectName = basenameWithoutExtension(projectDb.path);
    tmp.projectDirName = dirname(projectDb.path);
    tmp.simpleNotesCount = await projectDb.getSimpleNotesCount(false);
    var imageNotescount = await projectDb.getImagesCount(false);
    tmp.simpleNotesCount += imageNotescount;
    tmp.logsCount = await projectDb.getGpsLogCount(false);
    tmp.formNotesCount = await projectDb.getFormNotesCount(false);

    List<Marker> tmpList = [];
    DataLoaderUtilities.loadImageMarkers(projectDb, tmpList, this);
    DataLoaderUtilities.loadNotesMarkers(projectDb, tmpList, this);
    tmp.geopapMarkers = tmpList;
    tmp.geopapLogs = await DataLoaderUtilities.loadLogLinesLayer(projectDb);
    _projectData = tmp;
  }
}

class ProjectData {
  String projectName;
  String projectDirName;
  int simpleNotesCount;
  int logsCount;
  int formNotesCount;
  List<Marker> geopapMarkers;
  PolylineLayerOptions geopapLogs;
}
