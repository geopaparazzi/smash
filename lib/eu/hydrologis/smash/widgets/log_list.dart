/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:after_layout/after_layout.dart';
import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';

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
  Log4ListWidget fromMap(Map<String, dynamic> map) {
    Log4ListWidget l = new Log4ListWidget()
      ..id = map[LOGS_COLUMN_ID]
      ..name = map[LOGS_COLUMN_TEXT]
      ..startTime = map[LOGS_COLUMN_STARTTS]
      ..endTime = map[LOGS_COLUMN_ENDTS]
      ..lengthm = map[LOGS_COLUMN_LENGTHM]
      ..color = map[LOGSPROP_COLUMN_COLOR]
      ..width = map[LOGSPROP_COLUMN_WIDTH]
      ..isVisible = map[LOGSPROP_COLUMN_VISIBLE];
    return l;
  }

  @override
  String insertSql() {
    // TODO
    return null;
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

  @override
  void afterFirstLayout(BuildContext context) {
    loadLogs();
  }

  Future loadLogs() async {
    var itemsList =
        await widget.db.getQueryObjectsList(Log4ListWidgetBuilder());

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
        await Provider.of<ProjectState>(context, listen: false)
            .reloadProject(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("GPS Logs list"),
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.checkBoxMultipleOutline),
              tooltip: "Select all",
              onPressed: () async {
                await db.updateGpsLogVisibility(true);
                await loadLogs();
              },
            ),
            IconButton(
              tooltip: "Unselect all",
              icon: Icon(MdiIcons.checkboxMultipleBlankOutline),
              onPressed: () async {
                await db.updateGpsLogVisibility(false);
                await loadLogs();
              },
            ),
            PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 1) {
                  await db.invertGpsLogsVisibility();
                  await loadLogs();
                } else if (value == 2) {
                  if (_logsList.length > 1) {
                    var masterId; // = (_logsList.first as Log4ListWidget).id;
                    var mergeIds = <int>[];
                    for (Log4ListWidget log in _logsList) {
                      if (log.isVisible == 1) {
                        if (masterId == null) {
                          masterId = log.id;
                        } else {
                          mergeIds.add(log.id);
                        }
                      }
                    }
                    await db.mergeGpslogs(masterId, mergeIds);
                    await loadLogs();
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                var txt1 = "Invert selection";
                var txt2 = "Merge selected";
                return [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(txt1),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(txt2),
                  )
                ];
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: SmashCircularProgress(label: "Loading logs..."))
            : ListView.builder(
                itemCount: _logsList.length,
                itemBuilder: (context, index) {
                  Log4ListWidget logItem = _logsList[index] as Log4ListWidget;
                  return LogInfo(logItem, gpsState, db, loadLogs);
                }),
      ),
    );
  }
}

class LogInfo extends StatefulWidget {
  var db;
  var gpsState;
  var logItem;
  var reloadLogFunction;

  LogInfo(this.logItem, this.gpsState, this.db, this.reloadLogFunction);

  @override
  _LogInfoState createState() => _LogInfoState();
}

class _LogInfoState extends State<LogInfo> with AfterLayoutMixin {
  String timeString = "- nv -";
  String lengthString = "- nv -";

  String upString = "- nv -";
  String downString = "- nv -";

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    timeString = await _getTime(widget.logItem, widget.gpsState, widget.db);
    lengthString = _getLength(widget.logItem, widget.gpsState);
    List<double> upDown =
        await _getElevDelta(widget.logItem, widget.gpsState, widget.db);
    if (upDown[0] == -1) {
      upString = "- nv -";
      downString = "- nv -";
    } else {
      upString = "${upDown[0].toInt()}m";
      downString = "${upDown[1].toInt()}m";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var logItem = widget.logItem;
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
        caption: 'Zoom to',
        color: SmashColors.mainDecorations,
        icon: MdiIcons.magnifyScan,
        onTap: () async {
          SmashMapState mapState =
              Provider.of<SmashMapState>(context, listen: false);
          LatLng position = await db.getLogStartPosition(logItem.id);
          mapState.center = Coordinate(position.longitude, position.latitude);
          Navigator.of(context).pop();
        }));
    actions.add(IconSlideAction(
      caption: 'Properties',
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
    secondaryActions.add(IconSlideAction(
        caption: 'Delete',
        color: SmashColors.mainDanger,
        icon: MdiIcons.delete,
        onTap: () async {
          bool doDelete = await showConfirmDialog(
              context, "DELETE", 'Are you sure you want to delete the log?');
          if (doDelete) {
            await db.deleteGpslog(logItem.id);
            await widget.reloadLogFunction();
          }
        }));

    return Slidable(
      key: ValueKey(logItem),
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
                ],
              )
            ],
          ),
        ),
        leading: Icon(
          SmashIcons.logIcon,
          color: ColorExt(logItem.color),
          size: SmashUI.MEDIUM_ICON_SIZE,
        ),
        trailing: Checkbox(
            value: logItem.isVisible == 1 ? true : false,
            onChanged: (isVisible) async {
              logItem.isVisible = isVisible ? 1 : 0;
              await db.updateGpsLogVisibility(isVisible, logItem.id);
              await Provider.of<ProjectState>(context, listen: false)
                  .reloadProject(context);
              setState(() {});
            }),
      ),
      actions: actions,
      secondaryActions: secondaryActions,
    );
  }

  Future<String> _getTime(
      Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) async {
    var minutes = (item.endTime - item.startTime) / 1000 / 60;
    if (item.endTime == 0) {
      if (gpsState.isLogging && item.id == gpsState.currentLogId) {
        minutes = (DateTime.now().millisecondsSinceEpoch - item.startTime) /
            1000 /
            60;
      } else {
        // needs to be fixed using the points. Do it and refresh.
        var data = await db.getLogDataPointsById(item.id);
        if (data != null && data.length > 0) {
          var last = data.last;
          var ts = last.ts;
          await db.updateGpsLogEndts(item.id, ts);
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
      var hStr = h > 1 ? "hours" : "hour";
      return "$h $hStr $m min";
    } else {
      var m = minutes.toInt();
      return "$m min";
    }
  }

  String _getLength(Log4ListWidget item, GpsState gpsState) {
    double length = item.lengthm;
    if (length == 0 &&
        item.endTime == 0 &&
        gpsState.isLogging &&
        item.id == gpsState.currentLogId) {
      var points = gpsState.currentLogPoints;
      double sum = 0;
      for (int i = 0; i < points.length - 1; i++) {
        double distance =
            CoordinateUtilities.getDistance(points[i], points[i + 1]);
        sum += distance;
      }
      length = sum;
    }
    if (length > 1000) {
      var lengthKm = length / 1000;
      var l = (lengthKm * 10).toInt() / 10.0;
      return "${l.toStringAsFixed(1)} km";
    } else {
      return "${length.round()} m";
    }
  }

  Future<List<double>> _getElevDelta(
      Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) async {
    double up = 0;
    double down = 0;
    // if (item.name != "log_20200601_170019") {
    //   return [-1, -1];
    // }
    var pointsList = await db.getLogDataPoints(item.id);
    List<int> removeIndexesList = [];
    // start removing subsequent duplicates
    for (int i = 0; i < pointsList.length - 1; i++) {
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
      var removeAt = pointsList.removeAt(index);
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
    return [up, down.abs()];
  }
}
