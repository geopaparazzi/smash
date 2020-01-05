/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_jts/dart_jts.dart' hide Orientation;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/flutterlibs/eventhandlers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geo.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_database.dart';
import 'package:smash/eu/hydrologis/smash/core/models.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/project_tables.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/validators.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/icons.dart';
import 'package:provider/provider.dart';

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
                                  await db.updateGpsLogVisibility(isVisible, logItem.id);
                                  await projectState.reloadProject();
                                  setState(() {});
                                }),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_right),
                        title: Text('${logItem.name}'),
                        subtitle: Text('${_getTime(logItem, gpsState, db)} ${_getLength(logItem, gpsState)}'),
                        onTap: () => _navigateToLogProperties(context, logItem),
                        onLongPress: () async {
                          SmashMapState mapState = Provider.of<SmashMapState>(context, listen: false);
                          LatLng position = await db.getLogStartPosition(logItem.id);
                          mapState.center = Coordinate(position.longitude, position.latitude);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  });
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
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
        minutes = (DateTime.now().millisecondsSinceEpoch - item.startTime) / 1000 / 60;
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
    if (length == 0 && item.endTime == 0 && gpsState.isLogging && item.id == gpsState.currentLogId) {
      var points = gpsState.currentLogPoints;
      double sum = 0;
      for (int i = 0; i < points.length - 1; i++) {
        double distance = CoordinateUtilities.getDistance(points[i], points[i + 1]);
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => LogPropertiesWidget(logItem)));
  }
}

/// The log properties page.
class LogPropertiesWidget extends StatefulWidget {
  var _logItem;

  LogPropertiesWidget(this._logItem);

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
  bool _somethingChanged = false;

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
          if (_somethingChanged) {
            // save color and width
            _logItem.width = _widthSliderValue;
            _logItem.color = ColorExt.asHex(_logColor);

            ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
            await projectState.projectDb.updateGpsLogStyle(_logItem.id, _logItem.color, _logItem.width);
            projectState.reloadProject();
          }
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
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.2),
                              1: FlexColumnWidth(0.8),
                            },
                            children: _getInfoTableCells(context),
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

  _getInfoTableCells(BuildContext context) {
    return [
      TableRow(
        children: [
          TableUtilities.cellForString("Name"),
          cellForEditableName(context, _logItem),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Start"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER.format(new DateTime.fromMillisecondsSinceEpoch(_logItem.startTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("End"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER.format(new DateTime.fromMillisecondsSinceEpoch(_logItem.endTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Color"),
          LimitedBox(
            maxHeight: 400,
            child: MaterialColorPicker(
                shrinkWrap: true,
                allowShades: false,
                onColorChange: (Color color) {
                  _logColor = ColorExt.fromColor(color);
                  _somethingChanged = true;
                },
                onMainColorChange: (mColor) {
                  _logColor = ColorExt.fromColor(mColor);
                  _somethingChanged = true;
                },
                selectedColor: Color(_logColor.value)),
          ),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Width"),
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
                      _somethingChanged = true;
                      setState(() => _widthSliderValue = newRating);
                    },
                    value: _widthSliderValue,
                  )),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: SmashUI.normalText(
                  '${_widthSliderValue.toInt()}',
                ),
              ),
            ],
          )
        ],
      ),
    ];
  }

  TableCell cellForEditableName(BuildContext context, Log4ListWidget item) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: SmashUI.normalText(item.name, color: SmashColors.mainDecorationsDarker),
          onDoubleTap: () {
            _changeLogName(context, item);
          },
        ),
      ),
    );
  }

  _changeLogName(BuildContext context, Log4ListWidget logItem) async {
    String result = await showInputDialog(
      context,
      "Change log name",
      "Please enter a new name for the log",
      defaultText: logItem.name,
      validationFunction: noEmptyValidator,
    );
    if (result != null) {
      ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
      await projectState.projectDb.updateGpsLogName(logItem.id, result);
      setState(() {
        logItem.name = result;
      });
    }
  }
}

