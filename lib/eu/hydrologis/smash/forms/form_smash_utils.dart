import 'dart:convert';
import 'dart:io';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_postgis/dart_postgis.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_sketch.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

/// Form utilities for smash (not web)

const IMAGE_ID_SEPARATOR = ";";

const HM_FORMS_TABLE = "hm_forms";
const FORMS_TABLENAME_FIELD = "tablename";
const FORMS_FIELD = "forms";

class SmashFormHelper extends AFormhelper {
  String _sectionName;
  Map<String, dynamic> _sectionMap;
  Widget _titleWidget;
  int? _id;
  dynamic _position;

  SmashFormHelper(this._id, this._sectionName, this._sectionMap,
      this._titleWidget, this._position);

  @override
  Future<bool> init() async {
    return true;
  }

  @override
  bool hasForm() {
    // notes always have forms
    return true;
  }

  @override
  Widget getFormTitleWidget() {
    return _titleWidget;
  }

  @override
  int getId() {
    return _id!;
  }

  @override
  getPosition() {
    return _position;
  }

  @override
  Map<String, dynamic> getSectionMap() {
    return _sectionMap;
  }

  @override
  String getSectionName() {
    return _sectionName;
  }

  /// Take a picture for forms
  Future<String?> takePictureForForms(
      BuildContext context, bool fromGallery, List<String> imageSplit) async {
    var gpsState = Provider.of<GpsState>(context, listen: false);
    dynamic lastGpsPosition = _position;
    if (gpsState != null && gpsState.lastGpsPosition != null) {
      lastGpsPosition = gpsState.lastGpsPosition;
    }
    var cameraResolution = GpPreferences().getStringSync(
        SmashPreferencesKeys.KEY_CAMERA_RESOLUTION, CameraResolutions.MEDIUM);
    int imageQuality = CameraResolutions.MEDIUM_VAL;
    switch (cameraResolution) {
      case CameraResolutions.HIGH:
        imageQuality = CameraResolutions.HIGH_VAL;
        break;
      case CameraResolutions.LOW:
        imageQuality = CameraResolutions.LOW_VAL;
        break;
      case CameraResolutions.MEDIUM:
      default:
    }

    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    dbImage.lon = lastGpsPosition.longitude;
    dbImage.lat = lastGpsPosition.latitude;
    try {
      dbImage.altim = lastGpsPosition.altitude;
      dbImage.azim = lastGpsPosition.heading;
    } catch (e) {
      dbImage.altim = -1;
      dbImage.azim = -1;
    }
    if (_id != null) {
      dbImage.noteId = _id;
    }

    int? imageId;
    var imagePath = fromGallery
        ? await Camera.loadImageFromGallery()
        : await Camera.takePicture(imageQuality: imageQuality);
    if (imagePath != null) {
      // var imageName = FileUtilities.nameFromFile(imagePath, true);
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
        SmashDialogs.showWarningDialog(
            context, SL.of(context).form_smash_cantSaveImageDb);
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> takeSketchForForms(
      BuildContext context, List<String> imageSplit) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    dbImage.lon = _position.longitude;
    dbImage.lat = _position.latitude;
    try {
      dbImage.altim = _position.altitude;
      dbImage.azim = _position.heading;
    } catch (e) {
      dbImage.altim = -1;
      dbImage.azim = -1;
    }
    if (_id != null) {
      dbImage.noteId = _id;
    }

    int? imageId;

    var imageBytes = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SketchPage(),
          fullscreenDialog: true,
        ));
    if (imageBytes != null) {
      dbImage.text =
          "SKETCH_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.png";
      imageId = ImageWidgetUtilities.saveImageBytesToSmashDb(
          imageBytes, context, dbImage, dbImage.text);
      if (imageId != null) {
        imageSplit.add(imageId.toString());
        var value = imageSplit.join(IMAGE_ID_SEPARATOR);
        return value;
      } else {
        SmashDialogs.showWarningDialog(
            context, SL.of(context).form_smash_cantSaveImageDb);
        return null;
      }
    }

    return null;
  }

  /// Get thumbnails from the database
  Future<List<Widget>> getThumbnailsFromDb(BuildContext context,
      Map<String, dynamic> itemsMap, List<String> imageSplit) async {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);

    String value = ""; //$NON-NLS-1$
    if (itemsMap.containsKey(TAG_VALUE)) {
      value = itemsMap[TAG_VALUE].trim();
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
      Widget? thumbnail = projectState.projectDb!.getThumbnail(id);
      Widget withBorder = Container(
        padding: SmashUI.defaultPadding(),
        child: thumbnail,
      );
      thumbList.add(withBorder);
    }
    return thumbList;
  }

  /// Save data on form exit.
  Future<void> onSaveFunction(BuildContext context) async {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    String jsonForm = jsonEncode(_sectionMap);
    int noteId;
    int ts = DateTime.now().millisecondsSinceEpoch;
    if (_id == null) {
      // create new note in position based on form

      var iconName = TagsManager.getIcon4Section(_sectionMap);
      String iconColor = ColorExt.asHex(SmashColors.mainDecorationsDarker);

      SmashPosition? pos;
      late double lon;
      late double lat;
      if (_position is SmashPosition) {
        pos = _position;
      } else {
        LatLng ll = _position;
        lon = ll.longitude;
        lat = ll.latitude;
      }
      Note note = Note()
        ..text = _sectionName
        ..description = "POI"
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

      noteId = db!.addNote(note)!;
    } else {
      noteId = _id!;
      // update form for note
      var note = db!.getNoteById(_id!);
      note.form = jsonForm;
      note.timeStamp = ts;
      db.updateNote(note);
    }

    projectState.reloadProject(context);
  }

  @override
  void setData(Map<String, dynamic> newValues) {
    // not needed here
  }

  @override
  Map<String, dynamic> getFormChangedData() {
    throw UnimplementedError();
  }
}
