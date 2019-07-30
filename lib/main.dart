/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';
import 'package:smash/eu/hydrologis/smash/widgets/dashboard.dart';

void main() => runApp(SmashApp());

class SmashApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SmashAppState();
  }
}

class SmashAppState extends State<SmashApp> {
  Future<bool> loadConfiguration() async {
    var layerManager = LayerManager();
    await layerManager.initialize();
    appGpsLoggingHandler = SmashLoggingHandler();
    var pos = await GpPreferences().getLastPosition();
    var gpProject = GPProject();
    if (pos != null) {
      gpProject.lastCenterLon = pos[0];
      gpProject.lastCenterLat = pos[1];
      gpProject.lastCenterZoom = pos[2];
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadConfiguration(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return MaterialApp(
            title: APP_NAME,
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
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
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
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
