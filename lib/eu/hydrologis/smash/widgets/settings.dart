/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/camera_settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/device_settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/diagnostics_settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/gps_settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/screen_settings.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/vectorlayer_settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

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

    final ListTile formSettingTile = ListTile(
        leading: Icon(
          FormSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText(FormSettingsState.title),
        subtitle: Text(FormSettingsState.subtitle),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = FormSettings();
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

    final ListTile gssSettingTile = ListTile(
        leading: Icon(
          GssSettingsState.iconData,
          color: SmashColors.mainDecorations,
        ),
        title: SmashUI.normalText("GSS"), // SL.of(context).settings_device),
        subtitle: Text(SLL.of(context).gss_settings),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          _selectedSetting = GssSettings();
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

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(SL.of(context).settings_settings), //"Settings"
      ),
      body: ListView(children: <Widget>[
        gpsSettingTile,
        screenSettingTile,
        cameraSettingTile,
        vectorLayerSettingTile,
        crsSettingTile,
        formSettingTile,
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
