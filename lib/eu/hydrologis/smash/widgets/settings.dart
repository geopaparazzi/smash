/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/pluginshandler.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

const SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE = 'SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE';
const SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE =
    'SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE';
const SETTINGS_EDIT_HANLDE_ICON_SIZES = [
  10,
  15,
  20,
  25,
  30,
  35,
  40,
  50,
  60,
  80,
  100
];

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => new _SettingsWidgetState();

  static void reloadMapSettings(BuildContext context) {
    // var projectState = Provider.of<ProjectState>(context, listen: false);
    // projectState.reloadProjectQuiet(context);
    SmashMapBuilder.reBuildStatic(context);
  }
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late Widget _selectedSetting;

  @override
  Widget build(BuildContext context) {
    final ListTile cameraSettingTile = ListTile(
        leading: Icon(
          CameraSettingState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(SL.of(context).settings_camera), //"Camera"
        subtitle: Text(
            SL.of(context).settings_cameraResolution), //"Camera Resolution"
        trailing: Icon(Icons.arrow_right),
        onTap: () async {
          _selectedSetting = CameraSetting();
          showSettingsSheet(context);
        });
    final ListTile screenSettingTile = ListTile(
        leading: Icon(
          ScreenSettingState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(SL.of(context).settings_screen), //"Screen"
        subtitle: Text(SL
            .of(context)
            .settings_screenScaleBarIconSize), //"Screen, Scalebar and Icon Size"
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = ScreenSetting();
          showSettingsSheet(context);
        });

    final ListTile gpsSettingTile = ListTile(
        leading: Icon(
          GpsSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(SL.of(context).settings_gps),
        subtitle: Text(SL.of(context).settings_gpsFiltersAndMockLoc),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = GpsSettings();
          showSettingsSheet(context);
        });

    final ListTile vectorLayerSettingTile = ListTile(
        leading: Icon(
          VectorLayerSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(
            SL.of(context).settings_vectorLayers), //"Vector Layers"
        subtitle: Text(SL
            .of(context)
            .settings_loadingOptionsInfoTool), //"Loading Options and Info Tool"
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = VectorLayerSettings();
          showSettingsSheet(context);
        });

    final ListTile crsSettingTile = ListTile(
        leading: Icon(
          ProjectionsSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(ProjectionsSettingsState.title),
        subtitle: Text(ProjectionsSettingsState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = ProjectionsSettings();
          showSettingsSheet(context);
        });

    final ListTile deviceSettingTile = ListTile(
        leading: Icon(
          DeviceSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(SL.of(context).settings_device),
        subtitle: Text(SL.of(context).settings_deviceIdentifier),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = DeviceSettings();
          showSettingsSheet(context);
        });

    final ListTile diagnosticsSettingTile = ListTile(
        leading: Icon(
          DiagnosticsSettingState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(SL.of(context).settings_diagnostics),
        subtitle: Text(SL.of(context).settings_diagnosticsDebugLog),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = DiagnosticsSetting();
          showSettingsSheet(context);
        });

    GpsState gpsState = Provider.of<GpsState>(context, listen: false);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(SL.of(context).settings_settings), //"Settings"
      ),
      body: ListView(children: <Widget>[
        if (gpsState.status != GpsStatus.NOGPS) gpsSettingTile,
        screenSettingTile,
        cameraSettingTile,
        vectorLayerSettingTile,
        crsSettingTile,
        deviceSettingTile,
        diagnosticsSettingTile,
      ]),
    );
  }

  Future showSettingsSheet(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => _selectedSetting));
  }
}

class CameraSetting extends StatefulWidget {
  @override
  CameraSettingState createState() {
    return CameraSettingState();
  }
}

class CameraSettingState extends State<CameraSetting> {
  //static final title = "Camera";
  //static final subtitle = "Camera Resolution";
  static final iconData = Icons.camera;

