/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_jts/dart_jts.dart' hide Orientation, Key;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings/gpslog_settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smash_import_export_plugins/smash_import_export_plugins.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

/// Log object dedicated to the list widget containing logs.
class Log4ListWidget {
  int? id;
  int? parentId;
  bool get isChild => parentId != null;

  String? name;
  double? width;
  int? startTime = 0;
  int? endTime = 0;
  double? lengthm = 0.0;
  String? color;
  int? isVisible;
  String? keywords;
}

class PieceStats {
  final int id;
  final String name;
  final String day;
  final String duration;
  final double lengthMeters;
  final double up;
  final double down;
  final int count;

  PieceStats({
    required this.id,
    required this.name,
    required this.day,
    required this.duration,
    required this.lengthMeters,
    required this.up,
    required this.down,
    required this.count,
  });
}

/// [QueryObjectBuilder] to allow easy extraction from the db.
class Log4ListWidgetBuilder extends QueryObjectBuilder<Log4ListWidget> {
  @override
  Log4ListWidget fromRow(QueryResultRow map) {
    Log4ListWidget l = new Log4ListWidget()
      ..id = map.get(LOGS_COLUMN_ID)
      ..parentId = map.get(LOGS_COLUMN_PARENTID)
      ..name = map.get(LOGS_COLUMN_TEXT)
      ..startTime = map.get(LOGS_COLUMN_STARTTS)
      ..endTime = map.get(LOGS_COLUMN_ENDTS)
      ..lengthm = map.get(LOGS_COLUMN_LENGTHM)
      ..color = map.get(LOGSPROP_COLUMN_COLOR)
      ..width = map.get(LOGSPROP_COLUMN_WIDTH)
      ..isVisible = map.get(LOGSPROP_COLUMN_VISIBLE)
      ..keywords = map.get(LOGSPROP_COLUMN_KEYWORDS);
    return l;
  }

  @override
  String querySql() {
    String sql = '''
        SELECT l.$LOGS_COLUMN_ID, 
               l.$LOGS_COLUMN_PARENTID, 
               l.$LOGS_COLUMN_TEXT, 
               l.$LOGS_COLUMN_STARTTS, 
               l.$LOGS_COLUMN_ENDTS, 
               l.$LOGS_COLUMN_LENGTHM, 
               p.$LOGSPROP_COLUMN_COLOR, 
               p.$LOGSPROP_COLUMN_WIDTH, 
               p.$LOGSPROP_COLUMN_VISIBLE, 
               p.$LOGSPROP_COLUMN_KEYWORDS
        FROM $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        WHERE l.$LOGS_COLUMN_ID=p.$LOGSPROP_COLUMN_LOGID
        ORDER BY
          COALESCE(l.$LOGS_COLUMN_PARENTID, l.$LOGS_COLUMN_ID),
          CASE WHEN l.$LOGS_COLUMN_PARENTID IS NULL THEN 0 ELSE 1 END,
          l.$LOGS_COLUMN_STARTTS
    ''';
    return sql;
  }

  @override
  Map<String, dynamic> toMap(Log4ListWidget item) {
    var map = <String, dynamic>{};
    // TODO unused
    return map;
  }
}

/// The log list widget.
class LogListWidget extends StatefulWidget {
  final GeopaparazziProjectDb db;
  LogListWidget(this.db);

  @override
  State<StatefulWidget> createState() {
    return LogListWidgetState();
  }
}

/// The log list widget state.
class LogListWidgetState extends State<LogListWidget> {
  bool? useGpsFilteredGenerally;
  List<String> _selectedTags = [];

  late Future<List<Log4ListWidget>> _logsFuture;
  late Map<int, List<Log4ListWidget>> childrenByParentId;

  @override
  void initState() {
    super.initState();
    useGpsFilteredGenerally = GpPreferences().getBooleanSync(
      SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY,
      false,
    );
    // Provide an initial future so build() always has something.
    _logsFuture = _loadLogs();
  }

  void _refreshLogs() {
    setState(() {
      _logsFuture = _loadLogs();
    });
  }

