/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';

import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/smash/forms/forms.dart';
import 'package:smash/eu/hydrologis/smash/forms/forms_widgets.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';

/// The notes list widget.
class NotesListWidget extends StatefulWidget {
  final bool _doSimpleNotes;

  NotesListWidget(this._doSimpleNotes);

  @override
  State<StatefulWidget> createState() {
    return NotesListWidgetState();
  }
}

/// The notes list widget state.
class NotesListWidgetState extends State<NotesListWidget> {
  List<dynamic> _notesList = [];

  Future<bool> loadNotes(var db) async {
    _notesList.clear();
    dynamic itemsList = await db.getNotes(doSimple: widget._doSimpleNotes);
    if (itemsList != null) {
      _notesList.addAll(itemsList);
    }
    if (widget._doSimpleNotes) {
      itemsList = await db.getImages();
      if (itemsList != null) {
        _notesList.addAll(itemsList);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget._doSimpleNotes ? "Simple Notes List" : "Form Notes List"),
        ),
        body: FutureBuilder<void>(
          future: loadNotes(db),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return ListView.builder(
                  itemCount: _notesList.length,
                  itemBuilder: (context, index) {
                    return buildNoteItem(index, db, projectState, context);
                  });
            } else {
              // Otherwise, display a loading indicator.
              return Center(
                  child: SmashCircularProgress(label: "Loading notes..."));
            }
          },
        ));
  }

  Slidable buildNoteItem(int index, GeopaparazziProjectDb db,
      ProjectState projectState, BuildContext context) {
    List<Widget> actions = [];
    List<Widget> secondaryActions = [];
    dynamic dynNote = _notesList[index];
    int id;
    var markerName;
    var markerColor;
    String text;
    bool isForm = false;
    int ts;
    double lat;
    double lon;
    if (dynNote is Note) {
      id = dynNote.id;
      markerName = dynNote.noteExt.marker;
      markerColor = dynNote.noteExt.color;
      text = dynNote.text;
      ts = dynNote.timeStamp;
      lon = dynNote.lon;
      lat = dynNote.lat;
      if (dynNote.form != null) {
        isForm = true;
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
    actions.add(IconSlideAction(
        caption: 'Zoom to',
        color: SmashColors.mainDecorations,
        icon: MdiIcons.magnifyScan,
        onTap: () async {
          LatLng position = LatLng(lat, lon);
          Provider.of<SmashMapState>(context, listen: false).center =
              Coordinate(position.longitude, position.latitude);
          Navigator.of(context).pop();
        }));
    if (isForm) {
      actions.add(IconSlideAction(
        caption: 'Edit',
        color: SmashColors.mainDecorations,
        icon: MdiIcons.pencil,
        onTap: () {
          var sectionMap = jsonDecode(dynNote.form);
          var sectionName = sectionMap[ATTR_SECTIONNAME];
          SmashPosition sp = SmashPosition.fromCoords(dynNote.lon, dynNote.lat,
              DateTime.now().millisecondsSinceEpoch.toDouble());

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MasterDetailPage(
                        sectionMap,
                        SmashUI.titleText(sectionName,
                            color: SmashColors.mainBackground, bold: true),
                        sectionName,
                        sp,
                        dynNote.id,
                      )));
        },
      ));
    } else {
      actions.add(IconSlideAction(
        caption: 'Properties',
        color: SmashColors.mainDecorations,
        icon: MdiIcons.palette,
        onTap: () => _navigateToNoteProperties(context, dynNote),
      ));
    }
    secondaryActions.add(IconSlideAction(
        caption: 'Delete',
        color: SmashColors.mainDanger,
        icon: MdiIcons.delete,
        onTap: () async {
          await db.deleteNote(id);
          await projectState.reloadProject(context);
          setState(() {});
        }));

    return Slidable(
      key: ValueKey(id),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text('$text'),
        subtitle: Text(
            '${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(ts))}'),
        leading: Icon(
          getIcon(markerName) ?? MdiIcons.mapMarker,
          color: ColorExt(markerColor),
          size: SmashUI.MEDIUM_ICON_SIZE,
        ),
      ),
      actions: actions,
      secondaryActions: secondaryActions,
    );
  }

  Future<bool> _confirmNoteDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text('Are you sure you want to delete the note?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  _navigateToNoteProperties(BuildContext context, Note note) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePropertiesWidget(note)));
  }
}
