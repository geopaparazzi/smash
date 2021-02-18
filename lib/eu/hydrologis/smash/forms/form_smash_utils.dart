import 'dart:convert';
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smashlibs/smashlibs.dart';
import '../../../../generated/l10n.dart';

/// Form utilities for smash (not web)

const IMAGE_ID_SEPARATOR = ";";

class SmashFormHelper implements AFormhelper {
  /// Take a picture for forms
  Future<String> takePictureForForms(BuildContext context, var noteId,
      var position, bool fromGallery, List<String> imageSplit) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    dbImage.lon = position.longitude;
    dbImage.lat = position.latitude;
    try {
      dbImage.altim = position.altitude;
      dbImage.azim = position.heading;
    } catch (e) {
      dbImage.altim = -1;
      dbImage.azim = -1;
    }
    if (noteId != null) {
      dbImage.noteId = noteId;
    }

    int imageId;
    var imagePath = fromGallery
        ? await Camera.loadImageFromGallery()
        : await Camera.takePicture();
    if (imagePath != null) {
      var imageName = FileUtilities.nameFromFile(imagePath, true);
      dbImage.text =
          "IMG_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.jpg";
      imageId =
          ImageWidgetUtilities.saveImageToSmashDb(context, imagePath, dbImage);
      if (imageId != null) {
        imageSplit.add(imageId.toString());
        var value = imageSplit.join(IMAGE_ID_SEPARATOR);

        File file = File(imagePath);
        if (file.existsSync()) {
          await file.delete();
        }
        return value;
      } else {
        SmashDialogs.showWarningDialog(context,
            SL.of(context).form_smash_utils_couldNotSaveImageInDatabase);
        return null;
      }
    }
    return null;
  }

  /// Get thumbnails from the database
  Future<List<Widget>> getThumbnailsFromDb(
      BuildContext context, var itemMap, List<String> imageSplit) async {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);

    String value = ""; //$NON-NLS-1$
    if (itemMap.containsKey(TAG_VALUE)) {
      value = itemMap[TAG_VALUE].trim();
    }
    if (value.isNotEmpty) {
      var split = value.split(IMAGE_ID_SEPARATOR);
      split.forEach((v) {
        if (!imageSplit.contains(v)) {
          imageSplit.add(v);
        }
      });
    }

    List<Widget> thumbList = [];
    for (int i = 0; i < imageSplit.length; i++) {
      var id = int.parse(imageSplit[i]);
      Widget thumbnail = projectState.projectDb.getThumbnail(id);
      Widget withBorder = Container(
        padding: SmashUI.defaultPadding(),
        child: thumbnail,
      );
      thumbList.add(withBorder);
    }
    return thumbList;
  }

  /// Save data on form exit.
  Future<void> onSaveFunction(BuildContext context, var _noteId,
      var sectionName, var sectionMap, var _position) async {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    String jsonForm = jsonEncode(sectionMap);
    int noteId;
    int ts = DateTime.now().millisecondsSinceEpoch;
    if (_noteId == null) {
      // create new note in position based on form

      var iconName = TagsManager.getIcon4Section(sectionMap);
      String iconColor = ColorExt.asHex(SmashColors.mainDecorationsDarker);

      SmashPosition pos;
      double lon;
      double lat;
      if (_position is SmashPosition) {
        pos = _position;
      } else {
        LatLng ll = _position;
        lon = ll.longitude;
        lat = ll.latitude;
      }
      Note note = Note()
        ..text = sectionName
        ..description = SL.of(context).form_smash_utils_POI
        ..form = jsonForm
        ..timeStamp = ts
        ..lon = pos != null ? pos.longitude : lon
        ..lat = pos != null ? pos.latitude : lat
        ..altim = pos != null ? pos.altitude : -1;

      NoteExt next = NoteExt();
      note.noteExt = next;
      if (pos != null) {
        next.speedaccuracy = pos.speedAccuracy;
        next.speed = pos.speed;
        next.heading = pos.heading;
        next.accuracy = pos.accuracy;
      }
      next.marker = iconName;
      next.color = iconColor;

      noteId = db.addNote(note);
    } else {
      noteId = _noteId;
      // update form for note
      var note = db.getNoteById(_noteId);
      note.form = jsonForm;
      note.timeStamp = ts;
      db.updateNote(note);
    }

    projectState.reloadProject(context);
  }
}
