/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter_geopackage/flutter_geopackage.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/smashlibs.dart';

class GeopackageExporter {
  static Future<String> exportDb(
      GeopaparazziProjectDb db, File outputFile) async {
    if (await outputFile.exists()) {
      return "Not writing over existing file.";
    }
    bool useFiltered = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, false);

    GeopackageDb newDb = GeopackageDb(outputFile.path);
    newDb.openOrCreate();

    exportNotesTable(newDb, db);
    exportImagesTable(newDb, db);
    exportLogsTable(newDb, db, useFiltered);

    newDb.close();

    return null;
  }

  static void exportNotesTable(GeopackageDb newDb, GeopaparazziProjectDb gpDb) {
    newDb.createSpatialTable(
      SqlName(TABLE_NOTES),
      4326,
      "the_geom POINT",
      [
        "$NOTES_COLUMN_ID  INTEGER PRIMARY KEY AUTOINCREMENT",
        "$NOTES_COLUMN_ALTIM  REAL NOT NULL",
        "$NOTES_COLUMN_TS TEXT NOT NULL",
        "$NOTES_COLUMN_DESCRIPTION TEXT",
        "$NOTES_COLUMN_TEXT TEXT NOT NULL",
        "$NOTES_COLUMN_FORM TEXT",
        "$NOTES_COLUMN_STYLE  TEXT",
        "$NOTES_COLUMN_ISDIRTY  INTEGER",
        "$NOTESEXT_COLUMN_MARKER  TEXT NOT NULL",
        "$NOTESEXT_COLUMN_SIZE  REAL NOT NULL",
        "$NOTESEXT_COLUMN_ROTATION  REAL NOT NULL",
        "$NOTESEXT_COLUMN_COLOR TEXT NOT NULL",
        "$NOTESEXT_COLUMN_ACCURACY REAL",
        "$NOTESEXT_COLUMN_HEADING REAL",
        "$NOTESEXT_COLUMN_SPEED REAL",
        "$NOTESEXT_COLUMN_SPEEDACCURACY REAL",
      ],
      null,
      false,
    );

    List<Note> notesList = gpDb.getNotes();
    var sql = """
                INSERT INTO $TABLE_NOTES (the_geom, $NOTES_COLUMN_ID, $NOTES_COLUMN_ALTIM, $NOTES_COLUMN_TS, $NOTES_COLUMN_DESCRIPTION,
                    $NOTES_COLUMN_TEXT, $NOTES_COLUMN_FORM, $NOTES_COLUMN_STYLE, $NOTES_COLUMN_ISDIRTY, $NOTESEXT_COLUMN_MARKER,
                    $NOTESEXT_COLUMN_SIZE, $NOTESEXT_COLUMN_ROTATION, $NOTESEXT_COLUMN_COLOR, $NOTESEXT_COLUMN_ACCURACY,
                    $NOTESEXT_COLUMN_HEADING, $NOTESEXT_COLUMN_SPEED, $NOTESEXT_COLUMN_SPEEDACCURACY) 
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
                """;

    var gf = GeometryFactory.defaultPrecision();
    notesList.forEach((note) {
      var point = gf.createPoint(Coordinate(note.lon, note.lat));
      var geomBytes = GeoPkgGeomWriter().write(point);
      newDb.execute(sql, arguments: [
        geomBytes,
        note.id,
        note.altim,
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp)),
        note.description,
        note.text,
        note.form,
        note.style,
        note.isDirty,
        note.noteExt.marker,
        note.noteExt.size,
        note.noteExt.rotation,
        note.noteExt.color,
        note.noteExt.accuracy,
        note.noteExt.heading,
        note.noteExt.speed,
        note.noteExt.speedaccuracy,
      ]);
    });
  }

  static void exportImagesTable(
      GeopackageDb newDb, GeopaparazziProjectDb gpDb) {
    newDb.createSpatialTable(
      SqlName(TABLE_IMAGES),
      4326,
      "the_geom POINT",
      [
        "$IMAGES_COLUMN_ID  INTEGER PRIMARY KEY AUTOINCREMENT",
        "$IMAGES_COLUMN_ALTIM  REAL NOT NULL",
        "$IMAGES_COLUMN_AZIM REAL NOT NULL",
        "$IMAGES_COLUMN_TS TEXT NOT NULL",
        "$IMAGES_COLUMN_TEXT TEXT NOT NULL",
        "$IMAGES_COLUMN_ISDIRTY  INTEGER",
        "$IMAGESDATA_COLUMN_IMAGE BLOB NOT NULL",
        "$IMAGESDATA_COLUMN_THUMBNAIL BLOB NOT NULL",
      ],
      null,
      false,
    );

    var sql = """
                INSERT INTO $TABLE_IMAGES (the_geom, $IMAGES_COLUMN_ID, $IMAGES_COLUMN_ALTIM,
                    $IMAGES_COLUMN_AZIM, $IMAGES_COLUMN_TS, $IMAGES_COLUMN_TEXT, $IMAGES_COLUMN_ISDIRTY,
                    $IMAGESDATA_COLUMN_IMAGE, $IMAGESDATA_COLUMN_THUMBNAIL
                ) 
                VALUES (?,?,?,?,?,?,?,?,?);
                """;

    var gf = GeometryFactory.defaultPrecision();
    var images = gpDb.getImages();
    images.forEach((img) {
      var point = gf.createPoint(Coordinate(img.lon, img.lat));
      var geomBytes = GeoPkgGeomWriter().write(point);

      var imageDataBytes = gpDb.getImageDataBytes(img.id);
      var thumbnailBytes = gpDb.getThumbnailBytes(img.id);

      newDb.execute(sql, arguments: [
        geomBytes,
        img.id,
        img.altim,
        img.azim,
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(img.timeStamp)),
        img.text,
        img.isDirty,
        imageDataBytes,
        thumbnailBytes,
      ]);
    });
  }

  static void exportLogsTable(
      GeopackageDb newDb, GeopaparazziProjectDb db, bool useFiltered) {
    newDb.createSpatialTable(
      SqlName(TABLE_GPSLOGS),
      4326,
      "the_geom LINESTRING",
      [
        "$LOGS_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT",
        "$LOGS_COLUMN_STARTTS TEXT NOT NULL",
        "$LOGS_COLUMN_ENDTS TEXT NOT NULL",
        "$LOGS_COLUMN_LENGTHM REAL NOT NULL",
        "$LOGS_COLUMN_ISDIRTY INTEGER NOT NULL",
        "$LOGS_COLUMN_TEXT TEXT NOT NULL",
        "$LOGSPROP_COLUMN_COLOR  TEXT NOT NULL",
        "$LOGSPROP_COLUMN_WIDTH  REAL NOT NULL",
      ],
      null,
      false,
    );
    // also export as points
    newDb.createSpatialTable(
      SqlName(TABLE_GPSLOG_DATA),
      4326,
      "the_geom POINT",
      [
        "$LOGSDATA_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT",
        "$LOGSDATA_COLUMN_ALTIM  REAL NOT NULL",
        "$LOGSDATA_COLUMN_TS  TEXT NOT NULL",
        "$LOGSDATA_COLUMN_LOGID  INTEGER NOT NULL",
      ],
      null,
      false,
    );

    var sqlLogs = """
                INSERT INTO $TABLE_GPSLOGS (the_geom, $LOGS_COLUMN_ID, $LOGS_COLUMN_STARTTS,
                    $LOGS_COLUMN_ENDTS, $LOGS_COLUMN_LENGTHM, $LOGS_COLUMN_ISDIRTY, $LOGS_COLUMN_TEXT,
                    $LOGSPROP_COLUMN_COLOR, $LOGSPROP_COLUMN_WIDTH
                ) 
                VALUES (?,?,?,?,?,?,?,?,?);
                """;
    var sqlPoints = """
                INSERT INTO $TABLE_GPSLOG_DATA (the_geom, $LOGSDATA_COLUMN_ID, 
                  $LOGSDATA_COLUMN_ALTIM, $LOGSDATA_COLUMN_TS, $LOGSDATA_COLUMN_LOGID
                ) 
                VALUES (?,?,?,?,?);
                """;
    var gf = GeometryFactory.defaultPrecision();
    var logs = db.getLogs();
    logs.forEach((log) {
      List<Coordinate> coordinates = [];
      List<LogDataPoint> logDataPoints = db.getLogDataPoints(log.id);
      logDataPoints.forEach((logPoint) {
        Coordinate coordinate;
        if (useFiltered) {
          coordinate = Coordinate(logPoint.filtered_lon, logPoint.filtered_lat);
        } else {
          coordinate = Coordinate(logPoint.lon, logPoint.lat);
        }
        coordinates.add(coordinate);

        var point = gf.createPoint(coordinate);
        var geomBytes = GeoPkgGeomWriter().write(point);
        newDb.execute(sqlPoints, arguments: [
          geomBytes,
          logPoint.id,
          logPoint.altim,
          HU.TimeUtilities.ISO8601_TS_FORMATTER
              .format(DateTime.fromMillisecondsSinceEpoch(logPoint.ts)),
          logPoint.logid,
        ]);
      });

      var logProperties = db.getLogProperties(log.id);

      var line = gf.createLineString(coordinates);
      var geomBytes = GeoPkgGeomWriter().write(line);
      newDb.execute(sqlLogs, arguments: [
        geomBytes,
        log.id,
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(log.startTime)),
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(log.endTime)),
        log.lengthm,
        log.isDirty,
        log.text,
        logProperties.color,
        logProperties.width,
      ]);
    });
  }
}