  @override
  Widget build(BuildContext context) {
    String value = GpPreferences().getStringSync(
            SmashPreferencesKeys.KEY_CAMERA_RESOLUTION,
            CameraResolutions.MEDIUM) ??
        CameraResolutions.MEDIUM;
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_camera), //"Camera"
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: SmashUI.defaultMargin(),
            // elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: ListTile(
              leading: Icon(MdiIcons.camera),
              title: Text(SL.of(context).settings_resolution), //"Resolution"
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultTBPadding(),
                    child: Text(
                      SL
                          .of(context)
                          .settings_theCameraResolution, //"The camera resolution"
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  DropdownButton<String>(
                    value: value,
                    isExpanded: false,
                    items: [
                      DropdownMenuItem(
                        child: Container(
                          child: Text(
                            CameraResolutions.HIGH,
                            textAlign: TextAlign.center,
                          ),
                          width: 200,
                        ),
                        value: CameraResolutions.HIGH,
                      ),
                      DropdownMenuItem(
                        child: Container(
                          child: Text(
                            CameraResolutions.MEDIUM,
                            textAlign: TextAlign.center,
                          ),
                          width: 200,
                        ),
                        value: CameraResolutions.MEDIUM,
                      ),
                      DropdownMenuItem(
                        child: Container(
                          child: Text(
                            CameraResolutions.LOW,
                            textAlign: TextAlign.center,
                          ),
                          width: 200,
                        ),
                        value: CameraResolutions.LOW,
                      ),
                    ],
                    onChanged: (selected) async {
                      await GpPreferences().setString(
                          SmashPreferencesKeys.KEY_CAMERA_RESOLUTION,
                          selected!);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenSetting extends StatefulWidget {
  @override
  ScreenSettingState createState() {
    return ScreenSettingState();
  }
}

class ScreenSettingState extends State<ScreenSetting> {
  //static final title = "Screen";
  //static final subtitle = "Screen, Scalebar and Icon Size";
  static final int index = 1;
  static final iconData = Icons.fullscreen;

  @override
  Widget build(BuildContext context) {
    bool keepScreenOn = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_KEEP_SCREEN_ON, true);
    bool retinaModeOn = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_RETINA_MODE_ON, false);
    double currentIconSize = GpPreferences().getDoubleSync(
            SmashPreferencesKeys.KEY_MAPTOOLS_ICON_SIZE,
            SmashUI.MEDIUM_ICON_SIZE) ??
        SmashUI.MEDIUM_ICON_SIZE;
    //    String themeStr = GpPreferences().getStringSync(KEY_THEME, SmashThemes.LIGHT.toString());
    //    SmashThemes theme = SmashThemes.LIGHT;
    //    if (themeStr == SmashThemes.DARK.toString()) {
    //      theme = SmashThemes.DARK;
    //    }

    CenterCrossStyle centerCrossStyle = CenterCrossStyle.fromPreferences();
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_screen), //"Screen"
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: CheckboxListTile(
                value: keepScreenOn,
                onChanged: (selected) async {
                  await GpPreferences().setBoolean(
                      SmashPreferencesKeys.KEY_KEEP_SCREEN_ON, selected!);
                  SettingsWidget.reloadMapSettings(context);
                  setState(() {});
                },
                title: SmashUI.normalText(
                  SL.of(context).settings_keepScreenOn, //"Keep Screen On"
                ),
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: CheckboxListTile(
                value: retinaModeOn,
                onChanged: (selected) async {
                  await GpPreferences().setBoolean(
                      SmashPreferencesKeys.KEY_RETINA_MODE_ON, selected!);
                  SettingsWidget.reloadMapSettings(context);
                  setState(() {});
                },
                title: SmashUI.normalText(
                  SL
                      .of(context)
                      .settings_retinaScreenMode, //"Retina screen mode"
                ),
                subtitle: SmashUI.smallText(
                  SL
                      .of(context)
                      .settings_toApplySettingEnterExitLayerView, //"To apply this setting you need to enter and exit the layer view."
                ),
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(SL
                        .of(context)
                        .settings_colorPickerToUse), //"Color Picker to use"
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<String>(
                      value: GpPreferences().getStringSync(
                          KEY_COLORPICKER_TYPE, ColorPickers.SWATCH_PICKER),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: ColorPickers.SWATCH_PICKER,
                          child: new Text(ColorPickers.SWATCH_PICKER),
                        ),
                        DropdownMenuItem(
                          value: ColorPickers.COLOR_PICKER,
                          child: new Text(ColorPickers.COLOR_PICKER),
                        ),
                        DropdownMenuItem(
                          value: ColorPickers.PALETTE_PICKER,
                          child: new Text(ColorPickers.PALETTE_PICKER),
                        ),
                      ],
                      onChanged: (selected) async {
                        await GpPreferences()
                            .setString(KEY_COLORPICKER_TYPE, selected!);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                      SL
                          .of(context)
                          .settings_mapCenterCross, //"Map Center Cross"
                    ),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SmashUI.normalText(
                            SL.of(context).settings_color), //"Color"
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                            left: SmashUI.DEFAULT_PADDING,
                            right: SmashUI.DEFAULT_PADDING,
                          ),
                          child: ColorPickerButton(
                              Color(ColorExt(centerCrossStyle.color).value),
                              (newColor) async {
                            centerCrossStyle.color = ColorExt.asHex(newColor);
                            await centerCrossStyle.saveToPreferences();
                            SettingsWidget.reloadMapSettings(context);
                            setState(() {});
                          }),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SmashUI.normalText(
                            SL.of(context).settings_size), //"Size"
                        Flexible(
                            flex: 1,
                            child: Slider(
                              activeColor: SmashColors.mainSelection,
                              min: 5.0,
                              max: 100,
                              divisions: 19,
                              onChanged: (newSize) async {
                                centerCrossStyle.size = newSize;
                                await centerCrossStyle.saveToPreferences();
                                SettingsWidget.reloadMapSettings(context);
                                setState(() {});
                              },
                              value: centerCrossStyle.size,
                            )),
                        Container(
                          width: 50.0,
                          alignment: Alignment.center,
                          child: SmashUI.normalText(
                            '${centerCrossStyle.size.toInt()}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SmashUI.normalText(
                            SL.of(context).settings_width), //"Width"
                        Flexible(
                            flex: 1,
                            child: Slider(
                              activeColor: SmashColors.mainSelection,
                              min: 1,
                              max: 20,
                              divisions: 19,
                              onChanged: (newSize) async {
                                centerCrossStyle.lineWidth = newSize;
                                await centerCrossStyle.saveToPreferences();
                                SettingsWidget.reloadMapSettings(context);
                                setState(() {});
                              },
                              value: centerCrossStyle.lineWidth,
                            )),
                        Container(
                          width: 50.0,
                          alignment: Alignment.center,
                          child: SmashUI.normalText(
                            '${centerCrossStyle.lineWidth.toInt()}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(SL
                        .of(context)
                        .settings_mapToolsIconSize), //"Map Tools Icon Size"
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: Slider(
                              activeColor: SmashColors.mainSelection,
                              min: 10.0,
                              max: 100,
                              divisions: 45,
                              onChanged: (newSize) async {
                                await GpPreferences().setDouble(
                                    SmashPreferencesKeys.KEY_MAPTOOLS_ICON_SIZE,
                                    newSize);
                                SettingsWidget.reloadMapSettings(context);
                                setState(() {});
                              },
                              value: currentIconSize,
                            )),
                        Container(
                          width: 50.0,
                          alignment: Alignment.center,
                          child: SmashUI.normalText(
                            '${currentIconSize.toInt()}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TODO enable when working on dark theme
            //            Card(
            //              margin: SmashUI.defaultMargin(),
            //              elevation: SmashUI.DEFAULT_ELEVATION,
            //              color: SmashColors.mainBackground,
            //              child: Column(
            //                children: <Widget>[
            //                  Padding(
            //                    padding: SmashUI.defaultPadding(),
            //                    child: SmashUI.normalText("Theme", bold: true),
            //                  ),
            //                  Padding(
            //                    padding: SmashUI.defaultPadding(),
            //                    child: DropdownButton<SmashThemes>(
            //                      value: theme,
            //                      isExpanded: true,
            //                      items: SmashThemes.values.map((i) {
            //                        return DropdownMenuItem<SmashThemes>(
            //                          child: SmashUI.normalText(
            //                            i.toString(),
            //                            textAlign: TextAlign.center,
            //                          ),
            //                          value: i,
            //                        );
            //                      }).toList(),
            //                      onChanged: (selected) async {
            //                        await GpPreferences().setString(KEY_THEME, selected.toString());
            //                        var themeState = Provider.of<ThemeState>(context);
            //                        themeState.currentTheme = selected;
            //                        setState(() {});
            //                      },
            //                    ),
            //                  ),
            //                ],
            //              ),
            //            ),
          ],
        ),
      ),
    );
  }
}

