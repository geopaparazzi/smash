/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/forms/forms.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/layers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/permissions.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:smash/eu/hydrologis/smash/widgets/dashboard.dart';
import 'package:provider/provider.dart';

void main() => runApp(SmashApp());

class SmashApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SmashAppState();
  }
}

class SmashAppState extends State<SmashApp> {
  @override
  Widget build(BuildContext context) {
    // If the Future is complete, display the preview.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectState()),
        ChangeNotifierProvider(create: (_) => GpsLoggingState()),
        ChangeNotifierProvider(create: (_) => GpsState()),
        ChangeNotifierProvider(create: (_) => MapState()),
      ],
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
            primarySwatch: SmashColors.mainDecorationsMc,
            accentColor: SmashColors.mainSelectionMc,
            canvasColor: SmashColors.mainBackground,
            brightness: Brightness.light,
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, SmashColors.mainDecorationsDarkR, SmashColors.mainDecorationsDarkG, SmashColors.mainDecorationsDarkB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, SmashColors.mainDecorationsDarkR, SmashColors.mainDecorationsDarkG, SmashColors.mainDecorationsDarkB)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, SmashColors.mainSelectionBorderR, SmashColors.mainSelectionBorderG, SmashColors.mainSelectionBorderB)),
              ),
//            labelStyle: const TextStyle(
//              color: Color.fromARGB(255, 128, 128, 128),
//            ),
            )),
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        home: InitializationWidget(),
      ),
    );
  }
}

class InitializationWidget extends StatefulWidget {
  InitializationWidget({Key key}) : super(key: key);

  @override
  _InitializationWidgetState createState() => new _InitializationWidgetState();
}

class _InitializationWidgetState extends State<InitializationWidget> {
  bool _locationPermission = false;
  bool _storagePermission = false;
  bool _loadDashboard = false;

  @override
  Widget build(BuildContext context) {
    if (_loadDashboard) {
      return DashboardWidget();
    } else if (_storagePermission && _locationPermission) {
      MapState mapState = Provider.of<MapState>(context);

      Future.delayed(Duration(seconds: 0), () async {
        // init preferences
        await GpPreferences().initialize();

        // read tags file
        await TagsManager().readFileTags();

        // init layer manager
        var layerManager = LayerManager();
        await layerManager.initialize();

        // enable logging
        appGpsLoggingHandler = SmashLoggingHandler();

        // set last known position
        var pos = await GpPreferences().getLastPosition();
        if (pos != null) {
          mapState.init(Coordinate(pos[0], pos[1]), pos[2]);
        }
        setState(() {
          _loadDashboard = true;
        });
      });
    } else {
      if (!_locationPermission) {
        PermissionManager().add(PERMISSIONS.LOCATION).check().then((allRight) async {
          if (allRight) {
            setState(() {
              _locationPermission = true;
            });
          }
        });
      } else {
        // location is ok, ask for storage
        if (!_storagePermission) {
          PermissionManager().add(PERMISSIONS.STORAGE).check().then((allRight) async {
            if (allRight) {
              setState(() {
                _storagePermission = true;
              });
            }
          });
        }
      }
    }
    return Container(
      color: SmashColors.mainBackground,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