class NotePropertiesWidgetState extends State<NotePropertiesWidget> {
  Note _note;
  double _sizeSliderValue = 10;
  double _maxSize = 500.0;
  ColorExt _noteColor;
  String _marker = 'mapMarker';
  bool _somethingChanged = false;
  var chosenIconsList = [];

  NotePropertiesWidgetState(this._note);

  @override
  void initState() {
    _sizeSliderValue = _note?.noteExt?.size;
    if (_sizeSliderValue > _maxSize) {
      _sizeSliderValue = _maxSize;
    }
    _noteColor = ColorExt(_note.noteExt.color);
    _marker = _note.noteExt.marker;

    chosenIconsList.addAll(GpPreferences().getStringListSync(KEY_ICONS_LIST, DEFAULT_NOTES_ICONDATA));
    if (!chosenIconsList.contains(_marker)) {
      chosenIconsList.insert(0, _marker);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<GridTile> _iconButtons = [];
    chosenIconsList.forEach((iconName) {
      var color = SmashColors.mainDecorations;
      if (iconName == _marker) color = SmashColors.mainSelection;
      var but = GridTile(
          child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        color: SmashColors.mainBackground,
        child: IconButton(
          icon: Icon(getIcon(iconName)),
          color: color,
          onPressed: () {
            _marker = iconName;
            _somethingChanged = true;
            setState(() {});
          },
        ),
      ));
      _iconButtons.add(but);
    });

    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _note.noteExt.color = ColorExt.asHex(_noteColor);
            _note.noteExt.marker = _marker;
            _note.noteExt.size = _sizeSliderValue;

            ProjectState projectState = Provider.of<ProjectState>(context, listen: false);
            await projectState.projectDb.updateNote(_note);
            projectState.reloadProject();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Note Properties"),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.4),
                              1: FlexColumnWidth(0.6),
                            },
                            children: _getInfoTableCells(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: MaterialColorPicker(
                          shrinkWrap: true,
                          allowShades: false,
                          circleSize: 45,
                          onColorChange: (Color color) {
                            _noteColor = ColorExt.fromColor(color);
                            _somethingChanged = true;
                          },
                          onMainColorChange: (mColor) {
                            _noteColor = ColorExt.fromColor(mColor);
                            _somethingChanged = true;
                          },
                          selectedColor: Color(_noteColor.value)),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SmashUI.normalText("Size"),
                          Flexible(
                              flex: 1,
                              child: Slider(
                                activeColor: SmashColors.mainSelection,
                                min: 5,
                                max: _maxSize,
                                divisions: 99,
                                onChanged: (newRating) {
                                  _somethingChanged = true;
                                  setState(() => _sizeSliderValue = newRating);
                                },
                                value: _sizeSliderValue,
                              )),
                          Container(
                            width: 50.0,
                            alignment: Alignment.center,
                            child: SmashUI.normalText(
                              '${_sizeSliderValue.toInt()}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return GridView.count(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: orientation == Orientation.portrait ? 5 : 10,
                            childAspectRatio: 1,
                            padding: EdgeInsets.all(5),
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: _iconButtons,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _getInfoTableCells(BuildContext context) {
    return [
      TableRow(
        children: [
          TableUtilities.cellForString("Note"),
          _cellForNoteText(context, _note),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Timestamp"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(_note.timeStamp))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Altitude"),
          TableUtilities.cellForString(_note.altim.toStringAsFixed(KEY_ELEV_DECIMALS)),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Longitude"),
          TableUtilities.cellForString(_note.lon.toStringAsFixed(KEY_LATLONG_DECIMALS)),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Latitude"),
          TableUtilities.cellForString(_note.lat.toStringAsFixed(KEY_LATLONG_DECIMALS)),
        ],
      ),
    ];
  }

  TableCell _cellForNoteText(BuildContext context, Note item) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: SmashUI.normalText(item.text, color: SmashColors.mainDecorationsDarker),
          onDoubleTap: () async {
            String result = await showInputDialog(
              context,
              "Change note text",
              "Please enter a new text for the note",
              defaultText: _note.text,
              validationFunction: noEmptyValidator,
            );
            if (result != null) {
              _note.text = result;
              _somethingChanged = true;
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}

/// The notes properties page.
class NotePropertiesWidget extends StatefulWidget {
  var _note;

  NotePropertiesWidget(this._note);

  @override
  State<StatefulWidget> createState() {
    return NotePropertiesWidgetState(_note);
  }
}

/// The notes list widget.
class NotesListWidget extends StatefulWidget {
  final bool _doSimpleNotes;

  NotesListWidget(this._doSimpleNotes);

  @override
  State<StatefulWidget> createState() {
    return NotesListWidgetState();
  }
}

/// The log list widget state.
class NotesListWidgetState extends State<NotesListWidget> {
  List<dynamic> _notesList = [];

  Future<bool> loadNotes(var db) async {
    _notesList.clear();
    dynamic itemsList = await db.getNotes(doSimple: widget._doSimpleNotes);
    if (itemsList != null) {
      _notesList.addAll(itemsList);
    }
    if (widget._doSimpleNotes) {
      itemsList = await db.getImages();
      if (itemsList != null) {
        _notesList.addAll(itemsList);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    var db = projectState.projectDb;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._doSimpleNotes ? "Simple Notes List" : "Form Notes List"),
        ),
        body: FutureBuilder<void>(
          future: loadNotes(db),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return ListView.builder(
                  itemCount: _notesList.length,
                  itemBuilder: (context, index) {
                    dynamic dynNote = _notesList[index];
                    int id;
                    var markerName;
                    var markerColor;
                    String text;
                    bool hasProperties = true;
                    int ts;
                    double lat;
                    double lon;
                    if (dynNote is Note) {
                      id = dynNote.id;
                      markerName = dynNote.noteExt.marker;
                      markerColor = dynNote.noteExt.color;
                      text = dynNote.text;
                      ts = dynNote.timeStamp;
                      lon = dynNote.lon;
                      lat = dynNote.lat;
                      if (dynNote.form != null) {
                        hasProperties = false;
                      }
                    } else {
                      hasProperties = false;
                      id = dynNote.id;
                      markerName = 'camera';
                      markerColor = ColorExt.asHex(SmashColors.mainDecorationsDarker);
                      text = dynNote.text;
                      ts = dynNote.timeStamp;
                      lon = dynNote.lon;
                      lat = dynNote.lat;
                    }

                    return Dismissible(
                      confirmDismiss: _confirmNoteDismiss,
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await db.deleteNote(id);
                        projectState.reloadProject();
                      },
                      key: Key("${id}"),
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
                              getIcon(markerName) ?? MdiIcons.mapMarker,
                              color: ColorExt(markerColor),
                              size: SmashUI.MEDIUM_ICON_SIZE,
                            ),
//                            Checkbox(
//                                value: note.isVisible == 1 ? true : false,
//                                onChanged: (isVisible) async {
//                                  note.isVisible = isVisible ? 1 : 0;
//                                  var db = await gpProjectModel.getDatabase();
//                                  await db.updateGpsLogVisibility(
//                                      isVisible, note.id);
//                                  widget._eventHandler.reloadProjectFunction();
//                                  setState(() {});
//                                }),
                          ],
                        ),
                        trailing: hasProperties ? Icon(Icons.arrow_right) : SmashUI.getTransparentIcon(),
                        title: Text('${text}'),
                        subtitle: Text('${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(ts))}'),
                        onTap: () {
                          if (hasProperties) {
                            _navigateToNoteProperties(context, dynNote);
                          }
                        },
                        onLongPress: () {
                          LatLng position = LatLng(lat, lon);
                          Provider.of<SmashMapState>(context, listen: false).center = Coordinate(position.longitude, position.latitude);
                          Navigator.of(context).pop();
                        },
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

  Future<bool> _confirmNoteDismiss(DismissDirection direction) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: Text('Are you sure you want to delete the note?'),
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

  _navigateToNoteProperties(BuildContext context, Note note) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotePropertiesWidget(note)));
  }
}
