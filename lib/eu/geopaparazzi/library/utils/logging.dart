/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:logger/logger.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/database.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/files.dart';
import 'package:sqflite/sqflite.dart';

/// [LogFilter] to show only errors in release mode, else the default.
///
/// Shows all logs with `level >= Logger.level` while in debug mode. In release
/// mode only errors to db.
class GpLogFilter extends LogFilter {
  @override
  bool shouldLog(Level level, message, [error, StackTrace stackTrace]) {
    var shouldLog =
        level.index >= Level.error.index; // log errors always in release mode
    assert(() {
      // only done in debug
      if (level.index >= Logger.level.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}

class DbOutput extends LogOutput {
  LogDb _db;

  DbOutput(this._db);

  @override
  void output(Level level, List<String> lines) {
    for (var line in lines) {
      print(line);
      _db.put(level, line);
    }
  }
}

class GpLogItem {
  String level;
  String message;
  int ts = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      LogDb.level_NAME: level,
      LogDb.message_NAME: message,
      LogDb.TimeStamp_NAME: ts,
    };
  }
}

class LogDb {
  static final String DB_NAME = "gp_debug.sqlite";
  static final String TABLE_NAME = "debug";
  static final String ID_NAME = "id";
  static final String message_NAME = "msg";
  static final String TimeStamp_NAME = "ts";
  static final String level_NAME = "level";

  static final String CREATE_STATEMENT = '''
    CREATE TABLE $TABLE_NAME (
      $ID_NAME INTEGER PRIMARY KEY AUTOINCREMENT,
      $TimeStamp_NAME INTEGER,
      $level_NAME TEXT,
      $message_NAME TEXT
    );"
  ''';

  SqliteDb _db;

  Future<bool> init() async {
    try {
      var configFolder = await FileUtils.getApplicationConfigurationFolder();
      var dbPath = FileUtils.joinPaths(configFolder.path, DB_NAME);
      _db = SqliteDb(dbPath);
      await _db.openOrCreate(dbCreateFunction: createLogDatabase);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  createLogDatabase(Database db) async {
    await db.execute(CREATE_STATEMENT);
  }

  void put(Level level, String message) async {
    var item = GpLogItem()
      ..level = level.toString()
      ..message = message;
    await _db.insertMap(TABLE_NAME, item.toMap());
  }
}

/// Geopaparazzi logger singleton class.
///
/// Logs to console and a database on the device.
class GpLogger {
  static final GpLogger _instance = GpLogger._internal();

  Logger _logger;

  factory GpLogger() => _instance;

  GpLogger._internal();

  Future<bool> init() async {
    if (_logger != null) return false;

    LogDb logDb = LogDb();
    logDb.init().then((ok) {
      if (ok) {
        _logger = Logger(
          printer: PrettyPrinter(
              methodCount: 2,
              // number of method calls to be displayed
              errorMethodCount: 8,
              // number of method calls if stacktrace is provided
              lineLength: 120,
              // width of the output
              colors: true,
              // Colorful log messages
              printEmojis: true,
              // Print an emoji for each log message
              printTime: false // Should each log print contain a timestamp
              ),
          filter: GpLogFilter(),
          output: DbOutput(logDb),
        );
      }
    });
    return true;
  }

  v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.v(message, error, stackTrace);
    } else {
      print("PRELOGGER v: ${message.toString()}");
    }
  }

  d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.d(message, error, stackTrace);
    } else {
      print("PRELOGGER d: ${message.toString()}");
    }
  }

  i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.i(message, error, stackTrace);
    } else {
      print("PRELOGGER i: ${message.toString()}");
    }
  }

  w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.w(message, error, stackTrace);
    } else {
      print("PRELOGGER w: ${message.toString()}");
    }
  }

  e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.e(message, error, stackTrace);
    } else {
      print("PRELOGGER e: ${message.toString()}");
    }
  }

  err(dynamic message, StackTrace stackTrace) {
    if (_logger != null) {
      _logger.e(message, "ERROR", stackTrace);
    } else {
      print("PRELOGGER err: ${message.toString()}");
    }
  }

  wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (_logger != null) {
      _logger.wtf(message, error, stackTrace);
    } else {
      print("PRELOGGER wtf: ${message.toString()}");
    }
  }
}
