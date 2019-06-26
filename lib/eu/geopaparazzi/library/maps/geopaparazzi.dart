/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables_methods.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables_objects.dart';
import 'package:latlong/latlong.dart';
import 'package:sqflite/sqflite.dart';

class GeopaparazziMapLoader {
  File _file;
  var _widgetState;

  GeopaparazziMapLoader(this._file, this._widgetState);

  loadProject() async {
    Database db = await openDatabase(_file.path);

    List<Marker> tmp = [];
    // IMAGES
    List<Map<String, dynamic>> resImages =
        await db.query("images", columns: ['lat', 'lon']);
    resImages.forEach((map) {
      var lat = map["lat"];
      var lon = map["lon"];
      tmp.add(Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
              child: Icon(
                Icons.image,
                size: 32,
                color: Colors.blue,
              ),
            ),
      ));
    });

    // NOTES
    List<Map<String, dynamic>> resNotes = await db.query(TABLE_NOTES, columns: [
      NOTES_COLUMN_LAT,
      NOTES_COLUMN_LON,
      NOTES_COLUMN_TEXT,
      NOTES_COLUMN_FORM
    ]);
    resNotes.forEach((map) {
      var lat = map[NOTES_COLUMN_LAT];
      var lon = map[NOTES_COLUMN_LON];
      var text = map[NOTES_COLUMN_TEXT];
      var label = "note: ${text}\nlat: ${lat}\nlon: ${lon}";
      tmp.add(Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(lat, lon),
        builder: (ctx) => new Container(
                child: GestureDetector(
              onTap: () {
                _widgetState.showSnackBar(SnackBar(
                  content: Text(label),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Icon(
                Icons.note,
                size: 32,
                color: Colors.green,
                semanticLabel: text,
              ),
            )),
      ));
    });

    String logsQuery = '''
        select l.$LOGS_COLUMN_ID, p.$LOGSPROP_COLUMN_COLOR, p.$LOGSPROP_COLUMN_WIDTH 
        from $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        where l.$LOGS_COLUMN_ID = p.$LOGSPROP_COLUMN_ID and p.$LOGSPROP_COLUMN_VISIBLE=1
    ''';
    List<Map<String, dynamic>> resLogs = await db.rawQuery(logsQuery);
    Map<int, List> logs = Map();
    resLogs.forEach((map) {
      var id = map['_id'];
      var color = map["color"];
      var width = map["width"];

      logs[id] = [color, width, <LatLng>[]];
    });

    addLogLines(tmp, logs, db);
  }

  void addLogLines(
      List<Marker> markers, Map<int, List> logs, Database db) async {
    String logDataQuery =
        "select $LOGSDATA_COLUMN_LAT, $LOGSDATA_COLUMN_LON, $LOGSDATA_COLUMN_LOGID from $TABLE_GPSLOG_DATA order by $LOGSDATA_COLUMN_LOGID, $LOGSDATA_COLUMN_TS";
    List<Map<String, dynamic>> resLogs = await db.rawQuery(logDataQuery);
    resLogs.forEach((map) {
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
      lines.add(
          Polyline(points: points, strokeWidth: width, color: ColorExt(color)));
    });

    _widgetState.geopapLogs = PolylineLayerOptions(
      polylines: lines,
    );
    _widgetState.geopapMarkers = markers;
  }
}
