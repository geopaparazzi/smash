part of smash_import_export;

/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

class GpxExporter {
  static Future<void> exportDb(
      ProjectDb db, File outputFile, bool doKml) async {
    var dbName = HU.FileUtilities.nameFromFile(db.getPath(), false);

    bool useFiltered = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, true);

    var gpx = Gpx();
    gpx.creator = "SMASH - http://www.geopaparazzi.eu using dart-gpx library.";
    gpx.metadata = Metadata();
    gpx.metadata?.keywords = "SMASH, export, notes, gps, log";
    gpx.metadata?.name = "SMASH GPX of project: $dbName";
    gpx.metadata?.time = DateTime.now();
    List<Wpt> wpts = [];
    gpx.wpts = wpts;

    List<Note> notesList = db.getNotes();
    notesList.forEach((note) {
      var nameStr = note.text;
      var descrStr = note.description;
      if (note.hasForm()) {
        nameStr = FormUtilities.getFormItemLabel(note.form!, nameStr);
        descrStr = note.text;
      }

      var wpt = Wpt(
        lat: note.lat,
        lon: note.lon,
        ele: note.altim,
        name: nameStr,
        desc: descrStr,
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
      List<LogDataPoint> logDataPoints = db.getLogDataPoints(log.id!);
      logDataPoints.forEach((logPoint) {
        var wpt = Wpt(
          lat: useFiltered ? logPoint.filtered_lat : logPoint.lat,
          lon: useFiltered ? logPoint.filtered_lon : logPoint.lon,
          ele: logPoint.altim,
          name: logPoint.id.toString(),
          time: DateTime.fromMillisecondsSinceEpoch(logPoint.ts!),
          cmt: logPoint.accuracy != null ? "acc: ${logPoint.accuracy}m" : null,
        );
        segmentPts.add(wpt);
      });
      Trkseg logSegment = Trkseg(trkpts: segmentPts);
      List<Trkseg> segments = [logSegment];
      var t = Trk(
          name: log.text,
          number: log.id,
          trksegs: segments,
          cmt:
              "${HU.TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(log.startTime!))} - ${HU.TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(log.endTime!))}");
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

  static Future<void> exportLog(
      ProjectDb db, int logId, String outputFolderPath,
      {bool doKml = false}) async {
    bool useFiltered = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, true);

    Log? log = db.getLogById(logId);
    if (log != null) {
      var parentLogName = log.text ?? "no name log";
      var gpx = Gpx();
      gpx.creator =
          "SMASH - http://www.geopaparazzi.eu using dart-gpx library.";
      gpx.metadata = Metadata();
      gpx.metadata?.keywords = "SMASH, export, log";
      gpx.metadata?.name = "$parentLogName";
      gpx.metadata?.time = DateTime.now();
      List<Wpt> wpts = [];
      gpx.wpts = wpts;

      List<Trk> trks = [];
      gpx.trks = trks;

      final logIds = <int>[log.id!];
      // collect children if any
      var childLogs = db.getChildLogs(log.id!);
      childLogs.forEach((childLog) {
        logIds.add(childLog.id!);
      });

      for (final id in logIds) {
        final log = db.getLogById(id);
        if (log == null) continue;

        final logName = (log.text == null || log.text!.trim().isEmpty)
            ? "log_$id"
            : log.text!.trim();

        List<Wpt> segmentPts = [];
        List<LogDataPoint> logDataPoints = db.getLogDataPoints(log.id!);
        logDataPoints.forEach((logPoint) {
          var wpt = Wpt(
            lat: useFiltered ? logPoint.filtered_lat : logPoint.lat,
            lon: useFiltered ? logPoint.filtered_lon : logPoint.lon,
            ele: logPoint.altim,
            name: logPoint.id.toString(),
            time: DateTime.fromMillisecondsSinceEpoch(logPoint.ts!),
          );
          segmentPts.add(wpt);
        });
        Trkseg logSegment = Trkseg(trkpts: segmentPts);
        List<Trkseg> segments = [logSegment];
        var t = Trk(name: logName, number: log.id, trksegs: segments);
        trks.add(t);
      }
      var ext = doKml ? "kml" : "gpx";
      parentLogName =
          parentLogName.replaceAll(" ", "_").replaceAll("\\s+", "_");
      var outFilePath =
          HU.FileUtilities.joinPaths(outputFolderPath, "$parentLogName.$ext");
      var outputFile = File(outFilePath);
      if (doKml) {
        var kmlString = KmlWriter().asString(gpx, pretty: true);
        await outputFile.writeAsString(kmlString);
      } else {
        var gpxString = GpxWriter().asString(gpx, pretty: true);
        await outputFile.writeAsString(gpxString);

        // now also export the style
        var fileName = HU.FileUtilities.nameFromFile(outFilePath, false);
        var sldPath =
            HU.FileUtilities.joinPaths(outputFolderPath, fileName + ".sld");

        // create style
        var sldString = HU.DefaultSlds.simpleLineSld();
        var style = HU.SldObjectParser.fromString(sldString);
        style.parse();
        LineStyle? lineStyle;
        var fts = style.featureTypeStyles.first;
        if (fts.rules.isNotEmpty) {
          var rule = fts.rules.first;
          if (rule.lineSymbolizers.isNotEmpty) {
            lineStyle = rule.lineSymbolizers.first.style;
          }
        }
        if (lineStyle != null) {
          var logProp = db.getLogProperties(logId);
          if (logProp != null) {
            lineStyle.strokeColorHex = logProp.color != null
                ? ColorExt.asHex(ColorExt(logProp.color!))
                : '#FF0000';
            lineStyle.strokeWidth = logProp.width ?? 3.0;
          }
        }
        sldString = HU.SldObjectBuilder.buildFromFeatureTypeStyles(
            style.featureTypeStyles);
        HU.FileUtilities.writeStringToFile(sldPath, sldString);
      }
    }
  }
}

class KmlExporter {
  String IMAGES_SEPARATOR = ";";
  late String dbName;
  late bool useFiltered;

  Future<void> exportDb(ProjectDb db, File outputFile) async {
    dbName = HU.FileUtilities.nameFromFile(db.getPath(), false);

    useFiltered = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, true);

    var kmlString = "";
    kmlString += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    kmlString +=
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\"\n";
    kmlString +=
        "xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n";
    kmlString += "<Document>\n";
    kmlString += "<name>";
    kmlString += makeXmlSafe(dbName);
    kmlString += "</name>\n";
    kmlString += getMarker("red-pushpin",
        "http://maps.google.com/mapfiles/kml/pushpin/red-pushpin.png", 20, 2);
    kmlString += getMarker("yellow-pushpin",
        "http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png", 20, 2);
    kmlString += getMarker("bookmark-icon",
        "http://maps.google.com/mapfiles/kml/pal4/icon39.png", 16, 16);
    kmlString += getMarker("camera-icon",
        "http://maps.google.com/mapfiles/kml/pal4/icon38.png", 16, 16);
    kmlString += getMarker("info-icon",
        "http://maps.google.com/mapfiles/kml/pal3/icon35.png", 16, 16);

    var notes = db.getNotes();
    for (Note note in notes) {
      kmlString += noteToKmlString(db, note);
    }
    var logs = db.getLogs();
    for (Log log in logs) {
      kmlString += logToKmlString(db, log);
    }
    var simpleImages = db.getImages(onlySimple: true);
    for (DbImage image in simpleImages) {
      kmlString += simpleImageToKmlString(db, image);
    }
    kmlString += "</Document>\n";
    kmlString += "</kml>\n";

    final archive = Archive();
    archive.addFile(ArchiveFile.string("kml.kml", kmlString));

    var images = db.getImages(onlySimple: false);
    for (var image in images) {
      var imgBytes = db.getImageDataBytes(image.imageDataId!);
      archive.addFile(
          ArchiveFile.noCompress(image.text, imgBytes!.length, imgBytes));
    }
    var zipData = ZipEncoder().encode(archive, modified: DateTime.now())!;
    await outputFile.writeAsBytes(zipData);
  }

  String logToKmlString(ProjectDb db, Log log) {
    String name = makeXmlSafe(log.text);
    var sB = "";
    sB += "<Placemark>\n";
    sB += "<name>${name}</name>\n";
    sB += "<visibility>1</visibility>\n";
    sB += "<LineString>\n";
    sB += "<tessellate>1</tessellate>\n";
    sB += "<coordinates>\n";

    List<LogDataPoint> logDataPoints = db.getLogDataPointsById(log.id!);
    for (LogDataPoint point in logDataPoints) {
      sB += "${point.lon},${point.lat},1 \n";
    }
    sB += "</coordinates>\n";
    sB += "</LineString>\n";
    sB += "<Style>\n";
    sB += "<LineStyle>\n";
    // int parsedColor = ColorUtilities.toColor(color);
    LogProperty? logProperties = db.getLogProperties(log.id!);
    String hexColor = logProperties!.color ?? "#FF0000";

    // remove colortables
    hexColor = "FF" + hexColor.split("@")[0].substring(1);

    sB += "<color>${hexColor}</color>\n";
    sB += "<width>${logProperties.width}</width>\n";
    sB += "</LineStyle>\n";
    sB += "</Style>\n";
    sB += "</Placemark>\n";

    return sB.toString();
  }

  String noteToKmlString(ProjectDb db, Note note) {
    var images = [];
    String name = makeXmlSafe(note.text);
    if (note.hasForm()) {
      name = makeXmlSafe(FormUtilities.getFormItemLabel(note.form!, name));
    }
    var sB = "<Placemark>\n";
    sB += "<styleUrl>#red-pushpin</styleUrl>\n";
    // sB += "<styleUrl>#info-icon</styleUrl>\n";
    sB += "<name>${name}</name>\n";
    sB += "<description>\n";

    if (note.hasForm()) {
      sB += "<![CDATA[\n";

      Map<String, dynamic> sectionObject = jsonDecode(note.form!);
      if (sectionObject.containsKey(ATTR_SECTIONNAME)) {
        String sectionName = sectionObject[ATTR_SECTIONNAME];
        sB += "<h1>${sectionName}</h1>\n";
      }

      List<String> formsNames = TagsManager.getFormNames4Section(sectionObject);
      for (String formName in formsNames) {
        sB += "<h2>${formName}</h2>\n";

        sB +=
            "<table style=\"text-align: left; width: 100%;\" border=\"1\" cellpadding=\"5\" cellspacing=\"2\">";
        sB += "<tbody>";

        Map<String, dynamic>? form4Name =
            TagsManager.getForm4Name(formName, sectionObject);
        List<Map<String, dynamic>> formItems =
            TagsManager.getFormItems(form4Name);
        for (int i = 0; i < formItems.length; i++) {
          Map<String, dynamic> formItem = formItems[i];
          if (!formItem.containsKey(TAG_KEY)) {
            continue;
          }

          String type = formItem[TAG_TYPE];
          String key = formItem[TAG_KEY];
          String value = formItem[TAG_VALUE];

          String label = key;
          if (formItem.containsKey(TAG_LABEL)) {
            label = formItem[TAG_LABEL];
          }

          if (type == TYPE_PICTURES) {
            if (value.trim().length == 0) {
              continue;
            }
            var imageIdsSplit = value.split(IMAGES_SEPARATOR);
            for (String imageId in imageIdsSplit) {
              DbImage image = db.getImageById(int.parse(imageId));
              String imgName = image.text;
              sB += "<tr>";
              sB +=
                  "<td colspan=\"2\" style=\"text-align: left; vertical-align: top; width: 100%;\">";
              sB += "<img src=\"${imgName}\" width=\"300\">";
              sB += "</td>";
              sB += "</tr>";

              images.add(imageId);
            }
          } else if (type == TYPE_MAP) {
            if (value.trim().length == 0) {
              continue;
            }
            sB += "<tr>";
            String imageId = value.trim();
            DbImage image = db.getImageById(int.parse(imageId));
            String imgName = image.text;
            sB +=
                "<td colspan=\"2\" style=\"text-align: left; vertical-align: top; width: 100%;\">";
            sB += "<img src=\"${imgName}\" width=\"300\">";
            sB += "</td>";
            sB += "</tr>";
            images.add(imageId);
          } else if (type == TYPE_SKETCH) {
            if (value.trim().length == 0) {
              continue;
            }
            var imageIdsSplit = value.split(IMAGES_SEPARATOR);
            for (String imageId in imageIdsSplit) {
              DbImage image = db.getImageById(int.parse(imageId));
              String imgName = image.text;
              sB += "<tr>";
              sB +=
                  "<td colspan=\"2\" style=\"text-align: left; vertical-align: top; width: 100%;\">";
              sB += "<img src=\"${imgName}\" width=\"300\">";
              sB += "</td>";
              sB += "</tr>";

              images.add(imageId);
            }
          } else {
            sB += "<tr>";
            sB +=
                "<td style=\"text-align: left; vertical-align: top; width: 50%;\">";
            sB += label;
            sB += "</td>";
            sB +=
                "<td style=\"text-align: left; vertical-align: top; width: 50%;\">";
            sB += value;
            sB += "</td>";
            sB += "</tr>";
          }
        }
        sB += "</tbody>";
        sB += "</table>";
      }
      sB += "]]>\n";
    } else {
      String description = makeXmlSafe(note.description);
      sB += description;
      sB += "\n";
      sB += TimeUtilities.ISO8601_TS_FORMATTER_MILLIS
          .format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp));
    }

