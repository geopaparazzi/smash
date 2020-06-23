import 'package:flutter/material.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:provider/provider.dart';

const KEY_PLUGIN_SCALE = "KEY_PLUGIN_SCALE";
const KEY_PLUGIN_GRID = "KEY_PLUGIN_GRID";
const KEY_PLUGIN_CROSS = "KEY_PLUGIN_CROSS";
const KEY_PLUGIN_GPS = "KEY_PLUGIN_GPS";
const KEY_PLUGIN_LOGSHEATMAP = "KEY_PLUGIN_LOGSHEATMAP";

var PLUGINMAP = {};

class PluginsHandler {
  final String key;
  final String label;
  static const HEATMAP_WORKING = false;

  const PluginsHandler._(this.key, this.label);

  static const SCALE = const PluginsHandler._(KEY_PLUGIN_SCALE, "Scalebar");
  static const GRID = const PluginsHandler._(KEY_PLUGIN_GRID, "Grid");
  static const CROSS = const PluginsHandler._(KEY_PLUGIN_CROSS, "Center Cross");
  static const GPS = const PluginsHandler._(KEY_PLUGIN_GPS, "GPS Position");
  static const LOG_HEATMAP = const PluginsHandler._(KEY_PLUGIN_LOGSHEATMAP, "Logs Heatmap");

  static List<PluginsHandler> values() {
    return [
      SCALE,
      GRID,
      CROSS,
      GPS,
     // LOG_HEATMAP, TODO add when ready
    ];
  }

  static PluginsHandler forKey(String key) {
    for (var item in values()) {
      if (item.key == key) {
        return item;
      }
    }
    throw StateError("No plugin for key $key");
  }

  bool isOn() {
    return PLUGINMAP[key] ??= GpPreferences().getBooleanSync(key, true);
  }

  Future toggle(bool setOn) async {
    PLUGINMAP[key] = setOn;
    await GpPreferences().setBoolean(key, setOn);
  }
}

class PluginCheckboxWidget extends StatefulWidget {
  final String prefKey;
  PluginCheckboxWidget(this.prefKey);

  @override
  _PluginCheckboxWidgetState createState() => _PluginCheckboxWidgetState();
}

class _PluginCheckboxWidgetState extends State<PluginCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    var plugin = PluginsHandler.forKey(widget.prefKey);

    return ListTile(
      leading: Checkbox(
        value: plugin.isOn(),
        onChanged: (selected) async {
          await plugin.toggle(selected);
          setState(() {});
          var projectState = Provider.of<ProjectState>(context, listen: false);
          projectState.reloadProject(context);
        },
      ),
      title: SmashUI.normalText(
        plugin.label,
        bold: true,
        color: SmashColors.mainDecorations,
      ),
    );
  }
}
