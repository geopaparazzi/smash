/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/validators.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/database/database.dart';

/// Log object dedicated to the list of logs widget.
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

/// [QueryObjectBuilder] to allow erasy extraction from the db.
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
        ORDER BY l.$LOGS_COLUMN_ID;
    ''';
    return sql;
  }

  @override
  Map<String, dynamic> toMap(Log4ListWidget item) {
    // TODO
    return null;
  }
}

class LogWidget extends StatefulWidget {
  Function _reloadFunction;

  LogWidget(this._reloadFunction);

  @override
  State<StatefulWidget> createState() {
    return LogWidgetState();
  }
}

class LogWidgetState extends State<LogWidget> {
  List<Log4ListWidget> _logsList = [];

  Future<bool> loadLogs() async {
    var db = await gpProjectModel.getDatabase();
    var itemsList = await db.getQueryObjectsList(Log4ListWidgetBuilder());
    if (itemsList != null) {
      _logsList = itemsList;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GPS Logs list"),
        ),
        body: FutureBuilder<void>(
          future: loadLogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return ListView.builder(
                  itemCount: _logsList.length,
                  itemBuilder: (context, index) {
                    Log4ListWidget logItem = _logsList[index];
                    return Dismissible(
                      confirmDismiss: _confirmLogDismiss,
                      direction: DismissDirection.endToStart,
                      onDismissed: _onDismissed(logItem),
                      key: ValueKey(logItem.hashCode.toString()),
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
                              size: GpConstants.MEDIUM_DIALOG_ICON_SIZE,
                            ),
                            Checkbox(
                                value: logItem.isVisible == 1 ? true : false,
                                onChanged: (isVisible) async {
                                  logItem.isVisible = isVisible ? 1 : 0;
                                  var db = await gpProjectModel.getDatabase();
                                  await db.updateGpsLogVisibility(
                                      logItem.id, isVisible);
                                  widget._reloadFunction();
                                  setState(() {});
                                }),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_right),
                        title: Text('${logItem.name}'),
                        subtitle:
                            Text('${_getTime(logItem)} ${_getLength(logItem)}'),
                        onTap: () => _navigateToLogProperties(context, logItem),
                        onLongPress: () => _changeLogName(context, logItem),
                      ),
                    );
                  });
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  _changeLogName(BuildContext context, Log4ListWidget logItem) async {
    String result = await showInputDialog(
      context,
      "Change log name",
      "Please enter a new name for the log",
      hintText: logItem.name,
      validationFunction: noEmptyValidator,
    );
    if (result != null) {
      var db = await gpProjectModel.getDatabase();
      await db.updateGpsLogName(logItem.id, result);
      setState(() {
        logItem.name = result;
      });
    }
  }

  _getTime(Log4ListWidget item) {
    var minutes = (item.endTime - item.startTime) / 1000 / 60;
    if (minutes > 60) {
      var hours = minutes / 60;
      var h = (hours * 10).toInt() / 10.0;
      return "Hours: $h";
    } else {
      var m = minutes.toInt();
      return "Minutes: $m";
    }
  }

  _getLength(Log4ListWidget item) {
    var length = item.lengthm.toInt();
    if (length > 1000) {
      var lengthKm = length / 1000;
      var l = (lengthKm * 10).toInt() / 10.0;
      return "Km: $l";
    } else {
      return "Meters: $length";
    }
  }

  _onDismissed(Log4ListWidget logItem) {
    // TODO remove log
  }

  Future<bool> _confirmLogDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text('Are you dure you want to delete the log?'),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LogPropertiesWidget(widget._reloadFunction, logItem)));
  }
}

class LogPropertiesWidget extends StatefulWidget {
  var _logItem;
  Function _reloadFunction;

  LogPropertiesWidget(this._reloadFunction, this._logItem);

  @override
  State<StatefulWidget> createState() {
    return LogPropertiesWidgetState(_logItem);
  }
}

class LogPropertiesWidgetState extends State<LogPropertiesWidget> {
  Log4ListWidget _logItem;
  double _widthSliderValue;
  ColorExt _logColor;
  double maxWidth = 20.0;

  LogPropertiesWidgetState(this._logItem);

  @override
  void initState() {
    _widthSliderValue = _logItem.width;
    if (_widthSliderValue > maxWidth) {
      _widthSliderValue = maxWidth;
    }
    _logColor = ColorExt(_logItem.color);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // save color and width
          _logItem.width = _widthSliderValue;
          _logItem.color = ColorExt.asHex(_logColor);

          var db = await gpProjectModel.getDatabase();
          await db.updateGpsLogStyle(
              _logItem.id, _logItem.color, _logItem.width);
          widget._reloadFunction();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("GPS Log Properties"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(GpConstants.DEFAULT_PADDING),
                  child: Card(
                    elevation: GpConstants.DEFAULT_ELEVATION,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(GpConstants.DEFAULT_PADDING),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.2),
                              1: FlexColumnWidth(0.8),
                            },
                            children: _getInfoTableCells(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _getInfoTableCells() {
    return [
      TableRow(
        children: [
          cellForString("Name"),
          cellForString(_logItem.name),
        ],
      ),
      TableRow(
        children: [
          cellForString("Start"),
          cellForString(ISO8601_TS_FORMATTER.format(
              new DateTime.fromMillisecondsSinceEpoch(_logItem.startTime))),
        ],
      ),
      TableRow(
        children: [
          cellForString("End"),
          cellForString(ISO8601_TS_FORMATTER.format(
              new DateTime.fromMillisecondsSinceEpoch(_logItem.endTime))),
        ],
      ),
      TableRow(
        children: [
          cellForString("Color"),
          MaterialColorPicker(
              allowShades: false,
              onColorChange: (Color color) {
                _logColor = ColorExt.fromColor(color);
              },
              onMainColorChange: (mColor) {
                _logColor = ColorExt.fromColor(mColor);
              },
              selectedColor: Color(_logColor.value)),
        ],
      ),
      TableRow(
        children: [
          cellForString("Width"),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Slider(
                    activeColor: SmashColors.mainSelection,
                    min: 1.0,
                    max: 20.0,
                    divisions: 10,
                    onChanged: (newRating) {
                      setState(() => _widthSliderValue = newRating);
                    },
                    value: _widthSliderValue,
                  )),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text('${_widthSliderValue.toInt()}',
                    style: GpConstants.MEDIUM_DIALOG_TEXT_STYLE),
              ),
            ],
          )
        ],
      ),
    ];
  }

  TableCell cellForString(String data) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          data,
          style: GpConstants.MEDIUM_DIALOG_TEXT_STYLE,
        ),
      ),
    );
  }
}
