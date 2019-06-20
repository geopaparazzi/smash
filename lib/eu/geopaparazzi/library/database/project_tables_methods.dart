/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:sqflite/sqflite.dart';
import 'package:latlong/latlong.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';

import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables_objects.dart';

/////////////////////////////////////
/////////////////////////////////////
/// NOTES
/////////////////////////////////////
/////////////////////////////////////

/// Get the count of the current notes
///
/// Get the count on a given [db], using [onlyDirty] to count only dirty notes.
Future<int> getNotesCount(Database db, bool onlyDirty) async {
  String where = !onlyDirty ? "" : " where ${NOTES_COLUMN_ISDIRTY} = 1";
  List<Map<String, dynamic>> resNotes = await db
      .rawQuery("SELECT count(*) as count FROM ${TABLE_NOTES} ${where}");

  var resNote = resNotes[0];
  var count = resNote["count"];
  return count;
}

/*
 * Add a note.
 *
 * @param db the database.
 * @param note the note to insert.
 * @return the inserted note id.
 */
Future<int> addNote(Database db, Note note) {
  var noteId = db.insert(TABLE_NOTES, note.toMap());
  return noteId;
}

/////////////////////////////////////
/////////////////////////////////////
/// LOGS
/////////////////////////////////////
/////////////////////////////////////

/// Get the count of the current logs
///
/// Get the count on a given [db], using [onlyDirty] to count only dirty notes.
Future<int> getGpsLogCount(Database db, bool onlyDirty) async {
  String where = !onlyDirty ? "" : " where ${LOGS_COLUMN_ISDIRTY} = 1";
  var sql = "SELECT count(*) as count FROM ${TABLE_GPSLOGS}${where}";
  List<Map<String, dynamic>> resMap = await db.rawQuery(sql);

  var res = resMap[0];
  var count = res["count"];
  return count;
}

Future<int> addGpsLog(Database db, Log insertLog, LogProperty prop) async {
  // TODO use transaction
  int insertedId = await db.insert(TABLE_GPSLOGS, insertLog.toMap());
  prop.logid = insertedId;
  await db.insert(TABLE_GPSLOG_PROPERTIES, prop.toMap());
  return insertedId;
}

Future<int> addGpsLogPoint(
    Database db, int logId, LogDataPoint logPoint) async {
  logPoint.logid = logId;
  int insertedId = await db.insert(TABLE_GPSLOG_DATA, logPoint.toMap());
  return insertedId;
}

Future<int> updateGpsLogEndts(Database db, int logId, int endTs) async {
  var updatedId = await db.rawUpdate(
      "update ${TABLE_GPSLOGS} set ${LOGS_COLUMN_ENDTS}=${endTs} where ${LOGS_COLUMN_ID}=${logId}");
  return updatedId;
}