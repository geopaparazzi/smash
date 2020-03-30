/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/smash/import/gss_import.dart';

class ImportWidget extends StatefulWidget {
  ImportWidget({Key key}) : super(key: key);

  @override
  _ImportWidgetState createState() => new _ImportWidgetState();
}

class _ImportWidgetState extends State<ImportWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Import"),
      ),
      body: ListView(children: <Widget>[
        ListTile(
            leading: Icon(
              MdiIcons.cloudLock,
              color: SmashColors.mainDecorations,
            ),
            title: Text("GSS"),
            subtitle: Text("Import from Geopaparazzi Survey Server"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new GssImportWidget()));
            }),
      ]),
    );
  }
}
