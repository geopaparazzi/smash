/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:provider/provider.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectState()),
        ChangeNotifierProvider(create: (_) => SmashMapBuilder()),
        ChangeNotifierProvider(create: (_) => ThemeState()),
        ChangeNotifierProvider(create: (_) => GpsState()),
        ChangeNotifierProvider(create: (_) => SmashMapState()),
        ChangeNotifierProvider(create: (_) => InfoToolState()),
      ],
      child: SmashApp(),
    ));
// void main() => runApp(SmashApp());

class SmashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      //theme: Provider.of<ThemeState>(context).currentThemeData,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: WelcomeWidget(),
    );
  }
}

class WelcomeWidget extends StatefulWidget {
  WelcomeWidget({Key key}) : super(key: key);

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  ValueNotifier<int> orderNotifier = ValueNotifier<int>(0);
  var finalOrder = 7;

  bool _initFinished = false;

  @override
  void initState() {
    super.initState();
    orderNotifier.addListener(() {
      if (orderNotifier.value == finalOrder) {
        _initFinished = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetToLoad;
    if (_initFinished) {
      // load projects page
      widgetToLoad = ProjectView(
        isOpeningPage: true,
      );
    } else {
      // show ongoing progress
      widgetToLoad = Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to SMASH!",
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          children: <Widget>[
            ProgressTile(
                MdiIcons.crosshairsGps,
                "Checking location permission...",
                "Location permission granted.",
                orderNotifier,
                0,
                handleLocationPermission),
            ProgressTile(
                MdiIcons.database,
                "Checking storage permission...",
                "Storage permission granted.",
                orderNotifier,
                1,
                handleStoragePermission),
            ProgressTile(MdiIcons.cog, "Loading preferences...",
                "Preferences loaded.", orderNotifier, 2, handlePreferences),
            ProgressTile(MdiIcons.folderCog, "Loading workspace...",
                "Workspace loaded.", orderNotifier, 3, handleWorkspace),
            // ProgressTile(MdiIcons.crosshairsGps, "Initializing GPS...",
            //     "GPS initialized.", orderNotifier, 4, handleGps),
            ProgressTile(MdiIcons.notePlus, "Loading tags list...",
                "Tags list loaded.", orderNotifier, 4, handleTags),
            ProgressTile(
                MdiIcons.earthBox,
                "Loading known projections...",
                "Known projections loaded.",
                orderNotifier,
                5,
                handleProjections),
            ProgressTile(MdiIcons.layers, "Loading layers list...",
                "Layers list loaded.", orderNotifier, 6, handleLayers),
          ],
        ),
      );
    }

    return widgetToLoad;
  }
}

Future<String> handleLayers(BuildContext context) async {
  // init layer manager
  var layerManager = LayerManager();
  await layerManager.initialize();
  return null;
}

Future<String> handleProjections(BuildContext context) async {
  // read tags file
  List<String> projList = await GpPreferences().getProjections();
  for (var projDef in projList) {
    var firstDot = projDef.indexOf(":");
    var epsg = projDef.substring(0, firstDot);
    var def = projDef.substring(firstDot + 1, projDef.length);
    try {
      int.parse(epsg);
      Projection.add('EPSG:$epsg', def);
    } catch (e) {
      GpLogger().err("Error adding projection $projDef", e);
    }
  }
  return null;
}

Future<String> handleTags(BuildContext context) async {
  // read tags file
  await TagsManager().readFileTags();
  return null;
}

Future<String> handlePreferences(BuildContext context) async {
  await GpPreferences().initialize();

  SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
  var pos = await GpPreferences().getLastPosition();
  if (pos != null) {
    mapState.init(Coordinate(pos[0], pos[1]), pos[2]);
  }
  return null;
}

Future<String> handleWorkspace(BuildContext context) async {
  await Workspace.init();
  var directory = await Workspace.getConfigFolder();
  bool init = await GpLogger().init(directory.path); // init logger
  if (init) GpLogger().i("Db logger initialized.");
  return null;
}

Future<String> handleLocationPermission(BuildContext context) async {
  if (!SmashPlatform.isDesktop()) {
    var locationPermission =
        await PermissionManager().add(PERMISSIONS.LOCATION).check();
    if (!locationPermission) {
      return "Location permission is mandatory to open SMASH.";
    }
  }
  return null;
}

Future<String> handleStoragePermission(BuildContext context) async {
  if (!SmashPlatform.isDesktop()) {
    var storagePermission =
        await PermissionManager().add(PERMISSIONS.STORAGE).check();
    if (!storagePermission) {
      return "Storage permission is mandatory to open SMASH.";
    }
  }
  return null;
}

class ProgressTile extends StatefulWidget {
  final ValueNotifier orderNotifier;
  final int order;

  final doneMsg;

  final iconData;

  final initMsg;
  Future<String> Function(BuildContext) processFunction;

  ProgressTile(this.iconData, this.initMsg, this.doneMsg, this.orderNotifier,
      this.order, this.processFunction);

  @override
  _ProgressTileState createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  bool isDone = false;
  String error;

  @override
  void initState() {
    if (widget.orderNotifier.value == widget.order) {
      process();
    } else {
      widget.orderNotifier.addListener(() {
        if (widget.orderNotifier.value == widget.order) {
          process();
        }
      });
    }
    super.initState();
  }

  process() async {
    error = await widget.processFunction(context);
    if (error == null) {
      // we can move on
      widget.orderNotifier.value = widget.orderNotifier.value + 1;
    }
    setState(() {
      isDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.iconData),
      title: error == null
          ? Text(isDone ? widget.doneMsg : widget.initMsg)
          : Text(
              error,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
    );
  }
}
