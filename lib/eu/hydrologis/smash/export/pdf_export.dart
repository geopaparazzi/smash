/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart' as HU;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as IMG;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class PdfExporter {
  static final String novalue = "-nv-";
  static final int EXPORT_IMG_LONGSIZE = 280;

  static Future<void> exportDb(GeopaparazziProjectDb db, File outputFile) async {
    var dbName = HU.FileUtilities.nameFromFile(db.path, false);

    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")),
    );

    final pw.Document pdf = pw.Document(
      author: "Smash User",
      keywords: "SMASH, export, notes, gps, log",
      creator: "SMASH - http://www.geopaparazzi.eu using flutter pdf package",
      title: "SMASH PDF Report of project: $dbName",
      subject: "SMASH PDF Export",
      theme: myTheme,
    );

    ByteData smashLogoBytes = await rootBundle.load("assets/smash_logo_64.png");
    final smashLogo = pw.MemoryImage(
      smashLogoBytes.buffer.asUint8List(),
    );

    List<Note> simpleNotesList = db.getNotes(doSimple: true);

    List<List<String>> simpleNotesTable = [];
    if (simpleNotesList.isNotEmpty) {
      simpleNotesTable.add(['id', 'lon', 'lat', 'altim', 'text', 'date', 'accur', 'head', 'speed']);
      simpleNotesList.forEach((note) {
        List<String> row = [];
        row.add(note.id.toString());
        row.add(note.lon.toStringAsFixed(6));
        row.add(note.lat.toStringAsFixed(6));
        row.add("${note.altim.toInt()}m");
        row.add(note.text);
        row.add(HU.TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp)));
        var noteExt = note.noteExt;

        if (noteExt != null) {
          if (noteExt.accuracy != null) {
            row.add("${noteExt.accuracy.toInt()}m");
          } else {
            row.add(novalue);
          }
          if (noteExt.heading != null) {
            row.add("${noteExt.heading.toInt()}");
          } else {
            row.add(novalue);
          }
          if (noteExt.speed != null) {
            row.add("${noteExt.speed.toStringAsFixed(1)}m/s");
          } else {
            row.add(novalue);
          }
        } else {
          row.add(novalue);
          row.add(novalue);
          row.add(novalue);
        }
        simpleNotesTable.add(row);
      });
    }

    List<Note> formNotesList = db.getNotes(doSimple: false);
    List<pw.Widget> formWidgetList = [];
    if (formNotesList.isNotEmpty) {
      formWidgetList.add(
        pw.Header(level: 1, text: 'Forms'),
      );
      for (var i = 0; i < formNotesList.length; i++) {
        Note note = formNotesList[i];
        formWidgetList.add(pw.Header(level: 2, text: note.text));

        String formJson = note.form;
        Map<String, dynamic> sectionMap = jsonDecode(formJson);
//      var sectionName = sectionMap[ATTR_SECTIONNAME];
        List<String> formNames = TagsManager.getFormNames4Section(sectionMap);
        for (var j = 0; j < formNames.length; j++) {
          var formName = formNames[j];
          formWidgetList.add(pw.Header(level: 3, text: formName));

          var form4name = TagsManager.getForm4Name(formName, sectionMap);
          List<dynamic> formItems = TagsManager.getFormItems(form4name);

          for (var k = 0; k < formItems.length; k++) {
            var itemMap = formItems[k];
            String label = TagsManager.getLabelFromFormItem(itemMap);

            dynamic value = ""; //$NON-NLS-1$
            if (itemMap.containsKey(TAG_VALUE)) {
              value = itemMap[TAG_VALUE].trim();
            }
            String type = TYPE_STRING;
            if (itemMap.containsKey(TAG_TYPE)) {
              type = itemMap[TAG_TYPE].trim();
            }

            if (type == TYPE_PICTURES || type == TYPE_IMAGELIB) {
              try {
                var valueString = value.toString().trim();
                var idSplit = valueString.split(";");
                if (valueString.isEmpty) {
                  idSplit = [];
                }
                for (var i = 0; i < idSplit.length; i++) {
                  var imageId = int.parse(idSplit[i]);
                  DbImage image = db.getImageById(imageId);
                  var p = pw.Paragraph(text: image.text, textAlign: pw.TextAlign.center);
                  formWidgetList.add(p);

                  Uint8List imageDataBytes = db.getImageDataBytes(image.imageDataId);
                  List<int> resizeImage = HU.ImageUtilities.resizeImage(imageDataBytes, longestSizeTo: EXPORT_IMG_LONGSIZE);

                  final pdfImage = pw.MemoryImage(resizeImage);

                  var c = pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
                    pw.Center(
                        child: pw.Image(
                      pdfImage,
                      fit: pw.BoxFit.none,
                    )),
                  ]);
                  formWidgetList.add(c);
                }
              } on Exception catch (e, s) {
                SMLogger().e("Error exporting image to pdf document", e, s);
              }
            } else if (type == TYPE_DYNAMICSTRING) {
              var p = pw.Paragraph(text: '$label: ');
              formWidgetList.add(p);
              List<String> valueSplit = value.toString().split(";");
              valueSplit.forEach((v) {
                var b = pw.Bullet(text: v);
                formWidgetList.add(b);
              });
            } else if (type == TYPE_LABEL || type == TYPE_LABELWITHLINE) {
              String sizeStr = "20";
              if (itemMap.containsKey(TAG_SIZE)) {
                sizeStr = itemMap[TAG_SIZE];
              }
              double size = double.parse(sizeStr);

//            var textDecoration;
//            if(type==TYPE_LABELWITHLINE){
//              textDecoration = TextDecoration.underline;
//            }

              var p = pw.Paragraph(text: '$value', style: pw.TextStyle(fontSize: size));
              formWidgetList.add(p);
            } else {
              var p = pw.Paragraph(text: '$label: $value');
              formWidgetList.add(p);
            }
          }
        }

        formWidgetList.add(
          pw.Header(level: 1, text: 'Image notes'),
        );

        List<DbImage> images = db.getImages();
        for (var i = 0; i < images.length; i++) {
          DbImage image = images[i];

          var p = pw.Paragraph(text: image.text);
          formWidgetList.add(p);
          formWidgetList.addAll([
            pw.Bullet(text: "latitude: ${image.lat}"),
            pw.Bullet(text: "longitude: ${image.lon}"),
            pw.Bullet(text: "altimetry: ${image.altim}m"),
            pw.Bullet(text: "azimuth: ${image.azim}"),
            pw.Bullet(text: "timestamp: ${HU.TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}"),
          ]);
          Uint8List imageDataBytes = db.getImageDataBytes(image.imageDataId);
          List<int> resizeImage = HU.ImageUtilities.resizeImage(imageDataBytes, longestSizeTo: EXPORT_IMG_LONGSIZE);

          final pdfImage = pw.MemoryImage(resizeImage);
          var c = pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
            pw.Center(
                child: pw.Image(
              pdfImage,
              fit: pw.BoxFit.none,
            )),
          ]);
          formWidgetList.add(c);
        }
      }
    }

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: pw.BoxDecoration(border: pw.Border.all(style: pw.BorderStyle.solid, width: 0.5, color: PdfColors.grey)),
              child: pw.Text('Report of project $dbName', style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) {
          List<pw.Widget> finalWidgets = []..add(
              pw.Header(
                  level: 0,
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: <pw.Widget>[
                    pw.Image(smashLogo, height: 32.0, width: 50.0, fit: pw.BoxFit.scaleDown),
                    pw.FittedBox(
                      child: pw.Paragraph(text: 'Project: ${dbName.replaceAll("_", " ")}', padding: pw.EdgeInsets.all(5)
                          // textScaleFactor: 2,
                          // softWrap: true,
                          ),
                    )
                  ])),
            );

          if (simpleNotesTable.isNotEmpty) {
            finalWidgets.add(
              pw.Header(level: 1, text: 'Simple Notes'),
            );
            finalWidgets.add(
              pw.Table.fromTextArray(
                context: context,
                data: simpleNotesTable,
              ),
            );
          }
          if (formWidgetList.isNotEmpty) {
            finalWidgets.addAll(formWidgetList);
          }

          return finalWidgets;
        }));

    await outputFile.writeAsBytes(await pdf.save());
  }
}
