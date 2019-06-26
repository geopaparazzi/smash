/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables_objects.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';

class AddNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddNotePageState();
}

class AddNotePageState extends State<AddNotePage> {
  final KEYNOTEDOGPS = 'KEY_NOTE_DOGPS';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Add Notes"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              bool doInGps =
                  await GpPreferences().getBoolean(KEYNOTEDOGPS, false);
              int ts = DateTime.now().millisecondsSinceEpoch;
              Position pos;
              double lon;
              double lat;
              if (doInGps) {
                pos = GpsHandler().lastPosition;
              } else {
                lon = gpProjectModel.lastCenterLon;
                lat = gpProjectModel.lastCenterLat;
              }
              showInputDialog(context, "New note", "Enter note here")
                  .then((noteString) {
                if (noteString != null && noteString.trim().length > 0) {
                  // TODO insert note

                  gpProjectModel.getDatabase().then((db) {
                    Note note = Note()
                      ..text = noteString
                      ..description = "POI"
                      ..timeStamp = ts
                      ..lon = pos != null ? pos.longitude : lon
                      ..lat = pos != null ? pos.latitude : lat
                      ..altim = pos != null ? pos.altitude : -1;
                    db.addNote(note);
                  });
                }
              });
            },
            icon: Icon(Icons.add_comment),
            tooltip: "Add simple note",
          ),
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.add_a_photo),
            tooltip: "Add simple picture",
          ),
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.aspect_ratio),
            tooltip: "Layout Settings",
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Text("map center"),
//                Switch(value: _doInGps, onChanged: null)
//              ],
//            ),
          ],
        ),
      ),
    );
  }
}
