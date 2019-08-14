/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';

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
        leading: Icon(CameraSettingState.iconData),
        title: SmashUI.normalText(CameraSettingState.title),
        subtitle: SmashUI.normalText(CameraSettingState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () async {
          _selectedSetting = CameraSetting();
          showSettingsSheet(context);
        });
    final ListTile screenSettingTile = ListTile(
        leading: Icon(ScreenSettingState.iconData),
        title: SmashUI.normalText(ScreenSettingState.title),
        subtitle: SmashUI.normalText(ScreenSettingState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = ScreenSetting();
          showSettingsSheet(context);
        });

    final ListTile diagnosticsSettingTile = ListTile(
        leading: Icon(DiagnosticsSettingState.iconData),
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
              child: Icon(iconData),
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
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(iconData),
            ),
            Text(subtitle),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: SmashUI.defaultMargin(),
            elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: CheckboxListTile(
              value: keepScreenOn,
              onChanged: (selected) async {
                await GpPreferences().setBoolean(KEY_KEEP_SCREEN_ON, selected);
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
              children: <Widget>[],
            ),
          ),
        ],
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
              child: Icon(iconData),
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
