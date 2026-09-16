part of smash_import_export;

/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

const TITLE_GPKG = "Geopackage";

class GeopackageExportPlugin extends AExportPlugin {
  late ProjectDb projectDb;
  late BuildContext context;

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  Icon getIcon() {
    return Icon(
      MdiIcons.packageVariant,
      color: SmashColors.mainDecorations,
    );
  }

  @override
  String getTitle() {
    return TITLE_GPKG;
  }

  @override
  String getDescription() {
    return SL.of(context).exportWidget_exportToGeopackage;
  }

  @override
  void setProjectDatabase(ProjectDb projectDb) {
    this.projectDb = projectDb;
  }

  @override
  Widget getExportPage() {
    return GeopackageExportWidget(
      projectDb: projectDb,
    );
  }

  @override
  Widget? getSettingsPage() {
    return null;
  }
}

class GeopackageExportWidget extends StatefulWidget {
  final ProjectDb projectDb;
  GeopackageExportWidget({Key? key, required this.projectDb}) : super(key: key);

  @override
  State<GeopackageExportWidget> createState() => _GeopackageExportWidgetState();
}

class _GeopackageExportWidgetState extends State<GeopackageExportWidget> {
  bool buildingWithout = false;
  bool buildingWith = false;
  String? error;
  late String outFilePath;

  @override
  Widget build(BuildContext context) {
    var w = ScreenUtilities.getWidth(context);
    return Scaffold(
        appBar: AppBar(title: const Text(TITLE_GPKG)),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: w / 3,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    buildingWith = true;
                  });
                  try {
                    await buildGeopackage(true);
                  } catch (e) {
                    error = e.toString();
                  }
                  setState(() {
                    buildingWith = false;
                  });
                },
                child: buildingWith
                    ? SmashCircularProgress()
                    : SmashUI.titleText("Export with images",
                        color: SmashColors.mainDecorations, bold: true),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              width: w / 3,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    buildingWithout = true;
                  });
                  try {
                    await buildGeopackage(false);
                  } catch (e) {
                    error = e.toString();
                  }
                  setState(() {
                    buildingWithout = false;
                  });
                },
                child: buildingWithout
                    ? SmashCircularProgress()
                    : SmashUI.titleText("Export without images",
                        color: SmashColors.mainDecorations, bold: true),
              ),
            ),
            if (error != null) SmashUI.errorWidget(error!),
          ],
        )));
  }

  // building
  //           ? Center(
  //               child: SmashCircularProgress(),
  //             )
  //           : error != null
  //               ? SmashUI.errorWidget(error!)
  //               : Center(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       SmashUI.titleText(
  //                         SL.of(context).exportWidget_geopackageExported,
  //                       ),
  //                       SmashUI.smallText(
  //                         outFilePath,
  //                       ),
  //                     ],
  //                   ),
  //                 ));

  Future<void> buildGeopackage(bool withImages) async {
    var exportsFolder = await Workspace.getExportsFolder();
    var ts = HU.TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now());
    outFilePath =
        HU.FileUtilities.joinPaths(exportsFolder.path, "smash_export_$ts.gpkg");
    String? errorString = await GeopackageExporter.exportDb(
        widget.projectDb, File(outFilePath), withImages);

    if (errorString != null) {
      setState(() {
        buildingWithout = false;
        error = errorString;
      });
    } else {
      setState(() {
        buildingWithout = false;
      });
    }
  }
}

class GeopackageExporter {
  static Future<String?> exportDb(
      ProjectDb db, File outputFile, bool withImages) async {
    if (await outputFile.exists()) {
      return "Not writing over existing file.";
    }
    bool useFiltered = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, true);

    GeopackageDb newDb = GeopackageDb(outputFile.path);
    newDb.openOrCreate();

    exportNotesTable(newDb, db);
    if (withImages) {
      exportImagesTable(newDb, db);
    } else {
      exportImagesTableWithout(newDb, db);
    }
    exportLogsTable(newDb, db, useFiltered);

    newDb.close();

