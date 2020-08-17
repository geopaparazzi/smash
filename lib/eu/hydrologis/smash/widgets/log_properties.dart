/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:provider/provider.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smashlibs/smashlibs.dart';

/// The log properties page.
class LogPropertiesWidget extends StatefulWidget {
  final _logItem;

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

            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.projectDb
                .updateGpsLogStyle(_logItem.id, _logItem.color, _logItem.width);
            projectState.reloadProject(context);
          }
          Navigator.pop(context, _somethingChanged);
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
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: EditableTextField(
                              "Log Name",
                              _logItem.name,
                              (res) {
                                if (res == null || res.trim().length == 0) {
                                  res = _logItem.name;
                                }
                                ProjectState projectState =
                                    Provider.of<ProjectState>(context,
                                        listen: false);
                                projectState.projectDb
                                    .updateGpsLogName(_logItem.id, res);
                                setState(() {
                                  _logItem.name = res;
                                });
                              },
                              validationFunction: noEmptyValidator,
                              doBold: true,
                            ),
                          ),
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
          TableUtilities.cellForString("Start"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(
                  new DateTime.fromMillisecondsSinceEpoch(_logItem.startTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("End"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(
                  new DateTime.fromMillisecondsSinceEpoch(_logItem.endTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Color"),
          TableCell(
            child: Padding(
              padding: SmashUI.defaultPadding(),
              child: ColorPickerButton(Color(_logColor.value), (newColor) {
                _logColor = ColorExt.fromColor(newColor);
                _somethingChanged = true;
              }),
            ),
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
        padding: const EdgeInsets.only(left: 4.0),
        child: EditableTextField(
          "Log Name",
          item.name,
          (res) {
            if (res == null || res.trim().length == 0) {
              res = item.name;
            }
            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.projectDb.updateGpsLogName(item.id, res);
            setState(() {
              item.name = res;
            });
          },
          validationFunction: noEmptyValidator,
        ),
      ),
    );
  }
}

class LogProfileView extends StatefulWidget {
  final logId;

  LogProfileView(this.logId, {Key key}) : super(key: key);

  @override
  _LogProfileViewState createState() => _LogProfileViewState();
}

class _LogProfileViewState extends State<LogProfileView> with AfterLayoutMixin {
  LatLng hoverPoint;
  List<LatLng> points = [];
  List<ElevationPoint> elevationPoints = [];
  LatLng center;

  void afterFirstLayout(BuildContext context) {
    ProjectState project = Provider.of<ProjectState>(context, listen: false);
    var logDataPoints = project.projectDb.getLogDataPoints(widget.logId);
    bool useGpsFilteredGenerally =
        GpPreferences().getBooleanSync(KEY_GPS_USE_FILTER_GENERALLY, false);
    logDataPoints.forEach((p) {
      LatLng ll;
      if (useGpsFilteredGenerally && p.filtered_accuracy != null) {
        ll = LatLng(p.filtered_lat, p.filtered_lon);
      } else {
        ll = LatLng(p.lat, p.lon);
      }
      points.add(ll);
      elevationPoints.add(ElevationPoint(ll, p.altim));
    });

    Envelope env = Envelope.empty();
    logDataPoints.forEach((point) {
      var lat = point.lat;
      var lon = point.lon;
      env.expandToInclude(lon, lat);
    });

    center = LatLng(env.centre().y, env.centre().x);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    var opacity = 0.7;

    if (hoverPoint is LatLng)
      markers.add(Marker(
          point: hoverPoint,
          width: 15,
          height: 15,
          builder: (BuildContext context) => Container(
                decoration: BoxDecoration(
                    color: SmashColors.mainDecorations,
                    borderRadius: BorderRadius.circular(8)),
              )));

    var height = ScreenUtilities.getHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("GPS Log Profile View"),
      ),
      body: center == null
          ? SmashCircularProgress(label: "Loading data...")
          : Stack(children: [
              FlutterMap(
                options: new MapOptions(
                  center: center,
                  zoom: 11.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolylineLayerOptions(
                    // Will only render visible polylines, increasing performance
                    polylines: [
                      Polyline(
                        // An optional tag to distinguish polylines in callback
                        points: points,
                        color: Colors.red,
                        strokeWidth: 3.0,
                      ),
                    ],
                  ),
                  MarkerLayerOptions(markers: markers),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height / 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: SmashColors.mainBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                  // color: Colors.white.withOpacity(0.5),
                  child: NotificationListener<ElevationHoverNotification>(
                      onNotification:
                          (ElevationHoverNotification notification) {
                        setState(() {
                          hoverPoint = notification.position;
                        });

                        return true;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, bottom: 6, right: 6),
                        child: Elevation(
                          elevationPoints,
                          color: Colors.grey.withOpacity(opacity),
                          // elevationGradientColors: ElevationGradientColors(
                          //     gt10: Colors.green.withOpacity(opacity),
                          //     gt20: Colors.orangeAccent.withOpacity(opacity),
                          //     gt30: Colors.redAccent.withOpacity(opacity)),
                        ),
                      )),
                ),
              )
            ]),
    );
  }
}
