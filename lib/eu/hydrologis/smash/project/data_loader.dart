/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:background_locator/location_dto.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:smash/eu/hydrologis/smash/forms/form_smash_utils.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/elevcolor.dart';
import 'package:smash/eu/hydrologis/smash/util/urls.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/note_properties.dart';
import 'package:smashlibs/smashlibs.dart';

class DataLoaderUtilities {
  static Note addNote(
      SmashMapBuilder mapBuilder, int doInGpsMode, MapController mapController,
      {String form, String iconName, String color, String text}) {
    int ts = DateTime.now().millisecondsSinceEpoch;
    SmashPosition pos;
    double lon;
    double lat;
    double altim;
    if (doInGpsMode == POINT_INSERTION_MODE_GPS) {
      var gpsState = Provider.of<GpsState>(mapBuilder.context, listen: false);
      pos = gpsState.lastGpsPosition;

      if (!gpsState.useFilteredGps) {
        lon = pos.longitude;
        lat = pos.latitude;
        altim = pos.altitude;
      } else {
        lon = pos.filteredLongitude;
        lat = pos.filteredLatitude;
        altim = pos.altitude;
      }
    } else {
      var center = mapController.center;
      lon = center.longitude;
      lat = center.latitude;
      altim = -1;
    }
    Note note = Note()
      ..text = text ??= "note"
      ..description = "POI"
      ..timeStamp = ts
      ..lon = lon
      ..lat = lat
      ..altim = altim;
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

    var projectState =
        Provider.of<ProjectState>(mapBuilder.context, listen: false);
    var db = projectState.projectDb;
    db.addNote(note);

    return note;
  }