  Future<List<Log4ListWidget>> _loadLogs() async {
    var logs = widget.db.getQueryObjectsList(Log4ListWidgetBuilder());

    // first remove child logs
    var parentLogs = logs.where((log) => log.parentId == null).toList();
    parentLogs = parentLogs.reversed.toList();

    childrenByParentId = <int, List<Log4ListWidget>>{};
    for (final l in logs.cast<Log4ListWidget>()) {
      final pid = l.parentId;
      if (pid != null) {
        childrenByParentId.putIfAbsent(pid, () => []).add(l);
      }
    }
    return parentLogs;
  }

  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb!;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ProjectState>(context, listen: false)
            .reloadProject(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(SL.of(context).logList_gpsLogsList), //"GPS Logs list"
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await showSettings(context);
                  _refreshLogs();
                },
                icon: Icon(
                  MdiIcons.cog,
                  color: SmashColors.mainBackground,
                )),
            IconButton(
                onPressed: () async {
                  var allTags = GpPreferences().getStringListSync(
                      SmashPreferencesKeys.KEY_GPS_LOG_TAGS, [])!;
                  allTags.sort(
                      (a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

                  var selected =
                      await SmashDialogs.showMultiSelectionComboDialog(
                          context, "Select tags to view", allTags,
                          selectedItems: _selectedTags);
                  if (selected != null) {
                    _selectedTags = selected;
                    setState(() {});
                  }
                },
                icon: Icon(
                  MdiIcons.filterVariant,
                  color: _selectedTags.isEmpty
                      ? SmashColors.mainBackground
                      : SmashColors.mainSelection,
                )),
            PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 1) {
                  db.updateGpsLogVisibility(true);
                  _refreshLogs();
                } else if (value == 2) {
                  db.updateGpsLogVisibility(false);
                  _refreshLogs();
                } else if (value == 3) {
                  db.invertGpsLogsVisibility();
                  _refreshLogs();
                } else if (value == 4) {
                  final logs = await _logsFuture;
                  if (logs.length > 1) {
                    var minTs = double.infinity;
                    var masterId;
                    logs.forEach((l) {
                      var lw = l as Log4ListWidget;
                      if (lw.isVisible == 1 && lw.startTime! < minTs) {
                        masterId = lw.id;
                      }
                    });

                    var mergeIds = <int>[];
                    for (Log4ListWidget log in logs) {
                      if (log.isVisible == 1 && log.id != masterId) {
                        mergeIds.add(log.id!);
                      }
                    }
                    db.mergeGpslogs(masterId, mergeIds);
                    _refreshLogs();
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                var txt1 = SL.of(context).logList_selectAll; //"Select all"
                var txt2 = SL.of(context).logList_unSelectAll; //"Unselect all"
                var txt3 =
                    SL.of(context).logList_invertSelection; //"Invert selection"
                var txt4 =
                    SL.of(context).logList_mergeSelected; //"Merge selected"
                return [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(txt1),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(txt2),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(txt3),
                  ),
                  PopupMenuItem<int>(
                    value: 4,
                    child: Text(txt4),
                  ),
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Log4ListWidget>>(
          future: _logsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SmashCircularProgress(
                  label: SL.of(context).logList_loadingLogs,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading logs: ${snapshot.error}"),
              );
            }

            final parentLogs = snapshot.data ?? const <Log4ListWidget>[];
            return filterLogs(gpsState, projectState, parentLogs);
          },
        ),

        // _isLoading
        //     ? Center(
        //         child: SmashCircularProgress(
        //             label:
        //                 SL.of(context).logList_loadingLogs)) //"Loading logs..."
        //     : filterLogs(gpsState, projectState),
      ),
    );
  }

  ListView filterLogs(GpsState gpsState, ProjectState projectState,
      List<Log4ListWidget> parentLogs) {
    // then filter of necessary
    List<Log4ListWidget> filteredList = [];
    if (_selectedTags.isNotEmpty) {
      for (var logItem in parentLogs) {
        Log4ListWidget log = logItem;
        if (log.keywords != null && log.keywords!.isNotEmpty) {
          var logTags = log.keywords!.split(";");
          for (var selectedTag in _selectedTags) {
            if (logTags.contains(selectedTag)) {
              filteredList.add(logItem);
              break;
            }
          }
        }
      }
    } else {
      filteredList = parentLogs;
    }
    return ListView.separated(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        Log4ListWidget logItem = filteredList[index];
        final children =
            childrenByParentId[logItem.id] ?? const <Log4ListWidget>[];

        return LogInfo(
          logItem,
          gpsState,
          projectState,
          _refreshLogs,
          useGpsFilteredGenerally,
          children: children,
          key: Key("${logItem.id}"),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        );
      },
    );
  }

  Future<void> showSettings(BuildContext context) async {
    Dialog settingsDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: GpsLogsSetting(),
      ),
    );
    await showDialog(
        context: context, builder: (BuildContext context) => settingsDialog);
  }
}

