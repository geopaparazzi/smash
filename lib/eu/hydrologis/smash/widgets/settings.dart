/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/tables.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/device.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/util/logging.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => new _SettingsWidgetState();

  static void reloadMapSettings(BuildContext context) {
    // var projectState = Provider.of<ProjectState>(context, listen: false);
    // projectState.reloadProjectQuiet(context);
    SmashMapBuilder.reBuildStatic(context);
  }
}

class _SettingsWidgetState extends State<SettingsWidget> {
  Widget _selectedSetting;

  @override
  Widget build(BuildContext context) {
    final ListTile cameraSettingTile = ListTile(
        leading: Icon(
          CameraSettingState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(CameraSettingState.title),
        subtitle: Text(CameraSettingState.subtitle),
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
        title: SmashUI.normalText(ScreenSettingState.title),
        subtitle: Text(ScreenSettingState.subtitle),
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
        title: SmashUI.normalText(GpsSettingsState.title),
        subtitle: Text(GpsSettingsState.subtitle),
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
        title: SmashUI.normalText(VectorLayerSettingsState.title),
        subtitle: Text(VectorLayerSettingsState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = VectorLayerSettings();
          showSettingsSheet(context);
        });

    final ListTile deviceSettingTile = ListTile(
        leading: Icon(
          DeviceSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(DeviceSettingsState.title),
        subtitle: Text(DeviceSettingsState.subtitle),
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
        title: SmashUI.normalText(DiagnosticsSettingState.title),
        subtitle: Text(DiagnosticsSettingState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = DiagnosticsSetting();
          showSettingsSheet(context);
        });

    final ListTile gssSettingTile = ListTile(
        leading: Icon(
          GssSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(GssSettingsState.title),
        subtitle: Text(GssSettingsState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = GssSettings();
          showSettingsSheet(context);
        });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: ListView(children: <Widget>[
        gpsSettingTile,
        screenSettingTile,
        cameraSettingTile,
        vectorLayerSettingTile,
        deviceSettingTile,
        gssSettingTile,
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
  static final title = "Camera";
  static final subtitle = "Camera Resolution";
  static final iconData = Icons.camera;

  @override
  Widget build(BuildContext context) {
    String value = GpPreferences()
        .getStringSync(KEY_CAMERA_RESOLUTION, CameraResolutions.MEDIUM);
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
            Text(title),
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
              title: Text("Resolution"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultTBPadding(),
                    child: Text(
                      "The camera resolution",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  DropdownButton(
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
                      await GpPreferences()
                          .setString(KEY_CAMERA_RESOLUTION, selected);
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
  static final title = "Screen";
  static final subtitle = "Screen, Scalebar and Icon Size";
  static final int index = 1;
  static final iconData = Icons.fullscreen;

  @override
  Widget build(BuildContext context) {
    bool keepScreenOn =
        GpPreferences().getBooleanSync(KEY_KEEP_SCREEN_ON, true);
    double currentIconSize = GpPreferences()
        .getDoubleSync(KEY_MAPTOOLS_ICON_SIZE, SmashUI.MEDIUM_ICON_SIZE);
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
            Text(title),
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
                  await GpPreferences()
                      .setBoolean(KEY_KEEP_SCREEN_ON, selected);
                  SettingsWidget.reloadMapSettings(context);
                  setState(() {});
                },
                title: SmashUI.normalText(
                  "Keep Screen On",
                ),
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: SmashUI.normalText(
                      "Map Center Cross",
                    ),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SmashUI.normalText("Color"),
                        Expanded(
                          child: MaterialColorPicker(
                            shrinkWrap: true,
                            allowShades: false,
                            circleSize: 45,
                            onColorChange: (Color color) async {
                              centerCrossStyle.color = ColorExt.asHex(color);
                              await centerCrossStyle.saveToPreferences();
                              setState(() {});
                            },
                            onMainColorChange: (mColor) async {
                              centerCrossStyle.color = ColorExt.asHex(mColor);
                              await centerCrossStyle.saveToPreferences();
                              SettingsWidget.reloadMapSettings(context);
                              setState(() {});
                            },
                            selectedColor:
                                Color(ColorExt(centerCrossStyle.color).value),
                            colors: SmashColorPalette.getColorSwatchValues(),
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
                        SmashUI.normalText("Size"),
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
                        SmashUI.normalText("Width"),
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
                  SmashUI.normalText("Map Tools Icon Size"),
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
                                await GpPreferences()
                                    .setDouble(KEY_MAPTOOLS_ICON_SIZE, newSize);
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
  static final title = "GPS";
  static final subtitle = "GPS filters and mock locations";
  static final iconData = MdiIcons.crosshairsGps;
  List<GpsFilterManagerMessage> gpsInfoList = [];
  List<int> gpsInfoListCounter = [];
  int _count = 0;
  bool isPaused = false;

  MapController _mapController;
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
              Text(title),
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(text: "Settings"),
            Tab(text: "Live Preview"),
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
        return SmashCircularProgress(label: "No point available yet.");
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
            point: msg.newPosLatLon,
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
                      "longitude [deg]":
                          msg.newPosLatLon.longitude.toStringAsFixed(6),
                      "latitude [deg]":
                          msg.newPosLatLon.latitude.toStringAsFixed(6),
                      "accuracy [m]": msg.accuracy.toStringAsFixed(0),
                      "altitude [m]": msg.altitude.toStringAsFixed(0),
                      "heading [deg]": msg.heading.toStringAsFixed(0),
                      "speed [m/s]": msg.speed.toStringAsFixed(0),
                      "is logging?": msg.isLogging,
                      "mock locations?": msg.mocked,
                    };

                    var infoTable = TableUtilities.fromMap(infoMap,
                        doSmallText: true,
                        borderColor: SmashColors.mainDecorations,
                        withBorder: true);

                    double distanceLastEvent = msg.distanceLastEvent;
                    int maxAllowedDistanceLastEvent =
                        msg.maxAllowedDistanceLastEvent;
                    int minAllowedDistanceLastEvent =
                        msg.minAllowedDistanceLastEvent;

                    int timeLastEvent = msg.timeDeltaLastEvent;
                    int minAllowedTimeLastEvent =
                        msg.minAllowedTimeDeltaLastEvent;

                    bool maxDistFilterBlocks =
                        distanceLastEvent > maxAllowedDistanceLastEvent;
                    bool minDistFilterBlocks =
                        distanceLastEvent <= minAllowedDistanceLastEvent;
                    bool minTimeFilterBlocks =
                        timeLastEvent <= minAllowedTimeLastEvent;

                    var maxDistString = maxDistFilterBlocks
                        ? "MAX DIST FILTER BLOCKS"
                        : "Max dist filter passes";
                    var minDistString = minDistFilterBlocks
                        ? "MIN DIST FILTER BLOCKS"
                        : "Min dist filter passes";
                    var minTimeString = minTimeFilterBlocks
                        ? "MIN TIME FILTER BLOCKS"
                        : "Min time filter passes";

                    bool hasBeenBlocked = msg.blockedByFilter;
                    var filterMap = {
                      "HAS BEEN BLOCKED": "$hasBeenBlocked",
                      "Distance from prev [m]": distanceLastEvent,
                      "Time from prev [s]": timeLastEvent,
                      maxDistString:
                          "$distanceLastEvent > $maxAllowedDistanceLastEvent",
                      minDistString:
                          "$distanceLastEvent <= $minAllowedDistanceLastEvent",
                      minTimeString:
                          "$timeLastEvent <= $minAllowedTimeLastEvent",
                    };
                    var filtersTable = TableUtilities.fromMap(filterMap,
                        doSmallText: true,
                        borderColor: Colors.orange,
                        withBorder: true,
                        colWidthFlex: [0.6, 0.4],
                        highlightPattern: "BLOCKS",
                        highlightColor: Colors.orange.withAlpha(128));

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
                                      child: Text("Location Info",
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
                                        "Filters",
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
                          ? "Disable Filters."
                          : "Enable Filters.",
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
                      tooltip: "Zoom in",
                      icon: Icon(
                        SmashIcons.zoomInIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.zoom + 1;
                        if (z > 21) z = 21;
                        _mapController.move(gpsInfoList.last.newPosLatLon, z);
                      },
                    ),
                    IconButton(
                      tooltip: "Zoom out",
                      icon: Icon(
                        SmashIcons.zoomOutIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.zoom - 1;
                        if (z < 7) z = 7;
                        _mapController.move(gpsInfoList.last.newPosLatLon, z);
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      tooltip: isPaused
                          ? "Activate point flow."
                          : "Pause points flow.",
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
    int minDistance =
        GpPreferences().getIntSync(KEY_GPS_MIN_DISTANCE, MINDISTANCES.first);
    int maxDistance =
        GpPreferences().getIntSync(KEY_GPS_MAX_DISTANCE, MAXDISTANCES.last);
    int timeInterval =
        GpPreferences().getIntSync(KEY_GPS_TIMEINTERVAL, TIMEINTERVALS.first);
    bool doTestLog = GpPreferences().getBooleanSync(KEY_GPS_TESTLOG, false);
    bool showAllGpsPointCount =
        GpPreferences().getBooleanSync(KEY_GPS_SHOW_ALL_POINTS, false);
    bool showValidGpsPointCount =
        GpPreferences().getBooleanSync(KEY_GPS_SHOW_VALID_POINTS, false);

    SmashLocationAccuracy locationAccuracy =
        SmashLocationAccuracy.fromPreferences();
    var accuraciesList = SmashLocationAccuracy.values();
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
                  child: SmashUI.normalText("Visualize point count",
                      bold: true, textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: Icon(MdiIcons.formatListNumbered),
                  title: Text("Show the GPS points count for VALID points."),
                  subtitle: Wrap(
                    children: <Widget>[
                      Checkbox(
                        value: showValidGpsPointCount,
                        onChanged: (selValid) async {
                          await GpPreferences().setBoolean(
                              KEY_GPS_SHOW_VALID_POINTS, selValid);
                          Provider.of<SmashMapBuilder>(context).reBuild();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.formatListNumbered),
                  title: Text("Show the GPS points count for ALL points."),
                  subtitle: Wrap(
                    children: <Widget>[
                      Checkbox(
                        value: showAllGpsPointCount,
                        onChanged: (selAll) async {
                          await GpPreferences()
                              .setBoolean(KEY_GPS_SHOW_ALL_POINTS, selAll);

                          Provider.of<SmashMapBuilder>(context).reBuild();
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
                  child: SmashUI.normalText("Log filters",
                      bold: true, textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: Icon(MdiIcons.ruler),
                  title: Text("Min distance between 2 points."),
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: minDistance,
                        isExpanded: false,
                        items: MINDISTANCES.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i m",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences()
                              .setInt(KEY_GPS_MIN_DISTANCE, selected);
                          var gpsState = Provider.of<GpsState>(context);
                          gpsState.gpsMinDistance = selected;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.timelapse),
                  title: Text("Min timespan between 2 points."),
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: timeInterval,
                        isExpanded: false,
                        items: TIMEINTERVALS.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i sec",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences()
                              .setInt(KEY_GPS_TIMEINTERVAL, selected);
                          var gpsState = Provider.of<GpsState>(context);
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
                  child: SmashUI.normalText("Other filters", bold: true),
                ),
                ListTile(
                  leading: Icon(MdiIcons.ruler),
                  title: Text("Max distance between 2 points."),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: SmashUI.defaultTBPadding(),
                        child: Text(
                          "Max distance allowed between two subsequent points. This marks GPS points with higher 'jumps' as invalid and ignores them.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      DropdownButton<int>(
                        value: maxDistance,
                        isExpanded: false,
                        items: MAXDISTANCES.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i m",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences()
                              .setInt(KEY_GPS_MAX_DISTANCE, selected);
                          var gpsState = Provider.of<GpsState>(context);
                          gpsState.gpsMaxDistance = selected;
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
                  child: SmashUI.normalText("Mock locations", bold: true),
                ),
                ListTile(
                  leading: Icon(MdiIcons.crosshairsGps),
                  title: Text(
                      "${doTestLog ? "Disable" : "Enable"} test gps log for demo use."),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: SmashUI.defaultTBPadding(),
                        child: Text(
                          "WARNING: This needs a working gps fix since it modifies the incoming gps points with those of the demo.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Checkbox(
                        value: doTestLog,
                        onChanged: (newValue) async {
                          await GpPreferences()
                              .setBoolean(KEY_GPS_TESTLOG, newValue);
                          var gpsState = Provider.of<GpsState>(context);
                          gpsState.doTestLog = newValue;
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

class VectorLayerSettings extends StatefulWidget {
  @override
  VectorLayerSettingsState createState() {
    return VectorLayerSettingsState();
  }
}

class VectorLayerSettingsState extends State<VectorLayerSettings> {
  static final title = "Vector Layers";
  static final subtitle = "Loading Options and Info Tool";
  static final iconData = MdiIcons.vectorPolyline;

  @override
  Widget build(BuildContext context) {
    bool loadOnlyVisible =
        GpPreferences().getBooleanSync(KEY_VECTOR_LOAD_ONLY_VISIBLE, false);
    int maxFeaturesToLoad =
        GpPreferences().getIntSync(KEY_VECTOR_MAX_FEATURES, -1);
    int tapAreaPixels = GpPreferences().getIntSync(KEY_VECTOR_TAPAREA_SIZE, 50);

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
            Text(title),
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
                    child: SmashUI.normalText("Data loading", bold: true),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.counter),
                    title: Text("Max number of features."),
                    subtitle: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: SmashUI.defaultTBPadding(),
                          child: Text(
                            "Max number of features to load per layer. To apply remove and add layer back.",
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        DropdownButton<int>(
                          value: maxFeaturesToLoad,
                          isExpanded: false,
                          items: MAXFEATURESTOLOAD.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                i > 0 ? "$i" : "all",
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences()
                                .setInt(KEY_VECTOR_MAX_FEATURES, selected);
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
                      child: Text("Load map area."),
                    ),
                    subtitle: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: SmashUI.defaultTBPadding(),
                          child: Text(
                            "Load only on the last visible map area. To apply remove and add layer back.",
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Checkbox(
                          value: loadOnlyVisible,
                          onChanged: (newValue) async {
                            await GpPreferences().setBoolean(
                                KEY_VECTOR_LOAD_ONLY_VISIBLE, newValue);
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
                    child: SmashUI.normalText("Info Tool", bold: true),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.mapMarkerRadius),
                    title: Text("Tap size of the info tool in pixels."),
                    subtitle: Wrap(
                      children: <Widget>[
                        DropdownButton<int>(
                          value: tapAreaPixels,
                          isExpanded: true,
                          items: TAPAREASIZES.map((i) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                "$i px",
                                textAlign: TextAlign.center,
                              ),
                              value: i,
                            );
                          }).toList(),
                          onChanged: (selected) async {
                            await GpPreferences()
                                .setInt(KEY_VECTOR_TAPAREA_SIZE, selected);
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
  static final title = "Diagnostics";
  static final subtitle = "Diagnostics & Debug Log";
  static final iconData = Icons.bug_report;

  @override
  Widget build(BuildContext context) {
    bool value = GpPreferences().getBooleanSync(KEY_ENABLE_DIAGNOSTICS, false);
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
            Text(title),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: SmashUI.defaultMargin(),
            // elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: ListTile(
              leading: Icon(iconData),
              title: Text("${value ? "Disable" : "Enable"} diagnostics menu"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: value,
                    onChanged: (selected) async {
                      await GpPreferences()
                          .setBoolean(KEY_ENABLE_DIAGNOSTICS, selected);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: ListTile(
              leading: Icon(MdiIcons.tableEye),
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                    color: SmashColors.mainBackground,
                    child: Text("Open full debug log"),
                    onPressed: () {
                      ProjectState projectState =
                          Provider.of<ProjectState>(context);
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

  DebugLogViewer(this.projectState, {Key key}) : super(key: key);

  @override
  _DebugLogViewerState createState() => _DebugLogViewerState();
}

class _DebugLogViewerState extends State<DebugLogViewer> {
  int limit = 1000;
  List<GpLogItem> logItems;
  List<GpLogItem> allLogItems;
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
    "Level.debug": MdiIcons.androidDebugBridge,
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

  void loadDebug() async {
    allLogItems = await GpLogger().getLogItems(limit: limit);
    allLogItems = allLogItems.where((element) {
      element.message = element.message.trim();

      if (element.message.contains("38;5;12m")) {
        element.message = element.message.substring(12).trim();
      }

      if (element.message.contains("────────") ||
          element.message.contains("┄┄┄┄┄┄") ||
          element.message.startsWith("│ #") ||
          element.message.startsWith("#")) {
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
        title: Text("Debug Log View"),
        actions: [
          IconButton(
              icon: Icon(isViewingErrors
                  ? MdiIcons.androidDebugBridge
                  : MdiIcons.flashAlert),
              tooltip: isViewingErrors
                  ? "View all messages"
                  : "View only errors and warnings",
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
              })
        ],
      ),
      body: logItems == null
          ? SmashCircularProgress(
              label: "Loading data...",
            )
          : ListView.builder(
              itemCount: logItems.length,
              itemBuilder: (BuildContext context, int index) {
                GpLogItem logItem = logItems[index];
                Color c = levelToColor[logItem.level];
                String msg = logItem.message;
                String ts = TimeUtilities.ISO8601_TS_FORMATTER_MILLIS
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
  static final title = "Device";
  static final subtitle = "Device identifier";
  static final iconData = MdiIcons.tabletCellphone;

  String _deviceId;
  String _overrideId;

  @override
  void initState() {
    getIds();
    super.initState();
  }

  Future<void> getIds() async {
    String id = await Device().getDeviceId();
    String overrideId = await GpPreferences().getString(DEVICE_ID_OVERRIDE, id);

    setState(() {
      _deviceId = id;
      _overrideId = overrideId;
    });
  }

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
            Text(title),
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
                            child: SmashUI.normalText("Device Id", bold: true),
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
                            child: SmashUI.normalText("Override Device Id",
                                bold: true),
                          ),
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.normalText(_overrideId),
                          ),
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: FlatButton(
                              child: SmashUI.normalText("CHANGE",
                                  color: SmashColors.mainDanger),
                              onPressed: () async {
                                var res = await showInputDialog(context,
                                    "Override id", "Insert override id",
                                    defaultText: _overrideId);
                                if (res == null || res.trim().length == 0) {
                                  res = _deviceId;
                                }
                                await GpPreferences()
                                    .setString(DEVICE_ID_OVERRIDE, res);
                                setState(() {
                                  _overrideId = res;
                                });
                              },
                            ),
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

class GssSettings extends StatefulWidget {
  @override
  GssSettingsState createState() {
    return GssSettingsState();
  }
}

class GssSettingsState extends State<GssSettings> {
  static final title = "GSS";
  static final subtitle = "Geopaparazzi Survey Server";
  static final iconData = MdiIcons.cloudLock;

  String _gssUrl;
  String _gssUser; // TODO when server supports them
  String _gssPwd;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    String gssUrl = await GpPreferences().getString(KEY_GSS_SERVER_URL, "");
    String gssUser = await GpPreferences().getString(KEY_GSS_SERVER_USER, "");
    String gssPwd = await GpPreferences().getString(KEY_GSS_SERVER_PWD, "");

    setState(() {
      _gssUrl = gssUrl;
      _gssUser = gssUser;
      _gssPwd = gssPwd;
    });
  }

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
            Text(title),
          ],
        ),
      ),
      body: _gssUrl == null
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
                            child: SmashUI.normalText("Server URL", bold: true),
                          ),
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.normalText(_gssUrl),
                          ),
                          Padding(
                            padding: SmashUI.defaultPadding(),
                            child: FlatButton(
                              child: SmashUI.normalText("CHANGE",
                                  color: SmashColors.mainDecorations),
                              onPressed: () async {
                                var res = await showInputDialog(
                                    context, "Set url", "Set GSS server url",
                                    defaultText: _gssUrl,
                                    validationFunction: (text) {
                                  if (text.startsWith("http://") ||
                                      text.startsWith("https://")) {
                                    return null;
                                  } else {
                                    return "Server url needs to start with http or https.";
                                  }
                                });
                                if (res == null || res.trim().length == 0) {
                                  res = _gssUrl;
                                }
                                await GpPreferences()
                                    .setString(KEY_GSS_SERVER_URL, res);
                                setState(() {
                                  _gssUrl = res;
                                });
                              },
                            ),
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
