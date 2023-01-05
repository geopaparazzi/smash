/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
// import 'package:catcher/catcher.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/l10n/localization.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:smash/eu/hydrologis/smash/project/projects_view.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';
import 'package:smash_import_export_plugins/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:stack_trace/stack_trace.dart';

//import 'package:flutter_gen/gen_l10n/smash_localization.dart';
import 'generated/l10n.dart';

const DOCATCHER = false;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // TODO endable catcher again once it is aligned with libs
  // if (DOCATCHER) {
  //   CatcherOptions debugOptions =
  //       CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
  //   CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  //     EmailManualHandler(["feedback@geopaparazzi.eu"])
  //   ]);

  //   Catcher(
  //       rootWidget: getMainWidget(),
  //       debugConfig: debugOptions,
  //       releaseConfig: releaseOptions);
  // } else {
  runApp(getMainWidget());
  // }
}

MultiProvider getMainWidget() {
  return MultiProvider(
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
  );
}
// void main() => runApp(SmashApp());

class SmashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  locale: Locale('ja', 'JP'),
      localizationsDelegates: [
        SL.delegate,
        IEL.delegate,
        SLL.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: SL.supportedLocales,
      // PRE GEN
      // localizationsDelegates: [
      //   AppLocalizations.delegate, // available after codegen
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en', ''),
      //   const Locale('it', ''),
      //   const Locale.fromSubtags(languageCode: 'zh'),
      // ],
      // END PRE GEN
      // navigatorKey: Catcher.navigatorKey,
      title: Workspace.APP_NAME,
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
  WelcomeWidget({Key? key}) : super(key: key);

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
    Localization.init(context);
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
            SL.of(context).main_welcome,
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          children: <Widget>[
            ProgressTile(
                MdiIcons.crosshairsGps,
                SL.of(context).main_check_location_permission,
                SL.of(context).main_location_permission_granted,
                orderNotifier,
                0,
                handleLocationPermission),
            ProgressTile(
                MdiIcons.database,
                SL.of(context).main_checkingStoragePermission,
                SL.of(context).main_storagePermissionGranted,
                orderNotifier,
                1,
                handleStoragePermission),
            ProgressTile(
                MdiIcons.cog,
                SL.of(context).main_loadingPreferences,
                SL.of(context).main_preferencesLoaded,
                orderNotifier,
                2,
                handlePreferences),
            ProgressTile(
                MdiIcons.folderCog,
                SL.of(context).main_loadingWorkspace,
                SL.of(context).main_workspaceLoaded,
                orderNotifier,
                3,
                handleWorkspace),
            ProgressTile(
                MdiIcons.notePlus,
                SL.of(context).main_loadingTagsList,
                SL.of(context).main_tagsListLoaded,
                orderNotifier,
                4,
                handleTags),
            ProgressTile(
                MdiIcons.earthBox,
                SL.of(context).main_loadingKnownProjections,
                SL.of(context).main_knownProjectionsLoaded,
                orderNotifier,
                5,
                handleProjections),
            ProgressTile(
                MdiIcons.gate,
                SL.of(context).main_loadingFences,
                SL.of(context).main_fencesLoaded,
                orderNotifier,
                6,
                handleFences),
            ProgressTile(
                MdiIcons.layers,
                SL.of(context).main_loadingLayersList,
                SL.of(context).main_layersListLoaded,
                orderNotifier,
                7,
                handleLayers),
          ],
        ),
      );
    }

    return widgetToLoad;
  }
}

Future<String?> handleFences(BuildContext context) async {
  try {
    FenceMaster().readFences(context);
  } on Exception catch (e, s) {
    var msg = "Error while reading fences.";
    return logMsg(msg, e, s);
  }
  return null;
}

Future<String?> handleLayers(BuildContext context) async {
  // init layer manager
  try {
    var layerManager = LayerManager();
    await layerManager.initialize(context);
  } on Exception catch (e, s) {
    try {
      var msg = "Error while loading layers.";
      return logMsg(msg, e, s);
    } on Exception catch (e, s) {
      var eMsg = e.toString();
      if (eMsg != null &&
          eMsg.toLowerCase().contains("attempt to write a readonly database")) {
        return "Unable to access the filesystem in write mode. This seems like a permission problem. Check your configurations.";
      }
      if (e != null) {
        return e.toString();
      } else if (s != null) {
        return s.toString();
      }
    }
  }
  return null;
}

Future<String?> handleProjections(BuildContext context) async {
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
      } on Exception catch (e, s) {
        SMLogger().e("Error adding projection $projDef", e, s);
      }
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error while reading projections.";
    return logMsg(msg, e, s);
  }
}

Future<String?> handleTags(BuildContext context) async {
  // read tags file
  try {
    await TagsManager().readFileTags();
  } on Exception catch (e, s) {
    var msg = "Error while reading tags.";
    return logMsg(msg, e, s);
  }
  return null;
}

