/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/share.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/validators.dart';
import 'package:smash/eu/hydrologis/smash/export/export_widget.dart';
import 'package:smash/eu/hydrologis/smash/gps/geocoding.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/import/import_widget.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';
import 'package:smash/eu/hydrologis/smash/util/diagnostic.dart';
import 'package:smash/eu/hydrologis/smash/util/network.dart';
import 'package:smash/eu/hydrologis/smash/widgets/about.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';

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

  static List<Widget> getDrawerTilesList(
      BuildContext context, MapController mapController) {
    double iconSize = SmashUI.MEDIUM_ICON_SIZE;
    Color c = SmashColors.mainDecorations;
    return [
      ListTile(
        leading: new Icon(
          Icons.folder_open,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          "Projects",
          bold: true,
          color: c,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProjectView()));
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ImportWidget()));
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
          MdiIcons.informationOutline,
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

  static List<Widget> getEndDrawerListTiles(
      BuildContext context, MapController mapController) {
    Color c = SmashColors.mainDecorations;
    var iconSize = SmashUI.MEDIUM_ICON_SIZE;
    var doDiagnostics =
        GpPreferences().getBooleanSync(KEY_ENABLE_DIAGNOSTICS, false);

    List<Widget> list = []
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
          trailing:
              Consumer<InfoToolState>(builder: (context, infoState, child) {
            return Checkbox(
                value: infoState.isEnabled,
                onChanged: (value) {
                  infoState.setEnabled(value);
                });
          }),
        ),
      )
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GeocodingPage()));
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => IconsWidget()));
          },
        ),
      )
      ..add(
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
      )
      ..add(
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiagnosticWidget())),
              )
            : Container(),
      );

    return list;
  }

  static Future _createNewProject(BuildContext context) async {
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
          iconData = SmashIcons.logIcon;
          color = SmashColors.gpsLogging;
          break;
        }
      case GpsStatus.OFF:
      case GpsStatus.ON_WITH_FIX:
      case GpsStatus.ON_NO_FIX:
      case GpsStatus.NOPERMISSION:
        {
          iconData = SmashIcons.logIcon;
          color = SmashColors.mainBackground;
          break;
        }
      default:
        {
          iconData = SmashIcons.logIcon;
          color = SmashColors.mainBackground;
        }
    }
    return Icon(
      iconData,
      color: color,
    );
  }
}
