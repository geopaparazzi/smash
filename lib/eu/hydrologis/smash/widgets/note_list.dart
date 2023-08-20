/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

/// The notes list widget.
class NotesListWidget extends StatefulWidget {
  final bool _doSimpleNotes;
  final GeopaparazziProjectDb db;

  NotesListWidget(this._doSimpleNotes, this.db);

  @override
  State<StatefulWidget> createState() {
    return NotesListWidgetState();
  }
}

/// The notes list widget state.
class NotesListWidgetState extends State<NotesListWidget>
    with AfterLayoutMixin {
  List<dynamic> _notesList = [];
  bool _isLoading = true;

  @override
  void afterFirstLayout(BuildContext context) {
    loadNotes();
  }

  loadNotes() {
    _notesList.clear();
    dynamic itemsList = widget.db.getNotes(doSimple: widget._doSimpleNotes);
    if (itemsList != null) {
      _notesList.addAll(itemsList);
    }
    if (widget._doSimpleNotes) {
      itemsList = widget.db.getImages();
      if (itemsList != null) {
        _notesList.addAll(itemsList);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ProjectState>(context, listen: false)
            .reloadProject(context);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget._doSimpleNotes
                ? SL.of(context).noteList_simpleNotesList //"Simple Notes List"
                : SL.of(context).noteList_formNotesList), //"Form Notes List"
            actions: [
              IconButton(
                  onPressed: () => openNotesViewSettings(),
                  icon: Icon(
                    MdiIcons.cog,
                    color: SmashColors.mainBackground,
                  ))
            ],
          ),
          body: _isLoading
              ? Center(
                  child: SmashCircularProgress(
                      label: SL
                          .of(context)
                          .noteList_loadingNotes)) //"Loading Notes..."
              : ListView.builder(
                  itemCount: _notesList.length,
                  itemBuilder: (context, index) {
                    return NoteInfo(
                        _notesList[index], db!, projectState, loadNotes);
                  })),
    );
  }

  Future openNotesViewSettings() async {
    Dialog settingsDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: NotesViewSetting(),
      ),
    );
    await showDialog(
        context: context, builder: (BuildContext context) => settingsDialog);
  }
}

class NoteInfo extends StatefulWidget {
  dynamic note;
  final GeopaparazziProjectDb db;
  final ProjectState projectState;
  final reloadNotesFunction;
  NoteInfo(this.note, this.db, this.projectState, this.reloadNotesFunction);

  @override
  _NoteInfoState createState() => _NoteInfoState();
}

class _NoteInfoState extends State<NoteInfo> {
  @override
  Widget build(BuildContext context) {
    List<Widget> startActions = [];
    List<Widget> endActions = [];
    // dynamic dynNote = _notesList[index];
    dynamic dynNote = widget.note;
    int id;
    var markerName;
    var markerColor;
    String text;
    bool isForm = false;
    int ts;
    double lat;
    double lon;
    if (dynNote is Note) {
      id = dynNote.id!;
      markerName = dynNote.noteExt!.marker;
      markerColor = dynNote.noteExt!.color;
      text = dynNote.text;
      ts = dynNote.timeStamp;
      lon = dynNote.lon;
      lat = dynNote.lat;
      if (dynNote.hasForm()) {
        isForm = true;
        // text should get the label, if there is one
        text = FormUtilities.getFormItemLabel(dynNote.form!, text);
      }
    } else {
      id = dynNote.id;
      markerName = 'camera';
      markerColor = ColorExt.asHex(SmashColors.mainDecorationsDarker);
      text = dynNote.text;
      ts = dynNote.timeStamp;
      lon = dynNote.lon;
      lat = dynNote.lat;
    }
    startActions.add(SlidableAction(
        label: SL.of(context).noteList_zoomTo, //'Zoom to'
        foregroundColor: SmashColors.mainDecorations,
        icon: MdiIcons.magnifyScan,
        onPressed: (context) async {
          LatLng position = LatLng(lat, lon);
          Provider.of<SmashMapState>(context, listen: false).center =
              Coordinate(position.longitude, position.latitude);
          Navigator.of(context).pop();
        }));
    if (isForm) {
      startActions.add(SlidableAction(
        label: SL.of(context).noteList_edit, //'Edit'
        foregroundColor: SmashColors.mainDecorations,
        icon: MdiIcons.pencil,
        onPressed: (context) async {
          var sectionMap = jsonDecode(dynNote.form);
          var sectionName = sectionMap[ATTR_SECTIONNAME];
          SmashPosition sp = SmashPosition.fromCoords(dynNote.lon, dynNote.lat,
              DateTime.now().millisecondsSinceEpoch.toDouble());

          var titleWidget = SmashUI.titleText(sectionName,
              color: SmashColors.mainBackground, bold: true);
          var formHelper = SmashFormHelper(
              dynNote.id, sectionName, sectionMap, titleWidget, sp);

          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MasterDetailPage(formHelper);
          }));
          setState(() {
            widget.note = widget.db.getNoteById(dynNote.id);
          });
        },
      ));
    } else if (dynNote is Note) {
      startActions.add(SlidableAction(
        label: SL.of(context).noteList_properties, //'Properties'
        foregroundColor: SmashColors.mainDecorations,
        icon: MdiIcons.palette,
        onPressed: (context) async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotePropertiesWidget(dynNote)));
          setState(() {});
        },
      ));
    }
    endActions.add(SlidableAction(
        label: SL.of(context).noteList_delete, //'Delete'
        foregroundColor: SmashColors.mainDanger,
        icon: MdiIcons.delete,
        onPressed: (context) async {
          bool doDelete = await SmashDialogs.showConfirmDialog(
                  context,
                  SL.of(context).noteList_DELETE, //"DELETE"
                  SL
                      .of(context)
                      .noteList_areYouSureDeleteNote) //'Are you sure you want to delete the note?'
              ??
              false;
          if (doDelete) {
            if (dynNote is Note) {
              widget.db.deleteNote(id);
            } else {
              widget.db.deleteImage(id);
            }
            widget.reloadNotesFunction();
          }
        }));

    return Slidable(
      key: ValueKey(id),
      startActionPane: ActionPane(
        extentRatio: 0.35,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: startActions,
      ),
      endActionPane: ActionPane(
        extentRatio: 0.35,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: endActions,
      ),
      child: ListTile(
        title: SmashUI.normalText('$text', bold: true),
        subtitle: Text(
            '${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(ts))}'),
        leading: Icon(
          getSmashIcon(markerName),
          color: ColorExt(markerColor),
          size: SmashUI.MEDIUM_ICON_SIZE,
        ),
      ),
    );
  }
}
