/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/notifier.dart';
import 'package:smashlibs/smashlibs.dart';

/// The provider object of the current project status
///
/// This provides the project database and triggers notification when that changes.
class ProjectState extends ChangeNotifierPlus {
  String _projectName = "No project loaded";
  String _projectPath;
  GeopaparazziProjectDb _db;
  ProjectData _projectData;

  String get projectPath => _projectPath;

  String get projectName => _projectName;

  GeopaparazziProjectDb get projectDb => _db;

  ProjectData get projectData => _projectData;

  Future<void> setNewProject(String path, BuildContext context) async {
    GpLogger().i("Set new project: $path");
    await close();
    _projectPath = path;
    await openDb(_projectPath);
    await GpPreferences().addRecentProject(path);
    await reloadProject(context);
  }

  Future<void> openDb([String projectPath]) async {
    _projectPath = projectPath;
    if (_projectPath == null) {
      _projectPath = await GpPreferences().getString(KEY_LAST_GPAPPROJECT);
      GpLogger().i("Read db path from preferences: $_projectPath");
    }
    if (_projectPath == null) {
      GpLogger().w("No project path found creating default");
      var projectsFolder = await Workspace.getProjectsFolder();
      _projectPath = FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
    }
    try {
      GpLogger().i("Opening db $_projectPath...");
      _db = GeopaparazziProjectDb(_projectPath);
      await _db.openOrCreate();
      GpLogger().i("Db opened: $_projectPath");
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
      GpLogger().i("Closed db: ${_db.path}");
    }
    _db = null;
    _projectPath = null;
  }

  Future<void> reloadProject(BuildContext context) async {
    if (projectDb == null) return;
    var mapBuilder = Provider.of<SmashMapBuilder>(context, listen: false);
    await reloadProjectQuiet(mapBuilder);
    mapBuilder.reBuild();
  }

  /// Reloads the project data but doesn't tigger a map build
  Future<void> reloadProjectQuiet(SmashMapBuilder mapBuilder) async {
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
    await DataLoaderUtilities.loadImageMarkers(projectDb, tmpList, mapBuilder);
    await DataLoaderUtilities.loadNotesMarkers(projectDb, tmpList, mapBuilder);
    tmp.geopapMarkers = tmpList;

    var gpsState = Provider.of<GpsState>(mapBuilder.context);
    tmp.geopapLogs = await DataLoaderUtilities.loadLogLinesLayer(
      projectDb,
      gpsState.logMode != LOGVIEWMODES[0],
      gpsState.filteredLogMode != LOGVIEWMODES[0],
      gpsState.logMode == LOGVIEWMODES[2],
      gpsState.filteredLogMode == LOGVIEWMODES[2],
    );
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