class GpsSettings extends StatefulWidget {
  @override
  GpsSettingsState createState() {
    return GpsSettingsState();
  }
}

class GpsSettingsState extends State<GpsSettings> {
  //static final title = "GPS";
  //static final subtitle = "GPS filters and mock locations";
  static final iconData = MdiIcons.crosshairsGps;
  List<GpsFilterManagerMessage> gpsInfoList = [];
  List<int> gpsInfoListCounter = [];
  int _count = 0;
  bool isPaused = false;

  late MapController _mapController;
  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  iconData,
                  color: SmashColors.mainBackground,
                ),
              ),
              Text(SL.of(context).settings_gps), //"GPS"
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(text: SL.of(context).settings_settings), //"Settings"
            Tab(text: SL.of(context).settings_livePreview), //"Live Preview"
          ]),
        ),
        body: TabBarView(children: [
          getSettingsPart(context),
          getLivePreviewPart(context),
        ]),
      ),
    );
  }

  Widget getLivePreviewPart(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      if (!isPaused) {
        var msg = GpsFilterManager().currentMessage;
        if (!gpsInfoList.contains(msg) &&
            msg != null &&
            msg.newPosLatLon != null) {
          gpsInfoList.insert(0, msg);
          gpsInfoListCounter.insert(0, _count);
          _count++;
          if (gpsInfoList.length > 50) {
            gpsInfoList.removeRange(50, gpsInfoList.length);
          }
        }
      }

      if (gpsInfoList.isEmpty) {
        return SmashCircularProgress(
            label: SL
                .of(context)
                .settings_noPointAvailableYet); //"No point available yet."
      }

      var layer = new MarkerLayerOptions(
        markers: gpsInfoList.map((msg) {
          var clr = Colors.red.withAlpha(100);
          if (msg == gpsInfoList.first) {
            clr = Colors.blue.withAlpha(150);
          }

          return new Marker(
            width: 10,
            height: 10,
            point: msg.newPosLatLon!,
            builder: (ctx) => new Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    MdiIcons.circle,
                    color: clr,
                    size: 10,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );

      return Stack(
        children: <Widget>[
          FlutterMap(
            options: new MapOptions(
              center: gpsInfoList.last.newPosLatLon,
              zoom: 19,
              minZoom: 7,
              maxZoom: 21,
            ),
            layers: [layer],
            mapController: _mapController,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: gpsInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    GpsFilterManagerMessage msg = gpsInfoList[index];
                    int i = gpsInfoListCounter[index];
                    var infoMap = {
                      SL.of(context).settings_longitudeDeg: //"longitude [deg]"
                          msg.newPosLatLon!.longitude.toStringAsFixed(6),
                      SL.of(context).settings_latitudeDeg: //"latitude [deg]"
                          msg.newPosLatLon!.latitude.toStringAsFixed(6),
                      SL.of(context).settings_accuracyM: //"accuracy [m]"
                          msg.accuracy!.toStringAsFixed(0),
                      SL.of(context).settings_altitudeM: //"altitude [m]"
                          msg.altitude!.toStringAsFixed(0),
                      SL.of(context).settings_headingDeg: //"heading [deg]"
                          msg.heading!.toStringAsFixed(0),
                      SL.of(context).settings_speedMS: //"speed [m/s]"
                          msg.speed!.toStringAsFixed(0),
                      SL.of(context).settings_isLogging: //"is logging?"
                          msg.isLogging,
                      SL.of(context).settings_mockLocations: //"mock locations?"
                          msg.mocked,
                    };

                    var infoTable = TableUtilities.fromMap(infoMap,
                        doSmallText: true,
                        borderColor: SmashColors.mainDecorations,
                        backgroundColor: Colors.white.withAlpha(0),
                        withBorder: true);

                    double distanceLastEvent = msg.distanceLastEvent!;
                    int minAllowedDistanceLastEvent =
                        msg.minAllowedDistanceLastEvent!;

                    int timeLastEvent = msg.timeDeltaLastEvent!;
                    int minAllowedTimeLastEvent =
                        msg.minAllowedTimeDeltaLastEvent!;

                    bool minDistFilterBlocks =
                        distanceLastEvent <= minAllowedDistanceLastEvent;
                    bool minTimeFilterBlocks =
                        timeLastEvent <= minAllowedTimeLastEvent;

                    var minDistString = minDistFilterBlocks
                        ? SL
                            .of(context)
                            .settings_minDistFilterBlocks //"MIN DIST FILTER BLOCKS"
                        : SL
                            .of(context)
                            .settings_minDistFilterPasses; //"Min dist filter passes"
                    var minTimeString = minTimeFilterBlocks
                        ? SL
                            .of(context)
                            .settings_minTimeFilterBlocks //"MIN TIME FILTER BLOCKS"
                        : SL
                            .of(context)
                            .settings_minTimeFilterPasses; //"Min time filter passes"

                    bool hasBeenBlocked = msg.blockedByFilter;
                    var filterMap = {
                      SL
                              .of(context)
                              .settings_hasBeenBlocked: //"HAS BEEN BLOCKED"
                          "$hasBeenBlocked",
                      SL
                              .of(context)
                              .settings_distanceFromPrevM: //"Distance from prev [m]"
                          distanceLastEvent,
                      SL
                              .of(context)
                              .settings_timeFromPrevS: //"Time from prev [s]"
                          timeLastEvent,
                      minDistString:
                          "$distanceLastEvent <= $minAllowedDistanceLastEvent",
                      minTimeString:
                          "$timeLastEvent <= $minAllowedTimeLastEvent",
                    };
                    var filtersTable = TableUtilities.fromMap(
                      filterMap,
                      doSmallText: true,
                      borderColor: Colors.orange,
                      withBorder: true,
                      colWidthFlex: [0.6, 0.4],
                      highlightPattern: "BLOCKS",
                      highlightColor: Colors.orange.withAlpha(128),
                      backgroundColor: Colors.white.withAlpha(0),
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: ListTile(
                        title: Text(
                            "$i        " +
                                DateTime.fromMillisecondsSinceEpoch(
                                        (msg.timestamp).toInt())
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SmashColors.mainDecorations)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                          SL
                                              .of(context)
                                              .settings_locationInfo, //"Location Info"
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  SmashColors.mainDecorations)),
                                    ),
                                    Expanded(child: infoTable),
                                  ],
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        SL
                                            .of(context)
                                            .settings_filters, //"Filters"
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    Expanded(child: filtersTable),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: SmashColors.mainDecorations,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: GpsFilterManager().filtersEnabled
                          ? SL
                              .of(context)
                              .settings_disableFilters //"Disable Filters."
                          : SL
                              .of(context)
                              .settings_enableFilters, //"Enable Filters."
                      icon: Icon(
                        GpsFilterManager().filtersEnabled
                            ? MdiIcons.filterRemove
                            : MdiIcons.filter,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        setState(() {
                          GpsFilterManager().filtersEnabled =
                              !GpsFilterManager().filtersEnabled;
                        });
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      tooltip: SL.of(context).settings_zoomIn, //"Zoom in"
                      icon: Icon(
                        SmashIcons.zoomInIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.zoom + 1;
                        if (z > 21) z = 21;
                        _mapController.move(gpsInfoList.last.newPosLatLon!, z);
                      },
                    ),
                    IconButton(
                      tooltip: SL.of(context).settings_zoomOut, //"Zoom out"
                      icon: Icon(
                        SmashIcons.zoomOutIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.zoom - 1;
                        if (z < 7) z = 7;
                        _mapController.move(gpsInfoList.last.newPosLatLon!, z);
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      tooltip: isPaused
                          ? SL
                              .of(context)
                              .settings_activatePointFlow //"Activate point flow."
                          : SL
                              .of(context)
                              .settings_pausePointsFlow, //"Pause points flow."
                      icon: Icon(isPaused ? MdiIcons.play : MdiIcons.pause,
                          color: SmashColors.mainBackground),
                      onPressed: () {
                        setState(() {
                          isPaused = !isPaused;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );
    });
  }

  SingleChildScrollView getSettingsPart(BuildContext context) {
    int minDistance = GpPreferences().getIntSync(
            SmashPreferencesKeys.KEY_GPS_MIN_DISTANCE,
            SmashPreferencesKeys.MINDISTANCES[1]) ??
        SmashPreferencesKeys.MINDISTANCES[1];
    int timeInterval = GpPreferences().getIntSync(
            SmashPreferencesKeys.KEY_GPS_TIMEINTERVAL,
            SmashPreferencesKeys.TIMEINTERVALS[1]) ??
        SmashPreferencesKeys.TIMEINTERVALS[1];
    bool doTestLog = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_GPS_TESTLOG, false);
    var testlogDurationKey = "KEY_GPS_TESTLOG_DURATIONMILLIS";
    int testLogDuration =
        GpPreferences().getIntSync(testlogDurationKey, 500) ?? 500;
    bool showAllGpsPointCount = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_GPS_SHOW_ALL_POINTS, false);
    bool showValidGpsPointCount = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_GPS_SHOW_VALID_POINTS, false);
    bool useGpsFilteredGenerally = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, false);
    bool useGpsGoogleServices = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_GOOGLE_SERVICES, false);

    // SmashLocationAccuracy locationAccuracy =
    //     SmashLocationAccuracy.fromPreferences();
    // var accuraciesList = SmashLocationAccuracy.values();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            margin: SmashUI.defaultMargin(),
            // elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(
                      SL
                          .of(context)
                          .settings_visualizePointCount, //"Visualize point count"
                      bold: true,
                      textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: Icon(MdiIcons.formatListNumbered),
                  title: Text(SL
                      .of(context)
                      .settings_showGpsPointsValidPoints), //"Show the GPS points count for VALID points."
                  subtitle: Wrap(
                    children: <Widget>[
                      Checkbox(
                        value: showValidGpsPointCount,
                        onChanged: (selValid) async {
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_SHOW_VALID_POINTS,
                              selValid!);
                          Provider.of<SmashMapBuilder>(context, listen: false)
                              .reBuild();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.formatListNumbered),
                  title: Text(SL
                      .of(context)
                      .settings_showGpsPointsAllPoints), //"Show the GPS points count for ALL points."
                  subtitle: Wrap(
                    children: <Widget>[
                      Checkbox(
                        value: showAllGpsPointCount,
                        onChanged: (selAll) async {
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_SHOW_ALL_POINTS,
                              selAll!);

                          Provider.of<SmashMapBuilder>(context, listen: false)
                              .reBuild();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // TODO enable this when the locationaccuracy works properly
          // Card(
          //   margin: SmashUI.defaultMargin(),
          //   // elevation: SmashUI.DEFAULT_ELEVATION,
          //   color: SmashColors.mainBackground,
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //         padding: SmashUI.defaultPadding(),
          //         child: SmashUI.normalText("GPS accuracy",
          //             bold: true, textAlign: TextAlign.start),
          //       ),
          //       ListTile(
          //         leading: Icon(MdiIcons.crosshairsQuestion),
          //         title: Text("System accuracy to use."),
          //         subtitle: Wrap(
          //           children: <Widget>[
          //             DropdownButton<int>(
          //               value: locationAccuracy.code,
          //               isExpanded: false,
          //               items: accuraciesList.map((i) {
          //                 return DropdownMenuItem<int>(
          //                   child: Text(
          //                     i.label,
          //                     textAlign: TextAlign.center,
          //                   ),
          //                   value: i.code,
          //                 );
          //               }).toList(),
          //               onChanged: (selected) async {
          //                 if (locationAccuracy.code != selected) {
          //                   var newAccuracy =
          //                       SmashLocationAccuracy.fromCode(selected);
          //                   await SmashLocationAccuracy.toPreferences(
          //                       newAccuracy);
          //                   GpsHandler().restartLocationsService();
          //                   setState(() {});
          //                 }
          //               },
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Card(
            margin: SmashUI.defaultMargin(),
            // elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(
                      SL.of(context).settings_logFilters, //"Log filters"
                      bold: true,
                      textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: Icon(MdiIcons.ruler),
                  title: Text(SL
                      .of(context)
                      .settings_minDistanceBetween2Points), //"Min distance between 2 points."
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: minDistance,
                        isExpanded: false,
                        items: SmashPreferencesKeys.MINDISTANCES.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i m",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_GPS_MIN_DISTANCE,
                              selected!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.gpsMinDistance = selected;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.timelapse),
                  title: Text(SL
                      .of(context)
                      .settings_minTimespanBetween2Points), //"Min timespan between 2 points."
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: timeInterval,
                        isExpanded: false,
                        items: SmashPreferencesKeys.TIMEINTERVALS.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i sec",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_GPS_TIMEINTERVAL,
                              selected!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.gpsTimeInterval = selected;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(SL.of(context).settings_gpsFilter,
                      bold: true), //"GPS Filter"
                ),
                ListTile(
                  leading: Icon(MdiIcons.filter),
                  title: Text(
                      "${useGpsFilteredGenerally ? SL.of(context).settings_disable : SL.of(context).settings_enable} ${SL.of(context).settings_theUseOfTheGps}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: SmashUI.defaultTBPadding(),
                        child: Text(
                          SL
                              .of(context)
                              .settings_warningThisWillAffectGpsPosition, //"WARNING: This will affect GPS position, notes insertion, log statistics and charting."
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Checkbox(
                        value: useGpsFilteredGenerally,
                        onChanged: (newValue) async {
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.useFilteredGpsQuiet = newValue!;
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY,
                              newValue);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(
                      SL.of(context).settings_MockLocations,
                      bold: true), //"Mock locations"
                ),
                ListTile(
                  leading: Icon(MdiIcons.crosshairsGps),
                  title: Text(
                      "${doTestLog ? SL.of(context).settings_disable : SL.of(context).settings_enable} ${SL.of(context).settings_testGpsLogDemoUse}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: doTestLog,
                        onChanged: (newValue) async {
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_TESTLOG, newValue!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.doTestLog = newValue;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.timer),
                  title: Text(SL
                      .of(context)
                      .settings_setDurationGpsPointsInMilli), //"Set duration for GPS points in milliseconds."
                  subtitle: TextButton(
                      style: SmashUI.defaultFlatButtonStyle(),
                      onPressed: () async {
                        var newValue = await SmashDialogs.showInputDialog(
                            context,
                            SL.of(context).settings_SETTING, //"SETTING"
                            SL
                                .of(context)
                                .settings_setMockedGpsDuration, //"Set Mocked GPS duration"
                            defaultText: "$testLogDuration",
                            validationFunction: (value) {
                          if (int.tryParse(value) == null) {
                            return SL
                                .of(context)
                                .settings_theValueHasToBeInt; //"The value has to be an integer."
                          }
                          return null;
                        });
                        if (newValue != null) {
                          var newMillis = int.parse(newValue);
                          TestLogStream().setNewDuration(newMillis);
                          await GpPreferences()
                              .setInt(testlogDurationKey, newMillis);
                          setState(() {});
                        }
                      },
                      child: Text(
                          "$testLogDuration ${SL.of(context).settings_milliseconds}")), //milliseconds
                ),
              ],
            ),
          ),
          if (Platform.isAndroid)
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        SL
                            .of(context)
                            .settings_useGoogleToImproveLoc, //"Use Google Services to improve location"
                        bold: true),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.crosshairsGps),
                    title: Text(
                        "${useGpsGoogleServices ? SL.of(context).settings_disable : SL.of(context).settings_enable} ${SL.of(context).settings_useOfGoogleServicesRestart}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: useGpsGoogleServices,
                          onChanged: (newValue) async {
                            await GpPreferences().setBoolean(
                                SmashPreferencesKeys
                                    .KEY_GPS_USE_GOOGLE_SERVICES,
                                newValue!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class GpsLogsSetting extends StatefulWidget {
  GpsLogsSetting({Key? key}) : super(key: key);

  @override
  _GpsLogsSettingState createState() => _GpsLogsSettingState();
}

class _GpsLogsSettingState extends State<GpsLogsSetting> {
  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultPadding() * 2,
          child: SmashUI.normalText(SL.of(context).settings_gpsLogsViewMode,
              bold: true), //"GPS Logs view mode"
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eye,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_logViewModeForOrigData), //"Log view mode for original data."
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: gpsState.logMode,
                isExpanded: false,
                items: SmashPreferencesKeys.LOGVIEWMODES.map((i) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      i,
                      textAlign: TextAlign.center,
                    ),
                    value: i,
                  );
                }).toList(),
                onChanged: (selected) async {
                  await GpPreferences().setStringList(
                      SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE,
                      [selected!, gpsState.filteredLogMode]);
                  gpsState.logMode = selected;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eyeSettings,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_logViewModeFilteredData), //"Log view mode for filtered data."
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: gpsState.filteredLogMode,
                isExpanded: false,
                items: SmashPreferencesKeys.LOGVIEWMODES.map((i) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      i,
                      textAlign: TextAlign.center,
                    ),
                    value: i,
                  );
                }).toList(),
                onChanged: (selected) async {
                  await GpPreferences().setStringList(
                      SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE,
                      [gpsState.logMode, selected!]);
                  gpsState.filteredLogMode = selected;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        SmashUI.defaultButtonBar(
          cancelLabel: SL.of(context).settings_cancel, //"CANCEL"
          cancelFunction: () => Navigator.pop(context),
          okLabel: SL.of(context).settings_ok, //"OK"
          okFunction: () {
            Navigator.pop(context);
            var projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.reloadProject(context);
          },
        ),
      ],
    );
  }
}

