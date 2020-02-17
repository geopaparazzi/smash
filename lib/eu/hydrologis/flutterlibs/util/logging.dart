/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/diagnostic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stack_trace/stack_trace.dart';

/// [LogFilter] to show only errors in release mode, else the default.
///
/// Shows all logs with `level >= Logger.level` while in debug mode. In release
/// mode only errors to db.
class GpLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = event.level.index >=
        Level.error.index; // log errors always in release mode
    assert(() {
      // only done in debug
      if (event.level.index >= Logger.level.index) {
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
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print(line);
      _db.put(event.level, line);
    }
  }
}

class GpLogItem {
  String level;
  String message;
  int ts = DateTime
      .now()
      .millisecondsSinceEpoch;

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
  String _dbPath;

  Future<bool> init(String folder) async {
    try {
      GpLogger().d("Init LogDb with folder: $folder and app name: $DB_NAME");
      _dbPath = FileUtilities.joinPaths(folder, DB_NAME);
      _db = SqliteDb(_dbPath);
      await _db.openOrCreate(dbCreateFunction: createLogDatabase);
    } catch (e) {
      GpLogger().err("Error initializing LogDb", e);
      return false;
    }
    return true;
  }

  String get path => _dbPath;

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

  Logger internalLogger;
  LogDb _logDb;
  String _folder;

  factory GpLogger() => _instance;

  GpLogger._internal();

  Future<bool> init(String folder) async {
    if (internalLogger != null) return false;
    _folder = folder;
    d("Initializing GpLogger with folder: $_folder");

    _logDb = LogDb();
    await _logDb.init(_folder).then((ok) {
      if (ok) {
        internalLogger = Logger(
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
          output: DbOutput(_logDb),
        );
      }
    });
    return true;
  }

  String get folder => _folder;

  String get dbPath => _logDb?.path;

  v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.v(message, error, stackTrace);
    } else {
      print("PRELOGGER v: ${message.toString()}");
    }
  }

  d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.d(message, error, stackTrace);
    } else {
      print("PRELOGGER d: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      addToDiagnostic("DEBUG", message,
          bgColor: Colors.blue[100], iconColor: Colors.black);
    }
  }

  i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.i(message, error, stackTrace);
    } else {
      print("PRELOGGER i: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      addToDiagnostic("INFO", message,
          bgColor: Colors.yellow[100], iconColor: Colors.black);
    }
  }

  w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.w(message, error, stackTrace);
    } else {
      print("PRELOGGER w: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      addToDiagnostic("WARNING", message,
          bgColor: Colors.orange[100], iconColor: Colors.black);
    }
  }

  e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.e(message, error, stackTrace);
    } else {
      print("PRELOGGER e: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      if (error is StackTrace) {
        stackTrace = error;
      }
      var formatted = stackTrace != null ? Trace.format(stackTrace) : "";
      addToDiagnostic("ERROR", "$message\n$formatted",
          bgColor: Colors.red[100], iconColor: Colors.black);
    }
  }

  err(dynamic message, StackTrace stackTrace) {
    if (internalLogger != null) {
      internalLogger.e(message, "ERROR", stackTrace);
    } else {
      print("PRELOGGER err: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      var formatted = stackTrace != null ? Trace.format(stackTrace) : "";
      addToDiagnostic("ERROR", "$message\n$formatted",
          bgColor: Colors.red[100], iconColor: Colors.black);
    }
  }

  wtf(dynamic message, [dynamic error, StackTrace stackTrace]) {
    if (internalLogger != null) {
      internalLogger.wtf(message, error, stackTrace);
    } else {
      print("PRELOGGER wtf: ${message.toString()}");
    }
    if (DIAGNOSTIC_IS_ENABLED) {
      addToDiagnostic("WTF", message,
          bgColor: Colors.deepPurple[100], iconColor: Colors.black);
    }
  }
}
