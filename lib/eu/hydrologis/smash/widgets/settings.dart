/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/map_plugins.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
        subtitle: SmashUI.normalText(CameraSettingState.subtitle),
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
        subtitle: SmashUI.normalText(ScreenSettingState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = ScreenSetting();
          showSettingsSheet(context);
        });

    final ListTile diagnosticsSettingTile = ListTile(
        leading: Icon(
          DiagnosticsSettingState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(DiagnosticsSettingState.title),
        subtitle: SmashUI.normalText(DiagnosticsSettingState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = DiagnosticsSetting();
          showSettingsSheet(context);
        });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: ListView(children: <Widget>[
        cameraSettingTile,
        screenSettingTile,
        diagnosticsSettingTile
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
  static final subtitle = "Camera Settings";
  static final int index = 0;
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
            Text(subtitle),
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
  static final subtitle = "Screen Settings";
  static final int index = 1;
  static final iconData = Icons.fullscreen;

  @override
  Widget build(BuildContext context) {
    bool keepScreenOn =
        GpPreferences().getBooleanSync(KEY_KEEP_SCREEN_ON, true);
    bool showScalebar = GpPreferences().getBooleanSync(KEY_SHOW_SCALEBAR, true);
    double currentIconSize = GpPreferences()
        .getDoubleSync(KEY_MAPTOOLS_ICON_SIZE, SmashUI.MEDIUM_ICON_SIZE);

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
            Text(subtitle),
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
                        Flexible(
                          flex: 1,
                          child: MaterialColorPicker(
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
  static final subtitle = "Diagnostics Settings";
  static final int index = 2;
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
            Text(subtitle),
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
