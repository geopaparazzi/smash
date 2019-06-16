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
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/logs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/notes.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/map.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';
import 'package:path/path.dart';

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
  int _logsCount = 0;
  GpsStatus _gpsStatus = GpsStatus.OFF;
  Icon _gpsIcon;

  @override
  void initState() {
    _gpsIcon = Icon(
      Icons.gps_fixed,
      color: getGpsStatusColor(),
    );
  }

  Future<bool> _checkStats(BuildContext context) async {
    var database = await gpProjectModel.getDatabase();
    if (database != null) {
      _projectName = basename(database.path);

      _notesCount = await getNotesCount(database, false);
      _logsCount = await getLogsCount(database, false);
    } else {
      _notesCount = 0;
      _logsCount = 0;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    LocationPermissionHandler().requestPermission().then((isGranted) {
      if (isGranted) {
        GpsHandler().addPositionListener(this);
      }
    });

    _media = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Geopaparazzi"),
        actions: <Widget>[
          IconButton(
              icon: _gpsIcon,
              tooltip: "Check GPS Information",
              onPressed: () {
                print("GPS info Pressed...");
              })
        ],
      ),
      backgroundColor: GeopaparazziColors.mainBackground,
      body: FutureBuilder<void>(
        future: _checkStats(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                childAspectRatio:
                    orientation == Orientation.portrait ? 0.9 : 1.6,
                padding: EdgeInsets.all(5),
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children:
                    getTiles(context, orientation == Orientation.portrait),
              );
            });
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
    );
  }

  List<Widget> getTiles(BuildContext context, bool isPortrait) {
    var headerColor = Color.fromRGBO(256, 256, 256, 0);
    var iconSize = isPortrait ? _media.width / 4 : _media.height / 4;

    var headerNotes = "Notes";
    var iconNotes = Icons.note_add;

    var headerMetadata = "Metadata";
    var infoMetadata = "";
    var iconMetadata = Icons.developer_board;

    var headerLogs = "Logs";
    var infoLogs = "0";
    var iconLogs = GpsHandler().isLogging ? Icons.gps_fixed : Icons.gps_off;

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
      getSingleTile(context, headerNotes, headerColor,
          _notesCount == 0 ? "" : "${_notesCount}", iconNotes, iconSize, null),
      getSingleTile(context, headerMetadata, headerColor, infoMetadata,
          iconMetadata, iconSize, null),
      getSingleTile(
          context,
          headerLogs,
          headerColor,
          _logsCount == 0 ? "" : "${_logsCount}",
          iconLogs,
          iconSize,
          toggleLoggingFunction),
      getSingleTile(context, headerMaps, headerColor, infoMaps, iconMaps,
          iconSize, openMapFunction),
      getSingleTile(context, headerImport, headerColor, infoImport, iconImport,
          iconSize, null),
      getSingleTile(context, headerExport, headerColor, infoExport, iconExport,
          iconSize, null),
    ];
  }

  openMapFunction(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GeopaparazziMapWidget()));
  }

  toggleLoggingFunction(context) {
    if (GpsHandler().isLogging) {
      GpsHandler().stopLogging();
    } else {
      // TODO ask user
      String logName = ISO8601_TS_FORMATTER.format(DateTime.now());
      GpsHandler().startLogging(logName);
    }
    setState(() {});
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
          color: GeopaparazziColors.mainDecorations,
          child: IconButton(
            icon: Icon(
              icon,
              color: GeopaparazziColors.mainBackground,
            ),
            iconSize: iconSize,
            onPressed: () {
              function(context);
            },
            color: GeopaparazziColors.mainBackground,
            highlightColor: GeopaparazziColors.mainSelection,
          ),
        ));
  }

  getDrawerWidgets(BuildContext context) {
//    final String assetName = 'assets/geopaparazzi_launcher_icon.svg';
    double iconSize = 48;
    double textSize = iconSize / 2;
    var c = GeopaparazziColors.mainDecorations;
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(child: Image.asset("assets/gpicon.png")),
//            new SvgPicture.asset(
//          assetName,
//          fit: BoxFit.scaleDown,
//          semanticsLabel: 'A red up arrow',
//        )),
        color: GeopaparazziColors.mainDecorations,
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
  }

  @override
  void onPositionUpdate(Position position) {}

  @override
  void setStatus(GpsStatus currentStatus) {
    if (currentStatus != _gpsStatus) {
      setState(() {
        _gpsStatus = currentStatus;
        _gpsIcon = Icon(
          Icons.gps_fixed,
          color: getGpsStatusColor(),
        );
      });
    }
  }

  Color getGpsStatusColor() {
    switch (_gpsStatus) {
      case GpsStatus.OFF:
        {
          return GeopaparazziColors.gpsOff;
        }
      case GpsStatus.ON_WITH_FIX:
        {
          return GeopaparazziColors.gpsOnWithFix;
        }
      case GpsStatus.ON_NO_FIX:
        {
          return GeopaparazziColors.gpsOnNoFix;
        }
      case GpsStatus.LOGGING:
        {
          return GeopaparazziColors.gpsLogging;
        }
      case GpsStatus.NOPERMISSION:
        {
          return GeopaparazziColors.gpsNoPermission;
        }
    }
  }
}
