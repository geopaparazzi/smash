/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/mainview.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class ProjectView extends StatelessWidget {
  final bool isOpeningPage;
  ProjectView({this.isOpeningPage = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var recentProjectsList = GpPreferences().getRecentProjectsListSync();

    const inset = 15.0;
    const iconSize = 80.0;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // foregroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          SL.of(context).projectsView_projectsView, //"Project View",
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
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: SmashColors.mainDecorations, width: 3),
                  ),
                  // shape: StadiumBorder(),
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

                    if (selectedPath != null) {
                      await _openMainViewOnProject(context, selectedPath);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmashUI.normalText(
                        SL
                            .of(context)
                            .projectsView_openExistingProject, //"Open an existing project",
                        bold: false,
                        color: SmashColors.mainDecorations),
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
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: SmashColors.mainDecorations, width: 3),
                  ),
                  // shape: StadiumBorder(),
                  onPressed: () async {
                    await _createNewProjectAndOpenMainView(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmashUI.normalText(
                        SL
                            .of(context)
                            .projectsView_createNewProject, //"Create a new project",
                        bold: false,
                        color: SmashColors.mainDecorations),
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
                                  width: 3)),
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
                                  onTap: () async {
                                    await _openMainViewOnProject(context, path);
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
                              child: SmashUI.normalText(
                                  SL
                                      .of(context)
                                      .projectsView_recentProjects, //"Recent projects",
                                  color: SmashColors.mainDecorations),
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
    var userString = await SmashDialogs.showInputDialog(
      context,
      SL.of(context).projectsView_newProject, //"New Project",
      SL
          .of(context)
          .projectsView_enterNameForNewProject, //"Enter a name for the new project or accept the proposed.",
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
      await projectState.setNewProject(gpFile.path, context);
      if (isOpeningPage) {
        await initGpsTmp(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainViewWidget()));
      } else {
        Navigator.pop(context);
      }
    }
  }

  _openMainViewOnProject(BuildContext context, String selectedPath) async {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    await projectState.setNewProject(selectedPath, context);
    if (isOpeningPage) {
      await initGpsTmp(context);

      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainViewWidget()));
    } else {
      Navigator.pop(context);
    }
  }

  initGpsTmp(BuildContext context) async {
    if (isOpeningPage) {
      GpsState gpsState = Provider.of<GpsState>(context, listen: false);
      gpsState.init();
      ProjectState projectState =
          Provider.of<ProjectState>(context, listen: false);
      await GpsHandler().init(gpsState, projectState);
    }
  }
}
