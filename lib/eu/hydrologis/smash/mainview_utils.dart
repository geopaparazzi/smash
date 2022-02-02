/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:smash/eu/hydrologis/smash/gps/geocoding.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';

import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';
import 'package:smash/eu/hydrologis/smash/util/experimentals.dart';
import 'package:smash/eu/hydrologis/smash/util/network.dart';
import 'package:smash/eu/hydrologis/smash/util/urls.dart';
import 'package:smash/eu/hydrologis/smash/widgets/about.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash_import_export_plugins/smash_import_export_plugins.dart';
import 'package:url_launcher/url_launcher.dart';

const String KEY_DO_NOTE_IN_GPS = "KEY_DO_NOTE_IN_GPS_MODE";
const int POINT_INSERTION_MODE_GPS = 0;
const int POINT_INSERTION_MODE_MAPCENTER = 1;

class DashboardUtils {
  static Widget makeToolbarBadge(Widget widget, int badgeValue,
      {Color textColor,
      Color badgeColor,
      BadgePosition badgePosition,
      double iconSize}) {
    if (badgeValue > 0) {
      return Badge(
        badgeColor: badgeColor != null ? badgeColor : SmashColors.mainSelection,
        shape: badgeValue > 999 ? BadgeShape.square : BadgeShape.circle,
        borderRadius: BorderRadius.circular(20.0),
        toAnimate: false,
        position: badgePosition != null
            ? badgePosition
            : iconSize != null
                ? BadgePosition.topStart(
                    top: -iconSize / 2, start: 0.1 * iconSize)
                : null,
        badgeContent: Text(
          '$badgeValue',
          style: TextStyle(color: textColor != null ? textColor : Colors.white),
        ),
        child: widget,
      );
    } else {
      return widget;
    }
  }

