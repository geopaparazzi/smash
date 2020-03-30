/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/device.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/plugins/center_cross_plugin.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => new _SettingsWidgetState();
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
                color: SmashColors.mainDecorations,
              ),
            ),
            Text(title),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: SmashUI.normalText(
              "Resolution",
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: DropdownButton(
                value: value,
                isExpanded: true,
                hint: Text("Camera Resolution"),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: SmashUI.normalText(
                        CameraResolutions.HIGH,
                        textAlign: TextAlign.center,
                      ),
                      width: 200,
                    ),
                    value: CameraResolutions.HIGH,
                  ),
                  DropdownMenuItem(
                    child: Container(
                      child: SmashUI.normalText(
                        CameraResolutions.MEDIUM,
                        textAlign: TextAlign.center,
                      ),
                      width: 200,
                    ),
                    value: CameraResolutions.MEDIUM,
                  ),
                  DropdownMenuItem(
                    child: Container(
                      child: SmashUI.normalText(
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
    bool showScalebar = GpPreferences().getBooleanSync(KEY_SHOW_SCALEBAR, true);
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
                color: SmashColors.mainDecorations,
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
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: CheckboxListTile(
                value: keepScreenOn,
                onChanged: (selected) async {
                  await GpPreferences()
                      .setBoolean(KEY_KEEP_SCREEN_ON, selected);
                  setState(() {});
                },
                title: SmashUI.normalText(
                  "Keep Screen On",
                ),
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: CheckboxListTile(
                value: showScalebar,
                onChanged: (selected) async {
                  await GpPreferences().setBoolean(KEY_SHOW_SCALEBAR, selected);
                  setState(() {});
                },
                title: SmashUI.normalText(
                  "Show Scalebar",
                ),
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    value: centerCrossStyle.visible,
                    onChanged: (selected) async {
                      centerCrossStyle.visible = selected;
                      await centerCrossStyle.saveToPreferences();
                      setState(() {});
                    },
                    title: SmashUI.normalText(
                      "Show Center Cross",
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
                                setState(() {});
                              },
                              selectedColor: Color(
                                  ColorExt(centerCrossStyle.color).value)),
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
              elevation: SmashUI.DEFAULT_ELEVATION,
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

  @override
  Widget build(BuildContext context) {
    int minDistance =
        GpPreferences().getIntSync(KEY_GPS_MIN_DISTANCE, MINDISTANCES.first);
    int maxDistance =
        GpPreferences().getIntSync(KEY_GPS_MAX_DISTANCE, MAXDISTANCES.last);
    int timeInterval =
        GpPreferences().getIntSync(KEY_GPS_TIMEINTERVAL, TIMEINTERVALS.first);
    bool doTestLog = GpPreferences().getBooleanSync(KEY_GPS_TESTLOG, false);

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                iconData,
                color: SmashColors.mainDecorations,
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
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Log filters", bold: true),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Min distance between 2 points."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<int>(
                      value: minDistance,
                      isExpanded: true,
                      items: MINDISTANCES.map((i) {
                        return DropdownMenuItem<int>(
                          child: SmashUI.normalText(
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
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Min timespan between 2 points."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<int>(
                      value: timeInterval,
                      isExpanded: true,
                      items: TIMEINTERVALS.map((i) {
                        return DropdownMenuItem<int>(
                          child: SmashUI.normalText(
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
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Other filters", bold: true),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        "Max distance allowed between 2 subsequent points. This marks GPS points with higher 'jumps' as invalid and ignores them."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<int>(
                      value: maxDistance,
                      isExpanded: true,
                      items: MAXDISTANCES.map((i) {
                        return DropdownMenuItem<int>(
                          child: SmashUI.normalText(
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
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Mock locations", bold: true),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        "${doTestLog ? "Disable" : "Enable"} test gps log for demo use.\n\nWARNING: This needs a working gps fix since it modifies the incoming gps points with those of the demo."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Checkbox(
                      value: doTestLog,
                      onChanged: (newValue) async {
                        await GpPreferences()
                            .setBoolean(KEY_GPS_TESTLOG, newValue);
                        var gpsState = Provider.of<GpsState>(context);
                        gpsState.doTestLog = newValue;
                        setState(() {});
                      },
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
                color: SmashColors.mainDecorations,
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
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Data loading", bold: true),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        "Max number of features to load per layer. To apply remove and add layer back."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<int>(
                      value: maxFeaturesToLoad,
                      isExpanded: true,
                      items: MAXFEATURESTOLOAD.map((i) {
                        return DropdownMenuItem<int>(
                          child: SmashUI.normalText(
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
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        "Load only on the last visible map area. To apply remove and add layer back."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Checkbox(
                      value: loadOnlyVisible,
                      onChanged: (newValue) async {
                        await GpPreferences()
                            .setBoolean(KEY_VECTOR_LOAD_ONLY_VISIBLE, newValue);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: SmashUI.defaultMargin(),
              elevation: SmashUI.DEFAULT_ELEVATION,
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText("Info Tool", bold: true),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        "Tap size of the info tool in pixels."),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: DropdownButton<int>(
                      value: tapAreaPixels,
                      isExpanded: true,
                      items: TAPAREASIZES.map((i) {
                        return DropdownMenuItem<int>(
                          child: SmashUI.normalText(
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
                color: SmashColors.mainDecorations,
              ),
            ),
            Text(title),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          CheckboxListTile(
            value: value,
            onChanged: (selected) async {
              await GpPreferences()
                  .setBoolean(KEY_ENABLE_DIAGNOSTICS, selected);
              setState(() {});
            },
            title: SmashUI.normalText(
              "Enable diagnostics menu",
            ),
          ),
        ],
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
                color: SmashColors.mainDecorations,
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
                      elevation: SmashUI.DEFAULT_ELEVATION,
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
                      elevation: SmashUI.DEFAULT_ELEVATION,
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
                            child: RaisedButton(
                              child: SmashUI.normalText("Change"),
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
                color: SmashColors.mainDecorations,
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
                      elevation: SmashUI.DEFAULT_ELEVATION,
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
                            child: RaisedButton(
                              child: SmashUI.normalText("Change"),
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