class NotesViewSetting extends StatefulWidget {
  NotesViewSetting({Key? key}) : super(key: key);

  @override
  _NotesViewSettingState createState() => _NotesViewSettingState();
}

class _NotesViewSettingState extends State<NotesViewSetting> {
  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultPadding() * 2,
          child: SmashUI.normalText(SL.of(context).settings_notesViewModes,
              bold: true), //"Notes view modes"
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eye,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_selectNotesViewMode), //"Select a notes view mode."
          subtitle: DropdownButton<String>(
            value: gpsState.notesMode,
            isExpanded: false,
            items: SmashPreferencesKeys.NOTESVIEWMODES.map((i) {
              print(i);
              return DropdownMenuItem<String>(
                child: Text(
                  i,
                  textAlign: TextAlign.center,
                ),
                value: i,
              );
            }).toList(),
            onChanged: (selected) async {
              await GpPreferences().setString(
                  SmashPreferencesKeys.KEY_NOTES_VIEW_MODE, selected!);
              gpsState.notesMode = selected;
              setState(() {});
            },
          ),
        ),
        SmashUI.defaultButtonBar(
          cancelLabel: SL.of(context).settings_cancel, //'CANCEL'
          cancelFunction: () => Navigator.pop(context),
          okLabel: SL.of(context).settings_ok, //'OK'
          okFunction: () {
            Navigator.pop(context);
            var projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.reloadProject(context);
          },
        ),
      ],
    );
  }
}

