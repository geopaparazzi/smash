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
        ListTile(
          leading: Icon(
            Icons.sell_outlined, // or MdiIcons.tagMultiple
            color: SmashColors.mainDecorations,
          ),
          title: Text("Manage keywords"),
          // subtitle: Text(
          //   SL.of(context).settings_manageKeywordsSub ??
          //       "Remove keywords from the default list",
          // ),
          onTap: () async {
            await _showManageAllTagsDialog(context);
            setState(
                () {}); // optional; only needed if you display tags in this settings dialog
          },
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

  Future<void> _showManageAllTagsDialog(BuildContext context) async {
    const String prefsKeyAllTags = "smash_pref_keywords";

    List<String> allTags =
        (await GpPreferences().getStringList(prefsKeyAllTags, [])) ??
            <String>[];

    allTags = allTags
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    await showDialog<void>(
      context: context,
      useRootNavigator: false, // ✅ important when already inside a dialog
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            void removeTag(String tag) {
              allTags.remove(tag);
              allTags.sort();
              GpPreferences().setStringListSync(prefsKeyAllTags, allTags);
              setStateDialog(() {});
            }

            return AlertDialog(
              title: Text("Manage keywords"),
              content: SizedBox(
                width: MediaQuery.of(ctx).size.width * 0.9,
                child: allTags.isEmpty
                    ? Text("No keywords saved.")
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: allTags.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final t = allTags[i];
                          return ListTile(
                            dense: true,
                            title: Text(t),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => removeTag(t),
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx)
                      .pop(), // ✅ closes only this dialog
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