Future<String?> handlePreferences(BuildContext context) async {
  try {
    await GpPreferences().initialize();

    SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
    var pos = await GpPreferences().getLastPosition();
    if (pos != null) {
      mapState.init(Coordinate(pos[0], pos[1]), pos[2]);
    }

    await GpPreferences().setBoolean(GpsHandler.GPS_FORCED_OFF_KEY, false);

    bool? allowSelfCert = await GpPreferences().getBoolean(
        SmashPreferencesKeys.KEY_GSS_DJANGO_SERVER_ALLOW_SELFCERTIFICATE, true);
    String? gssUrl = await GpPreferences()
        .getString(SmashPreferencesKeys.KEY_GSS_DJANGO_SERVER_URL, "");
    if (gssUrl!.isNotEmpty) {
      var url = gssUrl
          .replaceFirst("https://", "")
          .replaceFirst("http://", "")
          .split(":")[0];
      NetworkHelper.toggleAllowSelfSignedCertificates(allowSelfCert!, url);
    } else {
      // reset setting to disabled
      await GpPreferences().setBoolean(
          SmashPreferencesKeys.KEY_GSS_DJANGO_SERVER_ALLOW_SELFCERTIFICATE,
          false);
    }

    return null;
  } on Exception catch (e, s) {
    var msg = "Error while reading preferences.";
    return logMsg(msg, e, s);
  }
}

Future<String?> handleWorkspace(BuildContext context) async {
  try {
    await Workspace.init(doSafeMode: false);
    var directory = await Workspace.getConfigFolder();
    bool init = SLogger().init(directory.path) ?? false; // init logger
    if (init) SMLogger().setSubLogger(SLogger());

    // handle issues with Android 11 not taking the
    if (directory.path
        .toLowerCase()
        .contains("android/data/eu.hydrologis.smash")) {
      // warn user the first time that the location of the files is in the android path
      var shownAlready =
          GpPreferences().getBooleanSync("SHOWN_FS_MOVED_WARNING", false);
      if (!shownAlready) {
        await SmashDialogs.showWarningDialog(
            context, SL.of(context).main_StorageIsInternalWarning);
        await GpPreferences().setBoolean("SHOWN_FS_MOVED_WARNING", true);
      }
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error during workspace initialization.";
    return logMsg(msg, e, s);
  }
}

Future<String?> handleLocationPermission(BuildContext context) async {
  try {
    if (!SmashPlatform.isDesktop()) {
      var status = await Permission.location.status;
      if (status != PermissionStatus.granted) {
        await SmashDialogs.showWarningDialog(
            context, SL.of(context).main_locationBackgroundWarning);
        var locationPermission =
            await PermissionManager().add(PERMISSIONS.LOCATION).check(context);
        if (!locationPermission) {
          return SL.of(context).main_locationPermissionIsMandatoryToOpenSmash;
        }
      }
    }
    return null;
  } on Exception catch (e, s) {
    var msg = "Error during permission handling.";
    return logMsg(msg, e, s);
  }
}

Future<String?> handleStoragePermission(BuildContext context) async {
  if (!SmashPlatform.isDesktop()) {
    var storagePermission = await PermissionManager()
        .add(PERMISSIONS.STORAGE)
        .add(
            PERMISSIONS.MANAGEEXTSTORAGE) // TODO comment this for store release
        .check(context);
    if (!storagePermission) {
      return SL.of(context).main_storagePermissionIsMandatoryToOpenSmash;
    }
  }
  return null;
}

String logMsg(String msg, Exception e, StackTrace? s) {
  SMLogger().e(msg, e, s);
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
  final Future<String?> Function(BuildContext) processFunction;

  ProgressTile(this.iconData, this.initMsg, this.doneMsg, this.orderNotifier,
      this.order, this.processFunction);

  @override
  _ProgressTileState createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  bool isDone = false;
  bool isStarted = false;
  String? error;

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
    setState(() {
      isStarted = true;
    });
    error = await widget.processFunction(context);
    if (error == null) {
      // we can move on
      widget.orderNotifier.value = widget.orderNotifier.value + 1;
    }
    setState(() {
      isDone = true;
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle;
    if (isStarted) {
      textStyle = TextStyle(
        color: SmashColors.mainSelection,
        fontWeight: FontWeight.bold,
      );
    }
    var color = isStarted ? SmashColors.mainSelection : null;
    return ListTile(
      leading: Icon(
        widget.iconData,
        color: color,
      ),
      title: error == null
          ? Text(
              isDone ? widget.doneMsg : widget.initMsg,
              style: textStyle,
            )
          : TextButton(
              child: Text(
                SL.of(context).main_anErrorOccurredTapToView,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await SmashDialogs.showErrorDialog(context, error!);
              },
            ),
    );
  }
}
