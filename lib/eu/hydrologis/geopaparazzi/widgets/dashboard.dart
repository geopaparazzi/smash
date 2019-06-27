/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/map.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/mapsforgetest/showmap.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/files.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/logging.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/validators.dart';
import 'package:geopaparazzi_light/eu/hydrologis/geopaparazzi/widgets/notes_ui.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => new _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget>
    implements PositionListener {
  Size _media;

  String _projectName = "No project loaded";
  int _notesCount = 0;

  ValueNotifier<GpsStatus> _gpsStatusValueNotifier =
      new ValueNotifier(GpsStatus.OFF);
  ValueNotifier<bool> _gpsLoggingValueNotifier = new ValueNotifier(false);

  Future<bool> _loadDashboardData(BuildContext context) async {
    List<PermissionGroup> mandatory = [];
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      mandatory.add(PermissionGroup.storage);
    }
    permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission != PermissionStatus.granted) {
      mandatory.add(PermissionGroup.location);
    }

    if (mandatory.length > 0) {
      Map<PermissionGroup, PermissionStatus> permissionsMap =
          await PermissionHandler().requestPermissions(mandatory);
      if (permissionsMap[PermissionGroup.storage] != PermissionStatus.granted) {
        return false;
      }
      if (permissionsMap[PermissionGroup.location] !=
          PermissionStatus.granted) {
        return false;
      } else {
        GpsHandler().addPositionListener(this);
      }
    }

    await GpLogger().init(); // init logger

    var database = await gpProjectModel.getDatabase();
    if (database != null) {
      _projectName = basename(database.path);
      _projectName = _projectName.substring(0, _projectName.length - 5);

      _notesCount = await database.getNotesCount(false);
    } else {
      _notesCount = 0;
    }

    bool gpsIsOn = await GpsHandler().isGpsOn();
    if (gpsIsOn != null) {
      if (gpsIsOn) {
        _gpsStatusValueNotifier.value = GpsStatus.ON_NO_FIX;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    _media = MediaQuery.of(context).size;

    return WillPopScope(
        // check when the app is left
        child: new Scaffold(
          appBar: new AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Image.asset("assets/smash_text.png", fit: BoxFit.cover),
            ),
            //new Text(GpConstants.APP_NAME),
            actions: <Widget>[
              AppBarGpsInfo(_gpsStatusValueNotifier),
            ],
          ),
          backgroundColor: SmashColors.mainBackground,
          body: FutureBuilder<bool>(
            future: _loadDashboardData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  // If the Future is complete and ended well, display the dashboard
                  return OrientationBuilder(builder: (context, orientation) {
                    return GridView.count(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3,
                      childAspectRatio:
                          orientation == Orientation.portrait ? 0.9 : 1.6,
                      padding: EdgeInsets.all(5),
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: getTiles(
                          context, orientation == Orientation.portrait),
                    );
                  });
                } else {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Storage and location permission are necessary to work!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ));
                }
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
//      persistentFooterButtons: <Widget>[
//        Card(
//            elevation: 5,
//            color: GeopaparazziColors.mainDecorations,
//            child: Text(_projectName)),
//      ],
          drawer: Drawer(
              child: ListView(
            children: getDrawerWidgets(context),
          )),
        ),
        onWillPop: () async {
          bool doExit = await showConfirmDialog(
              context,
              "Are you sure you want to exit?",
              "Active operations will be stopped.");
          if (doExit) {
            dispose();
            return Future.value(true);
//              Navigator.of(context).pop(true);
          }
        });
  }

  @override
  void dispose() {
    if (gpProjectModel != null) {
      _savePosition().then((v) {
        gpProjectModel.close();
        gpProjectModel = null;
        super.dispose();
      });
    } else {
      super.dispose();
    }
  }

  Future<void> _savePosition() async {
    await GpPreferences().setLastPosition(gpProjectModel.lastCenterLon,
        gpProjectModel.lastCenterLat, gpProjectModel.lastCenterZoom);
  }

  List<Widget> getTiles(BuildContext context, bool isPortrait) {
    var headerColor = Color.fromRGBO(256, 256, 256, 0);
    var iconSize = isPortrait ? _media.width / 4 : _media.height / 4;

    var headerNotes = "Notes";
    var iconNotes = Icons.note_add;

    var headerMetadata = _projectName;
    var infoMetadata = "";
    var iconMetadata = Icons.developer_board;

    var headerMaps = "Maps";
    var infoMaps = "";
    var iconMaps = Icons.map;

    var headerImport = "Import";
    var infoImport = "";
    var iconImport = Icons.file_download;

    var headerExport = "Export";
    var infoExport = "";
    var iconExport = Icons.file_upload;

    return [
      getSingleTile(
          context,
          headerNotes,
          headerColor,
          _notesCount == 0 ? "" : "${_notesCount}",
          iconNotes,
          iconSize,
          _openAddNoteFunction),
      getSingleTile(context, headerMetadata, headerColor, infoMetadata,
          iconMetadata, iconSize, _openMapsforgeFunction),
      DashboardLogButton(_gpsLoggingValueNotifier, _gpsStatusValueNotifier),
      getSingleTile(context, headerMaps, headerColor, infoMaps, iconMaps,
          iconSize, _openMapFunction),
      getSingleTile(context, headerImport, headerColor, infoImport, iconImport,
          iconSize, null),
      getSingleTile(context, headerExport, headerColor, infoExport, iconExport,
          iconSize, null),
    ];
  }

  _openMapFunction(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GeopaparazziMapWidget()));
  }

  _openMapsforgeFunction(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Showmap()));
  }

  _openAddNoteFunction(context) {
    if (GpsHandler().hasFix()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddNotePage()));
    } else {
      showOperationNeedsGps(context);
    }
  }

  GridTile getSingleTile(BuildContext context, String header, Color color,
      String info, IconData icon, double iconSize, Function function) {
    return GridTile(
        header: GridTileBar(
          title: Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: color,
        ),
        footer: GridTileBar(
            title: Text(info,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold))),
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          color: SmashColors.mainDecorations,
          child: IconButton(
            icon: Icon(
              icon,
              color: SmashColors.mainBackground,
            ),
            iconSize: iconSize,
            onPressed: () {
              function(context);
            },
            color: SmashColors.mainBackground,
            highlightColor: SmashColors.mainSelection,
          ),
        ));
  }

  getDrawerWidgets(BuildContext context) {
//    final String assetName = 'assets/geopaparazzi_launcher_icon.svg';
    double iconSize = 48;
    double textSize = iconSize / 2;
    var c = SmashColors.mainDecorations;
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(child: Image.asset("assets/smash_icon.png")),
        color: SmashColors.mainBackground,
      ),
      new Container(
        child: new Column(children: [
          ListTile(
            leading: new Icon(
              Icons.create_new_folder,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "New Project",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _createNewProject(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.folder_open,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Open Project",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openProject(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.settings,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openSettings(context),
          ),
          ListTile(
            leading: new Icon(
              Icons.info_outline,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "About",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => _openAbout(context),
          ),
        ]),
      ),
    ];
  }

  Future doExit(BuildContext context) async {
    await gpProjectModel.close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  Future _openSettings(BuildContext context) async {}

  Future _openAbout(BuildContext context) async {}

  Future _openProject(BuildContext context) async {
    File file =
        await FilePicker.getFile(type: FileType.ANY, fileExtension: 'gpap');
    if (file != null && file.existsSync()) {
      gpProjectModel.setNewProject(this, file.path);
    }
    Navigator.of(context).pop();
  }

  Future _createNewProject(BuildContext context) async {
    String projectName =
        "geopaparazzi_${GpConstants.DATE_TS_FORMATTER.format(DateTime.now())}";

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
      var file = await FileUtils.getDefaultStorageFolder();
      var newPath = join(file.path, userString);
      if (!newPath.endsWith(".gpap")) {
        newPath = "$newPath.gpap";
      }
      var gpFile = new File(newPath);
      gpProjectModel.setNewProject(this, gpFile.path);
    }

    Navigator.of(context).pop();
  }

  @override
  void onPositionUpdate(Position position) {}

  @override
  void setStatus(GpsStatus currentStatus) {
    _gpsStatusValueNotifier.value = currentStatus;
  }
}

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class AppBarGpsInfo extends StatefulWidget {
  final ValueNotifier<GpsStatus> _gpsStatusValueNotifier;

  AppBarGpsInfo(this._gpsStatusValueNotifier);

  @override
  State<StatefulWidget> createState() =>
      AppBarGpsInfoState(_gpsStatusValueNotifier);
}

