import 'package:flutter/material.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

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
        // PluginCheckboxWidget(PluginsHandler.GRID.key),
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
