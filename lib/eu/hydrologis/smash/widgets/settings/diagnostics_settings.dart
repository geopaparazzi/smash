import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class DiagnosticsSetting extends StatefulWidget {
  @override
  DiagnosticsSettingState createState() {
    return DiagnosticsSettingState();
  }
}

class DiagnosticsSettingState extends State<DiagnosticsSetting> {
  //static final title = "Diagnostics";
  //static final subtitle = "Diagnostics & Debug Log";
  static final iconData = Icons.bug_report;

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
                color: SmashColors.mainBackground,
              ),
            ),
            Text(SL.of(context).settings_diagnostics),
          ],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: ListTile(
              leading: Icon(MdiIcons.tableEye),
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                    style: SmashUI.defaultFlatButtonStyle(
                        color: SmashColors.mainDecorations),
                    child: Text(SL
                        .of(context)
                        .settings_openFullDebugLog), //"Open full debug log"
                    onPressed: () {
                      ProjectState projectState =
                          Provider.of<ProjectState>(context, listen: false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DebugLogViewer(projectState)));
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DebugLogViewer extends StatefulWidget {
  final ProjectState projectState;

  DebugLogViewer(this.projectState, {Key? key}) : super(key: key);

  @override
  _DebugLogViewerState createState() => _DebugLogViewerState();
}

class _DebugLogViewerState extends State<DebugLogViewer> {
  int limit = 1000;
  late List<dynamic> logItems;
  late List<dynamic> allLogItems;
  bool isViewingErrors = false;

  var levelToColor = {
    "Level.verbose": Colors.grey[100],
    "Level.debug": Colors.green[100],
    "Level.info": Colors.blue[100],
    "Level.warning": Colors.orange[100],
    "Level.error": Colors.red[100],
    "Level.wtf": Colors.deepPurple[100],
    "Level.nothing": Colors.grey[100],
  };
  var levelToIcon = {
    "Level.verbose": MdiIcons.accountVoice,
    "Level.debug": MdiIcons.ladybug,
    "Level.info": MdiIcons.information,
    "Level.warning": MdiIcons.alertOutline,
    "Level.error": MdiIcons.flashAlert,
    "Level.wtf": MdiIcons.bomb,
    "Level.nothing": MdiIcons.helpCircleOutline,
  };

  @override
  void initState() {
    super.initState();
    loadDebug();
  }

  void loadDebug() {
    allLogItems = SMLogger().getLogItems(limit: limit);
    allLogItems = allLogItems.where((element) {
      element.message = element.message.trim();

      if (element.message.contains(RegExp("38;5;.*m"))) {
        element.message = element.message.substring(12).trim();
      }

      if (element.message.contains("────────") ||
          element.message.contains("┄┄┄┄┄┄") ||
          element.message.startsWith("│ #") ||
          element.message.startsWith("#") ||
          element.message.startsWith(RegExp(".*48;5;196mERROR.\\[0m"))) {
        return false;
      } else if (element.message.startsWith("│ ")) {
        element.message = element.message.substring(4).trim();
      }

      if (element.message.endsWith("[0m")) {
        element.message =
            element.message.substring(0, element.message.length - 4);
      }
      return true;
    }).toList();
    setState(() {
      logItems = allLogItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).settings_debugLogView), //"Debug Log View"
        actions: [
          IconButton(
              icon: Icon(
                  isViewingErrors ? MdiIcons.ladybug : MdiIcons.flashAlert),
              tooltip: isViewingErrors
                  ? SL
                      .of(context)
                      .settings_viewAllMessages //"View all messages"
                  : SL
                      .of(context)
                      .settings_viewOnlyErrorsWarnings, //"View only errors and warnings"
              onPressed: () {
                if (isViewingErrors) {
                  logItems = allLogItems;
                } else {
                  logItems = allLogItems.where((element) {
                    return element.level == "Level.warning" ||
                        element.level == "Level.error";
                  }).toList();
                }
                setState(() {
                  isViewingErrors = !isViewingErrors;
                });
              }),
          IconButton(
              icon: Icon(MdiIcons.delete),
              tooltip:
                  SL.of(context).settings_clearDebugLog, //"Clear debug log"
              onPressed: () {
                SMLogger().clearLog();
                loadDebug();
              }),
        ],
      ),
      body: logItems == null
          ? SmashCircularProgress(
              label: SL.of(context).settings_loadingData, //"Loading data..."
            )
          : ListView.builder(
              itemCount: logItems.length,
              itemBuilder: (BuildContext context, int index) {
                GpLogItem logItem = logItems[index] as GpLogItem;
                Color c = levelToColor[logItem.level]!;
                String msg = logItem.message!;
                String ts = HU.TimeUtilities.ISO8601_TS_FORMATTER_MILLIS
                    .format(DateTime.fromMillisecondsSinceEpoch(logItem.ts));
                var iconData = levelToIcon[logItem.level];

                return Container(
                  color: c,
                  child: ListTile(
                    leading: Icon(iconData),
                    title: Text(ts),
                    subtitle: Text(msg),
                  ),
                );
              },
            ),
    );
  }
}