class PluginsViewSetting extends StatefulWidget {
  PluginsViewSetting({Key? key}) : super(key: key);

  @override
  _PluginsViewSettingState createState() => _PluginsViewSettingState();
}

class _PluginsViewSettingState extends State<PluginsViewSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultPadding() * 2,
          child: SmashUI.normalText(SL.of(context).settings_mapPlugins,
              bold: true), //"Map Plugins"
        ),
        PluginCheckboxWidget(PluginsHandler.SCALE.key),
        PluginCheckboxWidget(PluginsHandler.GRID.key),
        PluginCheckboxWidget(PluginsHandler.CROSS.key),
        PluginCheckboxWidget(PluginsHandler.GPS.key),
        PluginCheckboxWidget(PluginsHandler.FENCE.key),
        PluginsHandler.HEATMAP_WORKING
            ? PluginCheckboxWidget(PluginsHandler.LOG_HEATMAP.key)
            : Container(),
        SmashUI.defaultButtonBar(
          cancelLabel: SL.of(context).settings_cancel, //'CANCEL'
          cancelFunction: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class VectorLayerSettings extends StatefulWidget {
  @override
  VectorLayerSettingsState createState() {
    return VectorLayerSettingsState();
  }
}

class VectorLayerSettingsState extends State<VectorLayerSettings> {
  //static final title = "Vector Layers";
  //static final subtitle = "Loading Options and Info Tool";
  static final iconData = MdiIcons.vectorPolyline;

  @override
  Widget build(BuildContext context) {
    bool loadOnlyVisible = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_VECTOR_LOAD_ONLY_VISIBLE, false);
    int maxFeaturesToLoad = GpPreferences()
            .getIntSync(SmashPreferencesKeys.KEY_VECTOR_MAX_FEATURES, 1000) ??
        -1;
    int tapAreaPixels = GpPreferences()
            .getIntSync(SmashPreferencesKeys.KEY_VECTOR_TAPAREA_SIZE, 50) ??
        50;
    int handleIconSize =
        GpPreferences().getIntSync(SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE, 25) ??
            25;
    int intermediateHandleIconSize = GpPreferences()
            .getIntSync(SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE, 20) ??
        20;

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_vectorLayers),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        SL.of(context).settings_dataLoading,
                        bold: true), //"Data loading"
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.counter),
                    title: Text(SL
                        .of(context)
                        .settings_maxNumberFeatures), //"Max number of features."
                    subtitle: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: SmashUI.defaultTBPadding(),
                          child: Text(
                            SL
                                .of(context)
                                .settings_maxNumFeaturesPerLayer, //"Max number of features to load per layer. To apply remove and add layer back."
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        DropdownButton<int>(
                          value: maxFeaturesToLoad,
                          isExpanded: false,
                          items:
                              SmashPreferencesKeys.MAXFEATURESTOLOAD.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                i > 0
                                    ? "$i"
                                    : SL.of(context).settings_all, //"all"
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences().setInt(
                                SmashPreferencesKeys.KEY_VECTOR_MAX_FEATURES,
                                selected!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.selectMarker),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(SL
                          .of(context)
                          .settings_loadMapArea), //"Load map area."
                    ),
                    subtitle: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: SmashUI.defaultTBPadding(),
                          child: Text(
                            SL
                                .of(context)
                                .settings_loadOnlyLastVisibleArea, //"Load only on the last visible map area. To apply remove and add layer back."
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Checkbox(
                          value: loadOnlyVisible,
                          onChanged: (newValue) async {
                            await GpPreferences().setBoolean(
                                SmashPreferencesKeys
                                    .KEY_VECTOR_LOAD_ONLY_VISIBLE,
                                newValue!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(SL.of(context).settings_infoTool,
                        bold: true), //"Info Tool"
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.mapMarkerRadius),
                    title: Text(SL
                        .of(context)
                        .settings_tapSizeInfoToolPixels), //"Tap size of the info tool in pixels."
                    subtitle: Wrap(
                      children: <Widget>[
                        DropdownButton<int>(
                          value: tapAreaPixels,
                          isExpanded: true,
                          items: SmashPreferencesKeys.TAPAREASIZES.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                "$i px",
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences().setInt(
                                SmashPreferencesKeys.KEY_VECTOR_TAPAREA_SIZE,
                                selected!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        SL.of(context).settings_editingTool,
                        bold: true), //"Editing tool"
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.gestureTap),
                    title: Text(SL
                        .of(context)
                        .settings_editingDragIconSize), //"Editing drag handler icon size."
                    subtitle: Wrap(
                      children: <Widget>[
                        DropdownButton<int>(
                          value: handleIconSize,
                          isExpanded: true,
                          items: SETTINGS_EDIT_HANLDE_ICON_SIZES.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                "$i px",
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences().setInt(
                                SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE, selected!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.gestureTap),
                    title: Text(SL
                        .of(context)
                        .settings_editingIntermediateDragIconSize), //"Editing intermediate drag handler icon size."
                    subtitle: Wrap(
                      children: <Widget>[
                        DropdownButton<int>(
                          value: intermediateHandleIconSize,
                          isExpanded: true,
                          items: SETTINGS_EDIT_HANLDE_ICON_SIZES.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                "$i px",
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences().setInt(
                                SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE,
                                selected!);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsSetting extends StatefulWidget {
  @override
  DiagnosticsSettingState createState() {
    return DiagnosticsSettingState();
  }
}

class DiagnosticsSettingState extends State<DiagnosticsSetting> {
  //static final title = "Diagnostics";
  //static final subtitle = "Diagnostics & Debug Log";
  static final iconData = Icons.bug_report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_diagnostics),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: ListTile(
              leading: Icon(MdiIcons.tableEye),
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                    style: SmashUI.defaultElevateButtonStyle(
                        color: SmashColors.mainBackground),
                    child: Text(SL
                        .of(context)
                        .settings_openFullDebugLog), //"Open full debug log"
                    onPressed: () {
                      ProjectState projectState =
                          Provider.of<ProjectState>(context, listen: false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DebugLogViewer(projectState)));
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DebugLogViewer extends StatefulWidget {
  final ProjectState projectState;

  DebugLogViewer(this.projectState, {Key? key}) : super(key: key);

  @override
  _DebugLogViewerState createState() => _DebugLogViewerState();
}

class _DebugLogViewerState extends State<DebugLogViewer> {
  int limit = 1000;
  late List<dynamic> logItems;
  late List<dynamic> allLogItems;
  bool isViewingErrors = false;

  var levelToColor = {
    "Level.verbose": Colors.grey[100],
    "Level.debug": Colors.green[100],
    "Level.info": Colors.blue[100],
    "Level.warning": Colors.orange[100],
    "Level.error": Colors.red[100],
    "Level.wtf": Colors.deepPurple[100],
    "Level.nothing": Colors.grey[100],
  };
  var levelToIcon = {
    "Level.verbose": MdiIcons.accountVoice,
    "Level.debug": MdiIcons.ladybug,
    "Level.info": MdiIcons.information,
    "Level.warning": MdiIcons.alertOutline,
    "Level.error": MdiIcons.flashAlert,
    "Level.wtf": MdiIcons.bomb,
    "Level.nothing": MdiIcons.helpCircleOutline,
  };

  @override
  void initState() {
    super.initState();
    loadDebug();
  }

  void loadDebug() {
    allLogItems = SMLogger().getLogItems(limit: limit);
    allLogItems = allLogItems.where((element) {
      element.message = element.message.trim();

      if (element.message.contains(RegExp("38;5;.*m"))) {
        element.message = element.message.substring(12).trim();
      }

      if (element.message.contains("────────") ||
          element.message.contains("┄┄┄┄┄┄") ||
          element.message.startsWith("│ #") ||
          element.message.startsWith("#") ||
          element.message.startsWith(RegExp(".*48;5;196mERROR.\\[0m"))) {
        return false;
      } else if (element.message.startsWith("│ ")) {
        element.message = element.message.substring(4).trim();
      }

      if (element.message.endsWith("[0m")) {
        element.message =
            element.message.substring(0, element.message.length - 4);
      }
      return true;
    }).toList();
    setState(() {
      logItems = allLogItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).settings_debugLogView), //"Debug Log View"
        actions: [
          IconButton(
              icon: Icon(
                  isViewingErrors ? MdiIcons.ladybug : MdiIcons.flashAlert),
              tooltip: isViewingErrors
                  ? SL
                      .of(context)
                      .settings_viewAllMessages //"View all messages"
                  : SL
                      .of(context)
                      .settings_viewOnlyErrorsWarnings, //"View only errors and warnings"
              onPressed: () {
                if (isViewingErrors) {
                  logItems = allLogItems;
                } else {
                  logItems = allLogItems.where((element) {
                    return element.level == "Level.warning" ||
                        element.level == "Level.error";
                  }).toList();
                }
                setState(() {
                  isViewingErrors = !isViewingErrors;
                });
              }),
          IconButton(
              icon: Icon(MdiIcons.delete),
              tooltip:
                  SL.of(context).settings_clearDebugLog, //"Clear debug log"
              onPressed: () {
                SMLogger().clearLog();
                loadDebug();
              }),
        ],
      ),
      body: logItems == null
          ? SmashCircularProgress(
              label: SL.of(context).settings_loadingData, //"Loading data..."
            )
          : ListView.builder(
              itemCount: logItems.length,
              itemBuilder: (BuildContext context, int index) {
                GpLogItem logItem = logItems[index] as GpLogItem;
                Color c = levelToColor[logItem.level]!;
                String msg = logItem.message!;
                String ts = HU.TimeUtilities.ISO8601_TS_FORMATTER_MILLIS
                    .format(DateTime.fromMillisecondsSinceEpoch(logItem.ts));
                var iconData = levelToIcon[logItem.level];

                return Container(
                  color: c,
                  child: ListTile(
                    leading: Icon(iconData),
                    title: Text(ts),
                    subtitle: Text(msg),
                  ),
                );
              },
            ),
    );
  }
}

class DeviceSettings extends StatefulWidget {
  @override
  DeviceSettingsState createState() {
    return DeviceSettingsState();
  }
}

class DeviceSettingsState extends State<DeviceSettings> {
  //static final title = "Device";
  //static final subtitle = "Device identifier";
  static final iconData = MdiIcons.tabletCellphone;

  late String _deviceId;
  late String _overrideId;

  @override
  void initState() {
    getIds();
    super.initState();
  }

  Future<void> getIds() async {
    String? id = await Device().getDeviceId();
    String? overrideId = await GpPreferences()
        .getString(SmashPreferencesKeys.DEVICE_ID_OVERRIDE, id);

    setState(() {
      _deviceId = id!;
      _overrideId = overrideId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = SmashUI.DEFAULT_PADDING;
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_device), //Device
          ],
        ),
      ),
      body: _deviceId == null
          ? Center(
              child: SmashCircularProgress(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Card(
                      margin: SmashUI.defaultMargin(),
                      color: SmashColors.mainBackground,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.normalText(
                                SL.of(context).settings_deviceId,
                                bold: true), //"Device Id"
                          ),
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.normalText(_deviceId),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Card(
                      margin: SmashUI.defaultMargin(),
                      color: SmashColors.mainBackground,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.normalText(
                                SL
                                    .of(context)
                                    .settings_overrideDeviceId, //"Override Device Id"
                                bold: true),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: p, bottom: p, right: p, left: 2 * p),
                              child: EditableTextField(
                                SL
                                    .of(context)
                                    .settings_overrideId, //"Override Id"
                                _overrideId,
                                (res) async {
                                  if (res == null || res.trim().length == 0) {
                                    res = _deviceId;
                                  }
                                  await GpPreferences().setString(
                                      SmashPreferencesKeys.DEVICE_ID_OVERRIDE,
                                      res);
                                  setState(() {
                                    _overrideId = res;
                                  });
                                },
                                validationFunction: (text) {
                                  if (text.toString().trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return SL
                                        .of(context)
                                        .settings_pleaseEnterValidPassword; //"Please enter a valid server password."
                                  }
                                },
                              )),
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
