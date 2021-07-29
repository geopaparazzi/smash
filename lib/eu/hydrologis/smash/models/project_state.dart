/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/project/data_loader.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/notifier.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
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
    SMLogger().i("Set new project: $path");
    close();
    _projectPath = path;
    await openDb(_projectPath);
    await GpPreferences().addRecentProject(path);
    reloadProject(context);
  }

  Future<void> openDb([String projectPath]) async {
    _projectPath = projectPath;
    if (_projectPath == null) {
      _projectPath = await GpPreferences()
          .getString(SmashPreferencesKeys.KEY_LAST_GPAPPROJECT);
      SMLogger().i("Read db path from preferences: $_projectPath");
    }
    if (_projectPath == null) {
      SMLogger().w("No project path found creating default");
      var projectsFolder = await Workspace.getProjectsFolder();
      _projectPath = FileUtilities.joinPaths(projectsFolder.path, "smash.gpap");
    }
    try {
      SMLogger().i("Opening db $_projectPath...");
      _db = GeopaparazziProjectDb(_projectPath);
      _db.open();
      SMLogger().i("Db opened: $_projectPath");
    } on Exception catch (e, s) {
      SMLogger().e("Error opening project db: ", e, s);
    }

    _db.createNecessaryExtraTables();
    await GpPreferences()
        .setString(SmashPreferencesKeys.KEY_LAST_GPAPPROJECT, _projectPath);
    _projectName = FileUtilities.nameFromFile(_projectPath, false);
  }

  void close() {
    if (_db != null && _db.isOpen()) {
      _db.close();
      SMLogger().i("Closed db: ${_db.path}");
    }
    _db = null;
    _projectPath = null;
  }

  void reloadProject(BuildContext context) {
    if (projectDb == null) return;
    var mapBuilder = Provider.of<SmashMapBuilder>(context, listen: false);
    mapBuilder.context = context;
    reloadProjectQuiet(mapBuilder);
    mapBuilder.reBuild();
  }

  /// Reloads the project data but doesn't tigger a map build
  void reloadProjectQuiet(SmashMapBuilder mapBuilder) {
    if (projectDb == null) return;
    ProjectData tmp = ProjectData();
    tmp.projectName = basenameWithoutExtension(projectDb.path);
    tmp.projectDirName = dirname(projectDb.path);
    tmp.simpleNotesCount = projectDb.getSimpleNotesCount(false);
    int imageNotescount = projectDb.getImagesCount(false);
    tmp.simpleNotesCount += imageNotescount;
    tmp.logsCount = projectDb.getGpsLogCount(false);
    tmp.formNotesCount = projectDb.getFormNotesCount(false);

    List<Marker> tmpList = [];
    DataLoaderUtilities.loadImageMarkers(projectDb, tmpList, mapBuilder);
    var notesMode = GpPreferences().getStringSync(
        SmashPreferencesKeys.KEY_NOTES_VIEW_MODE,
        SmashPreferencesKeys.NOTESVIEWMODES[0]);
    DataLoaderUtilities.loadNotesMarkers(
        projectDb, tmpList, mapBuilder, notesMode);
    tmp.geopapMarkers = tmpList;

    List<String> currentLogViewModes = GpPreferences().getStringListSync(
        SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE, [
      SmashPreferencesKeys.LOGVIEWMODES[0],
      SmashPreferencesKeys.LOGVIEWMODES[1]
    ]);
    var logMode = currentLogViewModes[0];
    var filteredLogMode = currentLogViewModes[1];
    tmp.geopapLogs = DataLoaderUtilities.loadLogLinesLayer(
      projectDb,
      logMode != SmashPreferencesKeys.LOGVIEWMODES[0],
      filteredLogMode != SmashPreferencesKeys.LOGVIEWMODES[0],
      logMode == SmashPreferencesKeys.LOGVIEWMODES[2],
      filteredLogMode == SmashPreferencesKeys.LOGVIEWMODES[2],
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
