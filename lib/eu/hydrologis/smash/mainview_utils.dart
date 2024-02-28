/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:smash/eu/hydrologis/smash/gps/geocoding.dart';

import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';
import 'package:smash/eu/hydrologis/smash/util/network.dart';
import 'package:smash/eu/hydrologis/smash/util/urls.dart';
import 'package:smash/eu/hydrologis/smash/widgets/about.dart';
import 'package:smash/eu/hydrologis/smash/widgets/gps_mode_selector.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash_import_export_plugins/smash_import_export_plugins.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardUtils {
  static Widget makeToolbarBadge(Widget widget, int badgeValue,
      {Color? textColor,
      Color? badgeColor,
      badges.BadgePosition? badgePosition,
      double? iconSize}) {
    if (badgeValue > 0) {
      return badges.Badge(
        badgeStyle: badges.BadgeStyle(
          badgeColor:
              badgeColor != null ? badgeColor : SmashColors.mainSelection,
          shape: badgeValue > 999
              ? badges.BadgeShape.square
              : badges.BadgeShape.circle,
          borderRadius: BorderRadius.circular(20.0),
        ),
        badgeAnimation: badges.BadgeAnimation.slide(
          toAnimate: false,
        ),
        position: badgePosition != null
            ? badgePosition
            : iconSize != null
                ? badges.BadgePosition.topStart(
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
      {double? iconSize}) {
    if (badgeValue > 0) {
      return badges.Badge(
        badgeStyle: badges.BadgeStyle(
          badgeColor: SmashColors.mainDecorations,
          shape: badges.BadgeShape.circle,
        ),
        position: iconSize != null
            ? badges.BadgePosition.topEnd(
                top: -iconSize / 2, end: -iconSize / 3)
            : null,
        badgeAnimation: badges.BadgeAnimation.slide(
          toAnimate: false,
        ),
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

  static List<Widget> getDrawerTilesList(BuildContext context) {
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
                        projectDb: projectState.projectDb!,
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
                        projectDb: projectState.projectDb!,
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

  static List<Widget> getEndDrawerListTiles(BuildContext context) {
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
            String projectPath = projectState.projectPath!;
            if (Platform.isIOS) {
              projectPath =
                  IOS_DOCUMENTSFOLDER + Workspace.makeRelative(projectPath);
            }
            var isLandscape = ScreenUtilities.isLandscape(context);
            SmashDialogs.showInfoDialog(
                mapBuilder.context!,
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
                      shareProject(mapBuilder.context!);
                    },
                  )
                ]);
          },
        ),
      ))
      ..add(getPositionTools(c, backColor, iconSize, context))
      // ..add(getEditingTools(c, backColor, iconSize, context))
      ..add(getExtras(c, backColor, iconSize, context));

    return list;
  }

  static Container getExtras(
      Color c, Color backColor, double iconSize, BuildContext context) {
    FormBuilderFormHelper filebasedFormBuilderHelper = FormBuilderFormHelper();

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
            if (GpPreferences().getBooleanSync(
                SmashPreferencesKeys.KEY_SHOW_FORMBUILER, false))
              ListTile(
                leading: new Icon(
                  MdiIcons.formSelect,
                  color: c,
                  size: iconSize,
                ),
                title: SmashUI.normalText(
                  SL.of(context).formbuilder,
                  bold: true,
                  color: c,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainFormWidget(
                                filebasedFormBuilderHelper,
                                presentationMode:
                                    PresentationMode(isFormbuilder: true),
                                doScaffold: true,
                              )));
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
              MdiIcons.mapMarkerUp,
              color: c,
              size: iconSize,
            ),
            title: SmashUI.normalText(
              SL.of(context).mainviewUtils_goToCoordinate, //"Go to coordinate",
              bold: true,
              color: c,
            ),
            onTap: () async {
              var coord = await SmashDialogs.showInputDialog(
                context,
                SL.of(context).mainviewUtils_goToCoordinate,
                SL.of(context).mainviewUtils_enterLonLat,
                validationFunction: (String value) {
                  if (value.isEmpty) {
                    return SL.of(context).mainviewUtils_goToCoordinateEmpty;
                  } else {
                    // if (value.toUpperCase().contains("N") &&
                    //     value.toUpperCase().contains("E")) {
                    //   return null;
                    // } else {
                    var coordSplit = value.split(",");
                    bool wrongCoord = false;
                    if (coordSplit.length != 2) {
                      wrongCoord = true;
                    } else {
                      try {
                        double.parse(coordSplit[0]);
                        double.parse(coordSplit[1]);
                      } catch (e) {
                        wrongCoord = true;
                      }
                    }
                    if (wrongCoord) {
                      return SL
                          .of(context)
                          .mainviewUtils_goToCoordinateWrongFormat;
                    }
                    // }
                  }
                  return null;
                },
              );
              if (coord != null) {
                Navigator.pop(context);

                SmashMapState mapState =
                    Provider.of<SmashMapState>(context, listen: false);
                mapState.center = Coordinate(double.parse(coord.split(",")[0]),
                    double.parse(coord.split(",")[1]));
              }

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GeocodingPage()));
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
                          if (!value!) {
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

  // static Container getEditingTools(
  //     Color c, Color backColor, double iconSize, BuildContext context) {
  //   return Container(
  //     color: backColor,
  //     child: ExpansionTile(
  //       initiallyExpanded: true,
  //       title: SmashUI.normalText(
  //         "First Editing Point", // SL.of(context).mainviewUtils_positionTools, //"Position Tools"
  //         bold: true,
  //         color: c,
  //       ),
  //       children: [
  //         ListTile(
  //           title: GpsInsertionModeSelector(allowTap: true),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static Icon getGpsStatusIcon(GpsStatus status, [double? iconSize]) {
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

  static Icon getLoggingIcon(GpsStatus status, {double? size}) {
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

class FormBuilderFormHelper extends AFormhelper {
  SmashSection? section;

  FormBuilderFormHelper();

  @override
  Future<bool> init() async {
    return Future.value(true);
  }

  @override
  Widget getFormTitleWidget() {
    return SmashUI.titleText("Test form");
  }

  @override
  int getId() {
    return 1;
  }

  @override
  getPosition() {
    return null;
  }

  @override
  SmashSection? getSection() {
    return section;
  }

  @override
  String? getSectionName() {
    return section?.sectionName;
  }

  @override
  Future<List<Widget>> getThumbnailsFromDb(
      BuildContext context, SmashFormItem formItem, List<String> imageSplit) {
    return Future.value([]);
  }

  @override
  bool hasForm() {
    return true;
  }

  @override
  Future<void> onSaveFunction(BuildContext context) async {}

  @override
  Future<String?> takePictureForForms(
      BuildContext context, bool fromGallery, List<String> imageSplit) {
    throw UnimplementedError();
  }

  @override
  Future<String?> takeSketchForForms(
      BuildContext context, List<String> imageSplit) {
    throw UnimplementedError();
  }

  @override
  Widget? getOpenFormBuilderAction(BuildContext context,
      {Function? postAction}) {
    return Tooltip(
      message: "Open and existing form",
      child: IconButton(
          onPressed: () async {
            var lastUsedFolder = await Workspace.getLastUsedFolder();
            if (context.mounted) {
              var selectedPath = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FileBrowser(
                            false,
                            const [FileManager.JSON_EXT],
                            lastUsedFolder,
                          )));

              if (selectedPath != null &&
                  selectedPath.toString().endsWith("_tags.json")) {
                var tagsJson = HU.FileUtilities.readFile(selectedPath);
                var tm = TagsManager();
                await tm.readTags(tagsString: tagsJson);
                section = tm.getTags().getSections()[0];

                if (postAction != null) postAction();
              }
            }
          },
          icon: Icon(MdiIcons.folderOpenOutline)),
    );
  }

  @override
  Widget? getNewFormBuilderAction(BuildContext context,
      {Function? postAction}) {
    return Tooltip(
      message: "Create a new form",
      child: IconButton(
          onPressed: () async {
            var answer = await SmashDialogs.showInputDialog(
                context, "NEW FORM", "Enter a unique form name",
                validationFunction: (String? value) {
              if (value == null || value.isEmpty) {
                return "The name cannot be empty";
              }
              // no spaces
              if (value.contains(" ")) {
                return "The name cannot contain spaces";
              }
              return null;
            });
            if (answer != null) {
              var emptyTagsString = TagsManager.getEmptyTagsString(answer);
              var tm = TagsManager();
              await tm.readTags(tagsString: emptyTagsString);
              section = tm.getTags().getSections()[0];

              if (postAction != null) postAction();
            }
          },
          icon: Icon(MdiIcons.newspaperPlus)),
    );
  }

  @override
  Widget? getSaveFormBuilderAction(BuildContext context,
      {Function? postAction}) {
    return Tooltip(
      message: "Save the form in the forms folder",
      child: IconButton(
          onPressed: () async {
            // in this demo version we save the form with the name of the section and _tags.json
            // into the forms folder
            if (section != null) {
              Directory formsFolder = await Workspace.getFormsFolder();
              var name = section!.sectionName ?? "untitled";
              var saveFilePath = HU.FileUtilities.joinPaths(
                  formsFolder.path, "${name.replaceAll(" ", "_")}_tags.json");
              var sectionMap = section!.sectionMap;
              var jsonString =
                  const JsonEncoder.withIndent("  ").convert([sectionMap]);
              HU.FileUtilities.writeStringToFile(saveFilePath, jsonString);

              if (context.mounted) {
                SmashDialogs.showToast(context, "Form saved to $saveFilePath");
              }
            }
          },
          icon: Icon(MdiIcons.contentSave)),
    );
  }

  @override
  Widget? getRenameFormBuilderAction(BuildContext context,
      {Function? postAction}) {
    return Tooltip(
      message: "Rename the form",
      child: IconButton(
          onPressed: () async {
            Directory formsFolder = await Workspace.getFormsFolder();
            if (section != null && context.mounted) {
              var newName = await SmashDialogs.showInputDialog(
                  context, "RENAME", "Enter a unique form name",
                  validationFunction: (txt) {
                var filePath = HU.FileUtilities.joinPaths(
                    formsFolder.path, "${txt.replaceAll(" ", "_")}_tags.json");
                if (File(filePath).existsSync()) {
                  return "A form with that name already exists";
                }
                return null;
              });

              if (newName != null) {
                section!.setSectionName(newName);
                if (postAction != null) postAction();
              }
            }
          },
          icon: Icon(MdiIcons.rename)),
    );
  }
}
