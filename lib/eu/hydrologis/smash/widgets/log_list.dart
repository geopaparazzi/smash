/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database/database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
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
  var db;
  LogListWidget(this.db);

  @override
  State<StatefulWidget> createState() {
    return LogListWidgetState();
  }
}

/// The log list widget state.
class LogListWidgetState extends State<LogListWidget> {
  List<dynamic> _logsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future loadLogs() async {
    var itemsList =
        await widget.db.getQueryObjectsList(Log4ListWidgetBuilder());
    if (itemsList != null) {
      _logsList = itemsList;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS Logs list"),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.checkBoxMultipleOutline),
            tooltip: "Select all",
            onPressed: () async {
              await db.updateGpsLogVisibility(true);
              await loadLogs();
              await reloadMap(context);
            },
          ),
          IconButton(
            tooltip: "Unselect all",
            icon: Icon(MdiIcons.checkboxMultipleBlankOutline),
            onPressed: () async {
              await db.updateGpsLogVisibility(false);
              await loadLogs();
              await reloadMap(context);
            },
          ),
          PopupMenuButton<int>(
            onSelected: (value) async {
              if (value == 1) {
                await db.invertGpsLogsVisibility();
                await loadLogs();
                await reloadMap(context);
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
                  await reloadMap(context);
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
                return buildLogSlidable(logItem, gpsState, db);
              }),
    );
  }

  Slidable buildLogSlidable(
      Log4ListWidget logItem, GpsState gpsState, GeopaparazziProjectDb db) {
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
        var somethingChanged = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogPropertiesWidget(logItem)));
        if (somethingChanged) {
          loadLogs();
        }
      },
    ));
    secondaryActions.add(IconSlideAction(
        caption: 'Delete',
        color: SmashColors.mainDanger,
        icon: MdiIcons.delete,
        onTap: () async {
          await db.deleteGpslog(logItem.id);
          await loadLogs();
          await reloadMap(context);
          setState(() {});
        }));

    return Slidable(
      key: ValueKey(logItem),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text('${logItem.name}'),
        subtitle: Text(
            '${_getTime(logItem, gpsState, db)}; ${_getLength(logItem, gpsState)}'),
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
              await loadLogs();
              await reloadMap(context);
            }),
      ),
      actions: actions,
      secondaryActions: secondaryActions,
    );
  }

  Future reloadMap(context) async {
    Provider.of<ProjectState>(context).reloadProject(context);
  }

  _getTime(Log4ListWidget item, GpsState gpsState, GeopaparazziProjectDb db) {
    var minutes = (item.endTime - item.startTime) / 1000 / 60;
    if (item.endTime == 0) {
      if (gpsState.isLogging && item.id == gpsState.currentLogId) {
        minutes = (DateTime.now().millisecondsSinceEpoch - item.startTime) /
            1000 /
            60;
      } else {
        // needs to be fixed using the points. Do it and refresh.
        db.getLogDataPointsById(item.id).then((data) {
          if (data != null && data.length > 0) {
            var last = data.last;
            var ts = last.ts;
            db.updateGpsLogEndts(item.id, ts).then((i) {
              setState(() {});
            });
          } else {
            // remove those that have no data
            db.deleteGpslog(item.id).then((deleted) {
              if (deleted) {
                setState(() {});
              }
            });
          }
        });
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

  _getLength(Log4ListWidget item, GpsState gpsState) {
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
}
