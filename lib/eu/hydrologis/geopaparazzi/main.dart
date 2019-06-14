/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/geopaparazzi_models.dart';
import 'package:geopaparazzi_light/eu/hydrologis/geopaparazzi/widgets/dashboard.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(LoadingImageApp());

class LoadingImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geopaparazzi',
      theme: ThemeData(
          primarySwatch: GeopaparazziColors.mainDecorationsMc,
          accentColor: GeopaparazziColors.mainSelectionMc,
          canvasColor: GeopaparazziColors.mainBackground,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 55, 135, 86)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 55, 135, 86)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 153, 51, 0)),
            ),
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          )),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: ScopedModel<GeopaparazziProjectModel>(
        model: GeopaparazziProjectModel(),
        child: DashboardWidget(),
      ),
    );
  }
}