    return null;
  }

  static void exportNotesTable(GeopackageDb newDb, ProjectDb gpDb) {
    newDb.createSpatialTable(
      TableName(TABLE_NOTES, schemaSupported: false),
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
    for (var note in notesList) {
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
        note.noteExt?.marker,
        note.noteExt?.size,
        note.noteExt?.rotation,
        note.noteExt?.color,
        note.noteExt?.accuracy,
        note.noteExt?.heading,
        note.noteExt?.speed,
        note.noteExt?.speedaccuracy,
      ]);
    }
  }

  static void exportImagesTable(GeopackageDb newDb, ProjectDb gpDb) {
    newDb.createSpatialTable(
      TableName(TABLE_IMAGES, schemaSupported: false),
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
    var images = gpDb.getImages(onlySimple: false);
    for (var img in images) {
      if (img.id != null) {
        var point = gf.createPoint(Coordinate(img.lon, img.lat));
        var geomBytes = GeoPkgGeomWriter().write(point);

        var imageDataBytes = gpDb.getImageDataBytes(img.id!);
        var thumbnailBytes = gpDb.getThumbnailBytes(img.id!);

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
      }
    }
  }

  static void exportImagesTableWithout(GeopackageDb newDb, ProjectDb gpDb) {
    newDb.createSpatialTable(
      TableName(TABLE_IMAGES, schemaSupported: false),
      4326,
      "the_geom POINT",
      [
        "$IMAGES_COLUMN_ID  INTEGER PRIMARY KEY AUTOINCREMENT",
        "$IMAGES_COLUMN_ALTIM  REAL NOT NULL",
        "$IMAGES_COLUMN_AZIM REAL NOT NULL",
        "$IMAGES_COLUMN_TS TEXT NOT NULL",
        "$IMAGES_COLUMN_TEXT TEXT NOT NULL",
        "$IMAGES_COLUMN_ISDIRTY  INTEGER",
        "$IMAGESDATA_COLUMN_IMAGE BLOB",
        "$IMAGESDATA_COLUMN_THUMBNAIL BLOB",
      ],
      null,
      false,
    );

    var sql = """
                INSERT INTO $TABLE_IMAGES (the_geom, $IMAGES_COLUMN_ID, $IMAGES_COLUMN_ALTIM,
                    $IMAGES_COLUMN_AZIM, $IMAGES_COLUMN_TS, $IMAGES_COLUMN_TEXT, $IMAGES_COLUMN_ISDIRTY
                ) 
                VALUES (?,?,?,?,?,?,?);
                """;

    var gf = GeometryFactory.defaultPrecision();
    var images = gpDb.getImages(onlySimple: false);
    for (var img in images) {
      if (img.id != null) {
        var point = gf.createPoint(Coordinate(img.lon, img.lat));
        var geomBytes = GeoPkgGeomWriter().write(point);

        newDb.execute(sql, arguments: [
          geomBytes,
          img.id,
          img.altim,
          img.azim,
          HU.TimeUtilities.ISO8601_TS_FORMATTER
              .format(DateTime.fromMillisecondsSinceEpoch(img.timeStamp)),
          img.text,
          img.isDirty,
        ]);
      }
    }
  }

  static void exportLogsTable(
      GeopackageDb newDb, ProjectDb db, bool useFiltered) {
    newDb.createSpatialTable(
      TableName(TABLE_GPSLOGS, schemaSupported: false),
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
      TableName(TABLE_GPSLOG_DATA, schemaSupported: false),
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
    for (var log in logs) {
      if (log.id == null) {
        continue;
      }
      List<Coordinate> coordinates = [];
      List<LogDataPoint> logDataPoints = db.getLogDataPoints(log.id!);
      for (var logPoint in logDataPoints) {
        Coordinate coordinate;
        if (useFiltered) {
          coordinate =
              Coordinate(logPoint.filtered_lon!, logPoint.filtered_lat!);
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
              .format(DateTime.fromMillisecondsSinceEpoch(logPoint.ts!)),
          logPoint.logid,
        ]);
      }

      var logProperties = db.getLogProperties(log.id!);

      var line = gf.createLineString(coordinates);
      var geomBytes = GeoPkgGeomWriter().write(line);
      newDb.execute(sqlLogs, arguments: [
        geomBytes,
        log.id,
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(log.startTime!)),
        HU.TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(log.endTime!)),
        log.lengthm,
        log.isDirty,
        log.text,
        logProperties!.color,
        logProperties.width,
      ]);
    }
  }
}
