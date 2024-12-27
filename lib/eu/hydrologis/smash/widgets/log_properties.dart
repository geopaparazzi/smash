/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

/// The log properties page.
class LogPropertiesWidget extends StatefulWidget {
  final Log4ListWidget _logItem;

  LogPropertiesWidget(this._logItem);

  @override
  State<StatefulWidget> createState() {
    return LogPropertiesWidgetState(_logItem);
  }
}

class LogPropertiesWidgetState extends State<LogPropertiesWidget> {
  Log4ListWidget _logItem;
  late double _widthSliderValue;
  late ColorExt _logColor;
  ColorTables _ct = ColorTables.none;
  double maxWidth = 20.0;
  bool _somethingChanged = false;

  LogPropertiesWidgetState(this._logItem);

  @override
  void initState() {
    _widthSliderValue = _logItem.width!;
    if (_widthSliderValue > maxWidth) {
      _widthSliderValue = maxWidth;
    }

    var logColor =
        EnhancedColorUtility.splitEnhancedColorString(_logItem.color!);
    _logColor = ColorExt(logColor[0]);
    _ct = logColor[1];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            // save color and width
            _logItem.width = _widthSliderValue;

            var c = ColorExt.asHex(_logColor);
            var newColorString =
                EnhancedColorUtility.buildEnhancedColor(c, ct: _ct);

            _logItem.color = newColorString;

            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.projectDb!.updateGpsLogStyle(
                _logItem.id!, _logItem.color!, _logItem.width!);
            projectState.reloadProject(context);
          }
          Navigator.pop(context, _somethingChanged);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(SL
                .of(context)
                .logProperties_gpsLogProperties), //"GPS Log Properties"
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
                              SL.of(context).logProperties_logName, //"Log Name"
                              _logItem.name!,
                              (res) {
                                if (res == null || res.trim().length == 0) {
                                  res = _logItem.name;
                                }
                                ProjectState projectState =
                                    Provider.of<ProjectState>(context,
                                        listen: false);
                                projectState.projectDb!
                                    .updateGpsLogName(_logItem.id!, res);
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
                              0: FlexColumnWidth(0.3),
                              1: FlexColumnWidth(0.7),
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
          TableUtilities.cellForString(
              SL.of(context).logProperties_start), //"Start"
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(new DateTime.fromMillisecondsSinceEpoch(
                  _logItem.startTime!))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString(
              SL.of(context).logProperties_end), //"End"
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(
                  new DateTime.fromMillisecondsSinceEpoch(_logItem.endTime!))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString(
              SL.of(context).logProperties_duration), //"Duration"
          TableUtilities.cellForString(StringUtilities.formatDurationMillis(
              _logItem.endTime! - _logItem.startTime!)),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString(
              SL.of(context).logProperties_color), //"Color"
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
          TableUtilities.cellForString(
              SL.of(context).logProperties_palette), //"Palette"
          TableCell(
            child: Padding(
              padding: SmashUI.defaultPadding(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<ColorTables>(
                  value: _ct,
                  isExpanded: false,
                  items: ColorTables.valuesLogs.map((i) {
                    return DropdownMenuItem<ColorTables>(
                      child: Text(
                        i.name,
                        textAlign: TextAlign.center,
                      ),
                      value: i,
                    );
                  }).toList(),
                  onChanged: (selectedCt) async {
                    setState(() {
                      _ct = selectedCt!;
                      _somethingChanged = true;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString(
              SL.of(context).logProperties_width), //"Width"
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
          SL.of(context).logProperties_logName, //"Log Name"
          item.name!,
          (res) {
            if (res == null || res.trim().length == 0) {
              res = item.name;
            }
            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            projectState.projectDb!.updateGpsLogName(item.id!, res);
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
  final Log4ListWidget logItem;

  LogProfileView(this.logItem, {Key? key}) : super(key: key);

  @override
  _LogProfileViewState createState() => _LogProfileViewState();
}

class _LogProfileViewState extends State<LogProfileView> with AfterLayoutMixin {
  LatLngExt? hoverPoint;
  List<LatLngExt> points = [];
  LatLng? center;
  LatLngBounds? bounds;
  double? totalLengthMeters;
  double minLineElev = double.infinity;
  double maxLineElev = double.negativeInfinity;
  MapController mapController = new MapController();
  List<Marker> staticMarkers = [];
  bool _showStats = true;

  ErrorTileCallBack? errorTileCallback = (tile, exception, stacktrace) {
    // ignore tiles that can't load to avoid
    SMLogger().e("Unable to load tile: ${tile.coordinates}", null, null);
  };
  bool overrideTilesOnUrlChange = true;

  @override
  void initState() {
    super.initState();
  }

  void loadData(BuildContext context) {
    ProjectState project = Provider.of<ProjectState>(context, listen: false);
    var logDataPoints = project.projectDb!.getLogDataPoints(widget.logItem.id!);
    bool useGpsFilteredGenerally = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, false);
    LatLngExt? prevll;
    double progressiveMeters = 0;
    var maxSpeedLL;
    var maxSpeed = double.negativeInfinity;
    logDataPoints.forEach((p) {
      Coordinate llTmp;
      if (useGpsFilteredGenerally && p.filtered_accuracy != null) {
        llTmp = Coordinate.fromYX(p.filtered_lat!, p.filtered_lon!);
      } else {
        llTmp = Coordinate.fromYX(p.lat, p.lon);
      }
      LatLngExt llExt;
      if (prevll == null) {
        llExt = LatLngExt(
            llTmp.y, llTmp.x, p.altim!, 0, 0, p.ts!, p.accuracy ?? -1);
      } else {
        var distanceMeters = CoordinateUtilities.getDistance(
            Coordinate(prevll!.longitude, prevll!.latitude), llTmp);
        progressiveMeters += distanceMeters;
        var deltaTs = (p.ts! - prevll!.ts) / 1000;
        var speedMS = distanceMeters / deltaTs;
        if (speedMS > maxSpeed) {
          maxSpeed = speedMS;
          maxSpeedLL = LatLng(p.lat, p.lon);
        }

        llExt = LatLngExt(p.lat, p.lon, p.altim!, progressiveMeters, speedMS,
            p.ts!, p.accuracy ?? -1);
      }

      points.add(llExt);
      minLineElev = min(minLineElev, p.altim!);
      maxLineElev = max(maxLineElev, p.altim!);
      prevll = llExt;
    });
    totalLengthMeters = progressiveMeters;
    var halfLength = totalLengthMeters! / 2;
    var halfLengthLL;
    var halfTime = logDataPoints.first.ts! +
        (logDataPoints.last.ts! - logDataPoints.first.ts!) / 2;
    var halfTimeLL;
    var minElevLL;
    var maxElevLL;
    var minElev = double.infinity;
    var maxElev = double.negativeInfinity;

    Envelope env = Envelope.empty();
    Coordinate? prevll2 = null;
    progressiveMeters = 0;
    logDataPoints.forEach((point) {
      var lat = point.lat;
      var lon = point.lon;
      env.expandToInclude(lon, lat);
      if (halfTimeLL == null && point.ts! > halfTime) {
        halfTimeLL = LatLng(lat, lon);
      }
      var llTmp = Coordinate.fromYX(lat, lon);
      if (prevll2 != null) {
        var distanceMeters = CoordinateUtilities.getDistance(prevll2!, llTmp);
        progressiveMeters += distanceMeters;
        if (halfLengthLL == null && progressiveMeters >= halfLength) {
          halfLengthLL = LatLng(llTmp.y, llTmp.x);
        }
      }
      prevll2 = llTmp;

      if (point.altim! < minElev) {
        minElevLL = LatLng(point.lat, point.lon);
        minElev = point.altim!;
      }
      if (point.altim! > maxElev) {
        maxElevLL = LatLng(point.lat, point.lon);
        maxElev = point.altim!;
      }
    });

    bounds = LatLngBounds.fromPoints([
      LatLng(env.getMinY(), env.getMinX()),
      LatLng(env.getMaxY(), env.getMaxX())
    ]);
    mapController.fitCamera(CameraFit.bounds(bounds: bounds!));

    center = LatLng(env.centre()!.y, env.centre()!.x);

    // create static markers
    // start
    var size = 30.0;
    addStaticMarker(
        size,
        SL.of(context).logProperties_start, //"start"
        LatLng(logDataPoints.first.lat, logDataPoints.first.lon));
    addStaticMarker(size, SL.of(context).logProperties_end /*"end"*/,
        LatLng(logDataPoints.last.lat, logDataPoints.last.lon));
    addStaticMarker(size, "1/2t", halfTimeLL);
    addStaticMarker(size, "1/2l", halfLengthLL);
    addStaticMarker(size, "minEl", minElevLL);
    addStaticMarker(size, "maxEl", maxElevLL);
    addStaticMarker(size, maxSpeed.toStringAsFixed(0) + "m/s", maxSpeedLL);

    setState(() {});
  }

  void addStaticMarker(double size, String labelText, LatLng ll) {
    MarkerIcon mi = MarkerIcon(
        MdiIcons.circle,
        SmashColors.mainSelection,
        size * 3 / 4,
        labelText,
        SmashColors.mainTextColorNeutral,
        SmashColors.mainBackground.withAlpha(100));
    staticMarkers.add(Marker(
      point: ll,
      width: size * 3 / 2,
      height: size + MARKER_ICON_TEXT_EXTRA_HEIGHT,
      child: mi,
    ));
  }

  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    var opacity = 0.7;

    if (hoverPoint is LatLng)
      markers.add(Marker(
          point: hoverPoint!,
          width: 15,
          height: 15,
          child: Container(
            decoration: BoxDecoration(
                color: SmashColors.mainDecorations,
                borderRadius: BorderRadius.circular(8)),
          )));

    var height = ScreenUtilities.getHeight(context);

    String? progString;
    if (hoverPoint != null) {
      var prog = hoverPoint!.prog;
      var progFormatted = StringUtilities.formatMeters(prog);
      progString =
          "${SL.of(context).logProperties_distanceAtPosition} $progFormatted"; //Distance at position:
    }
    var totalNew;
    String? totalString;
    if (totalLengthMeters != null) {
      if (totalLengthMeters! > 1000) {
        var totalKm = totalLengthMeters! / 1000.0;
        totalNew = "${totalKm.toStringAsFixed(1)} km";
      } else {
        totalNew = "${totalLengthMeters!.toInt()} m";
      }
      totalString =
          "${SL.of(context).logProperties_totalDistance} $totalNew"; //Total distance:
    }

    int durationMillis = widget.logItem.endTime! - widget.logItem.startTime!;
    String durationStr = StringUtilities.formatDurationMillis(durationMillis);
    String? currentTouchStr;
    if (hoverPoint != null) {
      int currentTouchMillis = hoverPoint!.ts - widget.logItem.startTime!;
      currentTouchStr =
          StringUtilities.formatDurationMillis(currentTouchMillis);
    }

    PolylineLayer? polylines;
    if (bounds != null) {
      var clrSplit =
          EnhancedColorUtility.splitEnhancedColorString(widget.logItem.color!);
      ColorTables colorTable = clrSplit[1];
      if (colorTable.isValid()) {
        List<Polyline> lines = [];
        EnhancedColorUtility.buildPolylines(lines, points, colorTable,
            widget.logItem.width!, minLineElev, maxLineElev);

        polylines = PolylineLayer(
          polylines: lines,
        );
      } else {
        polylines = PolylineLayer(
          polylines: [
            Polyline(
              points: points,
              color: ColorExt(EnhancedColorUtility.splitEnhancedColorString(
                  widget.logItem.color!)[0]),
              strokeWidth: widget.logItem.width!,
            ),
          ],
        );
      }
    }

    var mapLayers = <Widget>[];

    if (center != null) {
      mapLayers = [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          errorTileCallback: errorTileCallback,
          additionalOptions: {
            "attribution":
                '&copy; <a href="https://www.openstreetmap.org/copyright">'
                    'OpenStreetMap</a> contributors',
          },
        ),
      ];
      if (polylines != null) {
        mapLayers.add(polylines);
      }
      if (staticMarkers.isNotEmpty && _showStats) {
        mapLayers.add(MarkerLayer(markers: staticMarkers));
      }
      mapLayers.add(MarkerLayer(markers: markers));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).logProperties_gpsLogView), //"GPS Log View"
        actions: [
          IconButton(
            icon: Icon(MdiIcons.palette),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LogPropertiesWidget(widget.logItem)));
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.informationOutline),
            tooltip: _showStats
                ? SL.of(context).logProperties_disableStats //"Disable stats"
                : SL.of(context).logProperties_enableStats, //"Enable stats"
            onPressed: () async {
              setState(() {
                _showStats = !_showStats;
              });
            },
          )
        ],
      ),
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: new MapOptions(
            // center: center,
            initialZoom: 11.0,
            onMapReady: () {
              loadData(context);
            },
          ),
          children: mapLayers,
        ),
        hoverPoint != null
            ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                // height: height / 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: SmashColors.mainBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: SmashUI.defaultPadding(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SmashUI.normalText(widget.logItem.name!,
                              bold: true, underline: true),
                        ),
                        SmashUI.normalText(
                            "${SL.of(context).logProperties_totalDuration} $durationStr"), //Total duration:
                        SmashUI.normalText(
                            "${SL.of(context).logProperties_timestamp} ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(hoverPoint!.ts))}"), //Timestamp:
                        SmashUI.normalText(
                            "${SL.of(context).logProperties_durationAtPosition} $currentTouchStr"), //Duration at position:
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SmashUI.normalText(totalString!),
                        ),
                        SmashUI.normalText(progString!),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SmashUI.normalText(
                              "${SL.of(context).logProperties_speed} ${hoverPoint!.speed.toStringAsFixed(0)} m/s (${(hoverPoint!.speed * 3.6).toStringAsFixed(0)} km/h)"), //Speed:
                        ),
                        SmashUI.normalText(
                            "${SL.of(context).logProperties_elevation} ${hoverPoint!.altim.toInt()}m"), //Elevation:
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        center != null
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height / 4,
                child: Container(
                  decoration: BoxDecoration(
                      color: SmashColors.mainBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                  // color: Colors.white.withOpacity(0.5),
                  child: NotificationListener<ElevationHoverNotification>(
                      onNotification:
                          (ElevationHoverNotification notification) {
                        setState(() {
                          if (notification.position != null)
                            hoverPoint = notification.position as LatLngExt;
                        });

                        return true;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, bottom: 6, right: 6),
                        child: Elevation(
                          points,
                          color:
                              SmashColors.mainDecorations.withOpacity(opacity),
                          // elevationGradientColors: ElevationGradientColors(
                          //     gt10: Colors.green.withOpacity(opacity),
                          //     gt20: Colors.orangeAccent.withOpacity(opacity),
                          //     gt30: Colors.redAccent.withOpacity(opacity)),
                        ),
                      )),
                ),
              )
            : Container(),
      ]),
    );
  }
}
