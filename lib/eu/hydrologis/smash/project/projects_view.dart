/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/validators.dart';
import 'package:smash/eu/hydrologis/smash/mainview.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';

class ProjectView extends StatelessWidget {
  final bool isOpeningPage;
  ProjectView({this.isOpeningPage = false, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var recentProjectsList = GpPreferences().getRecentProjectsListSync();

    const inset = 15.0;
    const iconSize = 96.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Project View",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                MdiIcons.folderOpenOutline,
                color: SmashColors.mainDecorations,
                size: iconSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: inset, right: inset, bottom: inset),
              child: Container(
                width: double.infinity,
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: SmashColors.mainDecorations, width: 5),
                  shape: StadiumBorder(),
                  onPressed: () async {
                    var lastUsedFolder = await Workspace.getLastUsedFolder();
                    var selectedPath = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FileBrowser(
                                  false,
                                  FileManager.ALLOWED_PROJECT_EXT,
                                  lastUsedFolder,
                                )));
                    _openMainViewOnProject(context, selectedPath);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmashUI.titleText("Open an existing project",
                        bold: false, color: SmashColors.mainDecorations),
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(
                MdiIcons.folderPlusOutline,
                color: SmashColors.mainDecorations,
                size: iconSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: inset, right: inset, bottom: inset),
              child: Container(
                width: double.infinity,
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: SmashColors.mainDecorations, width: 5),
                  shape: StadiumBorder(),
                  onPressed: () async {
                    _createNewProjectAndOpenMainView(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmashUI.titleText("Create a new project",
                        bold: false, color: SmashColors.mainDecorations),
                  ),
                ),
              ),
            ),
            recentProjectsList.length == 0
                ? Container()
                : Center(
                    child: Icon(
                      MdiIcons.history,
                      color: SmashColors.mainDecorations,
                      size: iconSize,
                    ),
                  ),
            recentProjectsList.length == 0
                ? Container()
                : Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              border: Border.all(
                                  color: SmashColors.mainDecorations,
                                  width: 5)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: recentProjectsList.map((path) {
                              String folder =
                                  FileUtilities.parentFolderFromFile(path);
                              folder = Workspace.makeRelative(folder);
                              String projectName =
                                  FileUtilities.nameFromFile(path, false)
                                      .replaceAll("_", " ");
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ListTile(
                                  leading: Icon(
                                    SmashIcons.forPath(path),
                                    color: SmashColors.mainDecorations,
                                    size: 48,
                                  ),
                                  title: Text(projectName),
                                  subtitle: Text(folder),
                                  trailing: Icon(MdiIcons.arrowRight),
                                  onTap: () {
                                    _openMainViewOnProject(context, path);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 50,
                          top: 0,
                          child: Container(
                            color: SmashColors.mainBackground,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: SmashUI.normalText("Recent projects",
                                  color: SmashColors.mainTextColor),
                            ),
                          ))
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  _createNewProjectAndOpenMainView(BuildContext context) async {
    String projectName =
        "smash_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";
    var userString = await showInputDialog(
      context,
      "New Project",
      "Enter a name for the new project or accept the proposed.",
      hintText: '',
      defaultText: projectName,
      validationFunction: fileNameValidator,
    );
    if (userString != null) {
      if (userString.trim().length == 0) userString = projectName;
      var file = await Workspace.getProjectsFolder();
      var newPath = FileUtilities.joinPaths(file.path, userString);
      if (!newPath.endsWith(".gpap")) {
        newPath = "$newPath.gpap";
      }
      var gpFile = new File(newPath);
      var projectState = Provider.of<ProjectState>(context, listen: false);
      var gpsState = Provider.of<GpsState>(context, listen: false);
      gpsState.projectState = projectState;
      await projectState.setNewProject(gpFile.path);
      await projectState.reloadProject();
      Navigator.pop(context);
      if (isOpeningPage) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainViewWidget()));
      }
    }
  }

  _openMainViewOnProject(BuildContext context, String selectedPath) async {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var gpsState = Provider.of<GpsState>(context, listen: false);
    gpsState.projectState = projectState;
    await projectState.setNewProject(selectedPath);
    await projectState.reloadProject();
    Navigator.pop(context);
    if (isOpeningPage) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainViewWidget()));
    }
  }
}
