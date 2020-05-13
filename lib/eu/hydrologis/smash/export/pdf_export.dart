/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smash/eu/hydrologis/smash/forms/forms.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:image/image.dart' as IMG;
import 'package:flutter/services.dart' show rootBundle;
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/smashlibs.dart';

class PdfExporter {
  static final String novalue = "-nv-";
  static final int EXPORT_IMG_LONGSIZE = 280;

  static Future<void> exportDb(
      GeopaparazziProjectDb db, File outputFile) async {
    var dbName = FileUtilities.nameFromFile(db.path, false);
    final Document pdf = Document(
      author: "Smash User",
      keywords: "SMASH, export, notes, gps, log",
      creator: "SMASH - http://www.geopaparazzi.eu using flutter pdf package",
      title: "SMASH PDF Report of project: $dbName",
      subject: "SMASH PDF Export",
    );

    ByteData smashLogoBytes = await rootBundle.load("assets/smash_logo_64.png");
    IMG.Image image =
        await IMG.decodeImage(smashLogoBytes.buffer.asUint8List());
    final smashLogo = PdfImage(
      pdf.document,
      image: image.data.buffer.asUint8List(),
      width: 99,
      height: 64,
    );

    List<Note> simpleNotesList = await db.getNotes(doSimple: true);

    List<List<String>> simpleNotesTable = [
      ['id', 'lon', 'lat', 'altim', 'text', 'date', 'accur', 'head', 'speed']
    ];
    simpleNotesList.forEach((note) {
      List<String> row = [];
      row.add(note.id.toString());
      row.add(note.lon.toStringAsFixed(6));
      row.add(note.lat.toStringAsFixed(6));
      row.add("${note.altim.toInt()}m");
      row.add(note.text);
      row.add(TimeUtilities.ISO8601_TS_FORMATTER
          .format(DateTime.fromMillisecondsSinceEpoch(note.timeStamp)));
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

    List<Widget> formWidgetList = [];
    formWidgetList.add(
      Header(level: 1, text: 'Forms'),
    );

    List<Note> formNotesList = await db.getNotes(doSimple: false);
    for (var i = 0; i < formNotesList.length; i++) {
      Note note = formNotesList[i];
      formWidgetList.add(Header(level: 2, text: note.text));

      String formJson = note.form;
      Map<String, dynamic> sectionMap = jsonDecode(formJson);
//      var sectionName = sectionMap[ATTR_SECTIONNAME];
      List<String> formNames = TagsManager.getFormNames4Section(sectionMap);
      for (var j = 0; j < formNames.length; j++) {
        var formName = formNames[j];
        formWidgetList.add(Header(level: 3, text: formName));

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
              var idSplit = value.toString().split(";");
              for (var i = 0; i < idSplit.length; i++) {
                var imageId = int.parse(idSplit[i]);
                DbImage image = await db.getImageById(imageId);
                var p =
                    Paragraph(text: image.text, textAlign: TextAlign.center);
                formWidgetList.add(p);

                Uint8List imageDataBytes =
                    await db.getImageDataBytes(image.imageDataId);
                List<int> resizeImage = ImageUtilities.resizeImage(
                    imageDataBytes,
                    longestSizeTo: EXPORT_IMG_LONGSIZE);
                IMG.Image img = IMG.decodeImage(resizeImage);

                final pdfImage = PdfImage(
                  pdf.document,
                  image: img.data.buffer.asUint8List(),
                  width: img.width,
                  height: img.height,
                );
                var c = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(child: Image(pdfImage, fit: BoxFit.none)),
                    ]);
                formWidgetList.add(c);
              }
            } catch (e) {
              GpLogger().err("Error exporting image to pdf document", e);
            }
          } else if (type == TYPE_DYNAMICSTRING) {
            var p = Paragraph(text: '$label: ');
            formWidgetList.add(p);
            List<String> valueSplit = value.toString().split(";");
            valueSplit.forEach((v) {
              var b = Bullet(text: v);
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

            var p = Paragraph(text: '$value', style: TextStyle(fontSize: size));
            formWidgetList.add(p);
          } else {
            var p = Paragraph(text: '$label: $value');
            formWidgetList.add(p);
          }
        }
      }

      formWidgetList.add(
        Header(level: 1, text: 'Image notes'),
      );

      List<DbImage> images = await db.getImages();
      for (var i = 0; i < images.length; i++) {
        DbImage image = images[i];

        var p = Paragraph(text: image.text);
        formWidgetList.add(p);
        formWidgetList.addAll([
          Bullet(text: "latitude: ${image.lat}"),
          Bullet(text: "longitude: ${image.lon}"),
          Bullet(text: "altimetry: ${image.altim}m"),
          Bullet(text: "azimuth: ${image.azim}"),
          Bullet(
              text:
                  "timestamp: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}"),
        ]);
        Uint8List imageDataBytes =
            await db.getImageDataBytes(image.imageDataId);
        List<int> resizeImage = ImageUtilities.resizeImage(imageDataBytes,
            longestSizeTo: EXPORT_IMG_LONGSIZE);
        IMG.Image img = await IMG.decodeImage(resizeImage);

        final pdfImage = PdfImage(
          pdf.document,
          image: img.data.buffer.asUint8List(),
          width: img.width,
          height: img.height,
        );
        var c = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Image(pdfImage, fit: BoxFit.none)),
            ]);
        formWidgetList.add(c);
      }
    }

    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Report of project $dbName',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image(smashLogo, fit: BoxFit.scaleDown),
                        Text('Project: $dbName',
                            textScaleFactor: 2, softWrap: true),
                      ])),
              Header(level: 1, text: 'Simple Notes'),
              Table.fromTextArray(
                context: context,
                data: simpleNotesTable,
              ),
            ]..addAll(formWidgetList)));

    await outputFile.writeAsBytes(pdf.save());
  }
}
