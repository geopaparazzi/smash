/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_importexport.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/diagnostic.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/network.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/share.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/validators.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:smash/eu/hydrologis/smash/gss.dart';
import 'package:smash/eu/hydrologis/smash/widgets/about.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';

const String KEY_DO_NOTE_IN_GPS = "KEY_DO_NOTE_IN_GPS";

_openProject(BuildContext context, String selectedPath) async {
  var projectState = Provider.of<ProjectState>(context, listen: false);
  await projectState.setNewProject(selectedPath);
  await projectState.reloadProject();
}

class DashboardUtils {
  static Widget makeToolbarBadge(Widget widget, int badgeValue) {
    if (badgeValue > 0) {
      return Badge(
        badgeColor: SmashColors.mainSelection,
        shape: BadgeShape.circle,
        toAnimate: false,
        badgeContent: Text(
          '$badgeValue',
          style: TextStyle(color: Colors.white),
        ),
        child: widget,
      );
    } else {
      return widget;
    }
  }

  static Widget makeToolbarZoomBadge(Widget widget, int badgeValue) {
    if (badgeValue > 0) {
      return Badge(
        badgeColor: SmashColors.mainDecorations,
        shape: BadgeShape.circle,
        toAnimate: false,
        badgeContent: Text(
          '$badgeValue',
          style: TextStyle(color: Colors.white),
        ),
        child: widget,
      );
    } else {
      return widget;
    }
  }

