/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/hydrologis/geopaparazzi/widgets/dashboard.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/logging.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';

void main() => runApp(GeopaparazziApp());

class GeopaparazziApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GeopaparazziAppState();
  }
}

class GeopaparazziAppState extends State<GeopaparazziApp> {
  @override
  void initState() {
    super.initState();

    gpProjectModel = GPProjectModel();
    GpPreferences().getLastPosition().then((pos) {
      if (pos != null) {
        gpProjectModel.lastCenterLon = pos[0];
        gpProjectModel.lastCenterLat = pos[1];
        gpProjectModel.lastCenterZoom = pos[2];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GpConstants.APP_NAME,
      theme: ThemeData(
          primarySwatch: SmashColors.mainDecorationsMc,
          accentColor: SmashColors.mainSelectionMc,
          canvasColor: SmashColors.mainBackground,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(
                      255,
                      SmashColors.mainDecorationsDarkR,
                      SmashColors.mainDecorationsDarkG,
                      SmashColors.mainDecorationsDarkB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(
                      255,
                      SmashColors.mainDecorationsDarkR,
                      SmashColors.mainDecorationsDarkG,
                      SmashColors.mainDecorationsDarkB)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(
                      255,
                      SmashColors.mainSelectionBorderR,
                      SmashColors.mainSelectionBorderG,
                      SmashColors.mainSelectionBorderB)),
            ),
//            labelStyle: const TextStyle(
//              color: Color.fromARGB(255, 128, 128, 128),
//            ),
          )),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: DashboardWidget(),
    );
  }
}