  /// Add an image into teh db.
  ///
  /// If [noteId] is specified, the image is added to a specific note.
  static Future<void> addImage(
    BuildContext parentContext,
    dynamic position,
    bool usefiltered, {
    int noteId,
  }) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    if (position is SmashPosition) {
      if (usefiltered) {
        dbImage.lon = position.filteredLongitude;
        dbImage.lat = position.filteredLatitude;
      } else {
        dbImage.lon = position.longitude;
        dbImage.lat = position.latitude;
      }
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
            builder: (context) =>
                TakePictureWidget("Saving image to db...", (String imagePath) {
                  if (imagePath != null) {
                    String imageName =
                        FileUtilities.nameFromFile(imagePath, true);
                    dbImage.text =
                        "IMG_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.jpg";
                    var imageId = ImageWidgetUtilities.saveImageToSmashDb(
                        context, imagePath, dbImage);
                    File file = File(imagePath);
                    if (file.existsSync()) {
                      file.deleteSync();
                    }
                    if (imageId != null) {
                      ProjectState projectState =
                          Provider.of<ProjectState>(context, listen: false);
                      if (projectState != null)
                        projectState.reloadProject(context);
//                } else {
//                  showWarningDialog(
//                      context, "Could not save image in database.");
                    }
                  }
                  return true;
                })));
  }

  static void loadNotesMarkers(GeopaparazziProjectDb db, List<Marker> tmp,
      SmashMapBuilder mapBuilder, String notesMode) {
    if (notesMode == SmashPreferencesKeys.NOTESVIEWMODES[2]) {
      return;
    }

    List<Note> notesList = db.getNotes();
    notesList.forEach((note) {
      NoteExt noteExt = note.noteExt;

      var iconData = getSmashIcon(noteExt.marker);
      var iconColor = ColorExt(noteExt.color);

      double textExtraHeight = MARKER_ICON_TEXT_EXTRA_HEIGHT;
      if (note.text == null || note.text.length == 0) {
        textExtraHeight = 0;
      }

      String text = note.text;
      if (note.hasForm()) {
        text = FormUtilities.getFormItemLabel(note.form, note.text);
      }
      if (notesMode == SmashPreferencesKeys.NOTESVIEWMODES[1]) {
        text = null; // so the text of the icon is not made in MarkerIcon
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
              text,
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
                                      .toStringAsFixed(SmashPreferencesKeys
                                          .KEY_LATLONG_DECIMALS)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Latitude"),
                                  TableUtilities.cellForString(note.lat
                                      .toStringAsFixed(SmashPreferencesKeys
                                          .KEY_LATLONG_DECIMALS)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableUtilities.cellForString("Altitude"),
                                  TableUtilities.cellForString(note.altim
                                      .toStringAsFixed(SmashPreferencesKeys
                                          .KEY_ELEV_DECIMALS)),
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
                              var urlStr = UrlUtilities.osmUrlFromLatLong(
                                  note.lat, note.lon,
                                  withMarker: true);
                              label = "$label\n$urlStr";
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
                                              SmashFormHelper(),
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
                              var doRemove = await SmashDialogs.showConfirmDialog(
                                  ctx,
                                  "Remove Note",
                                  "Are you sure you want to remove note ${note.id}?");
                              if (doRemove) {
                                db.deleteNote(note.id);
                                var projectState = Provider.of<ProjectState>(
                                    mapBuilder.context,
                                    listen: false);
                                projectState.reloadProject(ctx);
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

  static void loadImageMarkers(
      GeopaparazziProjectDb db, List<Marker> tmp, SmashMapBuilder mapBuilder) {
    // IMAGES
    var imagesList = db.getImages();
    imagesList.forEach((image) {
      var size = 48.0;
      var lat = image.lat;
      var lon = image.lon;
      tmp.add(Marker(
        width: size,
        height: size,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () {
            var thumb = db.getThumbnail(image.imageDataId);
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
                                .toStringAsFixed(
                                    SmashPreferencesKeys.KEY_LATLONG_DECIMALS)),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Latitude"),
                            TableUtilities.cellForString(image.lat
                                .toStringAsFixed(
                                    SmashPreferencesKeys.KEY_LATLONG_DECIMALS)),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableUtilities.cellForString("Altitude"),
                            TableUtilities.cellForString(image.altim
                                .toStringAsFixed(
                                    SmashPreferencesKeys.KEY_ELEV_DECIMALS)),
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
                                "image: ${image.text}\nlat: ${image.lat.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)}\nlon: ${image.lon.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)}\naltim: ${image.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}";
                            var urlStr = UrlUtilities.osmUrlFromLatLong(
                                image.lat, image.lon,
                                withMarker: true);
                            label = "$label\n$urlStr";
                            var uint8list =
                                db.getImageDataBytes(image.imageDataId);
                            await ShareHandler.shareImage(label, uint8list);
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
                            var doRemove = await SmashDialogs.showConfirmDialog(
                                ctx,
                                "Remove Image",
                                "Are you sure you want to remove image ${image.id}?");
                            if (doRemove) {
                              db.deleteImage(image.id);
                              var projectState = Provider.of<ProjectState>(
                                  mapBuilder.context,
                                  listen: false);
                              projectState
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

  static PolylineLayerOptions loadLogLinesLayer(GeopaparazziProjectDb db,
      bool doOrig, bool doFiltered, bool doOrigTransp, bool doFilteredTransp) {
    String logsQuery = '''
        select l.$LOGS_COLUMN_ID, p.$LOGSPROP_COLUMN_COLOR, p.$LOGSPROP_COLUMN_WIDTH 
        from $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        where l.$LOGS_COLUMN_ID = p.$LOGSPROP_COLUMN_ID and p.$LOGSPROP_COLUMN_VISIBLE=1
    ''';

    var resLogs = db.select(logsQuery);
    Map<int, List> logs = Map();
    resLogs.forEach((QueryResultRow map) {
      var id = map.get('_id');
      var color = map.get("color");
      var width = map.get("width");

      logs[id] = [color, width, <LatLngExt>[], <LatLngExt>[]];
    });

    String logDataQuery = '''
        select $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_ALTIM, 
        $LOGSDATA_COLUMN_LAT_FILTERED, $LOGSDATA_COLUMN_LON_FILTERED,
        $LOGSDATA_COLUMN_ACCURACY, $LOGSDATA_COLUMN_TS
        from $TABLE_GPSLOG_DATA order by $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_TS
        ''';
    var resLogData = db.select(logDataQuery);
    var rangeMap = <int, List<double>>{};
    var prevTs;
    var prevLatLng;
    var prevLatLngFiltered;
    resLogData.forEach((QueryResultRow map) {
      var logid = map.get(LOGSDATA_COLUMN_LOGID);
      var log = logs[logid];
      if (log != null) {
        var altim = map.get(LOGSDATA_COLUMN_ALTIM);

        var minMax =
            rangeMap[logid] ?? [double.infinity, double.negativeInfinity];
        var newMin = min(minMax[0], altim as double);
        var newMax = max(minMax[1], altim as double);
        rangeMap[logid] = [newMin, newMax];

        var ts = map.get(LOGSDATA_COLUMN_TS)?.toInt();
        var acc = map.get(LOGSDATA_COLUMN_ACCURACY);
        if (doOrig) {
          var lat = map.get(LOGSDATA_COLUMN_LAT);
          var lon = map.get(LOGSDATA_COLUMN_LON);
          var speed = 0.0;
          if (prevTs != null) {
            var distanceMeters =
                CoordinateUtilities.getDistance(LatLng(lat, lon), prevLatLng);
            var deltaTs = (ts - prevTs) / 1000;
            speed = distanceMeters / deltaTs;
          }
          var coordsList = log[2];
          var ll = LatLngExt(lat, lon, altim, -1, speed, ts, acc);
          coordsList.add(ll);
          prevLatLng = ll;
        }
        if (doFiltered) {
          var latF = map.get(LOGSDATA_COLUMN_LAT_FILTERED);
          if (latF != null) {
            var lonF = map.get(LOGSDATA_COLUMN_LON_FILTERED);
            var speed = 0.0;
            if (prevTs != null) {
              var distanceMeters = CoordinateUtilities.getDistance(
                  LatLng(latF, lonF), prevLatLngFiltered);
              var deltaTs = (ts - prevTs) / 1000;
              speed = distanceMeters / deltaTs;
            }
            var coordsListF = log[3];
            var ll = LatLngExt(latF, lonF, altim, -1, speed, ts, acc);
            coordsListF.add(ll);
            prevLatLngFiltered = ll;
          }
        }
        prevTs = ts;
      }
    });

    List<Polyline> lines = [];
    if (doOrig) {
      logs.forEach((logId, list) {
        var color = list[0];
        var width = list[1];
        List<ElevationPoint> points = list[2];

        var colorElev = EnhancedColorUtility.splitEnhancedColorString(color);
        var colString = colorElev[0];
        ColorTables ct = colorElev[1];

        if (ct.isValid()) {
          var minMax = rangeMap[logId];
          EnhancedColorUtility.buildPolylines(
              lines, points, ct, width, minMax[0], minMax[1]);
        } else {
          dynamic colorObj = ColorExt(colString);
          if (doOrigTransp) {
            colorObj = colorObj.withAlpha(100);
          }
          var polyline =
              Polyline(points: points, strokeWidth: width, color: colorObj);
          lines.add(polyline);
        }
      });
    }
    if (doFiltered) {
      logs.forEach((logId, list) {
        var color = list[0];
        var width = list[1];
        var points = list[3];
        if (points.length > 1) {
          var colorItems = EnhancedColorUtility.splitEnhancedColorString(color);
          var colString = colorItems[0];
          var ct = colorItems[1];

          if (ct.isValid()) {
            var minMax = rangeMap[logId];
            EnhancedColorUtility.buildPolylines(
                lines, points, ct, width, minMax[0], minMax[1]);
          } else {
            dynamic colorObj = ColorExt(colString);
            if (doFilteredTransp) {
              colorObj = colorObj.withAlpha(100);
            }
            lines.add(
                Polyline(points: points, strokeWidth: width, color: colorObj));
          }
        }
      });
    }

    return PolylineLayerOptions(
      polylineCulling: true,
      polylines: lines,
    );
  }
}