  static List<Widget> getDrawerTilesList(BuildContext context, MapController mapController) {
    var doDiagnostics = GpPreferences().getBooleanSync(KEY_ENABLE_DIAGNOSTICS, false);
    double iconSize = SmashUI.MEDIUM_ICON_SIZE;
    Color c = SmashColors.mainDecorations;
    return [
      ListTile(
        leading: new Icon(
          Icons.create_new_folder,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "New Project",
          bold: true,
          color: c,
        ),
        onTap: () => _createNewProject(context),
      ),
      ListTile(
        leading: new Icon(
          Icons.folder_open,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Open Project",
          bold: true,
          color: c,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          var lastUsedFolder = await Workspace.getLastUsedFolder();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileBrowser(
                        false,
                        FileManager.ALLOWED_PROJECT_EXT,
                        lastUsedFolder,
                        _openProject,
                      )));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.file_download,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Import",
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImportWidget()));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.file_upload,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Export",
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => ExportWidget()));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.settings,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Settings",
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsWidget()));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.insert_emoticon,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Available icons",
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => IconsWidget()));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.map,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Offline maps",
          bold: true,
          color: c,
        ),
        onTap: () async {
          var mapsFolder = await Workspace.getMapsFolder();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MapsDownloadWidget(mapsFolder)));
        },
      ),
      doDiagnostics
          ? ListTile(
              leading: new Icon(
                MdiIcons.bugOutline,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                "Run diagnostics",
                bold: true,
                color: c,
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiagnosticWidget())),
            )
          : Container(),
      ListTile(
        leading: new Icon(
          MdiIcons.informationOutline,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "About",
          bold: true,
          color: c,
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
      ),
    ];
  }

  static List<Widget> getEndDrawerListTiles(BuildContext context, MapController mapController) {
    Color c = SmashColors.mainDecorations;
    var iconSize = SmashUI.MEDIUM_ICON_SIZE;

    List<Widget> list = []
      ..add(
        ListTile(
          leading: new Icon(
            MdiIcons.navigation,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Go to",
            bold: true,
            color: c,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => GeocodingPage()));
          },
        ),
      )
      ..add(
        ListTile(
          leading: new Icon(
            MdiIcons.shareVariant,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Share position",
            bold: true,
            color: c,
          ),
          onTap: () {
            var gpsState = Provider.of<GpsState>(context, listen: false);
            var pos = gpsState.lastGpsPosition;
            StringBuffer sb = StringBuffer();
            sb.write("Latitude: ");
            sb.write(pos.latitude.toStringAsFixed(KEY_LATLONG_DECIMALS));
            sb.write("\nLongitude: ");
            sb.write(pos.longitude.toStringAsFixed(KEY_LATLONG_DECIMALS));
            sb.write("\nAltitude: ");
            sb.write(pos.altitude.toStringAsFixed(KEY_ELEV_DECIMALS));
            sb.write("\nAccuracy: ");
            sb.write(pos.accuracy.toStringAsFixed(KEY_ELEV_DECIMALS));
            sb.write("\nTimestamp: ");
            sb.write(TimeUtilities.ISO8601_TS_FORMATTER.format(pos.timestamp));
            ShareHandler.shareText(sb.toString());
          },
        ),
      )
      ..add(
        ListTile(
          leading: new Icon(
            MdiIcons.crosshairsGps,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Notes in GPS position",
            bold: true,
            color: c,
          ),
          trailing: Consumer<GpsState>(builder: (context, gpsState, child) {
            return Checkbox(
                value: gpsState.insertInGps,
                onChanged: (value) {
                  gpsState.insertInGps = value;
                });
          }),
        ),
      )
      ..add(
        ListTile(
          leading: new Icon(
            MdiIcons.crosshairsQuestion,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Query vector layers",
            bold: true,
            color: c,
          ),
          trailing: Consumer<InfoToolState>(builder: (context, infoState, child) {
            return Checkbox(
                value: infoState.isEnabled,
                onChanged: (value) {
                  infoState.setEnabled(value);
                });
          }),
        ),
      );

    return list;
  }

  static Future _createNewProject(BuildContext context) async {
    String projectName = "smash_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

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
      var newPath = join(file.path, userString);
      if (!newPath.endsWith(".gpap")) {
        newPath = "$newPath.gpap";
      }
      var gpFile = new File(newPath);
      var projectState = Provider.of<ProjectState>(context, listen: false);
      await projectState.setNewProject(gpFile.path);
      await projectState.reloadProject();
    }

    Navigator.of(context).pop();
  }

  static Icon getGpsStatusIcon(GpsStatus status, [double iconSize]) {
    Color color;
    IconData iconData;
    switch (status) {
      case GpsStatus.OFF:
        {
          color = SmashColors.gpsOff;
          iconData = Icons.gps_off;
          break;
        }
      case GpsStatus.ON_WITH_FIX:
        {
          color = SmashColors.gpsOnWithFix;
          iconData = Icons.gps_fixed;
          break;
        }
      case GpsStatus.ON_NO_FIX:
        {
          iconData = Icons.gps_not_fixed;
          color = SmashColors.gpsOnNoFix;
          break;
        }
      case GpsStatus.LOGGING:
        {
          iconData = Icons.gps_fixed;
          color = SmashColors.gpsLogging;
          break;
        }
      case GpsStatus.NOPERMISSION:
        {
          iconData = Icons.gps_off;
          color = SmashColors.gpsNoPermission;
          break;
        }
    }
    return iconSize != null
        ? Icon(
            iconData,
            color: color,
            size: iconSize,
          )
        : Icon(
            iconData,
            color: color,
          );
  }

  static Icon getLoggingIcon(GpsStatus status) {
    Color color;
    IconData iconData;
    switch (status) {
      case GpsStatus.LOGGING:
        {
          iconData = Icons.timeline;
          color = SmashColors.gpsLogging;
          break;
        }
      case GpsStatus.OFF:
      case GpsStatus.ON_WITH_FIX:
      case GpsStatus.ON_NO_FIX:
      case GpsStatus.NOPERMISSION:
        {
          iconData = Icons.timeline;
          color = SmashColors.mainBackground;
          break;
        }
      default:
        {
          iconData = Icons.timeline;
          color = SmashColors.mainBackground;
        }
    }
    return Icon(
      iconData,
      color: color,
    );
  }
}

class ExportWidget extends StatefulWidget {
  ExportWidget({Key key}) : super(key: key);

  @override
  _ExportWidgetState createState() => new _ExportWidgetState();
}

class _ExportWidgetState extends State<ExportWidget> {
  int _pdfBuildStatus = 0;
  String _outPath = "";

