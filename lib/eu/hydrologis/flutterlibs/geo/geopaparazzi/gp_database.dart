/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/eventhandlers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/forms/forms.dart';
import 'package:smash/eu/hydrologis/flutterlibs/forms/forms_widgets.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/database_widgets.dart';
import 'package:smash/eu/hydrologis/flutterlibs/media/camera.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/share.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/project_tables.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/images.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

const int MAXBLOBSIZE = 1900000;

class GeopaparazziProjectDb extends SqliteDb {
  var CREATE_NOTESEXT_STATEMENT = '''
        CREATE TABLE $TABLE_NOTESEXT (  
          $NOTESEXT_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
          $NOTESEXT_COLUMN_NOTEID  INTEGER NOT NULL,  
          $NOTESEXT_COLUMN_MARKER  TEXT NOT NULL,  
          $NOTESEXT_COLUMN_SIZE  REAL NOT NULL, 
          $NOTESEXT_COLUMN_ROTATION  REAL NOT NULL, 
          $NOTESEXT_COLUMN_COLOR TEXT NOT NULL, 
          $NOTESEXT_COLUMN_ACCURACY REAL,  
          $NOTESEXT_COLUMN_HEADING REAL,  
          $NOTESEXT_COLUMN_SPEED REAL,  
          $NOTESEXT_COLUMN_SPEEDACCURACY REAL
        );
        CREATE INDEX notesext_noteidx ON $TABLE_NOTESEXT ($NOTESEXT_COLUMN_NOTEID);
    ''';

  GeopaparazziProjectDb(dbPath) : super(dbPath);

  openOrCreate({Function dbCreateFunction}) async {
    await super.openOrCreate(dbCreateFunction: createDatabase);
  }

