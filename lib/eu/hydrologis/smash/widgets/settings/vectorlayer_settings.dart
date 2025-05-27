import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

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
    int handleIconSize = GpPreferences()
            .getIntSync(SLSettings.SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE, 25) ??
        25;
    int intermediateHandleIconSize = GpPreferences().getIntSync(
            SLSettings.SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE, 20) ??
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
                          items: SLSettings.SETTINGS_EDIT_HANLDE_ICON_SIZES
                              .map((i) {
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
                                SLSettings.SETTINGS_KEY_EDIT_HANLDE_ICON_SIZE,
                                selected!);
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
                          items: SLSettings.SETTINGS_EDIT_HANLDE_ICON_SIZES
                              .map((i) {
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
                                SLSettings
                                    .SETTINGS_KEY_EDIT_HANLDEINTERMEDIATE_ICON_SIZE,
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
