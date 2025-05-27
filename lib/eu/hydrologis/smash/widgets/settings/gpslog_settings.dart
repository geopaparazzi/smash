import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GpsLogsSetting extends StatefulWidget {
  GpsLogsSetting({Key? key}) : super(key: key);

  @override
  _GpsLogsSettingState createState() => _GpsLogsSettingState();
}

class _GpsLogsSettingState extends State<GpsLogsSetting> {
  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultPadding() * 2,
          child: SmashUI.normalText(SL.of(context).settings_gpsLogsViewMode,
              bold: true), //"GPS Logs view mode"
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eye,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_logViewModeForOrigData), //"Log view mode for original data."
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: gpsState.logMode,
                isExpanded: false,
                items: SmashPreferencesKeys.LOGVIEWMODES.map((i) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      i,
                      textAlign: TextAlign.center,
                    ),
                    value: i,
                  );
                }).toList(),
                onChanged: (selected) async {
                  await GpPreferences().setStringList(
                      SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE,
                      [selected!, gpsState.filteredLogMode]);
                  gpsState.logMode = selected;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eyeSettings,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_logViewModeFilteredData), //"Log view mode for filtered data."
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: gpsState.filteredLogMode,
                isExpanded: false,
                items: SmashPreferencesKeys.LOGVIEWMODES.map((i) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      i,
                      textAlign: TextAlign.center,
                    ),
                    value: i,
                  );
                }).toList(),
                onChanged: (selected) async {
                  await GpPreferences().setStringList(
                      SmashPreferencesKeys.KEY_GPS_LOG_VIEW_MODE,
                      [gpsState.logMode, selected!]);
                  gpsState.filteredLogMode = selected;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        SmashUI.defaultButtonBar(
          cancelLabel: SL.of(context).settings_cancel, //"CANCEL"
          cancelFunction: () => Navigator.pop(context),
          okLabel: SL.of(context).settings_ok, //"OK"
          okFunction: () {
            Navigator.pop(context);
            var projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.reloadProject(context);
          },
        ),
      ],
    );
  }
}
