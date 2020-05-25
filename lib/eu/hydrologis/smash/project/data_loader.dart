/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:background_locator/location_dto.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/maputils.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smashlibs/smashlibs.dart';

class DataLoaderUtilities {
  static Future<Note> addNote(
      SmashMapBuilder mapBuilder, bool doInGps, MapController mapController,
      {String form, String iconName, String color, String text}) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    SmashPosition pos;
    double lon;
    double lat;
    if (doInGps) {
      pos = Provider.of<GpsState>(mapBuilder.context, listen: false)
          .lastGpsPosition;
    } else {
      var center = mapController.center;
      lon = center.longitude;
      lat = center.latitude;
    }
    Note note = Note()
      ..text = text ??= "note"
      ..description = "POI"
      ..timeStamp = ts
      ..lon = pos != null ? pos.longitude : lon
      ..lat = pos != null ? pos.latitude : lat
      ..altim = pos != null ? pos.altitude : -1;
    if (form != null) {
      note.form = form;
    }

    NoteExt next = NoteExt();
    if (pos != null) {
      next.speedaccuracy = pos.speedAccuracy;
      next.speed = pos.speed;
      next.heading = pos.heading;
      next.accuracy = pos.accuracy;
    }
    if (iconName != null) {
      next.marker = iconName;
    }
    if (color != null) {
      next.color = color;
    }
    note.noteExt = next;

    var projectState = Provider.of<ProjectState>(mapBuilder.context);
    var db = projectState.projectDb;
    await db.addNote(note);

