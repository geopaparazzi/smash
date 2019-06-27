/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:sqflite/sqflite.dart';

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
  Future<List<T>> getQueryObjectsList<T>(QueryObjectBuilder<T> queryObj) async {
    String querySql = queryObj.querySql();
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

  insert(String insertSql) async {
    return _db.rawInsert(insertSql);
  }

  Future<int> insertMap(String table, Map<String, dynamic> values) async {
    return _db.insert(table, values);
  }

  update(String updateSql) async {
    return _db.rawUpdate(updateSql);
  }

  delete(String deleteSql) async {
    return _db.rawDelete(deleteSql);
  }

  Future<T> transaction<T>(Future<T> action(Transaction txn),
      {bool exclusive}) {
    return _db.transaction(action, exclusive: exclusive);
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

/*
 * Add a note.
 *
 * @param note the note to insert.
 * @return the inserted note id.
 */
  Future<int> addNote(Note note) {
    var noteId = insertMap(TABLE_NOTES, note.toMap());
    return noteId;
  }

  /// Delete a note by its [noteId].
  Future<int> deleteNote(int noteId) async {
    var sql = "delete from $TABLE_NOTES where $NOTES_COLUMN_ID=$noteId";
    var deletedCount = await delete(sql);
    return deletedCount;
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
  Future<int> updateGpsLogVisibility(int logId, bool isVisible) async {
    var updatedId = await update(
        "update $TABLE_GPSLOG_PROPERTIES set $LOGSPROP_COLUMN_VISIBLE=${isVisible ? 1 : 0} where $LOGSPROP_COLUMN_LOGID=$logId");
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
    String insert = '''
    update $TABLE_GPSLOGS set $LOGS_COLUMN_LENGTHM=$summedDistance 
    where $LOGS_COLUMN_ID=$logId;
  ''';
    var updateNums = await update(insert);
    if (updateNums != 1) {
      return null;
    }
    return summedDistance;
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

  createNecessaryExtraTables() async{
    bool has = await hasTable(TABLE_NOTESEXT);
    if(!has){
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
        print(
            "    ${tableColumn[0]} ${tableColumn[1]} ${tableColumn[2] == 1 ? "isPk" : ""} ");
      }
    }
  }
}