class LogInfo extends StatefulWidget {
  final ProjectState projectState;
  final gpsState;
  final Log4ListWidget logItem;
  final reloadLogFunction;
  final useGpsFilteredGenerally;
  final List<Log4ListWidget> children;

  LogInfo(this.logItem, this.gpsState, this.projectState,
      this.reloadLogFunction, this.useGpsFilteredGenerally,
      {required this.children, Key? key})
      : super(key: key);

  @override
  _LogInfoState createState() => _LogInfoState();
}

class _LogInfoState extends State<LogInfo> with AfterLayoutMixin {
  String timeString = "- nv -";
  String dayString = "- nv -";
  String lengthString = "- nv -";
  String countString = "- nv -";

  String upString = "- nv -";
  String downString = "- nv -";

  bool _expanded = false;

  List<PieceStats> _pieceStats = const []; // for the expanded view

  List<Log4ListWidget> get _pieces => [widget.logItem, ...widget.children];

  @override
  void afterFirstLayout(BuildContext context) {
    var db = widget.projectState.projectDb!;

    final pieces = _pieces;
    // Day: choose earliest start among pieces
    final minStart = pieces
        .where((p) => p.startTime != null)
        .map((p) => p.startTime!)
        .fold<int>(1 << 62, (a, b) => a < b ? a : b);
    dayString = TimeUtilities.ISO8601_TS_FORMATTER
        .format(DateTime.fromMillisecondsSinceEpoch(minStart));

    double totalUp = 0;
    double totalDown = 0;
    double totalLen = 0;
    double totalCount = 0;

    int totalDurationMs = 0;

    final perPiece = <PieceStats>[];

    for (final p in pieces) {
      final dur =
          _getDurationMillis(p, widget.gpsState, widget.projectState, db);
      totalDurationMs += dur;

      final upDownLenCnt =
          _getElevMinMaxAndLengthDeltaCount(p, widget.gpsState, db);
      final up = upDownLenCnt[0];
      final down = upDownLenCnt[1];
      final len = upDownLenCnt[2];
      final cnt = upDownLenCnt[3];

      // Your method returns -1 sentinel sometimes
      if (up != -1) {
        totalUp += up;
        totalDown += down;
      }

      totalLen += len;
      totalCount += cnt;

      perPiece.add(PieceStats(
        id: p.id!,
        name: p.name ?? "",
        day: TimeUtilities.ISO8601_TS_FORMATTER
            .format(DateTime.fromMillisecondsSinceEpoch(p.startTime!)),
        duration: StringUtilities.formatDurationMillis(dur),
        lengthMeters: len,
        up: up,
        down: down,
        count: cnt.toInt(),
      ));
    }

    timeString = StringUtilities.formatDurationMillis(totalDurationMs);
    if (totalUp == 0 && totalDown == 0) {
      upString = "- nv -";
      downString = "- nv -";
    } else {
      upString = "${totalUp.toInt()}m";
      downString = "${totalDown.toInt()}m";
    }

    countString = "${totalCount.toInt()} pts";

    if (totalLen > 1000) {
      var lengthKm = totalLen / 1000;
      var l = (lengthKm * 10).toInt() / 10.0;
      lengthString = "${l.toStringAsFixed(1)} km";
    } else {
      lengthString = "${totalLen.round()} m";
    }

    _pieceStats = perPiece;

    if (mounted) setState(() {});
  }

  int _getDurationMillis(
    Log4ListWidget item,
    GpsState gpsState,
    ProjectState projectState,
    GeopaparazziProjectDb db,
  ) {
    var endTime = item.endTime ?? 0;
    if (endTime == 0) {
      if (projectState.isLogging && item.id == projectState.currentLogId) {
        endTime = DateTime.now().millisecondsSinceEpoch;
      } else {
        // fix endts using last point (your existing logic)
        final data = db.getLogDataPointsById(item.id!);
        if (data.isNotEmpty) {
          final ts = data.last.ts;
          if (ts != null) db.updateGpsLogEndts(item.id!, ts);
          endTime = ts ?? item.startTime!;
        } else {
          endTime = item.startTime ?? 0;
        }
      }
    }
    return (endTime - (item.startTime ?? endTime)).clamp(0, 1 << 62);
  }

