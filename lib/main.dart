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
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/layers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/permissions.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/theme.dart';
import 'package:smash/eu/hydrologis/flutterlibs/workspace.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:smash/eu/hydrologis/smash/widgets/dashboard.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectState()),
        ChangeNotifierProvider(create: (_) => ThemeState()),
        ChangeNotifierProvider(create: (_) => GpsState()),
        ChangeNotifierProvider(create: (_) => GpsState()),
        ChangeNotifierProvider(create: (_) => SmashMapState()),
        ChangeNotifierProvider(create: (_) => InfoToolState()),
        ChangeNotifierProvider(create: (_) => MapTapState()),
      ],
      child: SmashApp(),
    ));

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
    return MaterialApp(
      title: APP_NAME,
      theme: Provider.of<ThemeState>(context).currentThemeData,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: InitializationWidget(),
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
      SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
      ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
      GpsState gpsState = Provider.of<GpsState>(context, listen: false);

      Future.delayed(Duration(seconds: 0), () async {
        // init preferences
        await GpPreferences().initialize();

        await Workspace.init();

        // TODO enable dark theme one day
        //        String themeStr = await GpPreferences().getString(KEY_THEME, SmashThemes.LIGHT.toString());
        //        SmashThemes theme = SmashThemes.LIGHT;
        //        if (themeStr == SmashThemes.DARK.toString()) {
        //          theme = SmashThemes.DARK;
        //        }
        //        Provider.of<ThemeState>(context).currentTheme = theme;

        gpsState.init();

        // read tags file
        await TagsManager().readFileTags();

        // init layer manager
        var layerManager = LayerManager();
        await layerManager.initialize();

        await projectState.openDb();

        GpsHandler().init(gpsState);
        gpsState.projectState = projectState;

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