    sB += "</description>\n";
    sB += "<gx:balloonVisibility>1</gx:balloonVisibility>\n";
    sB += "<Point>\n";
    sB += "<coordinates>";
    sB += note.lon.toString();
    sB += ",";
    sB += note.lat.toString();
    sB += ",0</coordinates>\n";
    sB += "</Point>\n";
    sB += "</Placemark>\n";

    return sB.toString();
  }

  String simpleImageToKmlString(ProjectDb db, DbImage image) {
    String name = makeXmlSafe(image.text);
    var kml = """
    <Placemark>
      <styleUrl>#camera-icon</styleUrl>
      <name>${name}</name>
      <description>
        <![CDATA[
          <h1>${name}</h1>
          <table style="text-align: left; width: 100%;" border="1" cellpadding="5" cellspacing="2">
            <tbody>
              <tr>
                <td colspan="2" style="text-align: left; vertical-align: top; width: 100%;">
                  <img src="${name}" width="300">
                </td>
              </tr>
            </tbody>
          </table>
        ]]>
      </description>
      <gx:balloonVisibility>1</gx:balloonVisibility>
      <Point>
        <coordinates>${image.lon.toString()},${image.lat.toString()},0</coordinates>
      </Point>
    </Placemark>
    """;

    return kml;
  }

  String makeXmlSafe(String? string) {
    if (string == null) return "";
    string = string.replaceAll("&", "&amp;");
    return string;
  }

  String getMarker(String alias, String url, int x, int y) {
    var sb = """
      <Style id="${alias}">
        <IconStyle>
          <scale>1.1</scale>
          <Icon>
            <href>${url}</href>
          </Icon>
          <hotSpot x="${x.toString()}" y="${y.toString()}" xunits="pixels" yunits="pixels" />
        </IconStyle>
        <ListStyle>
        </ListStyle>
      </Style>
    """;
    return sb;
  }
}