  @override
  Widget build(BuildContext context) {
    Log4ListWidget logItem = widget.logItem;
    var db = widget.projectState.projectDb!;

    var size = 15.0;
    var dayIcon = Icon(
      MdiIcons.calendar,
      size: size,
    );
    var timeIcon = Icon(
      MdiIcons.clockOutline,
      size: size,
    );
    var distIcon = Icon(
      MdiIcons.ruler,
      size: size,
    );
    var countIcon = Icon(
      MdiIcons.sigma,
      size: size,
    );
    var upIcon = Icon(
      MdiIcons.arrowTopRightThick,
      size: size,
    );
    var downIcon = Icon(
      MdiIcons.arrowBottomRightThick,
      size: size,
    );
    var padLeft = 5.0;
    var pad = 3.0;

    bool isLarge = ScreenUtilities.isLandscape(context) ||
        ScreenUtilities.isLargeScreen(context);

    var startActionPane = ActionPane(
      extentRatio: isLarge ? 0.55 : 1,
      dragDismissible: false,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
        // ADD PIECE
        SlidableAction(
          label: "Add piece", // TODO i18n
          foregroundColor: SmashColors.mainBackground,
          backgroundColor: SmashColors.mainDecorations.withAlpha(130),
          onPressed: (context) async {
            final parentId = logItem.id;
            if (parentId == null) return;

            final selectedChildId =
                await _showAddPiecePicker(context, parentId);
            if (selectedChildId != null) {
              db.setParentLog(selectedChildId, parentId);

              widget.reloadLogFunction();
            }
          },
        ),

        // ZOOM TO
        SlidableAction(
            label: SL.of(context).logList_zoomTo, //'Zoom to'
            foregroundColor: SmashColors.mainBackground,
            backgroundColor: SmashColors.mainDecorations.withAlpha(100),
            // icon: MdiIcons.magnifyScan,
            onPressed: (context) async {
              SmashMapState mapState =
                  Provider.of<SmashMapState>(context, listen: false);
              // Collect parent + children ids
              final ids = <int>[
                if (logItem.id != null) logItem.id!,
                ...widget.children.where((c) => c.id != null).map((c) => c.id!),
              ];

              Envelope env = Envelope.empty();

              for (final id in ids) {
                final logDataPoints = db.getLogDataPoints(id);
                for (final point in logDataPoints) {
                  env.expandToInclude(point.lon, point.lat);
                }
              }
              mapState.setBounds(env);
              Navigator.of(context).pop();
            }),
        // PROPERTIES
        SlidableAction(
          onPressed: (context) async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LogPropertiesWidget(logItem)));
            widget.reloadLogFunction();
          },
          foregroundColor: SmashColors.mainBackground,
          backgroundColor: SmashColors.mainDecorations.withAlpha(170),
          // icon: MdiIcons.palette,
          label: SL.of(context).logList_properties, //'Properties'
        ),
        // PROFILE VIEW
        SlidableAction(
          label: SL.of(context).logList_profileView, //'Profile View'
          foregroundColor: SmashColors.mainBackground,
          backgroundColor: SmashColors.mainDecorations.withAlpha(250),
          // icon: MdiIcons.chartAreaspline,
          onPressed: (context) async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LogProfileView(logItem)));
            setState(() {});
          },
        )
      ],
    );

    var endActionPane = ActionPane(
      extentRatio: isLarge ? 0.35 : 0.6,
      dragDismissible: false,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
        // TO GPX
        SlidableAction(
            label: SL.of(context).logList_toGPX, //'To GPX'
            foregroundColor: SmashColors.mainBackground,
            backgroundColor: SmashColors.mainDecorations,
            // icon: MdiIcons.mapMarker,
            onPressed: (context) async {
              var exportsFolder = await Workspace.getExportsFolder();
              try {
                await GpxExporter.exportLog(
                    db, logItem.id!, exportsFolder.path);
                SmashDialogs.showInfoDialog(
                    context,
                    SL
                        .of(context)
                        .logList_gpsSavedInExportFolder); //"GPX saved in export folder."
              } on Exception catch (e, s) {
                SMLogger().e("Error exporting log GPX", e, s);
                SmashDialogs.showErrorDialog(
                    context,
                    SL
                        .of(context)
                        .logList_errorOccurredExportingLogGPX); //"An error occurred while exporting log to GPX."
              }
            }),
        // DELETE
        SlidableAction(
            label: SL.of(context).logList_delete, //'Delete'
            foregroundColor: SmashColors.mainBackground,
            backgroundColor: SmashColors.mainDanger.withAlpha(200),
            // icon: MdiIcons.delete,
            onPressed: (context) async {
              bool hasChildren = widget.children.isNotEmpty;
              if (hasChildren) {
                // deleting log with children is not allowed, first remove children
                await SmashDialogs.showInfoDialog(context,
                    'Cannot delete logs with children. Please remove the children first.');
                return;
              }

              bool? doDelete = await SmashDialogs.showConfirmDialog(
                  context,
                  SL.of(context).logList_DELETE, //"DELETE"
                  SL
                      .of(context)
                      .logList_areYouSureDeleteTheLog); //'Are you sure you want to delete the log?'
              if (doDelete != null && doDelete) {
                db.deleteGpslog(logItem.id!);
                widget.reloadLogFunction();
              }
            })
      ],
    );

    var logColorObject =
        EnhancedColorUtility.splitEnhancedColorString(logItem.color!);
    Widget icon;
    if (logColorObject[1] != ColorTables.none) {
      icon = Icon(
        MdiIcons.palette,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.SMALL_ICON_SIZE,
      );
    } else {
      icon = Icon(
        SmashIcons.logIcon,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.SMALL_ICON_SIZE,
      );
    }

    return Slidable(
      key: Key("logview-${logItem.id}"),
      startActionPane: startActionPane,
      endActionPane: endActionPane,
      child: ListTile(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Checkbox(
                value: logItem.isVisible == 1,
                onChanged: (isVisible) async {
                  if (isVisible == null) return;
                  final ids = <int>[
                    logItem.id!,
                    ...widget.children.map((c) => c.id!),
                  ];

                  // Update all pieces in one go
                  for (final id in ids) {
                    db.updateGpsLogVisibility(isVisible, id);
                  }
                  Provider.of<ProjectState>(context, listen: false)
                      .reloadProject(context);
                  setState(() {
                    logItem.isVisible = isVisible ? 1 : 0;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: icon,
              ),
              SmashUI.normalText('${logItem.name}',
                  bold: true, textAlign: TextAlign.left),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: pad),
                            child: dayIcon),
                        Text(dayString),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: pad),
                            child: timeIcon),
                        Text(timeString),
                        Padding(
                            padding: EdgeInsets.only(right: pad),
                            child: distIcon),
                        Text(lengthString),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: pad),
                            child: upIcon),
                        Text(upString),
                        Padding(
                            padding: EdgeInsets.only(left: padLeft, right: pad),
                            child: downIcon),
                        Text(downString),
                        Padding(
                            padding: EdgeInsets.only(left: padLeft, right: pad),
                            child: countIcon),
                        Text(countString),
                      ],
                    ),
                  ],
                ),
              ),
              if (logItem.keywords != null &&
                  logItem.keywords!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LogTagsView(tagsString: logItem.keywords),
                ),
              // expand/collapse if children exist
              if (widget.children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: InkWell(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _expanded ? MdiIcons.chevronUp : MdiIcons.chevronDown,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(_expanded ? "Hide details" : "Show details"),
                        const SizedBox(width: 8),
                        Text("(${widget.children.length + 1} pieces)"),
                      ],
                    ),
                  ),
                ),
              // if expanded, show details for parent + children
              if (_expanded && _pieceStats.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _pieceStats.map((ps) {
                      final lenStr = ps.lengthMeters > 1000
                          ? "${(ps.lengthMeters / 1000).toStringAsFixed(1)} km"
                          : "${ps.lengthMeters.round()} m";

                      final isParent = ps.id == widget.logItem.id;
                      Log4ListWidget? piece = null;
                      for (final p in widget.children) {
                        if (p.id == ps.id) {
                          piece = p;
                          break;
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              isParent
                                  ? MdiIcons.arrowRight
                                  : MdiIcons.subdirectoryArrowRight,
                              size: 24,
                              color: SmashColors.mainDecorationsDarker,
                            ),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child:
                                  _buildLogColorIcon(piece ?? widget.logItem),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ps.name,
                                    style: TextStyle(
                                      fontWeight: isParent
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  Text("${ps.day} • ${ps.duration} • $lenStr"),
                                ],
                              ),
                            ),
                            if (!isParent && piece != null)
                              IconButton(
                                icon: Icon(
                                  MdiIcons.palette,
                                  size: 18,
                                  color: SmashColors.mainDecorationsDarker,
                                ),

                                tooltip: SL
                                    .of(context)
                                    .logList_properties, // or your string
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LogPropertiesWidget(piece!),
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                            if (!isParent)
                              Tooltip(
                                message: "Remove this log from its parent",
                                child: IconButton(
                                  icon: Icon(MdiIcons.linkOff),
                                  color: SmashColors.mainDecorationsDarker,
                                  onPressed: () async {
                                    final doIt =
                                        await SmashDialogs.showConfirmDialog(
                                      context,
                                      "REMOVE",
                                      "Remove this log from its parent?",
                                    );
                                    if (doIt == true) {
                                      final db = widget.projectState.projectDb!;
                                      db.setParentLog(ps.id, null);
                                      widget.reloadLogFunction();
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTime(
      Log4ListWidget item, GpsState gpsState, ProjectState projectState) {
    var endTime = item.endTime!;
    if (item.endTime == 0) {
      if (projectState.isLogging && item.id == projectState.currentLogId) {
        endTime = DateTime.now().millisecondsSinceEpoch;
      } else {
        // needs to be fixed using the points. Do it and refresh.
        var data = projectState.projectDb!.getLogDataPointsById(item.id!);
        if (data.length > 0) {
          var last = data.last;
          var ts = last.ts;
          projectState.projectDb!.updateGpsLogEndts(item.id!, ts!);
        }
        return "";
      }
    }

    var timeStr =
        StringUtilities.formatDurationMillis(endTime - item.startTime!);
    return timeStr;
  }

  List<double> _getElevMinMaxAndLengthDeltaCount(
      Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) {
    double up = 0;
    double down = 0;
    var pointsList = db.getLogDataPoints(item.id!);

    double length = 0;
    List<int> removeIndexesList = [];
    for (int i = 0; i < pointsList.length - 1; i++) {
      // calculate the length
      LogDataPoint ldp1 = pointsList[i];
      LogDataPoint ldp2 = pointsList[i + 1];
      double distance;
      if (widget.useGpsFilteredGenerally && ldp1.filtered_lat != null) {
        distance = CoordinateUtilities.getDistance(
            Coordinate.fromYX(ldp1.filtered_lat!, ldp1.filtered_lon!),
            Coordinate.fromYX(ldp2.filtered_lat!, ldp2.filtered_lon!));
      } else {
        distance = CoordinateUtilities.getDistance(
            Coordinate.fromYX(ldp1.lat, ldp1.lon),
            Coordinate.fromYX(ldp2.lat, ldp2.lon));
      }
      length += distance;

      // start removing subsequent duplicates
      double elev1 = pointsList[i].altim!;
      double elev2 = pointsList[i + 1].altim!;
      if (elev2 - elev1 == 0) {
        removeIndexesList.add(i);
      }
    }
    removeIndexesList.reversed.forEach((index) {
      pointsList.removeAt(index);
    });
    removeIndexesList = [];
    // then remove simmetric peaks
    for (int i = 0; i < pointsList.length - 2; i++) {
      double elev1 = pointsList[i].altim!;
      double elev2 = pointsList[i + 1].altim!;
      double elev3 = pointsList[i + 2].altim!;
      var delta1 = elev2 - elev1;
      var delta2 = elev3 - elev2;
      var deltaDiff = delta2 + delta1;
      // print("Check $i $elev1 / $elev2 / $elev3");
      if (deltaDiff.abs() < 0.1) {
        // print("REMOVE $elev1 and $elev2");
        // remove the central peak and first duplicate
        removeIndexesList.add(i);
        removeIndexesList.add(i + 1);
      }
    }
    removeIndexesList.reversed.toSet().forEach((index) {
      // var removeAt =
      pointsList.removeAt(index);
      // print("Removed $index: ${removeAt.altim}");
    });

    var minThresholdSum = 5; // meters
    var maxThreshold = 10; // meters
    double deltaSum = 0;
    for (int i = 0; i < pointsList.length - 1; i++) {
      double elev1 = pointsList[i].altim!;
      double elev2 = pointsList[i + 1].altim!;

      var delta = elev2 - elev1;

      // print("$i = $delta   ->   $elev1      $elev2");
      if (delta.abs() > maxThreshold) {
        // ignore the point
        continue;
      }

      deltaSum += delta;
      // print("$i = $delta   ->   $deltaSum");
      if (deltaSum.abs() > minThresholdSum) {
        // print("USE IT $deltaSum");
        if (deltaSum > 0) {
          up += deltaSum;
        } else {
          down += deltaSum;
        }
        deltaSum = 0;
      }
    }
    return [up, down.abs(), length, pointsList.length.toDouble()];
  }

  Widget _buildLogColorIcon(Log4ListWidget item) {
    if (item.color == null) {
      return Icon(SmashIcons.logIcon, size: SmashUI.SMALL_ICON_SIZE);
    }

    final logColorObject =
        EnhancedColorUtility.splitEnhancedColorString(item.color!);

    if (logColorObject[1] != ColorTables.none) {
      return Icon(
        MdiIcons.palette,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.SMALL_ICON_SIZE,
      );
    } else {
      return Icon(
        SmashIcons.logIcon,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.SMALL_ICON_SIZE,
      );
    }
  }

  Future<int?> _showAddPiecePicker(BuildContext context, int parentId) async {
    final db = widget.projectState.projectDb!;

    // Pull all logs as list widgets (fast enough; if you want, later we can pass them in)
    final all =
        db.getQueryObjectsList(Log4ListWidgetBuilder()).cast<Log4ListWidget>();

    // Exclude: the parent itself + already in this group
    final excludedIds = <int>{
      parentId,
      ...widget.children.where((c) => c.id != null).map((c) => c.id!),
    };

    // Optional: avoid nesting (only allow logs that are not already children)
    // If you want to allow moving a child from another parent, remove this constraint.
    final candidates = all.where((l) {
      final id = l.id;
      if (id == null) return false;
      if (excludedIds.contains(id)) return false;

      // avoid nesting: do not allow selecting a log that is already a child
      if (l.parentId != null) return false;

      return true;
    }).toList();

    candidates.sort((a, b) {
      final at = a.startTime ?? 0;
      final bt = b.startTime ?? 0;
      return bt.compareTo(at); // newest first
    });

    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        String query = "";
        List<Log4ListWidget> filtered = List.of(candidates);

        void applyFilter(void Function(void Function()) setModalState) {
          setModalState(() {
            if (query.trim().isEmpty) {
              filtered = List.of(candidates);
            } else {
              final q = query.toLowerCase();
              filtered = candidates.where((l) {
                final name = (l.name ?? "").toLowerCase();
                final kws = (l.keywords ?? "").toLowerCase();
                return name.contains(q) ||
                    kws.contains(q) ||
                    "${l.id}".contains(q);
              }).toList();
            }
          });
        }

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Add piece", // TODO i18n
                            style: Theme.of(ctx).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search logs…", // TODO i18n
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) {
                        query = v;
                        applyFilter(setModalState);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text("No eligible logs found."), // TODO i18n
                      )
                    else
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(ctx).size.height * 0.6,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final l = filtered[i];
                            final day = (l.startTime != null)
                                ? TimeUtilities.ISO8601_TS_FORMATTER.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        l.startTime!),
                                  )
                                : "";

                            return ListTile(
                              dense: true,
                              title: Text(l.name ?? "Log ${l.id}"),
                              subtitle: Text(day),
                              onTap: () => Navigator.pop(ctx, l.id),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class LogTagsView extends StatelessWidget {
  final String? tagsString; // e.g. "forest;hydrology;field"
  final double fontSize;
  final bool wrapSpacingTight;

  const LogTagsView({
    required this.tagsString,
    this.fontSize = 14,
    this.wrapSpacingTight = false,
  });

  @override
  Widget build(BuildContext context) {
    final tags = (tagsString ?? '')
        .split(';')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return SmashSelectedReadonlyTags(
      tags: tags,
      fontSize: fontSize,
      wrapSpacingTight: wrapSpacingTight,
    );
  }
}