  Future<void> buildPdf(BuildContext context) async {
    var exportsFolder = await Workspace.getExportsFolder();
    var ts = TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now());
    var outFilePath = FileUtilities.joinPaths(exportsFolder.path, "smash_pdf_export_$ts.pdf");
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    await PdfExporter.exportDb(db, File(outFilePath));

    setState(() {
      _outPath = outFilePath;
      _pdfBuildStatus = 2;
    });
//    showInfoDialog(context, "Exported to $outFilePath");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Export"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
            leading: _pdfBuildStatus == 0
                ? Icon(
                    MdiIcons.filePdf,
                    color: SmashColors.mainDecorations,
                  )
                : _pdfBuildStatus == 1
                    ? CircularProgressIndicator()
                    : Icon(
                        Icons.check,
                        color: SmashColors.mainDecorations,
                      ),
            title: Text("${_pdfBuildStatus == 2 ? 'PDF exported' : 'PDF'}"),
            subtitle: Text("${_pdfBuildStatus == 2 ? _outPath : 'Export project to Portable Document Format'}"),
            onTap: () {
              setState(() {
                _outPath = "";
                _pdfBuildStatus = 1;
              });
              buildPdf(context);
//              Navigator.pop(context);
            }),
      ]),
    );
  }
}

class ImportWidget extends StatefulWidget {
  ImportWidget({Key key}) : super(key: key);

  @override
  _ImportWidgetState createState() => new _ImportWidgetState();
}

class _ImportWidgetState extends State<ImportWidget> {
  int _buildStatus = 0;
  String _outPath = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Import"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
            leading: Icon(
              MdiIcons.cloudLock,
              color: SmashColors.mainDecorations,
            ),
            title: Text("GSS"),
            subtitle: Text("Import from Geopaparazzi Survey Server"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => new GssImportWidget()));
            }),
      ]),
    );
  }
}

class GssImportWidget extends StatefulWidget {
  GssImportWidget({Key key}) : super(key: key);

  @override
  _GssImportWidgetState createState() => new _GssImportWidgetState();
}

class _GssImportWidgetState extends State<GssImportWidget> {
  /*
   * 0 = waiting
   * 1 = has data
   *
   * 11 = no server url available
   * 12 = download list error
   */
  int _status = 0;

  String _mapsFolderPath;
  String _projectsFolderPath;
  String _formsFolderPath;
  String _serverUrl;
  String _authHeader;
  List<String> _baseMapsList = [];
  List<String> _projectsList = [];
  List<String> _tagsList = [];

  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    Directory mapsFolder = await Workspace.getMapsFolder();
    _mapsFolderPath = mapsFolder.path;
    Directory projectsFolder = await Workspace.getProjectsFolder();
    _projectsFolderPath = projectsFolder.path;
    Directory formsFolder = await Workspace.getFormsFolder();
    _formsFolderPath = formsFolder.path;

    _serverUrl = GpPreferences().getStringSync(KEY_GSS_SERVER_URL);
    if (_serverUrl == null) {
      setState(() {
        _status = 11;
      });
      return;
    }
    String downloadDataListUrl = _serverUrl + GssUtilities.DATA_DOWNLOAD_PATH;
    String downloadTagsListUrl = _serverUrl + GssUtilities.TAGS_DOWNLOAD_PATH;
    _authHeader = await GssUtilities.getAuthHeader();

