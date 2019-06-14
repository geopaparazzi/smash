/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => new _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  static const iconSize = 64.0;

  Size media;

  @override
  Widget build(BuildContext context) {
    LocationPermissionHandler().requestPermission().then((isGranted) {
      if (isGranted) {
        GpsHandler();
      }
    });

    media = MediaQuery.of(context).size;
    print("${media.width} ${media.height}");

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
      body: LayoutBuilder(builder: (context, constraint) {
        return getDashboardTiles(
            media.width < media.height, constraint);
      }),
      drawer: Drawer(child: ListView(children: getDrawerWidgets())),
    );
  }

  Widget getDashboardTiles(bool isPortrait, BoxConstraints constraint) {
    var alig = MainAxisAlignment.center;
    var headerColor = Color.fromRGBO(0, 0, 0, 0.5);
    if (isPortrait) {
      return Center(
          child: Column(
        mainAxisAlignment: alig,
        children: <Widget>[
          Row(
            mainAxisAlignment: alig,
            children: <Widget>[
              buildButton("Notes", "0", Icons.note_add, headerColor, constraint,
                  _onNotesPushed()),
              buildButton("Metadata", "", Icons.developer_board, headerColor,
                  constraint, _onMetadataPushed()),
            ],
          ),
          Row(
            mainAxisAlignment: alig,
            children: <Widget>[
              buildButton("Logs", "0", Icons.gps_off, headerColor, constraint,
                  _onLogTogglePushed()),
              buildButton("Maps", "", Icons.map, headerColor, constraint,
                  _onMapsPushed()),
            ],
          ),
          Row(
            mainAxisAlignment: alig,
            children: <Widget>[
              buildButton("Import", "", Icons.file_download, headerColor,
                  constraint, _onImportPushed()),
              buildButton("Export", "", Icons.file_upload, headerColor,
                  constraint, _onExportPushed()),
            ],
          ),
        ],
      ));
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: alig,
        children: <Widget>[
          Row(
            mainAxisAlignment: alig,
            children: <Widget>[
              buildButton("Notes", "0", Icons.note_add, headerColor, constraint,
                  _onNotesPushed()),
              buildButton("Logs", "0", Icons.gps_off, headerColor, constraint,
                  _onLogTogglePushed()),
              buildButton("Maps", "", Icons.map, headerColor, constraint,
                  _onMapsPushed()),
            ],
          ),
          Row(
            mainAxisAlignment: alig,
            children: <Widget>[
              buildButton("Metadata", "", Icons.developer_board, headerColor,
                  constraint, _onMetadataPushed()),
              buildButton("Import", "", Icons.file_download, headerColor,
                  constraint, _onImportPushed()),
              buildButton("Export", "", Icons.file_upload, headerColor,
                  constraint, _onExportPushed()),
            ],
          ),
        ],
      ));
    }
  }

  Widget buildButton(String headerText, String footerText, IconData icon,
      Color headerColor, BoxConstraints constraint, runMethod) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      color: GeopaparazziColors.mainDecorations,
      child: IconButton(
        icon: Icon(
          icon,
          color: GeopaparazziColors.mainBackground,
        ),
        iconSize: constraint.maxWidth / 2.5,
        onPressed: runMethod,
        color: GeopaparazziColors.mainBackground,
        highlightColor: GeopaparazziColors.mainSelection,
      ),
    );
  }

  _onNotesPushed() {
    print("Notes pushed");
  }

  _onMetadataPushed() {}

  _onLogTogglePushed() {}

  _onMapsPushed() {}

  _onImportPushed() {}

  _onExportPushed() {}

  getDrawerWidgets() {
    return [
      Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.create_new_folder),
            onPressed: () {
              print("new project");
            }),
        Text("New Project")
      ]),
      Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: () {
              print("open project");
            }),
        Text("Open Project")
      ]),
      Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("settings");
            }),
        Text("Settings")
      ]),
      Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              print("about");
            }),
        Text("About")
      ]),
      Row(children: <Widget>[
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              print("exit");
            }),
        Text("Exit")
      ]),
    ];
  }
}
