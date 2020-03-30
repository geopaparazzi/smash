/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/smash/export/gss_export.dart';
import 'package:smash/eu/hydrologis/smash/export/pdf_export.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';

class ExportWidget extends StatefulWidget {
  ExportWidget({Key key}) : super(key: key);

  @override
  _ExportWidgetState createState() => new _ExportWidgetState();
}

class _ExportWidgetState extends State<ExportWidget> {
  int _pdfBuildStatus = 0;
  String _outPath = "";

  Future<void> buildPdf(BuildContext context) async {
    var exportsFolder = await Workspace.getExportsFolder();
    var ts = TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now());
    var outFilePath =
        FileUtilities.joinPaths(exportsFolder.path, "smash_pdf_export_$ts.pdf");
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    await PdfExporter.exportDb(db, File(outFilePath));

    setState(() {
      _outPath = outFilePath;
      _pdfBuildStatus = 2;
    });
//    showInfoDialog(context, "Exported to $outFilePath");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Export"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
            leading: _pdfBuildStatus == 0
                ? Icon(
                    MdiIcons.filePdf,
                    color: SmashColors.mainDecorations,
                  )
                : _pdfBuildStatus == 1
                    ? SmashCircularProgress()
                    : Icon(
                        Icons.check,
                        color: SmashColors.mainDecorations,
                      ),
            title: Text("${_pdfBuildStatus == 2 ? 'PDF exported' : 'PDF'}"),
            subtitle: Text(
                "${_pdfBuildStatus == 2 ? _outPath : 'Export project to Portable Document Format'}"),
            onTap: () {
              setState(() {
                _outPath = "";
                _pdfBuildStatus = 1;
              });
              buildPdf(context);
//              Navigator.pop(context);
            }),
        ListTile(
            leading: Icon(
              MdiIcons.cloudLock,
              color: SmashColors.mainDecorations,
            ),
            title: Text("GSS"),
            subtitle: Text("Export to Geopaparazzi Survey Server"),
            onTap: () {
              var projectState =
                  Provider.of<ProjectState>(context, listen: false);
              var db = projectState.projectDb;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new GssExportWidget(db)));
            }),
      ]),
    );
  }
}
