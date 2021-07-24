/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/export/gpx_kml_export.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/elevcolor.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

/// Log object dedicated to the list widget containing logs.
class Log4ListWidget {
  int id;
  String name;
  double width;
  int startTime = 0;
  int endTime = 0;
  double lengthm = 0.0;
  String color;
  int isVisible;
}

/// [QueryObjectBuilder] to allow easy extraction from the db.
class Log4ListWidgetBuilder extends QueryObjectBuilder<Log4ListWidget> {
  @override
  Log4ListWidget fromRow(QueryResultRow map) {
    Log4ListWidget l = new Log4ListWidget()
      ..id = map.get(LOGS_COLUMN_ID)
      ..name = map.get(LOGS_COLUMN_TEXT)
      ..startTime = map.get(LOGS_COLUMN_STARTTS)
      ..endTime = map.get(LOGS_COLUMN_ENDTS)
      ..lengthm = map.get(LOGS_COLUMN_LENGTHM)
      ..color = map.get(LOGSPROP_COLUMN_COLOR)
      ..width = map.get(LOGSPROP_COLUMN_WIDTH)
      ..isVisible = map.get(LOGSPROP_COLUMN_VISIBLE);
    return l;
  }

  @override
  String querySql() {
    String sql = '''
        SELECT l.$LOGS_COLUMN_ID, l.$LOGS_COLUMN_TEXT, l.$LOGS_COLUMN_STARTTS, l.$LOGS_COLUMN_ENDTS, 
               l.$LOGS_COLUMN_LENGTHM, p.$LOGSPROP_COLUMN_COLOR, p.$LOGSPROP_COLUMN_WIDTH, p.$LOGSPROP_COLUMN_VISIBLE
        FROM $TABLE_GPSLOGS l, $TABLE_GPSLOG_PROPERTIES p 
        WHERE l.$LOGS_COLUMN_ID=p.$LOGSPROP_COLUMN_LOGID
        ORDER BY l.$LOGS_COLUMN_ID
    ''';
    return sql;
  }

  @override
  Map<String, dynamic> toMap(Log4ListWidget item) {
    // TODO
    return null;
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
class LogListWidgetState extends State<LogListWidget> with AfterLayoutMixin {
  List<dynamic> _logsList = [];
  bool _isLoading = true;
  bool useGpsFilteredGenerally;

  @override
  void afterFirstLayout(BuildContext context) {
    useGpsFilteredGenerally = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, false);
    loadLogs();
  }

  loadLogs() {
    var itemsList = widget.db.getQueryObjectsList(Log4ListWidgetBuilder());

    if (itemsList != null) {
      _logsList = itemsList.reversed.toList();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    GpsState gpsState = Provider.of<GpsState>(context, listen: false);
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
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
            PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 1) {
                  db.updateGpsLogVisibility(true);
                  loadLogs();
                } else if (value == 2) {
                  db.updateGpsLogVisibility(false);
                  loadLogs();
                } else if (value == 3) {
                  db.invertGpsLogsVisibility();
                  loadLogs();
                } else if (value == 4) {
                  if (_logsList.length > 1) {
                    var minTs = double.infinity;
                    var masterId;
                    _logsList.forEach((l) {
                      var lw = l as Log4ListWidget;
                      if (lw.isVisible == 1 && lw.startTime < minTs) {
                        masterId = lw.id;
                      }
                    });

                    var mergeIds = <int>[];
                    for (Log4ListWidget log in _logsList) {
                      if (log.isVisible == 1 && log.id != masterId) {
                        mergeIds.add(log.id);
                      }
                    }
                    db.mergeGpslogs(masterId, mergeIds);
                    loadLogs();
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
        body: _isLoading
            ? Center(
                child: SmashCircularProgress(
                    label:
                        SL.of(context).logList_loadingLogs)) //"Loading logs..."
            : ListView.builder(
                itemCount: _logsList.length,
                itemBuilder: (context, index) {
                  Log4ListWidget logItem = _logsList[index] as Log4ListWidget;
                  return LogInfo(
                      logItem, gpsState, db, loadLogs, useGpsFilteredGenerally,
                      key: Key("${logItem.id}"));
                }),
      ),
    );
  }
}

class LogInfo extends StatefulWidget {
  final GeopaparazziProjectDb db;
  final gpsState;
  final Log4ListWidget logItem;
  final reloadLogFunction;
  final useGpsFilteredGenerally;

