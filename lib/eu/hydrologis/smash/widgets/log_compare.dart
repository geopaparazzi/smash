/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

class LogCompare extends StatefulWidget {
  const LogCompare({Key? key}) : super(key: key);

  @override
  State<LogCompare> createState() => _LogCompareState();
}

class _LogCompareState extends State<LogCompare> {
  Future<void>? _loadFuture;

  final Map<String, ProjectDb> _projectDbsMap = <String, ProjectDb>{};

  // two independent panes (top/bottom)
  final _PaneState _top = _PaneState();
  final _PaneState _bottom = _PaneState();

  // tweak as you like
  static const double _wideBreakpoint = 900;
  static const double _initialLeftPaneWidth = 360;
  static const double _minLeftPaneWidth = 260;
  static const double _minChartPaneWidth = 320;
  static const double _dividerWidth = 10;

  double _leftPaneWidth = _initialLeftPaneWidth;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadProjects();
  }

  @override
  void dispose() {
    _top.dispose();
    _bottom.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    final projectsFolder = await Workspace.getProjectsFolder();

    final projectFilePaths = await projectsFolder
        .list()
        .where((f) => f.path.endsWith('.gpap'))
        .map((f) => f.path)
        .toList();

    _projectDbsMap.clear();
    for (final projectFilePath in projectFilePaths) {
      final projectDb = await GeopaparazziProjectDb(projectFilePath);
      projectDb.createNecessaryExtraTables();
      final name = FileUtilities.nameFromFile(projectFilePath, false);
      _projectDbsMap[name] = projectDb;
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<List<Log>> _loadLogs(ProjectDb db) async {
    final logs = await db.getLogs();
    return logs.where((log) => log.parentLogId == null).toList();
  }

  Future<void> _enterLogsMode(_PaneState pane, String projectName) async {
    final db = _projectDbsMap[projectName];
    if (db == null) return;

    pane.selectedProjectName = projectName;
    pane.selectedProjectDb = db;
    pane.selectedLog = null;
    pane.logs = const [];
    pane.isInLogsMode = true;

    if (!mounted) return;
    setState(() {});

    final logs = await _loadLogs(db);
    if (!mounted) return;

    pane.logs = logs;
    setState(() {});
  }

  void _backToProjects(_PaneState pane) {
    pane.isInLogsMode = false;
    pane.selectedProjectName = null;
    pane.selectedProjectDb = null;
    pane.selectedLog = null;
    pane.logs = const [];
    pane.logsFilterController.text = '';
    setState(() {});
  }

  void _selectLog(_PaneState pane, Log log) {
    pane.selectedLog = log;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snap) {
        final isLoading = snap.connectionState != ConnectionState.done;
        final hasError = snap.hasError;

        return Scaffold(
          appBar: AppBar(
            title: Text(SL.of(context).logCompare_title),
            actions: [
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
          body: hasError
              ? SmashUI.errorWidget(snap.error.toString())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= _wideBreakpoint;
                    return isWide
                        ? _buildWide(constraints.maxWidth)
                        : _buildNarrow();
                  },
                ),
        );
      },
    );
  }

  Widget _buildWide(double totalWidth) {
    final allProjectNames = _projectDbsMap.keys.toList()..sort();
    final maxLeftPaneWidth = math.max(
        _minLeftPaneWidth, totalWidth - _minChartPaneWidth - _dividerWidth);
    final leftPaneWidth =
        _leftPaneWidth.clamp(_minLeftPaneWidth, maxLeftPaneWidth).toDouble();

    return Row(
      children: [
        SizedBox(
          width: leftPaneWidth,
          child: Column(
            children: [
              Expanded(
                child: _SelectorPane(
                  paneColor: Colors.red,
                  pane: _top,
                  projectNames: allProjectNames,
                  onSelectProject: (name) => _enterLogsMode(_top, name),
                  onBackToProjects: () => _backToProjects(_top),
                  onSelectLog: (log) => _selectLog(_top, log),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _SelectorPane(
                  paneColor: Colors.blue,
                  pane: _bottom,
                  projectNames: allProjectNames,
                  onSelectProject: (name) => _enterLogsMode(_bottom, name),
                  onBackToProjects: () => _backToProjects(_bottom),
                  onSelectLog: (log) => _selectLog(_bottom, log),
                ),
              ),
            ],
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              final next = (_leftPaneWidth + details.delta.dx)
                  .clamp(_minLeftPaneWidth, maxLeftPaneWidth)
                  .toDouble();
              if (next != _leftPaneWidth) {
                setState(() => _leftPaneWidth = next);
              }
            },
            child: SizedBox(
              width: _dividerWidth,
              child: const Center(
                child: VerticalDivider(width: 1, thickness: 1),
              ),
            ),
          ),
        ),
        Expanded(
          child: _ChartArea(
            logA: _top.selectedLog,
            logB: _bottom.selectedLog,
            projectA: _top.selectedProjectName,
            projectB: _bottom.selectedProjectName,
            projectDbsMap: _projectDbsMap,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrow() {
    final allProjectNames = _projectDbsMap.keys.toList()..sort();
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            child: TabBar(
              labelColor: SmashColors.mainDecorationsDarker,
              unselectedLabelColor: SmashColors.mainDecorations,
              tabs: [
                Tab(text: SL.of(context).logCompare_log1),
                Tab(text: SL.of(context).logCompare_log2),
                Tab(text: SL.of(context).logCompare_chartTab),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _SelectorPane(
                  paneColor: Colors.red,
                  pane: _top,
                  projectNames: allProjectNames,
                  onSelectProject: (name) => _enterLogsMode(_top, name),
                  onBackToProjects: () => _backToProjects(_top),
                  onSelectLog: (log) => _selectLog(_top, log),
                ),
                _SelectorPane(
                  paneColor: Colors.blue,
                  pane: _bottom,
                  projectNames: allProjectNames,
                  onSelectProject: (name) => _enterLogsMode(_bottom, name),
                  onBackToProjects: () => _backToProjects(_bottom),
                  onSelectLog: (log) => _selectLog(_bottom, log),
                ),
                _ChartArea(
                  logA: _top.selectedLog,
                  logB: _bottom.selectedLog,
                  projectA: _top.selectedProjectName,
                  projectB: _bottom.selectedProjectName,
                  projectDbsMap: _projectDbsMap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaneState {
  bool isInLogsMode = false;

  final TextEditingController projectsFilterController =
      TextEditingController();
  final TextEditingController logsFilterController = TextEditingController();

  final FocusNode projectsFilterFocus = FocusNode(debugLabel: 'projectsFilter');
  final FocusNode logsFilterFocus = FocusNode(debugLabel: 'logsFilter');

  String? selectedProjectName;
  ProjectDb? selectedProjectDb;

  List<Log> logs = const [];
  Log? selectedLog;

  void dispose() {
    projectsFilterController.dispose();
    logsFilterController.dispose();

    projectsFilterFocus.dispose();
    logsFilterFocus.dispose();
  }

  List<Log> filteredLogs() {
    final f = logsFilterController.text.trim().toLowerCase();
    if (f.isEmpty) return logs;
    return logs.where((l) {
      final label = (l.text ?? '').toLowerCase();
      final idStr = '${l.id}';
      return label.contains(f) || idStr.contains(f);
    }).toList();
  }
}

class _SelectorPane extends StatelessWidget {
  const _SelectorPane({
    required this.paneColor,
    required this.pane,
    required this.projectNames, // full list (sorted)
    required this.onSelectProject,
    required this.onBackToProjects,
    required this.onSelectLog,
  });

  final Color paneColor;
  final _PaneState pane;

  final List<String> projectNames;
  final void Function(String projectName) onSelectProject;
  final VoidCallback onBackToProjects;
  final void Function(Log log) onSelectLog;

  List<String> _filterProjects(List<String> all, String filter) {
    final f = filter.trim().toLowerCase();
    if (f.isEmpty) return all;
    return all.where((n) => n.toLowerCase().contains(f)).toList();
  }

  List<Log> _filterLogs(List<Log> all, String filter) {
    final f = filter.trim().toLowerCase();
    if (f.isEmpty) return all;
    return all.where((l) {
      final label = (l.text ?? '').toLowerCase();
      final idStr = '${l.id}';
      return label.contains(f) || idStr.contains(f);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = pane.isInLogsMode
        ? pane.logsFilterController
        : pane.projectsFilterController;

    final fn =
        pane.isInLogsMode ? pane.logsFilterFocus : pane.projectsFilterFocus;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              SmashUI.normalText(
                pane.isInLogsMode
                    ? SL.of(context).logCompare_selectLog
                    : SL.of(context).logCompare_selectProject,
                bold: true,
                color: paneColor,
              ),
              const Spacer(),
              if (pane.isInLogsMode)
                Tooltip(
                  message: SL.of(context).logCompare_backToProjects,
                  child: IconButton(
                    onPressed: onBackToProjects,
                    icon: Icon(Icons.arrow_back,
                        color: SmashColors.mainDecorationsDarker),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            focusNode: fn,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: pane.isInLogsMode
                  ? SL.of(context).logCompare_filterLogs
                  : SL.of(context).logCompare_filterProjects,
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: paneColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: paneColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: paneColor, width: 2),
              ),
              suffixIcon: ctrl.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: SL.of(context).logCompare_clearFilter,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ctrl.clear();

                        // re-focus so user can type again immediately
                        fn.requestFocus();

                        // trigger rebuild so list updates + suffix icon disappears
                        (context as Element).markNeedsBuild();
                      },
                    ),
            ),
            onChanged: (_) {
              (context as Element).markNeedsBuild();
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: paneColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: ctrl,
                builder: (context, value, _) {
                  if (pane.isInLogsMode) {
                    final logs = _filterLogs(pane.logs, value.text);
                    return _buildLogsList(context, logs);
                  } else {
                    final names = _filterProjects(projectNames, value.text);
                    return _buildProjectsList(context, names);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, List<String> names) {
    if (names.isEmpty) {
      return Center(
        child: SmashUI.titleText(
          SL.of(context).logCompare_noProjects,
          color: SmashColors.mainDecorationsDarker,
          bold: true,
        ),
      );
    }

    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, idx) {
        final name = names[idx];
        final selected = pane.selectedProjectName == name && !pane.isInLogsMode;

        return ListTile(
          dense: true,
          selected: selected,
          leading:
              Icon(MdiIcons.database, color: SmashColors.mainDecorationsDarker),
          title: Tooltip(
            message: name,
            child: SmashUI.smallText(
              name,
              overflow: TextOverflow.ellipsis,
              color: SmashColors.mainDecorationsDarker,
            ),
          ),
          onTap: () => onSelectProject(name),
        );
      },
    );
  }

  Widget _buildLogsList(BuildContext context, List<Log> logs) {
    if (pane.selectedProjectName == null) {
      return Center(child: Text(SL.of(context).logCompare_selectProjectFirst));
    }
    if (pane.logs.isEmpty) {
      return Center(child: Text(SL.of(context).logCompare_noLogsOrLoading));
    }
    if (logs.isEmpty) {
      return Center(child: Text(SL.of(context).logCompare_noLogsMatchFilter));
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, idx) {
        final log = logs[idx];
        final selectedColor = paneColor;
        final sl = SL.of(context);
        final label = (log.text == null || log.text!.trim().isEmpty)
            ? sl.logCompare_logWithId(log.id ?? '')
            : log.text!.trim();
        final selected = pane.selectedLog?.id == log.id;

        return ListTile(
          dense: true,
          selected: selected,
          selectedTileColor: selectedColor.withValues(alpha: 0.08),
          leading: Icon(
            MdiIcons.vectorPolyline,
            color: selected ? selectedColor : SmashColors.mainDecorationsDarker,
          ),
          title: Tooltip(
            message: label,
            child: SmashUI.smallText(
              label,
              overflow: TextOverflow.ellipsis,
              color:
                  selected ? selectedColor : SmashColors.mainDecorationsDarker,
              bold: selected,
            ),
          ),
          subtitle: SmashUI.smallText(
            sl.logCompare_idWithValue(log.id ?? ''),
            color: selected ? selectedColor : SmashColors.mainDecorationsDarker,
            bold: selected,
          ),
          onTap: () => onSelectLog(log),
        );
      },
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea({
    required this.logA,
    required this.logB,
    required this.projectA,
    required this.projectB,
    required this.projectDbsMap,
  });

  final Log? logA;
  final Log? logB;
  final String? projectA;
  final String? projectB;
  final Map<String, ProjectDb> projectDbsMap;

  String _logLabel(BuildContext context, Log log) {
    final text = log.text?.trim();
    if (text == null || text.isEmpty) {
      return SL.of(context).logCompare_logWithId(log.id ?? '');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final sl = SL.of(context);
    if (logA == null && logB == null) {
      return Center(child: Text(sl.logCompare_selectAtLeastOneLog));
    }
    List<List<LogDataPoint>> logDataA = const [];
    List<List<LogDataPoint>> logDataB = const [];

    if (logA != null && projectA != null) {
      final dbA = projectDbsMap[projectA];
      if (dbA != null) {
        logDataA = logA!.getLogData(dbA);
      }
    }

    if (logB != null && projectB != null) {
      final dbB = projectDbsMap[projectB];
      if (dbB != null) {
        logDataB = logB!.getLogData(dbB);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 6,
                children: [
                  if (logA != null)
                    Text(
                      _logLabel(context, logA!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  if (logA != null && logB != null)
                    Text(
                      sl.logCompare_vs,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (logB != null)
                    Text(
                      _logLabel(context, logB!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: LogCompareChartWithToggles(
                      redSegments: logDataA,
                      blueSegments: logDataB,
                      redLabel: sl.logCompare_log1,
                      blueLabel: sl.logCompare_log2,
                      initialXAxis: CompareXAxis.distance,
                      initialYAxis: CompareYAxis.altitude,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
// HELPER METHODS FOR CHART PREPARATION BELOW
//////////////////////////////////////////////////
class PreparedMulti {
  PreparedMulti(this.segments, this.minX, this.maxX, this.minY, this.maxY);

  final List<List<FlSpot>> segments;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
}

double _lon(LogDataPoint p) => p.filtered_lon ?? p.lon;
double _lat(LogDataPoint p) => p.filtered_lat ?? p.lat;

double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0; // meters
  final dLat = (lat2 - lat1) * math.pi / 180.0;
  final dLon = (lon2 - lon1) * math.pi / 180.0;

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180.0) *
          math.cos(lat2 * math.pi / 180.0) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return r * c;
}

/// Converts List<List<LogDataPoint>> (main + children) into
/// one continuous FlSpot series (children appended after parent) + global bounds.
/// Dart 2 compatible.
PreparedMulti prepareMultiSeries(
  List<List<LogDataPoint>> segments, {
  required CompareXAxis xAxis,
  required CompareYAxis yAxis,
  SpeedSeriesMode speedMode = SpeedSeriesMode.smoothed,
  bool computeSpeedIfMissing = true,
  bool sortByTsWithinSegment = true,
  int maxPointsPerSegment = 2500,
}) {
  if (segments.isEmpty) {
    return PreparedMulti(const [], 0, 1, 0, 1);
  }

  final mergedSpots = <FlSpot>[];
  var xOffset = 0.0;
  const segmentJoinEps = 1e-6;

  double minX = double.infinity;
  double maxX = -double.infinity;
  double minY = double.infinity;
  double maxY = -double.infinity;

  for (final rawSeg in segments) {
    if (rawSeg.isEmpty) continue;

    final seg = <LogDataPoint>[...rawSeg];

    if (sortByTsWithinSegment) {
      seg.sort((a, b) {
        final ta = a.ts;
        final tb = b.ts;
        if (ta == null && tb == null) return 0;
        if (ta == null) return 1;
        if (tb == null) return -1;
        return ta.compareTo(tb);
      });
    }

    // Find first usable point
    int startIdx = 0;
    while (startIdx < seg.length) {
      if (xAxis == CompareXAxis.time && seg[startIdx].ts == null) {
        startIdx++;
      } else {
        break;
      }
    }
    if (startIdx >= seg.length) continue;

    final startTs = seg[startIdx].ts ?? 0;

    final n = seg.length - startIdx;
    final stride =
        (n > maxPointsPerSegment) ? (n / maxPointsPerSegment).ceil() : 1;

    final spots = <FlSpot>[];
    double cumDist = 0.0;

    LogDataPoint? prevKept;
    double? emaY;

    for (int i = startIdx; i < seg.length; i += stride) {
      final p = seg[i];

      // X
      double x;
      if (xAxis == CompareXAxis.time) {
        if (p.ts == null) {
          prevKept = p;
          continue;
        }
        // epoch millis -> minutes from segment start
        x = (p.ts! - startTs) / 60000.0;
      } else {
        if (prevKept != null) {
          final d = _haversineMeters(
            _lat(prevKept),
            _lon(prevKept),
            _lat(p),
            _lon(p),
          );
          if (d.isFinite && d >= 0) cumDist += d;
        }
        x = cumDist; // meters
      }

      // Y
      double? y;
      switch (yAxis) {
        case CompareYAxis.speed:
          y = p.speed;
          if ((y == null || !y.isFinite) && computeSpeedIfMissing) {
            if (prevKept != null && prevKept.ts != null && p.ts != null) {
              final dt = (p.ts! - prevKept.ts!) / 1000.0;
              if (dt >= 1.0 && dt <= 60.0) {
                final d = _haversineMeters(
                  _lat(prevKept),
                  _lon(prevKept),
                  _lat(p),
                  _lon(p),
                );
                final sp = d / dt; // m/s
                if (sp.isFinite && sp >= 0 && sp <= 20.0) y = sp;
              }
            }
          }
          break;

        case CompareYAxis.altitude:
          y = p.altim;
          break;
      }

      if (y != null && y.isFinite && speedMode == SpeedSeriesMode.smoothed) {
        final alpha = yAxis == CompareYAxis.speed ? 0.04 : 0.1;
        emaY = emaY == null ? y : (alpha * y + (1 - alpha) * emaY);
        y = emaY;
      }

      if (y == null || !y.isFinite) {
        prevKept = p;
        continue;
      }

      final mergedX = xOffset + x;
      spots.add(FlSpot(mergedX, y));

      if (mergedX < minX) minX = mergedX;
      if (mergedX > maxX) maxX = mergedX;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;

      prevKept = p;
    }

    if (spots.isNotEmpty) {
      mergedSpots.addAll(spots);
      xOffset = spots.last.x + segmentJoinEps;
    }
  }

  if (mergedSpots.isEmpty) {
    return PreparedMulti(const [], 0, 1, 0, 1);
  }

  // pad Y a bit so lines aren't glued to borders
  final spanY = (maxY - minY).abs();
  final pad = spanY == 0 ? (maxY.abs() * 0.1 + 1) : spanY * 0.06;

  return PreparedMulti(
    [mergedSpots],
    minX.isFinite ? minX : 0,
    maxX.isFinite ? maxX : 1,
    (minY - pad).isFinite ? (minY - pad) : 0,
    (maxY + pad).isFinite ? (maxY + pad) : 1,
  );
}

enum CompareXAxis { time, distance }

enum CompareYAxis { speed, altitude }

enum SpeedSeriesMode { raw, smoothed }

/// Drop-in header: legend + toggles.
/// Put this above the LineChart in your chart area.
class LogCompareHeader extends StatelessWidget {
  const LogCompareHeader({
    Key? key,
    required this.redLabel,
    required this.blueLabel,
    required this.xAxis,
    required this.yAxis,
    required this.onXAxisChanged,
    required this.onYAxisChanged,
    required this.speedMode,
    required this.onSpeedModeChanged,
    this.onToggleRedVisible,
    this.onToggleBlueVisible,
    this.redVisible = true,
    this.blueVisible = true,
  }) : super(key: key);

  final String redLabel;
  final String blueLabel;

  final CompareXAxis xAxis;
  final CompareYAxis yAxis;
  final SpeedSeriesMode speedMode;

  final ValueChanged<CompareXAxis> onXAxisChanged;
  final ValueChanged<CompareYAxis> onYAxisChanged;
  final ValueChanged<SpeedSeriesMode> onSpeedModeChanged;

  // Optional: allow hiding/showing series by tapping legend
  final VoidCallback? onToggleRedVisible;
  final VoidCallback? onToggleBlueVisible;
  final bool redVisible;
  final bool blueVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sl = SL.of(context);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      spacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${sl.logCompare_xAxis}:', style: theme.textTheme.labelLarge),
            const SizedBox(width: 8),
            ToggleButtons(
              isSelected: [
                xAxis == CompareXAxis.distance,
                xAxis == CompareXAxis.time,
              ],
              onPressed: (idx) {
                onXAxisChanged(
                    idx == 0 ? CompareXAxis.distance : CompareXAxis.time);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_distance),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_time),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${sl.logCompare_yAxis}:', style: theme.textTheme.labelLarge),
            const SizedBox(width: 8),
            ToggleButtons(
              isSelected: [
                yAxis == CompareYAxis.altitude,
                yAxis == CompareYAxis.speed,
              ],
              onPressed: (idx) {
                final v = idx == 0 ? CompareYAxis.altitude : CompareYAxis.speed;
                onYAxisChanged(v);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_altitude),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_speed),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              isSelected: [
                speedMode == SpeedSeriesMode.raw,
                speedMode == SpeedSeriesMode.smoothed,
              ],
              onPressed: (idx) {
                onSpeedModeChanged(
                    idx == 0 ? SpeedSeriesMode.raw : SpeedSeriesMode.smoothed);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_raw),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(sl.logCompare_smoothed),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class LogCompareChartWithToggles extends StatefulWidget {
  const LogCompareChartWithToggles({
    Key? key,
    required this.redSegments,
    required this.blueSegments,
    required this.redLabel,
    required this.blueLabel,
    this.initialXAxis = CompareXAxis.distance,
    this.initialYAxis = CompareYAxis.altitude,
  }) : super(key: key);

  final List<List<LogDataPoint>> redSegments;
  final List<List<LogDataPoint>> blueSegments;

  final String redLabel;
  final String blueLabel;

  final CompareXAxis initialXAxis;
  final CompareYAxis initialYAxis;

  @override
  State<LogCompareChartWithToggles> createState() =>
      _LogCompareChartWithTogglesState();
}

class _LogCompareChartWithTogglesState
    extends State<LogCompareChartWithToggles> {
  late CompareXAxis _xAxis = widget.initialXAxis;
  late CompareYAxis _yAxis = widget.initialYAxis;
  SpeedSeriesMode _speedMode = SpeedSeriesMode.smoothed;
  double? _viewMinX;
  double? _viewMaxX;
  double? _viewMinY;
  double? _viewMaxY;

  bool _redVisible = true;
  bool _blueVisible = true;
  double? _touchX;
  double? _touchRedY;
  double? _touchBlueY;

  List<double> _clampRange({
    required double min,
    required double max,
    required double dataMin,
    required double dataMax,
    required double minSpan,
  }) {
    final normalizedDataMin = math.min(dataMin, dataMax);
    final normalizedDataMax = math.max(dataMin, dataMax);
    final normalizedMin = math.min(min, max);
    final normalizedMax = math.max(min, max);
    final dataSpan = normalizedDataMax - normalizedDataMin;
    if (!dataSpan.isFinite || dataSpan <= minSpan) {
      return <double>[normalizedDataMin, normalizedDataMax];
    }
    var span = normalizedMax - normalizedMin;
    if (!span.isFinite) span = dataSpan;
    final clampedMinSpan = minSpan.isFinite ? math.max(0.0, minSpan) : 0.0;
    span = span.clamp(clampedMinSpan, dataSpan).toDouble();

    final halfSpan = span / 2.0;
    var center = (normalizedMin + normalizedMax) / 2.0;
    if (!center.isFinite) {
      center = (normalizedDataMin + normalizedDataMax) / 2.0;
    }
    final minCenter = normalizedDataMin + halfSpan;
    final maxCenter = normalizedDataMax - halfSpan;
    if (minCenter.isFinite &&
        maxCenter.isFinite &&
        minCenter <= maxCenter &&
        center.isFinite) {
      center = center.clamp(minCenter, maxCenter).toDouble();
    } else {
      center = (normalizedDataMin + normalizedDataMax) / 2.0;
    }
    return <double>[center - halfSpan, center + halfSpan];
  }

  void _resetZoom() {
    setState(() {
      _viewMinX = null;
      _viewMaxX = null;
      _viewMinY = null;
      _viewMaxY = null;
    });
  }

  void _zoom({
    required double factor,
    required double dataMinX,
    required double dataMaxX,
    required double dataMinY,
    required double dataMaxY,
  }) {
    final curMinX = _viewMinX ?? dataMinX;
    final curMaxX = _viewMaxX ?? dataMaxX;
    final curMinY = _viewMinY ?? dataMinY;
    final curMaxY = _viewMaxY ?? dataMaxY;

    final nextX = _clampRange(
      min: (curMinX + curMaxX) / 2.0 - (curMaxX - curMinX) * factor / 2.0,
      max: (curMinX + curMaxX) / 2.0 + (curMaxX - curMinX) * factor / 2.0,
      dataMin: dataMinX,
      dataMax: dataMaxX,
      minSpan: math.max(1e-6, (dataMaxX - dataMinX).abs() * 0.02),
    );
    final nextY = _clampRange(
      min: (curMinY + curMaxY) / 2.0 - (curMaxY - curMinY) * factor / 2.0,
      max: (curMinY + curMaxY) / 2.0 + (curMaxY - curMinY) * factor / 2.0,
      dataMin: dataMinY,
      dataMax: dataMaxY,
      minSpan: math.max(1e-6, (dataMaxY - dataMinY).abs() * 0.02),
    );

    setState(() {
      _viewMinX = nextX[0];
      _viewMaxX = nextX[1];
      _viewMinY = nextY[0];
      _viewMaxY = nextY[1];
    });
  }

  void _pan({
    required double fracX,
    required double fracY,
    required double dataMinX,
    required double dataMaxX,
    required double dataMinY,
    required double dataMaxY,
  }) {
    final curMinX = _viewMinX ?? dataMinX;
    final curMaxX = _viewMaxX ?? dataMaxX;
    final curMinY = _viewMinY ?? dataMinY;
    final curMaxY = _viewMaxY ?? dataMaxY;

    final spanX = (curMaxX - curMinX).abs();
    final spanY = (curMaxY - curMinY).abs();

    final shiftedXMin = curMinX + spanX * fracX;
    final shiftedXMax = curMaxX + spanX * fracX;
    final shiftedYMin = curMinY + spanY * fracY;
    final shiftedYMax = curMaxY + spanY * fracY;

    final nextX = _clampRange(
      min: shiftedXMin,
      max: shiftedXMax,
      dataMin: dataMinX,
      dataMax: dataMaxX,
      minSpan: math.max(1e-6, (dataMaxX - dataMinX).abs() * 0.02),
    );
    final nextY = _clampRange(
      min: shiftedYMin,
      max: shiftedYMax,
      dataMin: dataMinY,
      dataMax: dataMaxY,
      minSpan: math.max(1e-6, (dataMaxY - dataMinY).abs() * 0.02),
    );

    setState(() {
      _viewMinX = nextX[0];
      _viewMaxX = nextX[1];
      _viewMinY = nextY[0];
      _viewMaxY = nextY[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final red = prepareMultiSeries(widget.redSegments,
        xAxis: _xAxis, yAxis: _yAxis, speedMode: _speedMode);
    final blue = prepareMultiSeries(widget.blueSegments,
        xAxis: _xAxis, yAxis: _yAxis, speedMode: _speedMode);

    if ((red.segments.isEmpty || !_redVisible) &&
        (blue.segments.isEmpty || !_blueVisible)) {
      return Center(child: Text(SL.of(context).logCompare_noChartableData));
    }

    final hasRed = _redVisible && red.segments.isNotEmpty;
    final hasBlue = _blueVisible && blue.segments.isNotEmpty;

    final dataMinX = hasRed && hasBlue
        ? math.min(red.minX, blue.minX)
        : (hasRed ? red.minX : blue.minX);
    final dataMaxX = hasRed && hasBlue
        ? math.max(red.maxX, blue.maxX)
        : (hasRed ? red.maxX : blue.maxX);
    final dataMinY = hasRed && hasBlue
        ? math.min(red.minY, blue.minY)
        : (hasRed ? red.minY : blue.minY);
    final dataMaxY = hasRed && hasBlue
        ? math.max(red.maxY, blue.maxY)
        : (hasRed ? red.maxY : blue.maxY);

    final xRange = _clampRange(
      min: _viewMinX ?? dataMinX,
      max: _viewMaxX ?? dataMaxX,
      dataMin: dataMinX,
      dataMax: dataMaxX,
      minSpan: math.max(1e-6, (dataMaxX - dataMinX).abs() * 0.02),
    );
    final yRange = _clampRange(
      min: _viewMinY ?? dataMinY,
      max: _viewMaxY ?? dataMaxY,
      dataMin: dataMinY,
      dataMax: dataMaxY,
      minSpan: math.max(1e-6, (dataMaxY - dataMinY).abs() * 0.02),
    );
    final minX = xRange[0];
    final maxX = xRange[1];
    final minY = yRange[0];
    final maxY = yRange[1];
    final dataSpanX = (dataMaxX - dataMinX).abs();
    final dataSpanY = (dataMaxY - dataMinY).abs();
    final viewSpanX = (maxX - minX).abs();
    final viewSpanY = (maxY - minY).abs();
    final isZoomed = (dataSpanX > 1e-9 && viewSpanX < dataSpanX * 0.999) ||
        (dataSpanY > 1e-9 && viewSpanY < dataSpanY * 0.999);

    final bars = <LineChartBarData>[];

    if (_redVisible) {
      for (final segSpots in red.segments) {
        bars.add(
          LineChartBarData(
            spots: segSpots,
            isCurved: false,
            barWidth: 2,
            color: Colors.red,
            dotData: const FlDotData(show: false),
          ),
        );
      }
    }

    if (_blueVisible) {
      for (final segSpots in blue.segments) {
        bars.add(
          LineChartBarData(
            spots: segSpots,
            isCurved: false,
            barWidth: 2,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
          ),
        );
      }
    }

    String xTitle() => _xAxis == CompareXAxis.time
        ? SL.of(context).logCompare_timeAxisTitle
        : SL.of(context).logCompare_distanceAxisTitle;
    String xReadoutLabel() => _xAxis == CompareXAxis.time
        ? SL.of(context).logCompare_time
        : SL.of(context).logCompare_distance;
    String yTitle() {
      if (_yAxis == CompareYAxis.speed) {
        return SL.of(context).logCompare_speedAxisTitle;
      }
      return SL.of(context).logCompare_altitudeAxisTitle;
    }

    String yReadoutLabel() {
      if (_yAxis == CompareYAxis.speed) return SL.of(context).logCompare_speed;
      return SL.of(context).logCompare_altitude;
    }

    String toIntTick(double v) => v.round().toString();

    String timeLabelFromMinutes(double v) {
      final total = v.round();
      final sign = total < 0 ? '-' : '';
      final absTotal = total.abs();
      final hours = absTotal ~/ 60;
      final minutes = absTotal % 60;
      return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    String xValueLabel(double v) =>
        _xAxis == CompareXAxis.time ? timeLabelFromMinutes(v) : _fmt(v);

    double niceIntInterval(double min, double max) {
      final span = (max - min).abs();
      if (span == 0 || !span.isFinite) return 1;
      final raw = span / 6.0;
      if (raw <= 1) return 1;

      final pow10 =
          math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
      final norm = raw / pow10;
      final step = norm < 1.5
          ? 1.0
          : (norm < 3.0)
              ? 2.0
              : (norm < 7.0)
                  ? 5.0
                  : 10.0;
      return math.max(1, (step * pow10).round()).toDouble();
    }

    FlSpot? nearestSpotAtX(List<List<FlSpot>> segments, double x) {
      FlSpot? best;
      var bestDx = double.infinity;
      for (final seg in segments) {
        for (final p in seg) {
          final dx = (p.x - x).abs();
          if (dx < bestDx) {
            bestDx = dx;
            best = p;
          }
        }
      }
      return best;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          LogCompareHeader(
            redLabel: widget.redLabel,
            blueLabel: widget.blueLabel,
            xAxis: _xAxis,
            yAxis: _yAxis,
            redVisible: _redVisible,
            blueVisible: _blueVisible,
            onToggleRedVisible: () =>
                setState(() => _redVisible = !_redVisible),
            onToggleBlueVisible: () =>
                setState(() => _blueVisible = !_blueVisible),
            onXAxisChanged: (v) => setState(() {
              _xAxis = v;
              _viewMinX = null;
              _viewMaxX = null;
            }),
            onYAxisChanged: (v) => setState(() {
              _yAxis = v;
              _viewMinY = null;
              _viewMaxY = null;
            }),
            speedMode: _speedMode,
            onSpeedModeChanged: (v) => setState(() => _speedMode = v),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 22,
            child: Align(
              alignment: Alignment.center,
              child: _touchX == null
                  ? const SizedBox.shrink()
                  : Builder(
                      builder: (context) {
                        final baseStyle =
                            (Theme.of(context).textTheme.bodySmall ??
                                    const TextStyle(fontSize: 12))
                                .copyWith(fontWeight: FontWeight.w700);
                        return Text.rich(
                          TextSpan(
                            style: baseStyle,
                            children: [
                              TextSpan(
                                  text:
                                      '${xReadoutLabel()}: ${xValueLabel(_touchX!)}'),
                              TextSpan(text: '   ${yReadoutLabel()}: '),
                              TextSpan(
                                text: _touchRedY == null
                                    ? '-'
                                    : _fmt(_touchRedY!),
                                style: baseStyle.copyWith(color: Colors.red),
                              ),
                              const TextSpan(text: ' / '),
                              TextSpan(
                                text: _touchBlueY == null
                                    ? '-'
                                    : _fmt(_touchBlueY!),
                                style: baseStyle.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Stack(
              children: [
                LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    clipData: const FlClipData.all(),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    extraLinesData: ExtraLinesData(
                      verticalLines: _touchX == null
                          ? const []
                          : [
                              VerticalLine(
                                x: _touchX!,
                                color: Theme.of(context).colorScheme.outline,
                                strokeWidth: 1.5,
                                dashArray: [4, 4],
                              ),
                            ],
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        axisNameSize: 44,
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(xTitle()),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: niceIntInterval(minX, maxX),
                          minIncluded: false,
                          maxIncluded: false,
                          getTitlesWidget: (v, meta) => SideTitleWidget(
                            meta: meta,
                            fitInside:
                                SideTitleFitInsideData.fromTitleMeta(meta),
                            child: Text(
                              _xAxis == CompareXAxis.time
                                  ? timeLabelFromMinutes(v)
                                  : toIntTick(v),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameSize: 32,
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(yTitle()),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 58,
                          interval: niceIntInterval(minY, maxY),
                          minIncluded: false,
                          maxIncluded: false,
                          getTitlesWidget: (v, meta) => SideTitleWidget(
                            meta: meta,
                            fitInside:
                                SideTitleFitInsideData.fromTitleMeta(meta),
                            child: Text(
                              toIntTick(v),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        final touched = response?.lineBarSpots;
                        if (touched == null || touched.isEmpty) {
                          if (_touchX != null ||
                              _touchRedY != null ||
                              _touchBlueY != null) {
                            setState(() {
                              _touchX = null;
                              _touchRedY = null;
                              _touchBlueY = null;
                            });
                          }
                          return;
                        }

                        final spot = touched.first;
                        final touchX = spot.x;
                        double? redY;
                        double? blueY;

                        if (_redVisible && red.segments.isNotEmpty) {
                          final redSpot = nearestSpotAtX(red.segments, touchX);
                          if (redSpot != null) {
                            redY = redSpot.y;
                          }
                        }

                        if (_blueVisible && blue.segments.isNotEmpty) {
                          final blueSpot =
                              nearestSpotAtX(blue.segments, touchX);
                          if (blueSpot != null) {
                            blueY = blueSpot.y;
                          }
                        }

                        if (touchX != _touchX ||
                            redY != _touchRedY ||
                            blueY != _touchBlueY) {
                          setState(() {
                            _touchX = touchX;
                            _touchRedY = redY;
                            _touchBlueY = blueY;
                          });
                        }
                      },
                    ),
                    lineBarsData: bars,
                  ),
                  duration: const Duration(milliseconds: 180),
                ),
                Positioned(
                  right: 6,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButtonTheme(
                        data: IconButtonThemeData(
                          style: IconButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(34, 34),
                            iconSize: 22,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: SL.of(context).logCompare_zoomIn,
                              icon: const Icon(Icons.zoom_in),
                              onPressed: () => _zoom(
                                factor: 0.7,
                                dataMinX: dataMinX,
                                dataMaxX: dataMaxX,
                                dataMinY: dataMinY,
                                dataMaxY: dataMaxY,
                              ),
                            ),
                            IconButton(
                              tooltip: SL.of(context).logCompare_zoomOut,
                              icon: const Icon(Icons.zoom_out),
                              onPressed: () => _zoom(
                                factor: 1.4,
                                dataMinX: dataMinX,
                                dataMaxX: dataMaxX,
                                dataMinY: dataMinY,
                                dataMaxY: dataMaxY,
                              ),
                            ),
                            IconButton(
                              tooltip: SL.of(context).logCompare_resetZoom,
                              icon: const Icon(Icons.refresh),
                              onPressed: _resetZoom,
                            ),
                            if (isZoomed) ...[
                              const SizedBox(height: 6),
                              IconButton(
                                tooltip: SL.of(context).logCompare_panUp,
                                icon: const Icon(Icons.arrow_upward),
                                onPressed: () => _pan(
                                  fracX: 0,
                                  fracY: 0.2,
                                  dataMinX: dataMinX,
                                  dataMaxX: dataMaxX,
                                  dataMinY: dataMinY,
                                  dataMaxY: dataMaxY,
                                ),
                              ),
                              IconButton(
                                tooltip: SL.of(context).logCompare_panLeft,
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => _pan(
                                  fracX: -0.2,
                                  fracY: 0,
                                  dataMinX: dataMinX,
                                  dataMaxX: dataMaxX,
                                  dataMinY: dataMinY,
                                  dataMaxY: dataMaxY,
                                ),
                              ),
                              IconButton(
                                tooltip: SL.of(context).logCompare_panRight,
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () => _pan(
                                  fracX: 0.2,
                                  fracY: 0,
                                  dataMinX: dataMinX,
                                  dataMaxX: dataMaxX,
                                  dataMinY: dataMinY,
                                  dataMaxY: dataMaxY,
                                ),
                              ),
                              IconButton(
                                tooltip: SL.of(context).logCompare_panDown,
                                icon: const Icon(Icons.arrow_downward),
                                onPressed: () => _pan(
                                  fracX: 0,
                                  fracY: -0.2,
                                  dataMinX: dataMinX,
                                  dataMaxX: dataMaxX,
                                  dataMinY: dataMinY,
                                  dataMaxY: dataMaxY,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v.abs() >= 1000) return v.toStringAsFixed(0);
    if (v.abs() >= 100) return v.toStringAsFixed(1);
    return v.toStringAsFixed(2);
  }
}
