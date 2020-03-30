/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database/database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
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
  LogListWidget();

  @override
  State<StatefulWidget> createState() {
    return LogListWidgetState();
  }
}

/// The log list widget state.
class LogListWidgetState extends State<LogListWidget> {
  List<dynamic> _logsList = [];

  Future<bool> loadLogs(var db) async {
    var itemsList = await db.getQueryObjectsList(Log4ListWidgetBuilder());
    if (itemsList != null) {
      _logsList = itemsList;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectState>(builder: (context, projectState, child) {
      GpsState gpsState = Provider.of<GpsState>(context, listen: false);
      var db = projectState.projectDb;
      return Scaffold(
        appBar: AppBar(
          title: Text("GPS Logs list"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              tooltip: "Select all",
              onPressed: () async {
                await db.updateGpsLogVisibility(true);
                setState(() {});
              },
            ),
            IconButton(
              tooltip: "Unselect all",
              icon: Icon(Icons.check_box_outline_blank),
              onPressed: () async {
                await db.updateGpsLogVisibility(false);
                setState(() {});
              },
            ),
            IconButton(
              tooltip: "Invert selection",
              icon: Icon(Icons.check_box),
              onPressed: () async {
                await db.invertGpsLogsVisibility();
                setState(() {});
              },
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: loadLogs(db),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return ListView.builder(
                  itemCount: _logsList.length,
                  itemBuilder: (context, index) {
                    Log4ListWidget logItem = _logsList[index] as Log4ListWidget;
                    return Dismissible(
                      confirmDismiss: _confirmLogDismiss,
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await db.deleteGpslog(logItem.id);
                        await projectState.reloadProject();
                      },
                      key: Key("${logItem.id}"),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.timeline,
                              color: ColorExt(logItem.color),
                              size: SmashUI.MEDIUM_ICON_SIZE,
                            ),
                            Checkbox(
                                value: logItem.isVisible == 1 ? true : false,
                                onChanged: (isVisible) async {
                                  logItem.isVisible = isVisible ? 1 : 0;
                                  await db.updateGpsLogVisibility(
                                      isVisible, logItem.id);
                                  await projectState.reloadProject();
                                  setState(() {});
                                }),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_right),
                        title: Text('${logItem.name}'),
                        subtitle: Text(
                            '${_getTime(logItem, gpsState, db)} ${_getLength(logItem, gpsState)}'),
                        onTap: () => _navigateToLogProperties(context, logItem),
                        onLongPress: () async {
                          SmashMapState mapState = Provider.of<SmashMapState>(
                              context,
                              listen: false);
                          LatLng position =
                          await db.getLogStartPosition(logItem.id);
                          mapState.center =
                              Coordinate(position.longitude, position.latitude);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  });
            } else {
              // Otherwise, display a loading indicator.
              return Center(
                  child: SmashCircularProgress(label: "Loading logs..."));
            }
          },
        ),
      );
    });
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
          var last = data.last;
          var ts = last.ts;
          db.updateGpsLogEndts(item.id, ts).then((i) {
            setState(() {});
          });
        });
        return "";
      }
    }

    if (minutes > 60) {
      var hours = minutes / 60;
      var h = (hours * 10).toInt() / 10.0;
      return "Hours: $h";
    } else {
      var m = minutes.toInt();
      return "Minutes: $m";
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
      return "Km: ${l.round()}";
    } else {
      return "Meters: ${length.round()}";
    }
  }

  Future<bool> _confirmLogDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text('Are you sure you want to delete the log?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  _navigateToLogProperties(BuildContext context, Log4ListWidget logItem) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LogPropertiesWidget(logItem)));
  }
}
