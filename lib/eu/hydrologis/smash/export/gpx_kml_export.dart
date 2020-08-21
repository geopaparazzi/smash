/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:gpx/gpx.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/smashlibs.dart';

class GpxExporter {
  static Future<void> exportDb(
      GeopaparazziProjectDb db, File outputFile, bool doKml) async {
    var dbName = HU.FileUtilities.nameFromFile(db.path, false);

    bool useFiltered =
        GpPreferences().getBooleanSync(KEY_GPS_USE_FILTER_GENERALLY, false);

    var gpx = Gpx();
    gpx.creator = "SMASH - http://www.geopaparazzi.eu using dart-gpx library.";
    gpx.metadata = Metadata();
    gpx.metadata.keywords = "SMASH, export, notes, gps, log";
    gpx.metadata.name = "SMASH PDF Report of project: $dbName";
    gpx.metadata.time = DateTime.now();
    List<Wpt> wpts = [];
    gpx.wpts = wpts;

    List<Note> notesList = db.getNotes();
    notesList.forEach((note) {
      var wpt = Wpt(
        lat: note.lat,
        lon: note.lon,
        ele: note.altim,
        name: note.text,
        desc: note.description,
        time: DateTime.fromMillisecondsSinceEpoch(note.timeStamp),
      );
      wpts.add(wpt);
    });

    var images = db.getImages();
    images.forEach((img) {
      var wpt = Wpt(
        lat: img.lat,
        lon: img.lon,
        ele: img.altim,
        name: img.text,
        desc: "Note id: ${img.noteId}",
        time: DateTime.fromMillisecondsSinceEpoch(img.timeStamp),
      );
      wpts.add(wpt);
    });

    List<Trk> trks = [];
    gpx.trks = trks;

    var logs = db.getLogs();
    logs.forEach((log) {
      List<Wpt> segmentPts = [];
      List<LogDataPoint> logDataPoints = db.getLogDataPoints(log.id);
      logDataPoints.forEach((logPoint) {
        var wpt = Wpt(
          lat: useFiltered ? logPoint.filtered_lat : logPoint.lat,
          lon: useFiltered ? logPoint.filtered_lon : logPoint.lon,
          ele: logPoint.altim,
          name: logPoint.id.toString(),
          time: DateTime.fromMillisecondsSinceEpoch(logPoint.ts),
        );
        segmentPts.add(wpt);
      });
      Trkseg logSegment = Trkseg(trkpts: segmentPts);
      List<Trkseg> segments = [logSegment];
      var t = Trk(name: log.text, number: log.id, trksegs: segments);
      trks.add(t);
    });

    if (doKml) {
      var kmlString = KmlWriter().asString(gpx, pretty: true);
      await outputFile.writeAsString(kmlString);
    } else {
      var gpxString = GpxWriter().asString(gpx, pretty: true);
      await outputFile.writeAsString(gpxString);
    }
  }
}
