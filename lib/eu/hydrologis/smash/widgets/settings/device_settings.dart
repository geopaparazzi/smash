import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/generated/l10n.dart';

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
                                    _overrideId = res!;
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