  LogInfo(this.logItem, this.gpsState, this.db, this.reloadLogFunction,
      this.useGpsFilteredGenerally,
      {Key key})
      : super(key: key);

  @override
  _LogInfoState createState() => _LogInfoState();
}

class _LogInfoState extends State<LogInfo> with AfterLayoutMixin {
  String timeString = "- nv -";
  String lengthString = "- nv -";
  String countString = "- nv -";

  String upString = "- nv -";
  String downString = "- nv -";

  @override
  void afterFirstLayout(BuildContext context) {
    timeString = _getTime(widget.logItem, widget.gpsState, widget.db);
    // lengthString = _getLength(widget.logItem, widget.gpsState);
    List<double> upDownLengthCount = _getElevMinMaxAndLengthDeltaCount(
        widget.logItem, widget.gpsState, widget.db);
    if (upDownLengthCount[0] == -1) {
      upString = "- nv -";
      downString = "- nv -";
    } else {
      upString = "${upDownLengthCount[0].toInt()}m";
      downString = "${upDownLengthCount[1].toInt()}m";
    }

    var count = upDownLengthCount[3];
    countString = "${count.toInt()} pts";

    var length = upDownLengthCount[2];
    if (length > 1000) {
      var lengthKm = length / 1000;
      var l = (lengthKm * 10).toInt() / 10.0;
      lengthString = "${l.toStringAsFixed(1)} km";
    } else {
      lengthString = "${length.round()} m";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Log4ListWidget logItem = widget.logItem;
    var db = widget.db;

    var size = 15.0;
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

    List<Widget> actions = [];
    List<Widget> secondaryActions = [];

    actions.add(IconSlideAction(
        caption: SL.of(context).logList_zoomTo, //'Zoom to'
        color: SmashColors.mainDecorations,
        icon: MdiIcons.magnifyScan,
        onTap: () async {
          SmashMapState mapState =
              Provider.of<SmashMapState>(context, listen: false);
          var logDataPoints = db.getLogDataPoints(logItem.id);
          Envelope env = Envelope.empty();
          logDataPoints.forEach((point) {
            var lat = point.lat;
            var lon = point.lon;
            env.expandToInclude(lon, lat);
          });
          mapState.setBounds(env);
          Navigator.of(context).pop();
        }));
    actions.add(IconSlideAction(
      caption: SL.of(context).logList_properties, //'Properties'
      color: SmashColors.mainDecorations,
      icon: MdiIcons.palette,
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogPropertiesWidget(logItem)));
        setState(() {});
      },
    ));
    actions.add(IconSlideAction(
      caption: SL.of(context).logList_profileView, //'Profile View'
      color: SmashColors.mainDecorations,
      icon: MdiIcons.chartAreaspline,
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => LogProfileView(logItem)));
        setState(() {});
      },
    ));
    secondaryActions.add(IconSlideAction(
        caption: SL.of(context).logList_toGPX, //'To GPX'
        color: SmashColors.mainDecorations,
        icon: MdiIcons.mapMarker,
        onTap: () async {
          var exportsFolder = await Workspace.getExportsFolder();
          try {
            await GpxExporter.exportLog(db, logItem.id, exportsFolder.path);
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
        }));
    secondaryActions.add(IconSlideAction(
        caption: SL.of(context).logList_delete, //'Delete'
        color: SmashColors.mainDanger,
        icon: MdiIcons.delete,
        onTap: () async {
          bool doDelete = await SmashDialogs.showConfirmDialog(
              context,
              SL.of(context).logList_DELETE, //"DELETE"
              SL
                  .of(context)
                  .logList_areYouSureDeleteTheLog); //'Are you sure you want to delete the log?'
          if (doDelete != null && doDelete) {
            db.deleteGpslog(logItem.id);
            widget.reloadLogFunction();
          }
        }));

    var logColorObject =
        EnhancedColorUtility.splitEnhancedColorString(logItem.color);
    var icon;
    if (logColorObject[1] != ColorTables.none) {
      icon = Icon(
        MdiIcons.palette,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.MEDIUM_ICON_SIZE,
      );
    } else {
      icon = Icon(
        SmashIcons.logIcon,
        color: ColorExt(logColorObject[0]),
        size: SmashUI.MEDIUM_ICON_SIZE,
      );
    }
    return Slidable(
      key: Key("logview-${logItem.id}"),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: SmashUI.normalText('${logItem.name}',
            bold: true, textAlign: TextAlign.left),
        subtitle: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: pad),
                    child: timeIcon,
                  ),
                  Text(timeString),
                  Padding(
                    padding: EdgeInsets.only(left: padLeft, right: pad),
                    child: distIcon,
                  ),
                  Text(lengthString),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: pad),
                    child: upIcon,
                  ),
                  Text(upString),
                  Padding(
                    padding: EdgeInsets.only(left: padLeft, right: pad),
                    child: downIcon,
                  ),
                  Text(downString),
                  Padding(
                    padding: EdgeInsets.only(left: padLeft, right: pad),
                    child: countIcon,
                  ),
                  Text(countString),
                ],
              )
            ],
          ),
        ),
        leading: icon,
        trailing: Checkbox(
            value: logItem.isVisible == 1 ? true : false,
            onChanged: (isVisible) async {
              logItem.isVisible = isVisible ? 1 : 0;
              db.updateGpsLogVisibility(isVisible, logItem.id);
              Provider.of<ProjectState>(context, listen: false)
                  .reloadProject(context);
              setState(() {});
            }),
      ),
      actions: actions,
      secondaryActions: secondaryActions,
    );
  }

  String _getTime(
      Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) {
    var minutes = (item.endTime - item.startTime) / 1000 / 60;
    if (item.endTime == 0) {
      if (gpsState.isLogging && item.id == gpsState.currentLogId) {
        minutes = (DateTime.now().millisecondsSinceEpoch - item.startTime) /
            1000 /
            60;
      } else {
        // needs to be fixed using the points. Do it and refresh.
        var data = db.getLogDataPointsById(item.id);
        if (data != null && data.length > 0) {
          var last = data.last;
          var ts = last.ts;
          db.updateGpsLogEndts(item.id, ts);
          minutes = (ts - item.startTime) / 1000 / 60;
        } else {
          minutes = 0;
        }

        return "";
      }
    }

    if (minutes > 60) {
      var h = minutes ~/ 60;
      var m = (minutes % 60).round();
      var hStr = h > 1
          ? SL.of(context).logList_hours //"hours"
          : SL.of(context).logList_hour; //"hour"
      return "$h $hStr $m ${SL.of(context).logList_minutes}"; // "$h $hStr $m min";
    } else {
      var m = minutes.toInt();
      return "$m ${SL.of(context).logList_minutes}"; //"$m min"
    }
  }

  List<double> _getElevMinMaxAndLengthDeltaCount(
      Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) {
    double up = 0;
    double down = 0;
    var pointsList = db.getLogDataPoints(item.id);

    double length = 0;
    List<int> removeIndexesList = [];
    for (int i = 0; i < pointsList.length - 1; i++) {
      // calculate the length
      LogDataPoint ldp1 = pointsList[i];
      LogDataPoint ldp2 = pointsList[i + 1];
      double distance;
      if (widget.useGpsFilteredGenerally && ldp1.filtered_lat != null) {
        distance = CoordinateUtilities.getDistance(
            LatLng(ldp1.filtered_lat, ldp1.filtered_lon),
            LatLng(ldp2.filtered_lat, ldp2.filtered_lon));
      } else {
        distance = CoordinateUtilities.getDistance(
            LatLng(ldp1.lat, ldp1.lon), LatLng(ldp2.lat, ldp2.lon));
      }
      length += distance;

      // start removing subsequent duplicates
      double elev1 = pointsList[i].altim;
      double elev2 = pointsList[i + 1].altim;
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
      double elev1 = pointsList[i].altim;
      double elev2 = pointsList[i + 1].altim;
      double elev3 = pointsList[i + 2].altim;
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
      double elev1 = pointsList[i].altim;
      double elev2 = pointsList[i + 1].altim;

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
}
