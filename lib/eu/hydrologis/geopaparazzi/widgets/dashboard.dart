/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/geopaparazzi_models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/notes.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => new _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Size _media;

  String _projectName = "No project loaded";
  int _notesCount = 0;
  int _logsCount = 0;

  _DashboardWidgetState() {}

  Future<bool> _checkStats(BuildContext context) async {
    GeopaparazziProjectModel projectModel =
        ScopedModel.of<GeopaparazziProjectModel>(context,
            rebuildOnChange: true);
    var database = await projectModel.getDatabase();
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
        GpsHandler();
      }
    });

    _media = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Geopaparazzi"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.gps_fixed,
                color: GeopaparazziColors.mainBackground,
              ),
              tooltip: "Check GPS Information",
              onPressed: () {
                print("GPS info Pressed...");
              })
        ],
      ),
      backgroundColor: GeopaparazziColors.mainBackground,
      body: ScopedModel<GeopaparazziProjectModel>(
          model: GeopaparazziProjectModel(),
          child: FutureBuilder<void>(
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
                    children: getTiles(orientation == Orientation.portrait),
                  );
                });
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
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

  List<Widget> getTiles(bool isPortrait) {
    var headerColor = Color.fromRGBO(256, 256, 256, 0);
    var iconSize = isPortrait ? _media.width / 4 : _media.height / 4;

    var headerNotes = "Notes";
    var iconNotes = Icons.note_add;

    var headerMetadata = "Metadata";
    var infoMetadata = "";
    var iconMetadata = Icons.developer_board;

    var headerLogs = "Logs";
    var infoLogs = "0";
    var iconLogs = Icons.gps_off;

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
      getSingleTile(headerNotes, headerColor,
          _notesCount == 0 ? "" : "${_notesCount}", iconNotes, iconSize),
      getSingleTile(
          headerMetadata, headerColor, infoMetadata, iconMetadata, iconSize),
      getSingleTile(headerLogs, headerColor,
          _logsCount == 0 ? "" : "${_logsCount}", iconLogs, iconSize),
      getSingleTile(headerMaps, headerColor, infoMaps, iconMaps, iconSize),
      getSingleTile(
          headerImport, headerColor, infoImport, iconImport, iconSize),
      getSingleTile(
          headerExport, headerColor, infoExport, iconExport, iconSize),
    ];
  }

  GridTile getSingleTile(
      String header, Color color, String info, IconData icon, double iconSize) {
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
            onPressed: () {},
            color: GeopaparazziColors.mainBackground,
            highlightColor: GeopaparazziColors.mainSelection,
          ),
        ));
  }

  getDrawerWidgets(BuildContext context) {
    final String assetName = 'assets/geopaparazzi_launcher_icon.svg';
    double iconSize = 48;
    double textSize = iconSize / 2;
    var c = GeopaparazziColors.mainDecorations;
    return [
      new Container(
        margin: EdgeInsets.only(bottom: 20),
        child: new DrawerHeader(
            child: new SvgPicture.asset(
          assetName,
          fit: BoxFit.scaleDown,
          semanticsLabel: 'A red up arrow',
        )),
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
          ListTile(
            leading: new Icon(
              Icons.exit_to_app,
              color: c,
              size: iconSize,
            ),
            title: Text(
              "Exit",
              style: TextStyle(fontSize: textSize, color: c),
            ),
            onTap: () => doExit(context),
          ),
        ]),
      ),
    ];
  }

  Future doExit(BuildContext context) async {
    GeopaparazziProjectModel projectModel =
        ScopedModel.of<GeopaparazziProjectModel>(context,
            rebuildOnChange: true);
    await projectModel.close();

    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  Future _openSettings(BuildContext context) async {}

  Future _openAbout(BuildContext context) async {}

  Future _openProject(BuildContext context) async {
    File file =
        await FilePicker.getFile(type: FileType.ANY, fileExtension: 'gpap');
    if (file != null && file.existsSync()) {
      GeopaparazziProjectModel projectModel =
          ScopedModel.of<GeopaparazziProjectModel>(context,
              rebuildOnChange: true);
      projectModel.projectPath = file.path;
      setState(() {});
    }
  }
}