    try {
      Dio dio = new Dio();

      var dataResponse = await dio.get(downloadDataListUrl, options: Options(headers: {"Authorization": _authHeader}));
      var dataResponseMap = dataResponse.data;

      List<dynamic> baseMaps = dataResponseMap[GssUtilities.DATA_DOWNLOAD_BASEMAP];
      _baseMapsList.clear();
      baseMaps.forEach((bm) {
        var name = bm[GssUtilities.DATA_DOWNLOAD_NAME];
        if (FileManager.isVectordataFile(name) || FileManager.isTiledataFile(name)) {
          _baseMapsList.add(name);
        }
      });

      List<dynamic> _overlays = dataResponseMap[GssUtilities.DATA_DOWNLOAD_OVERLAYS];
      _overlays.forEach((ov) {
        var name = ov[GssUtilities.DATA_DOWNLOAD_NAME];
        if (FileManager.isVectordataFile(name) || FileManager.isTiledataFile(name)) {
          _baseMapsList.add(name);
        }
      });

      List<dynamic> _projects = dataResponseMap[GssUtilities.DATA_DOWNLOAD_PROJECTS];
      _projectsList.clear();
      _projects.forEach((proj) {
        var name = proj[GssUtilities.DATA_DOWNLOAD_NAME];
        if (FileManager.isProjectFile(name)) {
          _projectsList.add(name);
        }
      });

      var tagsResponse = await dio.get(downloadTagsListUrl, options: Options(headers: {"Authorization": _authHeader}));
      var tagsResponseMap = tagsResponse.data;
      var tagsJsonList = tagsResponseMap[GssUtilities.TAGS_DOWNLOAD_TAGS];
      if (tagsJsonList != null) {
        tagsJsonList.forEach((tg) {
          var name = tg[GssUtilities.TAGS_DOWNLOAD_TAG];
          _tagsList.add(name);
        });
      }

      setState(() {
        _status = 1;
      });
    } catch (e) {
      setState(() {
        _status = 12;
      });
      GpLogger().e("An error occurred while downloading GSS data list.", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GSS Import"),
      ),
      body: _status == 0
          ? Center(
              child: SmashCircularProgress(label: "Downloading data list..."),
            )
          : _status == 12
              ? Center(
                  child: Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.errorWidget("Unable to download data list, check diagnostics."),
                  ),
                )
              : _status == 11
                  ? Center(
                      child: Padding(
                        padding: SmashUI.defaultPadding(),
                        child: SmashUI.titleText("No GSS server url has been set. Check your settings."),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Card(
                              margin: SmashUI.defaultMargin(),
                              elevation: SmashUI.DEFAULT_ELEVATION,
                              color: SmashColors.mainBackground,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.normalText("Data", bold: true),
                                  ),
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.smallText("Datasets are downloaded into the maps folder.", color: Colors.grey),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _baseMapsList.length,
                                    itemBuilder: (context, index) {
                                      var name = _baseMapsList[index];

                                      String downloadUrl = _serverUrl + GssUtilities.DATA_DOWNLOAD_PATH + "?" + GssUtilities.DATA_DOWNLOAD_NAME + "=" + name;

                                      return FileDownloadListTileProgressWidget(
                                        downloadUrl,
                                        FileUtilities.joinPaths(_mapsFolderPath, name),
                                        name,
                                        authHeader: _authHeader,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Card(
                              margin: SmashUI.defaultMargin(),
                              elevation: SmashUI.DEFAULT_ELEVATION,
                              color: SmashColors.mainBackground,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.normalText("Projects", bold: true),
                                  ),
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.smallText("Projects are downloaded into the projects folder.", color: Colors.grey),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _projectsList.length,
                                    itemBuilder: (context, index) {
                                      var name = _projectsList[index];

                                      String downloadUrl = _serverUrl + GssUtilities.DATA_DOWNLOAD_PATH + "?" + GssUtilities.DATA_DOWNLOAD_NAME + "=" + name;

                                      return FileDownloadListTileProgressWidget(
                                        downloadUrl,
                                        FileUtilities.joinPaths(_projectsFolderPath, name),
                                        name,
                                        authHeader: _authHeader,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Card(
                              margin: SmashUI.defaultMargin(),
                              elevation: SmashUI.DEFAULT_ELEVATION,
                              color: SmashColors.mainBackground,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.normalText("Forms", bold: true),
                                  ),
                                  Padding(
                                    padding: SmashUI.defaultPadding(),
                                    child: SmashUI.smallText("Tags files are downloaded into the forms folder.", color: Colors.grey),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _tagsList.length,
                                    itemBuilder: (context, index) {
                                      var name = _tagsList[index];

                                      String downloadUrl = _serverUrl + GssUtilities.TAGS_DOWNLOAD_PATH + "?" + GssUtilities.TAGS_DOWNLOAD_NAME + "=" + name;

                                      return FileDownloadListTileProgressWidget(
                                        downloadUrl,
                                        FileUtilities.joinPaths(_formsFolderPath, name),
                                        name,
                                        authHeader: _authHeader,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
