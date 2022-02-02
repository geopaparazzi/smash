/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:typed_data';
import 'dart:ui';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

const int MAXBLOBSIZE = 1000000;

class GeopaparazziProjectDb extends SqliteDb implements ProjectDb {
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

  open({Function populateFunction}) {
    super.open(populateFunction: createDatabase);
  }

  @override
  String getPath() {
    return path;
  }

  @override
  int getNotesCount(bool onlyDirty) {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    var resNotes = select("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes.first;
    var count = resNote.get("count");
    return count;
  }

  @override
  int getSimpleNotesCount(bool onlyDirty) {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where ($NOTES_COLUMN_FORM is null or $NOTES_COLUMN_FORM='')";
    var resNotes = select("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes.first;
    var count = resNote.get("count");
    return count;
  }

  @override
  int getFormNotesCount(bool onlyDirty) {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    if (where.isEmpty) {
      where = " where ";
    } else {
      where = "$where and ";
    }
    where = "$where $NOTES_COLUMN_FORM is not null and $NOTES_COLUMN_FORM<>''";
    var resNotes = select("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes.first;
    var count = resNote.get("count");
    return count;
  }

  @override
  List<Note> getNotes({bool doSimple, bool onlyDirty: false}) {
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
        where =
            "$where $NOTES_COLUMN_FORM is not null and $NOTES_COLUMN_FORM<>''";
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
      from $TABLE_NOTES n left join $TABLE_NOTESEXT nex
      on n.$NOTES_COLUMN_ID=nex.$NOTESEXT_COLUMN_NOTEID
      $where
    ''';

    List<Note> notes = [];
    var resNotes = select(sql);
    resNotes.forEach((QueryResultRow resNoteMap) {
      Note note = Note()
        ..id = resNoteMap.get(NOTES_COLUMN_ID)
        ..lon = resNoteMap.get(NOTES_COLUMN_LON)
        ..lat = resNoteMap.get(NOTES_COLUMN_LAT)
        ..altim = resNoteMap.get(NOTES_COLUMN_ALTIM)
        ..timeStamp = resNoteMap.get(NOTES_COLUMN_TS)
        ..description = resNoteMap.get(NOTES_COLUMN_DESCRIPTION)
        ..text = resNoteMap.get(NOTES_COLUMN_TEXT)
        ..form = resNoteMap.get(NOTES_COLUMN_FORM)
        ..style = resNoteMap.get(NOTES_COLUMN_STYLE)
        ..isDirty = resNoteMap.get(NOTES_COLUMN_ISDIRTY);

      // we can add the extended part
      NoteExt noteExt = NoteExt();
      if (resNoteMap.get(extid) != null) {
        noteExt.id = resNoteMap.get(extid);
        noteExt.noteId = note.id;
        var marker = resNoteMap.get(NOTESEXT_COLUMN_MARKER);
        if (marker != null) noteExt.marker = marker;
        var _size = resNoteMap.get(NOTESEXT_COLUMN_SIZE);
        if (_size != null) noteExt.size = _size;
        var _rotation = resNoteMap.get(NOTESEXT_COLUMN_ROTATION);
        if (_rotation != null) noteExt.rotation = _rotation;
        var _color = resNoteMap.get(NOTESEXT_COLUMN_COLOR);
        if (_color != null) noteExt.color = _color;
        noteExt.accuracy = resNoteMap.get(NOTESEXT_COLUMN_ACCURACY);
        noteExt.heading = resNoteMap.get(NOTESEXT_COLUMN_HEADING);
        noteExt.speed = resNoteMap.get(NOTESEXT_COLUMN_SPEED);
        noteExt.speedaccuracy = resNoteMap.get(NOTESEXT_COLUMN_SPEEDACCURACY);
      } else {
        // insert the note ext
        noteExt.noteId = note.id;
        int noteExtId = addNoteExt(noteExt);
        noteExt.id = noteExtId;
      }
      note.noteExt = noteExt;
      notes.add(note);
    });
    return notes;
  }

  @override
  Note getNoteById(int id) {
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
    var resNotes = select(sql);
    var resNoteMap = resNotes.first;

    Note note = Note()
      ..id = resNoteMap.get(NOTES_COLUMN_ID)
      ..lon = resNoteMap.get(NOTES_COLUMN_LON)
      ..lat = resNoteMap.get(NOTES_COLUMN_LAT)
      ..altim = resNoteMap.get(NOTES_COLUMN_ALTIM)
      ..timeStamp = resNoteMap.get(NOTES_COLUMN_TS)
      ..description = resNoteMap.get(NOTES_COLUMN_DESCRIPTION)
      ..text = resNoteMap.get(NOTES_COLUMN_TEXT)
      ..form = resNoteMap.get(NOTES_COLUMN_FORM)
      ..style = resNoteMap.get(NOTES_COLUMN_STYLE)
      ..isDirty = resNoteMap.get(NOTES_COLUMN_ISDIRTY);

    // we can add the extended part
    NoteExt noteExt = NoteExt();
    if (resNoteMap.get(extid) != null) {
      noteExt.id = resNoteMap.get(extid);
      noteExt.noteId = note.id;
      var marker = resNoteMap.get(NOTESEXT_COLUMN_MARKER);
      if (marker != null) noteExt.marker = marker;
      var _size = resNoteMap.get(NOTESEXT_COLUMN_SIZE);
      if (_size != null) noteExt.size = _size;
      var _rotation = resNoteMap.get(NOTESEXT_COLUMN_ROTATION);
      if (_rotation != null) noteExt.rotation = _rotation;
      var _color = resNoteMap.get(NOTESEXT_COLUMN_COLOR);
      if (_color != null) noteExt.color = _color;
      noteExt.accuracy = resNoteMap.get(NOTESEXT_COLUMN_ACCURACY);
      noteExt.heading = resNoteMap.get(NOTESEXT_COLUMN_HEADING);
      noteExt.speed = resNoteMap.get(NOTESEXT_COLUMN_SPEED);
      noteExt.speedaccuracy = resNoteMap.get(NOTESEXT_COLUMN_SPEEDACCURACY);
    } else {
      // insert the note ext
      noteExt.noteId = note.id;
      int noteExtId = addNoteExt(noteExt);
      noteExt.id = noteExtId;
    }
    note.noteExt = noteExt;
    notes.add(note);
    return note;
  }

  @override
  int getImagesCount(bool onlyDirty) {
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
    var resImages = select("SELECT count(*) as count FROM $TABLE_IMAGES$where");

    var resImage = resImages.first;
    var count = resImage.get("count");
    return count;
  }

  @override
  List<DbImage> getImages({bool onlyDirty = false, bool onlySimple = true}) {
    List<String> wheres = [];

    if (onlyDirty) {
      wheres.add("$IMAGES_COLUMN_ISDIRTY=1");
    }
    if (onlySimple) {
      wheres.add("$IMAGES_COLUMN_NOTE_ID is null");
    }
    var where = wheres.join(" and ");
    var images = getQueryObjectsList(ImageQueryBuilder(), whereString: where);
    return images;
  }

  @override
  DbImage getImageById(int imageId) {
    String where = "where $IMAGES_COLUMN_ID=$imageId";
    var images = getQueryObjectsList(ImageQueryBuilder(), whereString: where);
    return images[0];
  }

  @override
  Image getThumbnail(int imageDataId) {
    var uint8list = getThumbnailBytes(imageDataId);
    if (uint8list != null) {
      return ImageWidgetUtilities.imageFromBytes(uint8list);
    }
    return null;
  }

  @override
  Uint8List getThumbnailBytes(int imageDataId) {
    var imageDataList = getQueryObjectsList(
        ImageDataQueryBuilder(doData: false, doThumb: true),
        whereString: "where $IMAGESDATA_COLUMN_ID=$imageDataId");
    if (imageDataList != null && imageDataList.length == 1) {
      DbImageData imgDataMap = imageDataList.first;
      if (imgDataMap != null && imgDataMap.thumb != null) {
        return imgDataMap.thumb;
      }
    }
    return null;
  }

  @override
  Image getImage(int imageDataId) {
    Uint8List imageDataBytes = getImageDataBytes(imageDataId);
    if (imageDataBytes != null)
      return ImageWidgetUtilities.imageFromBytes(imageDataBytes);
    return null;
  }

  @override
  Uint8List getImageDataBytes(int imageDataId) {
    Uint8List imageDataBytes;
    var whereStr = "where $IMAGESDATA_COLUMN_ID=$imageDataId";
    try {
      List<DbImageData> imageDataList = getQueryObjectsList(
          ImageDataQueryBuilder(doData: true, doThumb: false),
          whereString: whereStr);
      if (imageDataList != null && imageDataList.length == 1) {
        DbImageData imgDataMap = imageDataList.first;
        if (imgDataMap != null && imgDataMap.data != null) {
          imageDataBytes = imgDataMap.data;
        }
      }
    } catch (ex) {
      String sizeQuery =
          "SELECT $IMAGESDATA_COLUMN_ID, length($IMAGESDATA_COLUMN_IMAGE) as blobsize FROM $TABLE_IMAGE_DATA $whereStr";
      var res = select(sizeQuery);
      if (res.length == 1) {
        int blobSize = res.first.get('blobsize');
        List<int> total = List();
        if (blobSize > MAXBLOBSIZE) {
          for (int i = 1; i <= blobSize; i = i + MAXBLOBSIZE) {
            int from = i;
            int size = MAXBLOBSIZE;
            if (from + size > blobSize) {
              size = blobSize - from + 1;
            }
            String tmpQuery =
                "SELECT substr($IMAGESDATA_COLUMN_IMAGE, $from, $size) as partialblob FROM $TABLE_IMAGE_DATA $whereStr";
            var res2 = select(tmpQuery);
            var partial = res2.first.get('partialblob');
            total.addAll(partial);
          }
          imageDataBytes = Uint8List.fromList(total);
        }
      }
    }
    return imageDataBytes;
  }

  @override
  int addNote(Note note) {
    var noteId = insertMap(SqlName(TABLE_NOTES), note.toMap());
    note.id = noteId;
    if (note.noteExt == null) {
      NoteExt noteExt = NoteExt();
      noteExt.noteId = note.id;
      int noteExtId = addNoteExt(noteExt);
      noteExt.id = noteExtId;
      note.noteExt = noteExt;
    } else {
      note.noteExt.noteId = noteId;
      int extid = addNoteExt(note.noteExt);
      note.noteExt.id = extid;
    }
    return noteId;
  }

  @override
  int addNoteExt(NoteExt noteExt) {
    var noteExtId = insertMap(SqlName(TABLE_NOTESEXT), noteExt.toMap());
    return noteExtId;
  }

  @override
  int deleteNote(int noteId) {
    var sql = "delete from $TABLE_NOTES where $NOTES_COLUMN_ID=$noteId";
    var deletedCount = execute(sql);

    deleteImageByNoteId(noteId);
    return deletedCount;
  }

  @override
  int deleteImageByNoteId(int noteId) {
    var deleteSql =
        "delete from $TABLE_IMAGES where $IMAGES_COLUMN_NOTE_ID=$noteId";
    return execute(deleteSql);
  }

  @override
  int deleteImage(int imageId) {
    String sql = "delete from $TABLE_IMAGES where $IMAGES_COLUMN_ID=$imageId";
    return execute(sql);
  }

  @override
  int updateNoteImages(int noteId, List<int> imageIds) {
    if (imageIds == null || imageIds.isEmpty) {
      return 0;
    }
    var idsJoin = imageIds.join(',');
    var updateSql =
        "update $TABLE_IMAGES set $IMAGES_COLUMN_NOTE_ID=$noteId where $IMAGES_COLUMN_ID in (${idsJoin})";
    var updatedIds = execute(updateSql);
    return updatedIds;
  }

  @override
  int getGpsLogCount(bool onlyDirty) {
    String where = !onlyDirty ? "" : " where $LOGS_COLUMN_ISDIRTY = 1";
    var sql = "SELECT count(*) as count FROM $TABLE_GPSLOGS$where";
    var resMap = select(sql);

    var res = resMap.first;
    var count = res.get("count");
    return count;
  }

  @override
  List<Log> getLogs({bool onlyDirty: false}) {
    String where = "";
    if (onlyDirty) {
      where = " where $LOGS_COLUMN_ISDIRTY=1";
    }
    String logsQuery = '''
        select $LOGS_COLUMN_ID, $LOGS_COLUMN_STARTTS, $LOGS_COLUMN_ENDTS, $LOGS_COLUMN_TEXT, $LOGS_COLUMN_ISDIRTY, $LOGS_COLUMN_LENGTHM
        from $TABLE_GPSLOGS
        $where
    ''';

    var resLogs = select(logsQuery);
    List<Log> logs = [];
    resLogs.forEach((QueryResultRow map) {
      Log log = Log()
        ..id = map.get(LOGS_COLUMN_ID)
        ..startTime = map.get(LOGS_COLUMN_STARTTS)
        ..endTime = map.get(LOGS_COLUMN_ENDTS)
        ..text = map.get(LOGS_COLUMN_TEXT)
        ..isDirty = map.get(LOGS_COLUMN_ISDIRTY)
        ..lengthm = map.get(LOGS_COLUMN_LENGTHM);
      logs.add(log);
    });
    return logs;
  }

  @override
  Log getLogById(int logId) {
    String logsQuery = '''
        select $LOGS_COLUMN_ID, $LOGS_COLUMN_STARTTS, $LOGS_COLUMN_ENDTS, $LOGS_COLUMN_TEXT, $LOGS_COLUMN_ISDIRTY, $LOGS_COLUMN_LENGTHM
        from $TABLE_GPSLOGS
        where $LOGS_COLUMN_ID=$logId
    ''';

    var resLogs = select(logsQuery);
    if (resLogs.length == 1) {
      var map = resLogs.first;
      Log log = Log()
        ..id = map.get(LOGS_COLUMN_ID)
        ..startTime = map.get(LOGS_COLUMN_STARTTS)
        ..endTime = map.get(LOGS_COLUMN_ENDTS)
        ..text = map.get(LOGS_COLUMN_TEXT)
        ..isDirty = map.get(LOGS_COLUMN_ISDIRTY)
        ..lengthm = map.get(LOGS_COLUMN_LENGTHM);
      return log;
    }
    return null;
  }

  @override
  List<LogDataPoint> getLogDataPoints(int logId) {
    String logDataQuery = """
            select $LOGSDATA_COLUMN_ID, $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_LON, 
              $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_ALTIM, $LOGSDATA_COLUMN_TS ,
              $LOGSDATA_COLUMN_LAT_FILTERED, $LOGSDATA_COLUMN_LON_FILTERED, 
              $LOGSDATA_COLUMN_ACCURACY_FILTERED
            from $TABLE_GPSLOG_DATA where $LOGSDATA_COLUMN_LOGID=$logId
            order by $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_TS
            """;
    List<LogDataPoint> points = [];
    var resLogData = select(logDataQuery);
    resLogData.forEach((QueryResultRow map) {
      LogDataPoint point = LogDataPoint()
        ..id = map.get(LOGSDATA_COLUMN_ID)
        ..lat = map.get(LOGSDATA_COLUMN_LAT)
        ..lon = map.get(LOGSDATA_COLUMN_LON)
        ..logid = map.get(LOGSDATA_COLUMN_LOGID)
        ..altim = map.get(LOGSDATA_COLUMN_ALTIM)
        ..ts = map.get(LOGSDATA_COLUMN_TS)
        ..filtered_lon = map.get(LOGSDATA_COLUMN_LON_FILTERED)
        ..filtered_lat = map.get(LOGSDATA_COLUMN_LAT_FILTERED)
        ..filtered_accuracy = map.get(LOGSDATA_COLUMN_ACCURACY_FILTERED);
      points.add(point);
    });
    return points;
  }

  @override
  LogProperty getLogProperties(int logId) {
    String logPropQuery = """
            select $LOGSPROP_COLUMN_ID, $LOGSPROP_COLUMN_COLOR, $LOGSPROP_COLUMN_VISIBLE, 
            $LOGSPROP_COLUMN_WIDTH,$LOGSPROP_COLUMN_LOGID
            from $TABLE_GPSLOG_PROPERTIES where $LOGSPROP_COLUMN_LOGID=$logId
            """;
    var resLogData = select(logPropQuery);
    if (resLogData.length == 1) {
      var map = resLogData.first;
      LogProperty prop = LogProperty()
        ..id = map.get(LOGSPROP_COLUMN_ID)
        ..color = map.get(LOGSPROP_COLUMN_COLOR)
        ..isVisible = map.get(LOGSPROP_COLUMN_VISIBLE)
        ..width = map.get(LOGSPROP_COLUMN_WIDTH)
        ..logid = map.get(LOGSPROP_COLUMN_LOGID);
      return prop;
    }
    return null;
  }

  /// Get the start position coordinate of a log identified by [logId].
  LatLng getLogStartPosition(int logId) {
    var sql = '''
      select $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LAT from $TABLE_GPSLOG_DATA 
      where $LOGSDATA_COLUMN_LOGID=$logId
      order by $LOGSDATA_COLUMN_TS 
      limit 1
    ''';

    var resList = select(sql);
    if (resList.length == 1) {
      var map = resList.first;
      var lon = map.get(LOGSDATA_COLUMN_LON);
      var lat = map.get(LOGSDATA_COLUMN_LAT);
      return LatLng(lat, lon);
    }
    return null;
  }

  @override
  List<LogDataPoint> getLogDataPointsById(int logId) {
    var sql = '''
      select $LOGSDATA_COLUMN_ID, $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_ALTIM, $LOGSDATA_COLUMN_TS 
      from $TABLE_GPSLOG_DATA 
      where $LOGSDATA_COLUMN_LOGID=$logId
      order by $LOGSDATA_COLUMN_TS 
    ''';

    List<LogDataPoint> data = [];
    var resList = select(sql);
    resList.forEach((QueryResultRow map) {
      LogDataPoint ldp = LogDataPoint()
        ..id = map.get(LOGSDATA_COLUMN_ID)
        ..logid = map.get(LOGSDATA_COLUMN_LOGID)
        ..lon = map.get(LOGSDATA_COLUMN_LON)
        ..lat = map.get(LOGSDATA_COLUMN_LAT)
        ..altim = map.get(LOGSDATA_COLUMN_ALTIM)
        ..ts = map.get(LOGSDATA_COLUMN_TS);
      data.add(ldp);
    });
    return data;
  }

  @override
  int addGpsLog(Log insertLog, LogProperty prop) {
    Transaction(this).runInTransaction((GeopaparazziProjectDb _db) {
      int insertedId = _db.insertMap(SqlName(TABLE_GPSLOGS), insertLog.toMap());
      prop.logid = insertedId;
      insertLog.id = insertedId;
      _db.insertMap(SqlName(TABLE_GPSLOG_PROPERTIES), prop.toMap());
    });

    return insertLog.id;
  }

  @override
  int addGpsLogPoint(int logId, LogDataPoint logPoint) {
    logPoint.logid = logId;
    int insertedId = insertMap(SqlName(TABLE_GPSLOG_DATA), logPoint.toMap());
    return insertedId;
  }

  @override
  bool deleteGpslog(int logId) {
    return Transaction(this).runInTransaction((GeopaparazziProjectDb _db) {
      // delete log
      String sql = "delete from $TABLE_GPSLOGS where $LOGS_COLUMN_ID = $logId";
      _db.execute(sql);
      sql =
          "delete from $TABLE_GPSLOG_PROPERTIES where $LOGSPROP_COLUMN_LOGID = $logId";
      _db.execute(sql);
      sql =
          "delete from $TABLE_GPSLOG_DATA where $LOGSDATA_COLUMN_LOGID = $logId";
      _db.execute(sql);
      return true;
    });
  }

  @override
  bool mergeGpslogs(int logId, List<int> mergeLogs) {
    return Transaction(this).runInTransaction((GeopaparazziProjectDb _db) {
      for (var mergeLogId in mergeLogs) {
        // assign all data of the log to the new log
        String sql =
            "update $TABLE_GPSLOG_DATA set $LOGSDATA_COLUMN_LOGID=$logId where $LOGSDATA_COLUMN_LOGID=$mergeLogId";
        _db.execute(sql);
        // then remove log and properties
        sql = "delete from $TABLE_GPSLOGS where $LOGS_COLUMN_ID = $mergeLogId";
        _db.execute(sql);
        sql =
            "delete from $TABLE_GPSLOG_PROPERTIES where $LOGSPROP_COLUMN_LOGID = $mergeLogId";
        _db.execute(sql);
      }

      // update log stats
      _db.updateLogLength(logId);
      var newEndTs = _db.getLogDataPoints(logId).last.ts;
      _db.updateGpsLogEndts(logId, newEndTs);

      return true;
    });
  }

  @override
  int updateGpsLogEndts(int logId, int endTs) {
    var updatedId = execute(
        "update $TABLE_GPSLOGS set $LOGS_COLUMN_ENDTS=$endTs where $LOGS_COLUMN_ID=$logId");
    updateLogLength(logId);
    return updatedId;
  }

  @override
  int updateGpsLogName(int logId, String name) {
    var updatedId = execute(
        "update $TABLE_GPSLOGS set $LOGS_COLUMN_TEXT='$name' where $LOGS_COLUMN_ID=$logId");
    return updatedId;
  }

  @override
  int updateGpsLogStyle(int logId, String color, double width) {
    var updatedId = execute(
        "update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_COLOR='$color', $LOGSPROP_COLUMN_WIDTH=$width where $LOGSPROP_COLUMN_LOGID=$logId");
    return updatedId;
  }

  @override
  int updateGpsLogVisibility(bool isVisible, [int logId]) {
    String where = "";
    if (logId != null) {
      where = " where $LOGSPROP_COLUMN_LOGID=$logId";
    }

    var updatedId = execute(
        "update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE=${isVisible ? 1 : 0}$where");
    return updatedId;
  }

  @override
  int invertGpsLogsVisibility() {
    String sql = '''
      update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE= CASE
        WHEN $LOGSPROP_COLUMN_VISIBLE = 1 THEN 0
                       ELSE 1
        END
    ''';
    var updatedId = execute(sql);
    return updatedId;
  }

  @override
  double updateLogLength(int logId) {
    var sql = '''
      SELECT $LOGSDATA_COLUMN_LON,$LOGSDATA_COLUMN_LAT,$LOGSDATA_COLUMN_TS 
      FROM $TABLE_GPSLOG_DATA 
      WHERE $LOGSDATA_COLUMN_LOGID=$logId
      ORDER BY $LOGSDATA_COLUMN_TS ASC
    ''';
    double summedDistance = 0.0;

    var res = select(sql);
    LatLng previousPosition;
    res.forEach((QueryResultRow map) {
      var lon = map.get(LOGSDATA_COLUMN_LON);
      var lat = map.get(LOGSDATA_COLUMN_LAT);
      // var ts = map.get(LOGSDATA_COLUMN_TS);
      LatLng pos = LatLng(lat, lon);
      if (previousPosition != null) {
        var distanceMeters =
            CoordinateUtilities.getDistance(pos, previousPosition);
        summedDistance += distanceMeters;
      }
      previousPosition = pos;
    });

    // update the value
    String updateSql = '''
      update $TABLE_GPSLOGS set $LOGS_COLUMN_LENGTHM=$summedDistance 
      where $LOGS_COLUMN_ID=$logId;
    ''';
    var updateNums = execute(updateSql);
    if (updateNums != 1) {
      return null;
    }
    return summedDistance;
  }

  @override
  int updateNote(Note note) {
    note.isDirty = 1; // set the note to dirty again
    var map = note.toMap();
    var noteId = map.remove(NOTES_COLUMN_ID);

    int count =
        updateMap(SqlName(TABLE_NOTES), map, "$NOTES_COLUMN_ID=$noteId");
    if (count == 1) {
      var extMap = note.noteExt.toMap();
      int noteExtId = extMap.remove(NOTESEXT_COLUMN_ID);
      extMap.remove(NOTESEXT_COLUMN_NOTEID);
      int extCount = updateMap(
          SqlName(TABLE_NOTESEXT), extMap, "$NOTESEXT_COLUMN_ID=$noteExtId");
      if (extCount != 1) {
        SMLogger().e(
            "Note ext values not updated for note $noteId and noteext $noteExtId",
            null,
            null);
      }
    } else {
      SMLogger().e("Note not updated for note $noteId", null, null);
    }
    return count;
  }

  @override
  void updateDirty(bool doDirty) {
    var dirty = 1;
    if (!doDirty) {
      dirty = 0;
    }
    String updateSql = 'update $TABLE_GPSLOGS set $LOGS_COLUMN_ISDIRTY=$dirty;';
    execute(updateSql);
    updateSql = 'update $TABLE_IMAGES set $IMAGES_COLUMN_ISDIRTY=$dirty;';
    execute(updateSql);
    updateSql = 'update $TABLE_NOTES set $NOTES_COLUMN_ISDIRTY=$dirty;';
    execute(updateSql);
  }

  @override
  void updateNoteDirty(int noteId, bool doDirty) {
    var dirty = doDirty ? 1 : 0;
    String updateSql =
        'update $TABLE_NOTES set $NOTES_COLUMN_ISDIRTY=$dirty where $NOTES_COLUMN_ID=$noteId;';
    execute(updateSql);
  }

  @override
  void updateImageDirty(int imageId, bool doDirty) {
    var dirty = doDirty ? 1 : 0;
    String updateSql =
        'update $TABLE_IMAGES set $IMAGES_COLUMN_ISDIRTY=$dirty where $IMAGES_COLUMN_ID=$imageId;';
    execute(updateSql);
  }

  @override
  void updateLogDirty(int logId, bool doDirty) {
    var dirty = doDirty ? 1 : 0;
    String updateSql =
        'update $TABLE_GPSLOGS set $LOGS_COLUMN_ISDIRTY=$dirty where $LOGS_COLUMN_ID=$logId;';
    execute(updateSql);
  }

  /// Create the geopaparazzi project database.
  createDatabase(SqliteDb db) async {
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

    db.transaction((_db) {
      var split = createTablesQuery.replaceAll("\n", "").trim().split(";");
      for (int i = 0; i < split.length; i++) {
        var sql = split[i].trim();
        if (sql.length > 0 && !sql.startsWith("--")) {
          _db.execute(sql);
        }
      }
    });
  }

  createNecessaryExtraTables() {
    bool hasNotesExt = hasTable(SqlName(TABLE_NOTESEXT));
    if (!hasNotesExt) {
      SMLogger().w("Adding extra database table $TABLE_NOTESEXT.");
      Transaction(this).runInTransaction((GeopaparazziProjectDb _db) {
        var split =
            CREATE_NOTESEXT_STATEMENT.replaceAll("\n", "").trim().split(";");
        for (int i = 0; i < split.length; i++) {
          var sql = split[i].trim();
          if (sql.length > 0 && !sql.startsWith("--")) {
            _db.execute(sql);
          }
        }
      });
    }

    var tableColumns = getTableColumns(SqlName(TABLE_GPSLOG_DATA));
    bool hasFiltered = false;
    tableColumns.forEach((list) {
      String name = list[0];
      if (name.toLowerCase() == LOGSDATA_COLUMN_LAT_FILTERED) {
        hasFiltered = true;
      }
    });
    if (!hasFiltered) {
      SMLogger().w("Adding extra columns for filtered data to log.");
      Transaction(this).runInTransaction((GeopaparazziProjectDb _db) {
        String sql =
            "alter table $TABLE_GPSLOG_DATA add column $LOGSDATA_COLUMN_ACCURACY real;";
        _db.execute(sql);
        sql =
            "alter table $TABLE_GPSLOG_DATA add column $LOGSDATA_COLUMN_ACCURACY_FILTERED real;";
        _db.execute(sql);
        sql =
            "alter table $TABLE_GPSLOG_DATA add column $LOGSDATA_COLUMN_LAT_FILTERED real;";
        _db.execute(sql);
        sql =
            "alter table $TABLE_GPSLOG_DATA add column $LOGSDATA_COLUMN_LON_FILTERED real;";
        _db.execute(sql);
      });
    }
  }

  void printInfo() {
    var tableNames = getTables(doOrder: true);
    for (int i = 0; i < tableNames.length; i++) {
      var tableName = tableNames[i];
      var has = hasTable(tableName);
      print("$tableName found: $has");
      var tableColumns = getTableColumns(tableName);
      for (int j = 0; j < tableColumns.length; j++) {
        var tableColumn = tableColumns[j];
        print(
            "    ${tableColumn[0]} ${tableColumn[1]} ${tableColumn[2] == 1 ? "isPk" : ""} ");
      }
    }
  }
}
