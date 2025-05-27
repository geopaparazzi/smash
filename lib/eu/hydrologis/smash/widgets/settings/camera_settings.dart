import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/generated/l10n.dart';

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
    String resolutionValue = GpPreferences().getStringSync(
            SmashPreferencesKeys.KEY_CAMERA_RESOLUTION,
            CameraResolutions.MEDIUM) ??
        CameraResolutions.MEDIUM;
    int? frameWidth = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_CAMERA_FRAME_W, null);
    int? frameHeight = GpPreferences()
        .getIntSync(SmashPreferencesKeys.KEY_CAMERA_FRAME_H, null);
    String? frameColor = GpPreferences()
        .getStringSync(SmashPreferencesKeys.KEY_CAMERA_FRAME_COLOR, "#000000");
    bool doFillFrame = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_CAMERA_FRAME_DOFILL, false);

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
            child: Column(
              children: [
                ListTile(
                  leading: Icon(MdiIcons.camera),
                  title: SmashUI.titleText(
                    SL.of(context).settings_resolution,
                    bold: true,
                    color: SmashColors.mainDecorations,
                  ), //"Resolution"
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
                        value: resolutionValue,
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
                ListTile(
                  leading: Icon(MdiIcons.cameraSwitchOutline),
                  title: SmashUI.titleText(
                    "Frame",
                    bold: true,
                    color: SmashColors.mainDecorations,
                  ), // Text(SL.of(context).settings_frame), //"Frame"
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: SL.of(context).settings_width, //"Width"
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) async {
                          if (value.isEmpty) {
                            value = "0";
                          }
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_CAMERA_FRAME_W,
                              int.parse(value));
                          setState(() {});
                        },
                        controller: TextEditingController()
                          ..text = frameWidth?.toString() ?? "",
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText:
                              "Height", //SL.of(context).settings_height, //"Height"
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) async {
                          if (value.isEmpty) {
                            value = "0";
                          }
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_CAMERA_FRAME_H,
                              int.parse(value));
                          setState(() {});
                        },
                        controller: TextEditingController()
                          ..text = frameHeight?.toString() ?? "",
                      ),
                      Row(
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
                                Color(ColorExt(frameColor!).value),
                                (newColor) async {
                              var newColorStr = ColorExt.asHex(newColor);
                              await GpPreferences().setString(
                                  SmashPreferencesKeys.KEY_CAMERA_FRAME_COLOR,
                                  newColorStr);
                              setState(() {});
                            }),
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Fill frame"),
                          Checkbox(
                            value: doFillFrame,
                            onChanged: (selected) async {
                              await GpPreferences().setBoolean(
                                  SmashPreferencesKeys.KEY_CAMERA_FRAME_DOFILL,
                                  selected!);
                              setState(() {});
                            },
                          ),
                        ],
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
