/*
 * Copyright (c) 2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';

/// Handler ov everything related to files supported in SMASH.
class FileManager {
  static const ALLOWED_PROJECT_EXT = [GEOPAPARAZZI_EXT];
  static const ALLOWED_VECTOR_DATA_EXT = [GPX_EXT, GEOPACKAGE_EXT];
  static const ALLOWED_TILE_DATA_EXT = [
    GEOPACKAGE_EXT,
    MBTILES_EXT,
    MAPSFORGE_EXT,
    MAPURL_EXT
  ];

  static const GEOPAPARAZZI_EXT = "gpap";
  static const GPX_EXT = "gpx";
  static const GEOPACKAGE_EXT = "gpkg";
  static const MAPSFORGE_EXT = "map";
  static const MAPURL_EXT = "mapurl";
  static const MBTILES_EXT = "mbtiles";

  static bool isProjectFile(String path) {
    return path.toLowerCase().endsWith(ALLOWED_PROJECT_EXT[0]);
  }

  static bool isVectordataFile(String path) {
    for (var ext in ALLOWED_VECTOR_DATA_EXT) {
      if (path.toLowerCase().endsWith(ext)) return true;
    }
    return false;
  }

  static bool isTiledataFile(String path) {
    for (var ext in ALLOWED_TILE_DATA_EXT) {
      if (path.toLowerCase().endsWith(ext)) return true;
    }
    return false;
  }

  static bool isMapsforge(String path) {
    return path != null && path.toLowerCase().endsWith(MAPSFORGE_EXT);
  }

  static bool isMapurl(String path) {
    return path != null && path.toLowerCase().endsWith(MAPURL_EXT);
  }

  static bool isMbtiles(String path) {
    return path != null && path.toLowerCase().endsWith(MBTILES_EXT);
  }

  static bool isGpx(String path) {
    return path != null && path.toLowerCase().endsWith(GPX_EXT);
  }

  static bool isGeopackage(String path) {
    return path != null && path.toLowerCase().endsWith(GEOPACKAGE_EXT);
  }
}

class FileBrowser extends StatefulWidget {
  bool _doFolderMode;

  List<String> _allowedExtensions;

  String _startFolder;

  Function onSelectionFunction;

  FileBrowser(this._doFolderMode, this._allowedExtensions, this._startFolder,
      this.onSelectionFunction);

  @override
  FileBrowserState createState() {
    return FileBrowserState();
  }
}

class FileBrowserState extends State<FileBrowser> {
  String currentPath;
  bool onlyFiles = false;

  Future<List<List<dynamic>>> getFiles() async {
    if (currentPath == null) {
      currentPath = widget._startFolder;
    }

    List<List<dynamic>> files = FileUtilities.listFiles(currentPath,
        doOnlyFolder: widget._doFolderMode,
        allowedExtensions: widget._allowedExtensions);
    return files;
  }

  @override
  Widget build(BuildContext context) {
    var upButton = FloatingActionButton(
      heroTag: "FileBrowserUpButton",
      tooltip: "Go back up one folder.",
      child: Icon(MdiIcons.folderUpload),
      onPressed: () async {
        var rootDir = await Workspace.getRootFolder();
        if (currentPath == rootDir.path) {
          showWarningDialog(
              context, "The top level folder has already been reached.");
        } else {
          setState(() {
            currentPath = FileUtilities.parentFolderFromFile(currentPath);
          });
        }
      },
    );

    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(onlyFiles
                ? MdiIcons.folderMultipleOutline
                : MdiIcons.fileOutline),
            tooltip: onlyFiles ? "View only Files" : "View everything",
            onPressed: () {
              setState(() {
                onlyFiles = !onlyFiles;
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: getFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<List<dynamic>> data = snapshot.data;
            if (onlyFiles) {
              data = data.where((pathName) {
                bool isDir = pathName[2];
                return !isDir;
              }).toList();
            }
            return ListView(
              children: data.map((pathName) {
                String parentPath = pathName[0];
                String labelParentPath = parentPath;
                if (Platform.isIOS) {
                  labelParentPath =
                      IOS_DOCUMENTSFOLDER + Workspace.makeRelative(parentPath);
                }
                String name = pathName[1];
                bool isDir = pathName[2];
                var fullPath = FileUtilities.joinPaths(parentPath, name);

                IconData iconData = SmashIcons.forPath(fullPath);
                Widget trailingWidget;
                if (isDir) {
                  if (widget._doFolderMode) {
                    // if folder you can enter or select it
                    trailingWidget = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(MdiIcons.checkCircleOutline,
                              color: SmashColors.mainDecorations),
                          tooltip: "Select folder",
                          onPressed: () async {
                            await Workspace.setLastUsedFolder(parentPath);
                            await widget.onSelectionFunction(context,
                                FileUtilities.joinPaths(parentPath, name));
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_right),
                          tooltip: "Enter folder",
                          onPressed: () {
                            setState(() {
                              currentPath =
                                  FileUtilities.joinPaths(parentPath, name);
                            });
                          },
                        )
                      ],
                    );
                  } else {
                    trailingWidget = IconButton(
                      icon: Icon(Icons.arrow_right),
                      tooltip: "Enter folder",
                      onPressed: () {
                        setState(() {
                          currentPath =
                              FileUtilities.joinPaths(parentPath, name);
                        });
                      },
                    );
                  }
                } else {
                  // if it gets here, then it is sure no folder mode
                  trailingWidget = IconButton(
                    icon: Icon(MdiIcons.checkCircleOutline,
                        color: SmashColors.mainDecorations),
                    tooltip: "Select file",
                    onPressed: () async {
                      await Workspace.setLastUsedFolder(parentPath);
                      await widget.onSelectionFunction(
                          context, FileUtilities.joinPaths(parentPath, name));
                      Navigator.of(context).pop();
                    },
                  );
                }

                return ListTile(
                  leading: Icon(
                    iconData,
                    color: SmashColors.mainDecorations,
                  ),
                  title: Text(name),
                  subtitle: Text(labelParentPath),
                  trailing: trailingWidget,
                );
              }).toList(),
            );
          } else {
            return Center(
                child: SmashCircularProgress(label: "Loading files list..."));
          }
        },
      ),
      floatingActionButton: upButton,
    );
  }
}
