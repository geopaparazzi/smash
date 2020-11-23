/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:catcher/catcher.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  /// STEP 1. Create catcher configuration.
  /// Debug configuration with dialog report mode and console handler. It will show dialog and once user accepts it, error will be shown   /// in console.
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["feedback@geopaparazzi.eu"])
  ]);

  Catcher(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProjectState()),
          ChangeNotifierProvider(create: (_) => SmashMapBuilder()),
          ChangeNotifierProvider(create: (_) => ThemeState()),
          ChangeNotifierProvider(create: (_) => GpsState()),
          ChangeNotifierProvider(create: (_) => SmashMapState()),
          ChangeNotifierProvider(create: (_) => InfoToolState()),
          ChangeNotifierProvider(create: (_) => RulerState()),
          ChangeNotifierProvider(create: (_) => GeometryEditorState()),
        ],
        child: SmashApp(),
      ),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
  // runApp(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (_) => ProjectState()),
  //     ChangeNotifierProvider(create: (_) => SmashMapBuilder()),
  //     ChangeNotifierProvider(create: (_) => ThemeState()),
  //     ChangeNotifierProvider(create: (_) => GpsState()),
  //     ChangeNotifierProvider(create: (_) => SmashMapState()),
  //     ChangeNotifierProvider(create: (_) => InfoToolState()),
  //     ChangeNotifierProvider(create: (_) => RulerState()),
  //     ChangeNotifierProvider(create: (_) => GeometryEditorState()),
  //   ],
  //   child: SmashApp(),
  // ));
}
// void main() => runApp(SmashApp());

class SmashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: APP_NAME,
      //theme: Provider.of<ThemeState>(context).currentThemeData,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  var finalOrder = 8;

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
            ProgressTile(MdiIcons.gate, "Loading fences...", "Fences loaded.",
                orderNotifier, 7, handleFences),
          ],
        ),
      );
    }

    return widgetToLoad;
  }
}

Future<String> handleFences(BuildContext context) async {
  try {
    FenceMaster().readFences();
  } on Exception catch (e, s) {
    var msg = "Error while reading fences.";
    return logMsg(msg, s);
  }
  return null;
}

Future<String> handleLayers(BuildContext context) async {
  // init layer manager
  try {
    var layerManager = LayerManager();
    await layerManager.initialize(context);
  } on Exception catch (e, s) {
    var msg = "Error while loading layers.";
    return logMsg(msg, s);
  }
  return null;
}

Future<String> handleProjections(BuildContext context) async {
  // read tags file
  try {
    List<String> projList = await GpPreferences().getProjections();
    for (var projDef in projList) {
      var firstDot = projDef.indexOf(":");
      var epsg = projDef.substring(0, firstDot);
      var def = projDef.substring(firstDot + 1, projDef.length);
      try {
        int.parse(epsg);
        Projection.add('EPSG:$epsg', def);
      } catch (e, s) {
        SMLogger().e("Error adding projection $projDef", s);
      }
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error while reading projections.";
    return logMsg(msg, s);
  }
}

Future<String> handleTags(BuildContext context) async {
  // read tags file
  try {
    await TagsManager().readFileTags();
  } on Exception catch (e, s) {
    var msg = "Error while reading tags.";
    return logMsg(msg, s);
  }
  return null;
}

Future<String> handlePreferences(BuildContext context) async {
  try {
    await GpPreferences().initialize();

    SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
    var pos = await GpPreferences().getLastPosition();
    if (pos != null) {
      mapState.init(Coordinate(pos[0], pos[1]), pos[2]);
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error while reading preferences.";
    return logMsg(msg, s);
  }
}

Future<String> handleWorkspace(BuildContext context) async {
  try {
    await Workspace.init();
    var directory = await Workspace.getConfigFolder();
    bool init = SLogger().init(directory.path); // init logger
    if (init) SMLogger().setSubLogger(SLogger());
    return null;
  } on Exception catch (e, s) {
    var msg = "Error during workspace initialization.";
    return logMsg(msg, s);
  }
}

Future<String> handleLocationPermission(BuildContext context) async {
  try {
    if (!SmashPlatform.isDesktop()) {
      var status = await Permission.locationAlways.status;
      if (status != PermissionStatus.granted) {
        await SmashDialogs.showWarningDialog(context,
            """This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.

If you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.
          """);
        var locationPermission =
            await PermissionManager().add(PERMISSIONS.LOCATION).check();
        if (!locationPermission) {
          return "Location permission is mandatory to open SMASH.";
        }
      }
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error during permission handling.";
    return logMsg(msg, s);
  }
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

String logMsg(String msg, StackTrace s) {
  SMLogger().e(msg, s);
  if (s != null) {
    msg += "\n" + Trace.format(s);
  }
  return msg;
}

class ProgressTile extends StatefulWidget {
  final ValueNotifier orderNotifier;
  final int order;

  final doneMsg;

  final iconData;

  final initMsg;
  final Future<String> Function(BuildContext) processFunction;

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
          : FlatButton(
              child: Text(
                "An error occurred. Tap to view.",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await SmashDialogs.showErrorDialog(context, error);
              },
            ),
    );
  }
}