class AppBarGpsInfoState extends State<AppBarGpsInfo> {
  ValueNotifier<GpsStatus> _gpsStatusValueNotifier;
  GpsStatus _gpsStatus;

  AppBarGpsInfoState(this._gpsStatusValueNotifier);

  @override
  void initState() {
    _gpsStatusValueNotifier.addListener(() {
      setState(() {
        _gpsStatus = _gpsStatusValueNotifier.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: getGpsStatusIcon(_gpsStatus),
        tooltip: "Check GPS Information",
        onPressed: () {
          print("GPS info Pressed...");
        });
  }
}

Icon getGpsStatusIcon(GpsStatus status) {
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
  return Icon(
    iconData,
    color: color,
  );
}

/// Class to hold the state of the dashboard logging button, updated by the gps logging state notifier.
///
class DashboardLogButton extends StatefulWidget {
  ValueNotifier<bool> _gpsLoggingValueNotifier;
  ValueNotifier<GpsStatus> _gpsStatusValueNotifier;

  DashboardLogButton(
      this._gpsLoggingValueNotifier, this._gpsStatusValueNotifier);

  @override
  State<StatefulWidget> createState() => DashboardLogButtonState(
      _gpsLoggingValueNotifier, _gpsStatusValueNotifier);
}

class DashboardLogButtonState extends State<DashboardLogButton> {
  ValueNotifier<bool> _gpsLoggingValueNotifier;
  bool _isLogging;
  ValueNotifier<GpsStatus> _gpsStatusValueNotifier;

  GpsStatus _lastNonLoggingStatus;

  int _logsCount;

  DashboardLogButtonState(
      this._gpsLoggingValueNotifier, this._gpsStatusValueNotifier);

  @override
  void initState() {
    _isLogging = _gpsLoggingValueNotifier.value;
    _gpsLoggingValueNotifier.addListener(() {
      if (this.mounted)
        setState(() {
          _isLogging = _gpsLoggingValueNotifier.value;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var headerColor = Color.fromRGBO(256, 256, 256, 0);

    var header = "Logs";
    var icon = _isLogging ? Icons.gps_fixed : Icons.gps_off;

    var _media = MediaQuery.of(context).size;

    return FutureBuilder<void>(
      future: _checkStats(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return OrientationBuilder(builder: (context, orientation) {
            return GridTile(
                header: GridTileBar(
                  title: Text(header,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: headerColor,
                ),
                footer: GridTileBar(
                    title: Text(_logsCount == 0 ? "" : "${_logsCount}",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  color: _isLogging
                      ? SmashColors.gpsLogging
                      : SmashColors.mainDecorations,
                  child: IconButton(
                    icon: Icon(
                      icon,
                      color: SmashColors.mainBackground,
                    ),
                    iconSize: orientation == Orientation.portrait
                        ? _media.width / 4
                        : _media.height / 4,
                    onPressed: () {
                      toggleLoggingFunction(context);
                    },
                    color: SmashColors.mainBackground,
                    highlightColor: SmashColors.mainSelection,
                  ),
                ));
          });
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<bool> _checkStats(BuildContext context) async {
    var database = await gpProjectModel.getDatabase();
    if (database != null) {
      _logsCount = await database.getGpsLogCount(false);
    } else {
      _logsCount = 0;
    }
    return true;
  }

  toggleLoggingFunction(BuildContext context) {
    if (GpsHandler().isLogging) {
      GpsHandler().stopLogging();
      _gpsStatusValueNotifier.value = _lastNonLoggingStatus;
      _gpsLoggingValueNotifier.value = false;
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log ${GpConstants.ISO8601_TS_FORMATTER.format(DateTime.now())}";

        showInputDialog(
          context,
          "New Log",
          "Enter a name for the new log",
          hintText: '',
          defaultText: logName,
          validationFunction: noEmptyValidator,
        ).then((userString) {
          if (userString != null) {
            if (userString.trim().length == 0) userString = logName;

            GpsHandler().startLogging(logName).then((logId) {
              if (logId == null) {
                // TODO show error
              } else {
                _lastNonLoggingStatus = _gpsStatusValueNotifier.value;
                _gpsStatusValueNotifier.value = GpsStatus.LOGGING;
                _gpsLoggingValueNotifier.value = true;
              }
            });
          }
        });
      } else {
        showOperationNeedsGps(context);
      }
    }
  }
}