    return note;
  }

  /// Add an image into teh db.
  ///
  /// If [noteId] is specified, the image is added to a specific note.
  static Future<void> addImage(
    BuildContext parentContext,
    dynamic position, {
    int noteId,
  }) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    if (position is LocationDto) {
      dbImage.lon = position.longitude;
      dbImage.lat = position.latitude;
      dbImage.altim = position.altitude;
      dbImage.azim = position.heading;
    } else {
      dbImage.lon = position.longitude;
      dbImage.lat = position.latitude;
      dbImage.altim = -1;
      dbImage.azim = -1;
    }
    if (noteId != null) {
      dbImage.noteId = noteId;
    }

    await Navigator.push(
        parentContext,
        MaterialPageRoute(
            builder: (context) => TakePictureWidget("Saving image to db...",
                    (String imagePath) async {
                  if (imagePath != null) {
                    String imageName =
                        FileUtilities.nameFromFile(imagePath, true);
                    dbImage.text =
                        "IMG_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.jpg";
                    var imageId = await ImageWidgetUtilities.saveImageToSmashDb(
                        context, imagePath, dbImage);
                    File file = File(imagePath);
                    if (file.existsSync()) {
                      await file.delete();
                    }
                    if (imageId != null) {
                      ProjectState projectState =
                          Provider.of<ProjectState>(context, listen: false);
                      if (projectState != null)
                        await projectState.reloadProject(context);
//                } else {
//                  showWarningDialog(
//                      context, "Could not save image in database.");
                    }
                  }
                  return true;
                })));
  }

  static void loadNotesMarkers(GeopaparazziProjectDb db, List<Marker> tmp,
      SmashMapBuilder mapBuilder) async {
    List<Note> notesList = await db.getNotes();
    notesList.forEach((note) {
      NoteExt noteExt = note.noteExt;

      var iconData = getSmashIcon(noteExt.marker);
      var iconColor = ColorExt(noteExt.color);

      double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
      if (note.text == null || note.text.length == 0) {
        textExtraHeight = 0;
      }

      tmp.add(Marker(
        width: noteExt.size * MARKER_ICON_TEXT_EXTRA_WIDTH_FACTOR,
        height: noteExt.size + textExtraHeight,
        point: LatLng(note.lat, note.lon),
        builder: (ctx) {
          return GestureDetector(
            child: MarkerIcon(
              iconData,
              iconColor,
              noteExt.size,
              note.text,
              SmashColors.mainTextColorNeutral,
              iconColor.withAlpha(80),
            ),
            onTap: () {
              mapBuilder.scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: SmashColors.snackBarColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.4),
                              1: FlexColumnWidth(0.6),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Note"),
                                  TableUtilities.cellForString(note.text),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Longitude"),
                                  TableUtilities.cellForString(note.lon
                                      .toStringAsFixed(KEY_LATLONG_DECIMALS)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Latitude"),
                                  TableUtilities.cellForString(note.lat
                                      .toStringAsFixed(KEY_LATLONG_DECIMALS)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Altitude"),
                                  TableUtilities.cellForString(note.altim
                                      .toStringAsFixed(KEY_ELEV_DECIMALS)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Timestamp"),
                                  TableUtilities.cellForString(
                                      TimeUtilities.ISO8601_TS_FORMATTER.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              note.timeStamp))),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Has Form"),
                                  TableUtilities.cellForString(
                                      "${note.hasForm()}"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: SmashColors.mainSelection,
                            ),
                            iconSize: SmashUI.MEDIUM_ICON_SIZE,
                            onPressed: () {
                              var label =
                                  "note: ${note.text}\nlat: ${note.lat}\nlon: ${note.lon}\naltim: ${note.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp))}";
                              ShareHandler.shareText(label);
                              mapBuilder.scaffoldKey.currentState
                                  .hideCurrentSnackBar();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: SmashColors.mainSelection,
                            ),
                            iconSize: SmashUI.MEDIUM_ICON_SIZE,
                            onPressed: () {
                              if (note.hasForm()) {
                                var sectionMap = jsonDecode(note.form);
                                var sectionName = sectionMap[ATTR_SECTIONNAME];
                                SmashPosition sp = SmashPosition.fromCoords(
                                    note.lon,
                                    note.lat,
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toDouble());

                                Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                        builder: (context) => MasterDetailPage(
                                              sectionMap,
                                              SmashUI.titleText(sectionName,
                                                  color: SmashColors
                                                      .mainBackground,
                                                  bold: true),
                                              sectionName,
                                              sp,
                                              note.id,
                                              onWillPopFunction,
                                              getThumbnailsFromDb,
                                              takePictureForForms,
                                            )));
                              } else {
                                Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotePropertiesWidget(note)));
                              }
                              mapBuilder.scaffoldKey.currentState
                                  .hideCurrentSnackBar();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: SmashColors.mainSelection,
                            ),
                            iconSize: SmashUI.MEDIUM_ICON_SIZE,
                            onPressed: () async {
                              var doRemove = await showConfirmDialog(
                                  ctx,
                                  "Remove Note",
                                  "Are you sure you want to remove note ${note.id}?");
                              if (doRemove) {
                                await db.deleteNote(note.id);
                                var projectState = Provider.of<ProjectState>(
                                    mapBuilder.context);
                                await projectState
                                    .reloadProject(ctx); // TODO check await
                              }
                              mapBuilder.scaffoldKey.currentState
                                  .hideCurrentSnackBar();
                            },
                          ),
                          Spacer(flex: 1),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: SmashColors.mainDecorationsDarker,
                            ),
                            iconSize: SmashUI.MEDIUM_ICON_SIZE,
                            onPressed: () {
                              mapBuilder.scaffoldKey.currentState
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                duration: Duration(seconds: 5),
              ));
            },
          );
        },
      ));
    });
  }

  static void loadImageMarkers(GeopaparazziProjectDb db, List<Marker> tmp,
      SmashMapBuilder mapBuilder) async {
    // IMAGES
    var imagesList = await db.getImages();
    imagesList.forEach((image) async {
      var size = 48.0;
      var lat = image.lat;
      var lon = image.lon;
      tmp.add(Marker(
        width: size,
        height: size,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () async {
            var thumb = await db.getThumbnail(image.imageDataId);
            mapBuilder.scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: SmashColors.snackBarColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.4),
                        1: FlexColumnWidth(0.6),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Image"),
                            TableUtilities.cellForString(image.text),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Longitude"),
                            TableUtilities.cellForString(image.lon
                                .toStringAsFixed(KEY_LATLONG_DECIMALS)),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Latitude"),
                            TableUtilities.cellForString(image.lat
                                .toStringAsFixed(KEY_LATLONG_DECIMALS)),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Altitude"),
                            TableUtilities.cellForString(
                                image.altim.toStringAsFixed(KEY_ELEV_DECIMALS)),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Timestamp"),
                            TableUtilities.cellForString(TimeUtilities
                                .ISO8601_TS_FORMATTER
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    image.timeStamp))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: SmashColors.mainDecorations)),
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          thumb,
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            ctx,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SmashImageZoomWidget(image)));
                        mapBuilder.scaffoldKey.currentState
                            .hideCurrentSnackBar();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () async {
                            var label =
                                "image: ${image.text}\nlat: ${image.lat.toStringAsFixed(KEY_LATLONG_DECIMALS)}\nlon: ${image.lon.toStringAsFixed(KEY_LATLONG_DECIMALS)}\naltim: ${image.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}";
                            var uint8list =
                                await db.getImageDataBytes(image.imageDataId);
                            ShareHandler.shareImage(label, uint8list);
                            mapBuilder.scaffoldKey.currentState
                                .hideCurrentSnackBar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () async {
                            var doRemove = await showConfirmDialog(
                                ctx,
                                "Remove Image",
                                "Are you sure you want to remove image ${image.id}?");
                            if (doRemove) {
                              await db.deleteImage(image.id);
                              var projectState =
                                  Provider.of<ProjectState>(mapBuilder.context);
                              await projectState
                                  .reloadProject(ctx); // TODO check await
                            }
                            mapBuilder.scaffoldKey.currentState
                                .hideCurrentSnackBar();
                          },
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: SmashColors.mainDecorationsDarker,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () {
                            mapBuilder.scaffoldKey.currentState
                                .hideCurrentSnackBar();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              duration: Duration(seconds: 5),
            ));
          },
          child: Icon(
            getSmashIcon('camera'),
            size: size,
            color: SmashColors.mainDecorationsDarker,
          ),
        )),
      ));
    });
  }

  static Future<PolylineLayerOptions> loadLogLinesLayer(var db) async {
    String logsQuery = '''
        select l.$LOGS_COLUMN_ID, p.$LOGSPROP_COLUMN_COLOR, p.$LOGSPROP_COLUMN_WIDTH 
        from $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        where l.$LOGS_COLUMN_ID = p.$LOGSPROP_COLUMN_ID and p.$LOGSPROP_COLUMN_VISIBLE=1
    ''';

    List<Map<String, dynamic>> resLogs = await db.query(logsQuery);
    Map<int, List> logs = Map();
    resLogs.forEach((map) {
      var id = map['_id'];
      var color = map["color"];
      var width = map["width"];

      logs[id] = [color, width, <LatLng>[]];
    });

    String logDataQuery =
        "select $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LOGID from $TABLE_GPSLOG_DATA order by $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_TS";
    List<Map<String, dynamic>> resLogData = await db.query(logDataQuery);
    resLogData.forEach((map) {
      var logid = map[LOGSDATA_COLUMN_LOGID];
      var log = logs[logid];
      if (log != null) {
        var lat = map[LOGSDATA_COLUMN_LAT];
        var lon = map[LOGSDATA_COLUMN_LON];
        var coordsList = log[2];
        coordsList.add(LatLng(lat, lon));
      }
    });

    List<Polyline> lines = [];
    logs.forEach((key, list) {
      var color = list[0];
      var width = list[1];
      var points = list[2];
      lines.add(
          Polyline(points: points, strokeWidth: width, color: ColorExt(color)));
    });

    return PolylineLayerOptions(
      polylineCulling: true,
      polylines: lines,
    );
  }
}
