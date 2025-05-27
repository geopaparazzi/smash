import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotesViewSetting extends StatefulWidget {
  NotesViewSetting({Key? key}) : super(key: key);

  @override
  _NotesViewSettingState createState() => _NotesViewSettingState();
}

class _NotesViewSettingState extends State<NotesViewSetting> {
  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: SmashUI.defaultPadding() * 2,
          child: SmashUI.normalText(SL.of(context).settings_notesViewModes,
              bold: true), //"Notes view modes"
        ),
        ListTile(
          leading: Icon(
            MdiIcons.eye,
            color: SmashColors.mainDecorations,
          ),
          title: Text(SL
              .of(context)
              .settings_selectNotesViewMode), //"Select a notes view mode."
          subtitle: DropdownButton<String>(
            value: gpsState.notesMode,
            isExpanded: false,
            items: SmashPreferencesKeys.NOTESVIEWMODES.map((i) {
              return DropdownMenuItem<String>(
                child: Text(
                  i,
                  textAlign: TextAlign.center,
                ),
                value: i,
              );
            }).toList(),
            onChanged: (selected) async {
              await GpPreferences().setString(
                  SmashPreferencesKeys.KEY_NOTES_VIEW_MODE, selected!);
              gpsState.notesMode = selected;
              setState(() {});
            },
          ),
        ),
        SmashUI.defaultButtonBar(
          cancelLabel: SL.of(context).settings_cancel, //'CANCEL'
          cancelFunction: () => Navigator.pop(context),
          okLabel: SL.of(context).settings_ok, //'OK'
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