  /// Get the count of the current notes
  ///
  /// Get the count using [onlyDirty] to count only dirty notes.
  Future<int> getNotesCount(bool onlyDirty) async {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    List<Map<String, dynamic>> resNotes = await query("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes[0];
    var count = resNote["count"];
    return count;
  }

  Future<int> getSimpleNotesCount(bool onlyDirty) async {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where ($NOTES_COLUMN_FORM is null or $NOTES_COLUMN_FORM='')";
    List<Map<String, dynamic>> resNotes = await query("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes[0];
    var count = resNote["count"];
    return count;
  }

  Future<int> getFormNotesCount(bool onlyDirty) async {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where $NOTES_COLUMN_FORM is not null and $NOTES_COLUMN_FORM<>''";
    List<Map<String, dynamic>> resNotes = await query("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes[0];
    var count = resNote["count"];
    return count;
  }

  Future<List<Note>> getNotes({bool doSimple, bool onlyDirty: false}) async {
    String where = "";
    if (onlyDirty) {
      where = " where $NOTES_COLUMN_ISDIRTY=1";
    }
    if (doSimple != null) {
      if (where.isEmpty) {
        where = " where ";
      } else {
        where = "$where and ";
      }
      if (doSimple) {
        where = "$where ($NOTES_COLUMN_FORM is null or $NOTES_COLUMN_FORM='')";
      } else {
        where = "$where $NOTES_COLUMN_FORM is not null and $NOTES_COLUMN_FORM<>''";
      }
    }

    String extid = "extid";
    String sql = '''
      select n.$NOTES_COLUMN_ID,n.$NOTES_COLUMN_LON,n.$NOTES_COLUMN_LAT,
             n.$NOTES_COLUMN_ALTIM,n.$NOTES_COLUMN_TS,n.$NOTES_COLUMN_DESCRIPTION,
             n.$NOTES_COLUMN_TEXT,n.$NOTES_COLUMN_FORM,n.$NOTES_COLUMN_STYLE,n.$NOTES_COLUMN_ISDIRTY,
             nex.$NOTESEXT_COLUMN_ID as $extid,nex.$NOTESEXT_COLUMN_NOTEID,nex.$NOTESEXT_COLUMN_MARKER,nex.$NOTESEXT_COLUMN_SIZE,
             nex.$NOTESEXT_COLUMN_ROTATION,nex.$NOTESEXT_COLUMN_COLOR,nex.$NOTESEXT_COLUMN_ACCURACY,
             nex.$NOTESEXT_COLUMN_HEADING,nex.$NOTESEXT_COLUMN_SPEED,nex.$NOTESEXT_COLUMN_SPEEDACCURACY
      from $TABLE_NOTES n left join  $TABLE_NOTESEXT nex
      on n.$NOTES_COLUMN_ID=nex.$NOTESEXT_COLUMN_NOTEID
      $where
    ''';

    List<Note> notes = [];
    List<Map<String, dynamic>> resNotes = await query(sql);
    for (int i = 0; i < resNotes.length; i++) {
      Map resNoteMap = resNotes[i];

      Note note = Note()
        ..id = resNoteMap[NOTES_COLUMN_ID]
        ..lon = resNoteMap[NOTES_COLUMN_LON]
        ..lat = resNoteMap[NOTES_COLUMN_LAT]
        ..altim = resNoteMap[NOTES_COLUMN_ALTIM]
        ..timeStamp = resNoteMap[NOTES_COLUMN_TS]
        ..description = resNoteMap[NOTES_COLUMN_DESCRIPTION]
        ..text = resNoteMap[NOTES_COLUMN_TEXT]
        ..form = resNoteMap[NOTES_COLUMN_FORM]
        ..style = resNoteMap[NOTES_COLUMN_STYLE]
        ..isDirty = resNoteMap[NOTES_COLUMN_ISDIRTY];

      // we can add the extended part
      NoteExt noteExt = NoteExt();
      if (resNoteMap[extid] != null) {
        noteExt.id = resNoteMap[extid];
        noteExt.noteId = note.id;
        var marker = resNoteMap[NOTESEXT_COLUMN_MARKER];
        if (marker != null) noteExt.marker = marker;
        var _size = resNoteMap[NOTESEXT_COLUMN_SIZE];
        if (_size != null) noteExt.size = _size;
        var _rotation = resNoteMap[NOTESEXT_COLUMN_ROTATION];
        if (_rotation != null) noteExt.rotation = _rotation;
        var _color = resNoteMap[NOTESEXT_COLUMN_COLOR];
        if (_color != null) noteExt.color = _color;
        noteExt.accuracy = resNoteMap[NOTESEXT_COLUMN_ACCURACY];
        noteExt.heading = resNoteMap[NOTESEXT_COLUMN_HEADING];
        noteExt.speed = resNoteMap[NOTESEXT_COLUMN_SPEED];
        noteExt.speedaccuracy = resNoteMap[NOTESEXT_COLUMN_SPEEDACCURACY];
      } else {
        // insert the note ext
        noteExt.noteId = note.id;
        int noteExtId = await addNoteExt(noteExt);
        noteExt.id = noteExtId;
      }
      note.noteExt = noteExt;
      notes.add(note);
    }
    return notes;
  }

  Future<Note> getNoteById(int id) async {
    String where = " where n.$NOTES_COLUMN_ID=$id";
    String extid = "extid";
    String sql = '''
      select n.$NOTES_COLUMN_ID,n.$NOTES_COLUMN_LON,n.$NOTES_COLUMN_LAT,
             n.$NOTES_COLUMN_ALTIM,n.$NOTES_COLUMN_TS,n.$NOTES_COLUMN_DESCRIPTION,
             n.$NOTES_COLUMN_TEXT,n.$NOTES_COLUMN_FORM,n.$NOTES_COLUMN_STYLE,n.$NOTES_COLUMN_ISDIRTY,
             nex.$NOTESEXT_COLUMN_ID as $extid,nex.$NOTESEXT_COLUMN_NOTEID,nex.$NOTESEXT_COLUMN_MARKER,nex.$NOTESEXT_COLUMN_SIZE,
             nex.$NOTESEXT_COLUMN_ROTATION,nex.$NOTESEXT_COLUMN_COLOR,nex.$NOTESEXT_COLUMN_ACCURACY,
             nex.$NOTESEXT_COLUMN_HEADING,nex.$NOTESEXT_COLUMN_SPEED,nex.$NOTESEXT_COLUMN_SPEEDACCURACY
      from $TABLE_NOTES n left join  $TABLE_NOTESEXT nex
      on n.$NOTES_COLUMN_ID=nex.$NOTESEXT_COLUMN_NOTEID
      $where
    ''';

    List<Note> notes = [];
    List<Map<String, dynamic>> resNotes = await query(sql);
    Map resNoteMap = resNotes[0];

    Note note = Note()
      ..id = resNoteMap[NOTES_COLUMN_ID]
      ..lon = resNoteMap[NOTES_COLUMN_LON]
      ..lat = resNoteMap[NOTES_COLUMN_LAT]
      ..altim = resNoteMap[NOTES_COLUMN_ALTIM]
      ..timeStamp = resNoteMap[NOTES_COLUMN_TS]
      ..description = resNoteMap[NOTES_COLUMN_DESCRIPTION]
      ..text = resNoteMap[NOTES_COLUMN_TEXT]
      ..form = resNoteMap[NOTES_COLUMN_FORM]
      ..style = resNoteMap[NOTES_COLUMN_STYLE]
      ..isDirty = resNoteMap[NOTES_COLUMN_ISDIRTY];

    // we can add the extended part
    NoteExt noteExt = NoteExt();
    if (resNoteMap[extid] != null) {
      noteExt.id = resNoteMap[extid];
      noteExt.noteId = note.id;
      var marker = resNoteMap[NOTESEXT_COLUMN_MARKER];
      if (marker != null) noteExt.marker = marker;
      var _size = resNoteMap[NOTESEXT_COLUMN_SIZE];
      if (_size != null) noteExt.size = _size;
      var _rotation = resNoteMap[NOTESEXT_COLUMN_ROTATION];
      if (_rotation != null) noteExt.rotation = _rotation;
      var _color = resNoteMap[NOTESEXT_COLUMN_COLOR];
      if (_color != null) noteExt.color = _color;
      noteExt.accuracy = resNoteMap[NOTESEXT_COLUMN_ACCURACY];
      noteExt.heading = resNoteMap[NOTESEXT_COLUMN_HEADING];
      noteExt.speed = resNoteMap[NOTESEXT_COLUMN_SPEED];
      noteExt.speedaccuracy = resNoteMap[NOTESEXT_COLUMN_SPEEDACCURACY];
    } else {
      // insert the note ext
      noteExt.noteId = note.id;
      int noteExtId = await addNoteExt(noteExt);
      noteExt.id = noteExtId;
    }
    note.noteExt = noteExt;
    notes.add(note);
    return note;
  }

  /// Get the count of the current image notes (not the number of images in the db,
  /// where multiple could be associated to the same note).
  ///
  /// Get the count using [onlyDirty] to count only dirty images.
  Future<int> getImagesCount(bool onlyDirty) async {
    String where = "";
    if (onlyDirty) {
      where = " where $IMAGES_COLUMN_ISDIRTY=1";
    }
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where ($IMAGES_COLUMN_NOTE_ID is null)";
    List<Map<String, dynamic>> resImages = await query("SELECT count(*) as count FROM $TABLE_IMAGES$where");

    var resImage = resImages[0];
    var count = resImage["count"];
    return count;
  }

  Future<List<DbImage>> getImages({bool onlyDirty = false}) async {
    String where = "";
    if (onlyDirty) {
      where = " where $IMAGES_COLUMN_ISDIRTY=1";
    }
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where ($IMAGES_COLUMN_NOTE_ID is null)";
    var images = await getQueryObjectsList(ImageQueryBuilder(), whereString: where);
    return images;
  }

  Future<DbImage> getImageById(int imageId) async {
    String where = "where $IMAGES_COLUMN_ID=$imageId";
    var images = await getQueryObjectsList(ImageQueryBuilder(), whereString: where);
    return images[0];
  }

  /// Get the image thumbnail of a given [imageDataId].
  Future<Image> getThumbnail(int imageDataId) async {
    var imageDataList = await getQueryObjectsList(ImageDataQueryBuilder(doData: false, doThumb: true), whereString: "where $IMAGESDATA_COLUMN_ID=$imageDataId");
    if (imageDataList != null && imageDataList.length == 1) {
      DbImageData imgDataMap = imageDataList.first;
      if (imgDataMap != null && imgDataMap.thumb != null) {
        return ImageWidgetUtilities.imageFromBytes(imgDataMap.thumb);
      }
    }
    return null;
  }

  /// Get the image of a given [imageDataId].
  Future<Image> getImage(int imageDataId) async {
    Uint8List imageDataBytes = await getImageDataBytes(imageDataId);
    if (imageDataBytes != null) return ImageWidgetUtilities.imageFromBytes(imageDataBytes);
    return null;
  }

  Future<Uint8List> getImageDataBytes(int imageDataId) async {
    Uint8List imageDataBytes;
    var whereStr = "where $IMAGESDATA_COLUMN_ID=$imageDataId";
    try {
      List<DbImageData> imageDataList = await getQueryObjectsList(ImageDataQueryBuilder(doData: true, doThumb: false), whereString: whereStr);
      if (imageDataList != null && imageDataList.length == 1) {
        DbImageData imgDataMap = imageDataList.first;
        if (imgDataMap != null && imgDataMap.data != null) {
          imageDataBytes = imgDataMap.data;
        }
      }
    } catch (ex) {
      String sizeQuery = "SELECT $IMAGESDATA_COLUMN_ID, length($IMAGESDATA_COLUMN_IMAGE) as blobsize FROM $TABLE_IMAGE_DATA $whereStr";
      var res = await query(sizeQuery);
      if (res.length == 1) {
        int blobSize = res[0]['blobsize'];
        List<int> total = List();
        if (blobSize > MAXBLOBSIZE) {
          for (int i = 1; i <= blobSize; i = i + MAXBLOBSIZE) {
            int from = i;
            int size = MAXBLOBSIZE;
            if (from + size > blobSize) {
              size = blobSize - from + 1;
            }
            String tmpQuery = "SELECT substr($IMAGESDATA_COLUMN_IMAGE, $from, $size) as partialblob FROM $TABLE_IMAGE_DATA $whereStr";
            var res2 = await query(tmpQuery);
            var partial = res2[0]['partialblob'];
            total.addAll(partial);
          }
          imageDataBytes = Uint8List.fromList(total);
        }
      }
    }
    return imageDataBytes;
  }

/*
 * Add a note.
 *
 * @param note the note to insert.
 * @return the inserted note id.
 */
  Future<int> addNote(Note note) async {
    var noteId = await insertMap(TABLE_NOTES, note.toMap());
    note.id = noteId;
    if (note.noteExt == null) {
      NoteExt noteExt = NoteExt();
      noteExt.noteId = note.id;
      int noteExtId = await addNoteExt(noteExt);
      noteExt.id = noteExtId;
      note.noteExt = noteExt;
    } else {
      note.noteExt.noteId = noteId;
      int extid = await addNoteExt(note.noteExt);
      note.noteExt.id = extid;
    }
    return noteId;
  }

  Future<int> addNoteExt(NoteExt noteExt) {
    var noteExtId = insertMap(TABLE_NOTESEXT, noteExt.toMap());
    return noteExtId;
  }

  /// Delete a note by its [noteId].
  Future<int> deleteNote(int noteId) async {
    var sql = "delete from $TABLE_NOTES where $NOTES_COLUMN_ID=$noteId";
    var deletedCount = await delete(sql);

    await deleteImageByNoteId(noteId);
    return deletedCount;
  }

  Future<int> deleteImageByNoteId(int noteId) async {
    var deleteSql = "delete from $TABLE_IMAGES where $IMAGES_COLUMN_NOTE_ID=$noteId";
    return await delete(deleteSql);
  }

  Future<int> deleteImage(int imageId) async {
    String sql = "delete from $TABLE_IMAGES where $IMAGES_COLUMN_ID=$imageId";
    return await delete(sql);
  }

  Future<int> updateNoteImages(int noteId, List<int> imageIds) async {
    if (imageIds == null || imageIds.isEmpty) {
      return 0;
    }
    var idsJoin = imageIds.join(',');
    var updateSql = "update $TABLE_IMAGES set $IMAGES_COLUMN_NOTE_ID=$noteId where $IMAGES_COLUMN_ID in (${idsJoin})";
    var updatedIds = await update(updateSql);
    return updatedIds;
  }

  /// Get the count of the current logs
  ///
  /// Get the count using [onlyDirty] to count only dirty notes.
  Future<int> getGpsLogCount(bool onlyDirty) async {
    String where = !onlyDirty ? "" : " where $LOGS_COLUMN_ISDIRTY = 1";
    var sql = "SELECT count(*) as count FROM $TABLE_GPSLOGS$where";
    List<Map<String, dynamic>> resMap = await query(sql);

    var res = resMap[0];
    var count = res["count"];
    return count;
  }

  /// Get the start position coordinate of a log identified by [logId].
  Future<LatLng> getLogStartPosition(int logId) async {
    var sql = '''
      select $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LAT from $TABLE_GPSLOG_DATA 
      where $LOGSDATA_COLUMN_LOGID=$logId
      order by $LOGSDATA_COLUMN_TS 
      limit 1
    ''';

    List<Map<String, dynamic>> resList = await query(sql);
    if (resList.length == 1) {
      var map = resList[0];
      var lon = map[LOGSDATA_COLUMN_LON];
      var lat = map[LOGSDATA_COLUMN_LAT];
      return LatLng(lat, lon);
    }
    return null;
  }

  /// Add a new gps [Log] into teh database.
  ///
  /// The log is inserted with the properties [prop].
  /// The method returns the id of the inserted log.
  Future<int> addGpsLog(Log insertLog, LogProperty prop) async {
    await transaction((tx) async {
      int insertedId = await tx.insert(TABLE_GPSLOGS, insertLog.toMap());
      prop.logid = insertedId;
      insertLog.id = insertedId;
      await tx.insert(TABLE_GPSLOG_PROPERTIES, prop.toMap());
    });

    return insertLog.id;
  }

  /// Add a point [logPoint] to a [Log] of id [logId].
  ///
  /// Returns the id of the inserted point.
  Future<int> addGpsLogPoint(int logId, LogDataPoint logPoint) async {
    logPoint.logid = logId;
    int insertedId = await insertMap(TABLE_GPSLOG_DATA, logPoint.toMap());
    return insertedId;
  }

  /// Delete a gps log by its id.
  ///
  /// @param id the log's id.
  Future<bool> deleteGpslog(int logId) async {
    return await transaction((tx) {
      // delete log
      String sql = "delete from $TABLE_GPSLOGS where $LOGS_COLUMN_ID = $logId";
      tx.execute(sql);
      sql = "delete from $TABLE_GPSLOG_PROPERTIES where $LOGSPROP_COLUMN_LOGID = $logId";
      tx.execute(sql);
      sql = "delete from $TABLE_GPSLOG_DATA where $LOGSDATA_COLUMN_LOGID = $logId";
      tx.execute(sql);
      return Future.value(true);
    });
  }

  /// Updates the end timestamp [endTs] of a log of id [logId].
  Future<int> updateGpsLogEndts(int logId, int endTs) async {
    var updatedId = await update("update $TABLE_GPSLOGS set $LOGS_COLUMN_ENDTS=$endTs where $LOGS_COLUMN_ID=$logId");
    await updateLogLength(logId);
    return updatedId;
  }

  /// Updates the [name] of a log of id [logId].
  Future<int> updateGpsLogName(int logId, String name) async {
    var updatedId = await update("update $TABLE_GPSLOGS set $LOGS_COLUMN_TEXT='$name' where $LOGS_COLUMN_ID=$logId");
    return updatedId;
  }

  /// Updates the [color] and [width] of a log of id [logId].
  Future<int> updateGpsLogStyle(int logId, String color, double width) async {
    var updatedId =
        await update("update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_COLOR='$color', $LOGSPROP_COLUMN_WIDTH=$width where $LOGSPROP_COLUMN_LOGID=$logId");
    return updatedId;
  }

  /// Updates the [isVisible] of a log of id [logId].
  Future<int> updateGpsLogVisibility(bool isVisible, [int logId]) async {
    String where = "";
    if (logId != null) {
      where = " where $LOGSPROP_COLUMN_LOGID=$logId";
    }

    var updatedId = await update("update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE=${isVisible ? 1 : 0}$where");
    return updatedId;
  }

  /// Invert the visiblity of all logs.
  Future<int> invertGpsLogsVisibility() async {
    String sql = '''
      update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE= CASE
        WHEN $LOGSPROP_COLUMN_VISIBLE = 1 THEN 0
                       ELSE 1
        END
    ''';
    var updatedId = await update(sql);
    return updatedId;
  }

  /// Update the length of a log
  ///
  /// Calculates the length of a log of id [logId].
  Future<double> updateLogLength(int logId) async {
    var sql = '''
      SELECT $LOGSDATA_COLUMN_LON,$LOGSDATA_COLUMN_LAT,$LOGSDATA_COLUMN_TS 
      FROM $TABLE_GPSLOG_DATA 
      WHERE $LOGSDATA_COLUMN_LOGID=$logId
      ORDER BY $LOGSDATA_COLUMN_TS ASC
    ''';
    double summedDistance = 0.0;

    var res = await query(sql);
    LatLng previousPosition;
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      var lon = map[LOGSDATA_COLUMN_LON];
      var lat = map[LOGSDATA_COLUMN_LAT];
      var ts = map[LOGSDATA_COLUMN_TS];
      LatLng pos = LatLng(lat, lon);
      if (previousPosition != null) {
        var distanceMeters = CoordinateUtilities.getDistance(pos, previousPosition);
        summedDistance += distanceMeters;
      }
      previousPosition = pos;
    }

    // update the value
    String updateSql = '''
      update $TABLE_GPSLOGS set $LOGS_COLUMN_LENGTHM=$summedDistance 
      where $LOGS_COLUMN_ID=$logId;
    ''';
    var updateNums = await update(updateSql);
    if (updateNums != 1) {
      return null;
    }
    return summedDistance;
  }

  Future<int> updateNote(Note note) async {
    var map = note.toMap();
    var noteId = map.remove(NOTES_COLUMN_ID);

    int count = await updateMap(TABLE_NOTES, map, "$NOTES_COLUMN_ID=$noteId");
    if (count == 1) {
      var extMap = note.noteExt.toMap();
      int noteExtId = extMap.remove(NOTESEXT_COLUMN_ID);
      extMap.remove(NOTESEXT_COLUMN_NOTEID);
      count = await updateMap(TABLE_NOTESEXT, extMap, "$NOTESEXT_COLUMN_ID=$noteExtId");
      if (count != 1) {
        print("Not updated");
      }
    }
  }

  /// Create the geopaparazzi project database.
  createDatabase(Database db) async {
    var createTablesQuery = '''
    CREATE TABLE $TABLE_NOTES (  
      $NOTES_COLUMN_ID  INTEGER PRIMARY KEY AUTOINCREMENT, 
      $NOTES_COLUMN_LON  REAL NOT NULL,  
      $NOTES_COLUMN_LAT  REAL NOT NULL, 
      $NOTES_COLUMN_ALTIM  REAL NOT NULL, 
      $NOTES_COLUMN_TS LONG NOT NULL, 
      $NOTES_COLUMN_DESCRIPTION TEXT,  
      $NOTES_COLUMN_TEXT TEXT NOT NULL,  
      $NOTES_COLUMN_FORM CLOB,  
      $NOTES_COLUMN_STYLE  TEXT, 
      $NOTES_COLUMN_ISDIRTY  INTEGER 
    );
    CREATE INDEX notes_ts_idx ON $TABLE_NOTES ($NOTES_COLUMN_TS);
    CREATE INDEX notes_x_by_y_idx ON $TABLE_NOTES ($NOTES_COLUMN_LON, $NOTES_COLUMN_LAT);
    CREATE INDEX notes_isdirty_idx ON $TABLE_NOTES ($NOTES_COLUMN_ISDIRTY);
    
    $CREATE_NOTESEXT_STATEMENT
    
    CREATE TABLE $TABLE_GPSLOGS (
      $LOGS_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $LOGS_COLUMN_STARTTS LONG NOT NULL,
      $LOGS_COLUMN_ENDTS LONG NOT NULL,
      $LOGS_COLUMN_LENGTHM REAL NOT NULL, 
      $LOGS_COLUMN_ISDIRTY INTEGER NOT NULL, 
      $LOGS_COLUMN_TEXT TEXT NOT NULL 
    );
    CREATE TABLE $TABLE_GPSLOG_DATA (
      $LOGSDATA_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $LOGSDATA_COLUMN_LON  REAL NOT NULL, 
      $LOGSDATA_COLUMN_LAT  REAL NOT NULL,
      $LOGSDATA_COLUMN_ALTIM  REAL NOT NULL,
      $LOGSDATA_COLUMN_TS  LONG NOT NULL,
      $LOGSDATA_COLUMN_LOGID  INTEGER NOT NULL 
          CONSTRAINT $LOGSDATA_COLUMN_LOGID 
          REFERENCES $TABLE_GPSLOGS ( $LOGS_COLUMN_ID ) 
          ON DELETE CASCADE
    );
    CREATE INDEX gpslog_id_idx ON $TABLE_GPSLOG_DATA ( $LOGSDATA_COLUMN_LOGID );
    CREATE INDEX gpslog_ts_idx ON $TABLE_GPSLOG_DATA ( $LOGSDATA_COLUMN_TS );
    CREATE INDEX gpslog_x_by_y_idx ON $TABLE_GPSLOG_DATA ( $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LAT );
    CREATE INDEX gpslog_logid_x_y_idx ON $TABLE_GPSLOG_DATA ( $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LAT );
    
    CREATE TABLE $TABLE_GPSLOG_PROPERTIES (
      $LOGSPROP_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
      $LOGSPROP_COLUMN_LOGID INTEGER NOT NULL 
          CONSTRAINT $LOGSPROP_COLUMN_LOGID 
          REFERENCES $TABLE_GPSLOGS ( $LOGS_COLUMN_ID ) 
          ON DELETE CASCADE,
      $LOGSPROP_COLUMN_COLOR  TEXT NOT NULL, 
      $LOGSPROP_COLUMN_WIDTH  REAL NOT NULL, 
      $LOGSPROP_COLUMN_VISIBLE  INTEGER NOT NULL
    );
    
    CREATE TABLE $TABLE_BOOKMARKS (
      $BOOKMARK_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $BOOKMARK_COLUMN_LON REAL NOT NULL, 
      $BOOKMARK_COLUMN_LAT REAL NOT NULL,
      $BOOKMARK_COLUMN_ZOOM REAL NOT NULL,
      $BOOKMARK_COLUMN_TEXT TEXT NOT NULL 
    );
    CREATE INDEX bookmarks_x_by_y_idx ON $TABLE_BOOKMARKS ($BOOKMARK_COLUMN_LAT, $BOOKMARK_COLUMN_LON);
    
    CREATE TABLE $TABLE_IMAGES (
      $IMAGES_COLUMN_ID  INTEGER PRIMARY KEY AUTOINCREMENT,
      $IMAGES_COLUMN_LON REAL NOT NULL,
      $IMAGES_COLUMN_LAT REAL NOT NULL,
      $IMAGES_COLUMN_ALTIM REAL NOT NULL,
      $IMAGES_COLUMN_AZIM REAL NOT NULL,
      $IMAGES_COLUMN_IMAGEDATA_ID INTEGER NOT NULL 
          CONSTRAINT $IMAGES_COLUMN_IMAGEDATA_ID
          REFERENCES $TABLE_IMAGE_DATA ($IMAGESDATA_COLUMN_ID)
          ON DELETE CASCADE,
      $IMAGES_COLUMN_TS LONG NOT NULL,
      $IMAGES_COLUMN_TEXT TEXT NOT NULL,
      $IMAGES_COLUMN_NOTE_ID INTEGER,
      $IMAGES_COLUMN_ISDIRTY INTEGER NOT NULL
    );
    
    CREATE INDEX images_ts_idx ON $TABLE_IMAGES ($IMAGES_COLUMN_TS);
    CREATE INDEX images_noteid_idx ON $TABLE_IMAGES ($IMAGES_COLUMN_NOTE_ID);
    CREATE INDEX images_isdirty_idx ON $TABLE_IMAGES ($IMAGES_COLUMN_ISDIRTY);
    CREATE INDEX images_x_by_y_idx ON $TABLE_IMAGES ($IMAGES_COLUMN_LAT, $IMAGES_COLUMN_LON);
    
    CREATE TABLE $TABLE_IMAGE_DATA (
      $IMAGESDATA_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $IMAGESDATA_COLUMN_IMAGE BLOB NOT NULL,
      $IMAGESDATA_COLUMN_THUMBNAIL BLOB NOT NULL
    );
  ''';

    await db.transaction((tx) async {
      var split = createTablesQuery.replaceAll("\n", "").trim().split(";");
      for (int i = 0; i < split.length; i++) {
        var sql = split[i].trim();
        if (sql.length > 0 && !sql.startsWith("--")) {
          await tx.execute(sql);
        }
      }
    });
  }

  createNecessaryExtraTables() async {
    bool hasNotesExt = await hasTable(TABLE_NOTESEXT);
    if (!hasNotesExt) {
      GpLogger().w("Adding extra database table $TABLE_NOTESEXT.");
      await transaction((tx) async {
        var split = CREATE_NOTESEXT_STATEMENT.replaceAll("\n", "").trim().split(";");
        for (int i = 0; i < split.length; i++) {
          var sql = split[i].trim();
          if (sql.length > 0 && !sql.startsWith("--")) {
            await tx.execute(sql);
          }
        }
      });
    }
  }

  void printInfo() async {
    var tableNames = await getTables(true);
    for (int i = 0; i < tableNames.length; i++) {
      var tableName = tableNames[i];
      var has = await hasTable(tableName);
      print("$tableName found: $has");
      var tableColumns = await getTableColumns(tableName);
      for (int j = 0; j < tableColumns.length; j++) {
        var tableColumn = tableColumns[j];
        print("    ${tableColumn[0]} ${tableColumn[1]} ${tableColumn[2] == 1 ? "isPk" : ""} ");
      }
    }
  }
}

class DataLoaderUtilities {
  static Future<Note> addNote(ProjectState projectState, bool doInGps, MapController mapController,
      {String form, String iconName, String color, String text}) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    Position pos;
    double lon;
    double lat;
    if (doInGps) {
      pos = Provider.of<GpsState>(projectState.context, listen: false).lastGpsPosition;
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
    var db = projectState.projectDb;
    await db.addNote(note);

    return note;
  }

  /// Add an image into teh db.
  ///
  /// If [noteId] is specified, the image is added to a specific note.
  static Future<void> addImage(
    BuildContext context,
    dynamic position, {
    int noteId,
  }) async {
    DbImage dbImage = DbImage()
      ..timeStamp = DateTime.now().millisecondsSinceEpoch
      ..isDirty = 1;

    if (position is Position) {
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
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureWidget("Saving image to db...", (String imagePath) async {
                  if (imagePath != null) {
                    String imageName = FileUtilities.nameFromFile(imagePath, true);
                    dbImage.text = "IMG_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(dbImage.timeStamp))}.jpg";
                    var imageId = await ImageWidgetUtilities.saveImageToSmashDb(context, imagePath, dbImage);
                    if (imageId != null) {
                      ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
                      if (projectState != null) projectState.reloadProject();
                      File file = File(imagePath);
                      if (file.existsSync()) {
                        await file.delete();
                      }
//                } else {
//                  showWarningDialog(
//                      context, "Could not save image in database.");
                    }
                  }
                  return true;
                })));
  }

  static void loadNotesMarkers(GeopaparazziProjectDb db, List<Marker> tmp, ProjectState projectState) async {
    List<Note> notesList = await db.getNotes();
    notesList.forEach((note) {
      NoteExt noteExt = note.noteExt;

      var iconData = getIcon(noteExt.marker);
      var iconColor = ColorExt(noteExt.color);

      tmp.add(Marker(
        width: noteExt.size,
        height: noteExt.size,
        point: new LatLng(note.lat, note.lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () {
            projectState.scaffoldKey.currentState.showSnackBar(SnackBar(
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
                                TableUtilities.cellForString(note.lon.toStringAsFixed(KEY_LATLONG_DECIMALS)),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableUtilities.cellForString("Latitude"),
                                TableUtilities.cellForString(note.lat.toStringAsFixed(KEY_LATLONG_DECIMALS)),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableUtilities.cellForString("Altitude"),
                                TableUtilities.cellForString(note.altim.toStringAsFixed(KEY_ELEV_DECIMALS)),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableUtilities.cellForString("Timestamp"),
                                TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp))),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableUtilities.cellForString("Has Form"),
                                TableUtilities.cellForString("${note.form != null}"),
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
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () {
                            if (note.form != null) {
                              var sectionMap = jsonDecode(note.form);
                              var sectionName = sectionMap[ATTR_SECTIONNAME];
                              Position p = Position(
                                latitude: note.lat,
                                longitude: note.lon,
                                altitude: -1,
                                heading: -1,
                                timestamp: DateTime.now(),
                              );
                              Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                      builder: (context) => MasterDetailPage(
                                            sectionMap,
                                            SmashUI.titleText(sectionName, color: SmashColors.mainBackground, bold: true),
                                            sectionName,
                                            p,
                                            note.id,
                                          )));
                            } else {
                              Navigator.push(ctx, MaterialPageRoute(builder: (context) => NotePropertiesWidget(note)));
                            }
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () async {
                            var doRemove = await showConfirmDialog(ctx, "Remove Note", "Are you sure you want to remove note ${note.id}?");
                            if (doRemove) {
                              await db.deleteNote(note.id);
                              await projectState.reloadProject(); // TODO check await
                            }
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
                          },
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: SmashColors.mainDecorationsDark,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () {
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
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
            iconData,
            size: noteExt.size,
            color: iconColor,
          ),
        )),
      ));
    });
  }

  static void loadImageMarkers(GeopaparazziProjectDb db, List<Marker> tmp, ProjectState projectState) async {
    // IMAGES
    var imagesList = await db.getImages();
    imagesList.forEach((image) async {
      var size = 48.0;
      var lat = image.lat;
      var lon = image.lon;
      var label =
          "image: ${image.text}\nlat: ${image.lat}\nlon: ${image.lon}\naltim: ${image.altim.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}";
      tmp.add(Marker(
        width: size,
        height: size,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
            child: GestureDetector(
          onTap: () async {
            var thumb = await db.getThumbnail(image.imageDataId);
            projectState.scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: SmashColors.snackBarColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SmashUI.normalText(label),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: SmashColors.mainDecorations)),
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          thumb,
                        ],
                      ),
                      onTap: () {
                        Navigator.push(ctx, MaterialPageRoute(builder: (context) => SmashImageZoomWidget(image)));
                        projectState.scaffoldKey.currentState.hideCurrentSnackBar();
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
                            var uint8list = await db.getImageDataBytes(image.imageDataId);
                            ShareHandler.shareImage(label, uint8list);
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: SmashColors.mainSelection,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () async {
                            var doRemove = await showConfirmDialog(ctx, "Remove Image", "Are you sure you want to remove image ${image.id}?");
                            if (doRemove) {
                              await db.deleteImage(image.id);
                              await projectState.reloadProject(); // TODO check await
                            }
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
                          },
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: SmashColors.mainDecorationsDark,
                          ),
                          iconSize: SmashUI.MEDIUM_ICON_SIZE,
                          onPressed: () {
                            projectState.scaffoldKey.currentState.hideCurrentSnackBar();
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
            getIcon('camera'),
            size: size,
            color: SmashColors.mainDecorationsDark,
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
      lines.add(Polyline(points: points, strokeWidth: width, color: ColorExt(color)));
    });

    return PolylineLayerOptions(
      polylines: lines,
    );
  }
}
