import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/generated/l10n.dart';
import 'package:provider/provider.dart';

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
        .getBooleanSync(SmashPreferencesKeys.KEY_RETINA_MODE_ON, true);
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
                            child: SmashSlider(
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
                            child: SmashSlider(
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
                            child: SmashSlider(
                              activeColor: SmashColors.mainSelection,
                              min: 10.0,
                              max: 100,
                              divisions: 45,
                              onChanged: (newSize) async {
                                await GpPreferences().setDouble(
                                    SmashPreferencesKeys.KEY_MAPTOOLS_ICON_SIZE,
                                    newSize);
                                PreferencesState prefState =
                                    Provider.of<PreferencesState>(context,
                                        listen: false);
                                prefState.readPrefs();
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
            Card(
              margin: SmashUI.defaultMargin(),
              color: SmashColors.mainBackground,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.normalText(
                        SL.of(context).settings_BottombarCustomization),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys
                                .KEY_SCREEN_TOOLBAR_SHOW_ADDNOTES,
                            SL.of(context).settings_Bottombar_showAddNote),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys
                                .KEY_SCREEN_TOOLBAR_SHOW_ADDFORMNOTES,
                            SL.of(context).settings_Bottombar_showAddFormNote),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys.KEY_SCREEN_TOOLBAR_SHOW_ADDLOG,
                            SL.of(context).settings_Bottombar_showAddGpsLog),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys
                                .KEY_SCREEN_TOOLBAR_SHOW_GPSBUTTON,
                            SL.of(context).settings_Bottombar_showGpsButton),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys.KEY_SCREEN_TOOLBAR_SHOW_LAYERS,
                            SL.of(context).settings_Bottombar_showLayers),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys.KEY_SCREEN_TOOLBAR_SHOW_ZOOM,
                            SL.of(context).settings_Bottombar_showZoom),
                        getBottombarCustomizationCheckbox(
                            context,
                            SmashPreferencesKeys
                                .KEY_SCREEN_TOOLBAR_SHOW_EDITING,
                            SL.of(context).settings_Bottombar_showEditing),
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
                    child: SmashUI.normalText("Formbuilder"),
                    // SL.of(context).settings_BottombarCustomization),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        CheckboxListTile(
                          value: GpPreferences().getBooleanSync(
                              SmashPreferencesKeys.KEY_SHOW_FORMBUILER, false),
                          onChanged: (selected) async {
                            await GpPreferences().setBoolean(
                                SmashPreferencesKeys.KEY_SHOW_FORMBUILER,
                                selected!);

                            PreferencesState prefState =
                                Provider.of<PreferencesState>(context,
                                    listen: false);
                            prefState.onChanged();

                            SettingsWidget.reloadMapSettings(context);
                            setState(() {});
                          },
                          title: SmashUI.normalText("Enable Formbuilder"),
                        )
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
                    child: SmashUI.normalText("Other"),
                  ),
                  Padding(
                    padding: SmashUI.defaultPadding(),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        CheckboxListTile(
                          value: GpPreferences().getBooleanSync(
                              SmashPreferencesKeys
                                  .KEY_SCREEN_SHOW_LOG_INFO_PANEL,
                              true),
                          onChanged: (selected) async {
                            await GpPreferences().setBoolean(
                                SmashPreferencesKeys
                                    .KEY_SCREEN_SHOW_LOG_INFO_PANEL,
                                selected!);

                            PreferencesState prefState =
                                Provider.of<PreferencesState>(context,
                                    listen: false);
                            prefState.onChanged();

                            SettingsWidget.reloadMapSettings(context);
                            setState(() {});
                          },
                          title:
                              SmashUI.normalText("Toggle GPS log info panel"),
                        )
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

  CheckboxListTile getBottombarCustomizationCheckbox(
      BuildContext context, String prefKey, String title) {
    bool doShow = GpPreferences().getBooleanSync(prefKey, true);
    return CheckboxListTile(
      value: doShow,
      onChanged: (selected) async {
        await GpPreferences().setBoolean(prefKey, selected!);

        PreferencesState prefState =
            Provider.of<PreferencesState>(context, listen: false);
        prefState.onChanged();

        SettingsWidget.reloadMapSettings(context);
        setState(() {});
      },
      title: SmashUI.normalText(title),
    );
  }
}
