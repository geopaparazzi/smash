/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/logging.dart';
import 'package:sqflite/sqflite.dart';
import 'package:latlong/latlong.dart';

abstract class QueryObjectBuilder<T> {
  String querySql();

  String insertSql();

  Map<String, dynamic> toMap(T item);

  T fromMap(Map<String, dynamic> map);
}

class SqliteDb {
  Database _db;
  var _dbPath;

  SqliteDb(this._dbPath);

  openOrCreate({Function dbCreateFunction}) async {
    _db = await openDatabase(
      _dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        if (dbCreateFunction != null) {
          await dbCreateFunction(db);
        }
      },
    );
  }

  String get path => _dbPath;

  bool isOpen() {
    if (_db == null) return false;
    return _db.isOpen;
  }

  close() {
    _db.close();
  }

  /// Get a list of items defined by the [queryObj].
  ///
  /// Optionally a custom [whereString] piece can be passed in. This needs to start with the word where.
  Future<List<T>> getQueryObjectsList<T>(QueryObjectBuilder<T> queryObj,
      {whereString: ""}) async {
    String querySql = "${queryObj.querySql()} $whereString";
    var res = await query(querySql);
    List<T> items = [];
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      var obj = queryObj.fromMap(map);
      items.add(obj);
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> query(String querySql) async {
    return _db.rawQuery(querySql);
  }

  Future<int> insert(String insertSql) async {
    return _db.rawInsert(insertSql);
  }

  Future<int> insertMap(String table, Map<String, dynamic> values) async {
    return _db.insert(table, values);
  }

  Future<int> update(String updateSql) async {
    return _db.rawUpdate(updateSql);
  }

  Future<int> updateMap(
      String table, Map<String, dynamic> values, String where) async {
    return _db.update(table, values, where: where);
  }

  Future<int> delete(String deleteSql) async {
    return _db.rawDelete(deleteSql);
  }

  Future<T> transaction<T>(Future<T> action(Transaction txn),
      {bool exclusive}) async {
    return await _db.transaction(action, exclusive: exclusive);
  }

  Future<List<String>> getTables(bool doOrder) async {
    List<String> tableNames = [];
    String orderBy = " ORDER BY name";
    if (!doOrder) {
      orderBy = "";
    }
    String sql =
        "SELECT name FROM sqlite_master WHERE type='table' or type='view'" +
            orderBy;
    var res = await query(sql);
    for (int i = 0; i < res.length; i++) {
      var name = res[i]['name'];
      tableNames.add(name);
    }
    return tableNames;
  }

  Future<bool> hasTable(String tableName) async {
    String sql = "SELECT name FROM sqlite_master WHERE type='table'";
    var res = await query(sql);
    getLogStartPosition() {}
    tableName = tableName.toLowerCase();
    for (int i = 0; i < res.length; i++) {
      String name = res[i]['name'];
      if (name.toLowerCase() == tableName) return true;
    }
    return false;
  }

  /**
   * Get the table columns from a non spatial db.
   *
   * @param db the db.
   * @param tableName the name of the table to get the columns for.
   * @return the list of table column information.
   * @throws Exception
   */
  Future<List<List<dynamic>>> getTableColumns(String tableName) async {
    String sql = "PRAGMA table_info(" + tableName + ")";
    List<List<dynamic>> columnsList = [];
    var res = await query(sql);
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      String colName = map['name'];
      String colType = map['type'];
      int isPk = map['pk'];
      columnsList.add([colName, colType, isPk]);
    }
    return columnsList;
  }
}

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
    List<Map<String, dynamic>> resNotes =
        await query("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes[0];
    var count = resNote["count"];
    return count;
  }

  Future<List<Note>> getNotes(bool onlyDirty) async {
    String where = "";
    if (onlyDirty) {
      where = " where $NOTES_COLUMN_ISDIRTY=1";
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

  /// Get the count of the current notes
  ///
  /// Get the count using [onlyDirty] to count only dirty notes.
  Future<int> getImagesCount(bool onlyDirty) async {
    String where = !onlyDirty ? "" : " where $NOTES_COLUMN_ISDIRTY = 1";
    List<Map<String, dynamic>> resNotes =
        await query("SELECT count(*) as count FROM $TABLE_NOTES$where");

    var resNote = resNotes[0];
    var count = resNote["count"];
    return count;
  }

  Future<List<Image>> getImages(bool onlyDirty) async {
    String where = !onlyDirty ? null : "where $IMAGES_COLUMN_ISDIRTY = 1";
    var images =
        await getQueryObjectsList(ImageQueryBuilder(), whereString: where);
    return images;
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
    var deleteSql =
        "delete from $TABLE_IMAGES where $IMAGES_COLUMN_NOTE_ID=$noteId";
    return await delete(deleteSql);
  }

  Future<int> deleteImage(int imageId) async {
    String sql = "delete from $TABLE_IMAGES where $IMAGES_COLUMN_ID=$imageId";
    return await delete(sql);
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

  /**
   * Delete a gps log by its id.
   *
   * @param id the log's id.
   * @throws IOException
   */
  Future<bool> deleteGpslog(int logId) async {
    await transaction((tx) {
      // delete log
      String sql = "delete from $TABLE_GPSLOGS where $LOGS_COLUMN_ID = $logId";
      tx.execute(sql);
      sql =
          "delete from $TABLE_GPSLOG_PROPERTIES where $LOGSPROP_COLUMN_LOGID = $logId";
      tx.execute(sql);
      sql =
          "delete from $TABLE_GPSLOG_DATA where $LOGSDATA_COLUMN_LOGID = $logId";
      tx.execute(sql);
    });
    return true;
  }

  /// Updates the end timestamp [endTs] of a log of id [logId].
  Future<int> updateGpsLogEndts(int logId, int endTs) async {
    var updatedId = await update(
        "update $TABLE_GPSLOGS set $LOGS_COLUMN_ENDTS=$endTs where $LOGS_COLUMN_ID=$logId");
    await updateLogLength(logId);
    return updatedId;
  }

  /// Updates the [name] of a log of id [logId].
  Future<int> updateGpsLogName(int logId, String name) async {
    var updatedId = await update(
        "update $TABLE_GPSLOGS set $LOGS_COLUMN_TEXT='$name' where $LOGS_COLUMN_ID=$logId");
    return updatedId;
  }

  /// Updates the [color] and [width] of a log of id [logId].
  Future<int> updateGpsLogStyle(int logId, String color, double width) async {
    var updatedId = await update(
        "update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_COLOR='$color', $LOGSPROP_COLUMN_WIDTH=$width where $LOGSPROP_COLUMN_LOGID=$logId");
    return updatedId;
  }

  /// Updates the [isVisible] of a log of id [logId].
  Future<int> updateGpsLogVisibility(bool isVisible, [int logId]) async {
    String where = "";
    if (logId != null) {
      where = " where $LOGSPROP_COLUMN_LOGID=$logId";
    }

    var updatedId = await update(
        "update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE=${isVisible ? 1 : 0}$where");
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
    Position previousPosition;
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      var lon = map[LOGSDATA_COLUMN_LON];
      var lat = map[LOGSDATA_COLUMN_LAT];
      var ts = map[LOGSDATA_COLUMN_TS];
      Position pos = Position(longitude: lon, latitude: lat);
      if (previousPosition != null) {
        var distanceMeters =
            await GpsHandler().getDistanceMeters(pos, previousPosition);
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
      count = await updateMap(
          TABLE_NOTESEXT, extMap, "$NOTESEXT_COLUMN_ID=$noteExtId");
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
        var split =
            CREATE_NOTESEXT_STATEMENT.replaceAll("\n", "").trim().split(";");
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
        print(
            "    ${tableColumn[0]} ${tableColumn[1]} ${tableColumn[2] == 1 ? "isPk" : ""} ");
      }
    }
  }
}