  static Widget makeToolbarZoomBadge(Widget widget, int badgeValue,
      {double iconSize}) {
    if (badgeValue > 0) {
      return Badge(
        badgeColor: SmashColors.mainDecorations,
        shape: BadgeShape.circle,
        position: iconSize != null
            ? BadgePosition.topEnd(top: -iconSize / 2, end: -iconSize / 3)
            : null,
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

    var projectState = Provider.of<ProjectState>(context, listen: false);

    Color c = SmashColors.mainDecorations;
    return [
      ListTile(
        leading: new Icon(
          Icons.folder_open,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_projects, //"Projects"
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
          SmashIcons.importIcon,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_import, //"Import"
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImportWidget(
                        projectDb: projectState.projectDb,
                      )));
        },
      ),
      ListTile(
        leading: new Icon(
          SmashIcons.exportIcon,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_export, //"Export"
          bold: true,
          color: c,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExportWidget(
                        projectDb: projectState.projectDb,
                      )));
        },
      ),
      ListTile(
        leading: new Icon(
          Icons.settings,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_settings, //"Settings"
          bold: true,
          color: c,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsWidget()));
        },
      ),
      ListTile(
        leading: new Icon(
          MdiIcons.lifebuoy,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_onlineHelp, //"Online Help"
          bold: true,
          color: c,
        ),
        onTap: () async {
          if (!await HU.NetworkUtilities.isConnected()) {
            SmashDialogs.showOperationNeedsNetwork(context);
          } else {
            var urlString = "https://www.geopaparazzi.org/smash/index.html";
            if (await canLaunch(urlString)) {
              await launch(urlString);
            }
          }
        },
      ),
      ListTile(
        leading: new Icon(
          MdiIcons.informationOutline,
          color: c,
          size: iconSize,
        ),
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_about, //"About"
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

    Color backColor = SmashColors.mainBackground;
    List<Widget> list = []
      ..add(Container(
        color: backColor,
        child: ListTile(
          title: SmashUI.normalText(
            SL.of(context).mainviewUtils_projectInfo, //"Project Info"
            bold: true,
            color: c,
          ),
          leading: new Icon(
            MdiIcons.informationOutline,
            color: c,
            size: iconSize,
          ),
          onTap: () {
            var projectState =
                Provider.of<ProjectState>(context, listen: false);
            var mapBuilder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            String projectPath = projectState.projectPath;
            if (Platform.isIOS) {
              projectPath =
                  IOS_DOCUMENTSFOLDER + Workspace.makeRelative(projectPath);
            }
            var isLandscape = ScreenUtilities.isLandscape(context);
            SmashDialogs.showInfoDialog(
                mapBuilder.context,
                "${SL.of(context).mainviewUtils_project}: ${projectState.projectName}\n${SL.of(context).mainviewUtils_database}: $projectPath"
                    .trim(), //Project //Database
                doLandscape: isLandscape,
                widgets: [
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: SmashColors.mainDecorations,
                    ),
                    onPressed: () async {
                      shareProject(mapBuilder.context);
                    },
                  )
                ]);
          },
        ),
      ))
      ..add(getPositionTools(c, backColor, iconSize, context))
      ..add(getExtras(c, backColor, iconSize, context));

    return list;
  }

  static Container getExtras(
      Color c, Color backColor, double iconSize, BuildContext context) {
    return Container(
      color: backColor,
      child: ExpansionTile(
          initiallyExpanded: true,
          title: SmashUI.normalText(
            SL.of(context).mainviewUtils_extras, //"Extras"
            bold: true,
            color: c,
          ),
          children: [
            ListTile(
              leading: new Icon(
                Icons.insert_emoticon,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                SL.of(context).mainviewUtils_availableIcons, //"Available icons"
                bold: true,
                color: c,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IconsWidget()));
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.map,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                SL.of(context).mainviewUtils_offlineMaps, //"Offline maps"
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
          ]),
    );
  }

  static Container getPositionTools(
      Color c, Color backColor, double iconSize, BuildContext context) {
    return Container(
      color: backColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: SmashUI.normalText(
          SL.of(context).mainviewUtils_positionTools, //"Position Tools"
          bold: true,
          color: c,
        ),
        children: [
          ListTile(
            leading: new Icon(
              MdiIcons.navigation,
              color: c,
              size: iconSize,
            ),
            title: SmashUI.normalText(
              SL.of(context).mainviewUtils_goTo, //"Go to"
              bold: true,
              color: c,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GeocodingPage()));
            },
          ),
          ListTile(
            leading: new Icon(
              MdiIcons.shareVariant,
              color: c,
              size: iconSize,
            ),
            title: SmashUI.normalText(
              SL.of(context).mainviewUtils_sharePosition, //"Share position"
              bold: true,
              color: c,
            ),
            onTap: () {
              var gpsState = Provider.of<GpsState>(context, listen: false);
              var pos = gpsState.lastGpsPosition;
              if (pos != null) {
                StringBuffer sb = StringBuffer();
                sb.write("Latitude: ");
                sb.write(pos.latitude.toStringAsFixed(
                    SmashPreferencesKeys.KEY_LATLONG_DECIMALS));
                sb.write("\nLongitude: ");
                sb.write(pos.longitude.toStringAsFixed(
                    SmashPreferencesKeys.KEY_LATLONG_DECIMALS));
                sb.write("\nAltitude: ");
                sb.write(pos.altitude
                    .toStringAsFixed(SmashPreferencesKeys.KEY_ELEV_DECIMALS));
                sb.write("\nAccuracy: ");
                sb.write(pos.accuracy
                    .toStringAsFixed(SmashPreferencesKeys.KEY_ELEV_DECIMALS));
                sb.write("\nTimestamp: ");
                sb.write(HU.TimeUtilities.ISO8601_TS_FORMATTER.format(
                    DateTime.fromMillisecondsSinceEpoch(pos.time.round())));
                sb.write("\n");
                sb.write(UrlUtilities.osmUrlFromLatLong(
                    pos.latitude, pos.longitude,
                    withMarker: true));

                ShareHandler.shareText(sb.toString());
              }
            },
          ),
          Platform.isAndroid && EXPERIMENTAL_ROTATION__ENABLED
              ? Consumer<SmashMapState>(builder: (context, mapState, child) {
                  return ListTile(
                    title: SmashUI.normalText(
                        SL
                            .of(context)
                            .mainviewUtils_rotateMapWithGps, //"Rotate map with GPS"
                        bold: true,
                        color: c),
                    leading: Checkbox(
                        value: mapState.rotateOnHeading,
                        onChanged: (value) {
                          if (!value) {
                            mapState.heading = 0;
                          }
                          mapState.rotateOnHeading = value;
                        }),
                  );
                })
              : Container(),
        ],
      ),
    );
  }

  static Icon getGpsStatusIcon(GpsStatus status, [double iconSize]) {
    Color color;
    IconData iconData;
    switch (status) {
      case GpsStatus.OFF:
      case GpsStatus.NOGPS:
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

  static Icon getLoggingIcon(GpsStatus status, {double size}) {
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
    if (size != null) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    } else {
      return Icon(
        iconData,
        color: color,
      );
    }
  }
}

Future<void> shareProject(BuildContext context) async {
  ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
  if (projectState.projectPath != null) {
    File projectFile = File("${projectState.projectPath}");
    if (projectFile.existsSync()) {
      await ShareExtend.share(projectFile.path, "file");
    }
  }
}
