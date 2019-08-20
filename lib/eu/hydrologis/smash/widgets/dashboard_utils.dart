/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';
import 'package:path/path.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'about.dart';

const String KEY_DO_NOTE_IN_GPS = "KEY_DO_NOTE_IN_GPS";

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

  static List<Widget> getDrawerTilesList(BuildContext context,
      MapController mapController, MainEventHandler mainEventsHandler) {
    var doDiagnostics =
        GpPreferences().getBooleanSync(KEY_ENABLE_DIAGNOSTICS, false);
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
        onTap: () => _createNewProject(context, mainEventsHandler),
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
        onTap: () => _openProject(context, mainEventsHandler),
      ),
//      ListTile(
//        leading: new Icon(
//          Icons.file_download,
//          color: c,
//          size: iconSize,
//        ),
//        title: SmashUI.normalText(
//          "Import",
//          bold: true,
//          color: c,
//        ),
//        onTap: () {},
//      ),
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ExportWidget()));
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsWidget()));
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IconsWidget()));
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapsDownloadWidget(mapsFolder)));
        },
      ),
      doDiagnostics
          ? ListTile(
              leading: new Icon(
                Icons.bug_report,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                "Run diagnostics",
                bold: true,
                color: c,
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DiagnosticWidget())),
            )
          : Container(),
      ListTile(
        leading: new Icon(
          Icons.info_outline,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "About",
          bold: true,
          color: c,
        ),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutPage())),
      ),
    ];
  }

  static List<Widget> getEndDrawerListTiles(BuildContext context,
      MapController mapController, MainEventHandler mainEventsHandler) {
    Color c = SmashColors.mainDecorations;
    var iconSize = SmashUI.MEDIUM_ICON_SIZE;

    List<Widget> list = []
      ..add(
        ListTile(
          leading: new Icon(
            Icons.navigation,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GeocodingPage(mainEventsHandler)));
          },
        ),
      )
      ..add(
        ListTile(
          leading: new Icon(
            Icons.share,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Share position",
            bold: true,
            color: c,
          ),
          onTap: () {
            var pos = GpsHandler().lastPosition;
            StringBuffer sb = StringBuffer();
            sb.write("Latitude: ");
            sb.write(pos.latitude.toStringAsFixed(6));
            sb.write("\nLongitude: ");
            sb.write(pos.longitude.toStringAsFixed(6));
            sb.write("\nAltitude: ");
            sb.write(pos.altitude.toStringAsFixed(0));
            sb.write("\nAccuracy: ");
            sb.write(pos.accuracy.toStringAsFixed(0));
            sb.write("\nTimestamp: ");
            sb.write(TimeUtilities.ISO8601_TS_FORMATTER.format(pos.timestamp));
            ShareHandler.shareText(sb.toString());
          },
        ),
      )
      ..add(
        ListTile(
          leading: new Icon(
            Icons.gps_fixed,
            color: c,
            size: iconSize,
          ),
          title: SmashUI.normalText(
            "Notes in GPS position",
            bold: true,
            color: c,
          ),
          trailing: Checkbox(
              value: mainEventsHandler.getInsertInGps(),
              onChanged: (value) {
                mainEventsHandler.setInsertInGps(value);
              }),
        ),
      );

    return list;
  }

  static Future _openProject(
      BuildContext context, MainEventHandler mainEventsHandler) async {
    File file =
        await FilePicker.getFile(type: FileType.ANY, fileExtension: 'gpap');
    if (file != null && file.existsSync()) {
      await GPProject().setNewProject(file.path);
      await mainEventsHandler.reloadProjectFunction();
    }
    Navigator.of(context).pop();
  }

  static Future _createNewProject(
      BuildContext context, MainEventHandler mainEventsHandler) async {
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
      var newPath = join(file.path, userString);
      if (!newPath.endsWith(".gpap")) {
        newPath = "$newPath.gpap";
      }
      var gpFile = new File(newPath);
      await GPProject().setNewProject(gpFile.path);
      await mainEventsHandler.reloadProjectFunction();
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
  int _buildStatus = 0;
  String _outPath = "";

  Future<void> buildPdf() async {
    var exportsFolder = await Workspace.getExportsFolder();
    var ts = TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now());
    var outFilePath =
        FileUtilities.joinPaths(exportsFolder.path, "smash_pdf_export_$ts.pdf");
    var db = await GPProject().getDatabase();
    await PdfExporter.exportDb(db, File(outFilePath));

    setState(() {
      _outPath = outFilePath;
      _buildStatus = 2;
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
            leading: _buildStatus == 0
                ? Icon(
                    FontAwesomeIcons.solidFilePdf,
                    color: SmashColors.mainDecorations,
                  )
                : _buildStatus == 1
                    ? CircularProgressIndicator()
                    : Icon(
                        Icons.check,
                        color: SmashColors.mainDecorations,
                      ),
            title: Text("${_buildStatus == 2 ? 'PDF exported' : 'PDF'}"),
            subtitle: Text(
                "${_buildStatus == 2 ? _outPath : 'Export project to Portable Document Format'}"),
            onTap: () {
              setState(() {
                _outPath = "";
                _buildStatus = 1;
              });
              buildPdf();
//              Navigator.pop(context);
            }),
      ]),
    );
  }
}
