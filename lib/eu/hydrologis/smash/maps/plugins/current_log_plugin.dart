/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_jts/dart_jts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_properties.dart';
import 'package:smashlibs/smashlibs.dart';

/// Plugin to show the current GPS log
class CurrentGpsLogLayer extends StatelessWidget {
  // 0 = large, 1 = medium, 2 = small
  final ValueNotifier panelExpandedValue = ValueNotifier(1);
  Paint? logPaint;
  Paint? filteredLogPaint;
  bool doFiltered = true;
  // defines if to flatten the chart to have more realistic ratio
  bool _doFlatChart = true;
  bool doOrig = true;

  final Color logColor;
  final double logWidth;
  CurrentGpsLogLayer({
    this.logColor = Colors.red,
    this.logWidth = 4,
  }) : super(key: ValueKey("SMASH_CURRENTGPSLOGLAYER"));

  /// The log view modes [originalData, filteredData].

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      final map = FlutterMapState.maybeOf(context)!;
      ProjectState projectState =
          Provider.of<ProjectState>(context, listen: false);

      if (projectState.isLogging && projectState.currentLogPoints.length > 1) {
        if (gpsState.logMode == SmashPreferencesKeys.LOGVIEWMODES[0]) {
          doOrig = false;
        } else {
          logPaint = Paint()
            ..color = (gpsState.logMode == SmashPreferencesKeys.LOGVIEWMODES[1])
                ? logColor
                : logColor.withAlpha(100)
            ..style = PaintingStyle.stroke
            ..strokeWidth = logWidth;
        }
        if (gpsState.filteredLogMode == SmashPreferencesKeys.LOGVIEWMODES[0]) {
          doFiltered = false;
        } else {
          filteredLogPaint = Paint()
            ..color = (gpsState.filteredLogMode ==
                    SmashPreferencesKeys.LOGVIEWMODES[1])
                ? logColor
                : logColor.withAlpha(100)
            ..style = PaintingStyle.stroke
            ..strokeWidth = logWidth;
        }

        print(panelExpandedValue.value);
        var panel = _getInfoWidget(context, projectState, true);
        if (panelExpandedValue.value == 1) {
          panel = _getInfoWidget(context, projectState, false);
        } else if (panelExpandedValue.value == 2) {
          panel = _getTinyInfoWidget(context, projectState);
        }

        return Stack(
          children: [
            CustomPaint(
              painter: CurrentLogPathPainter(
                  logPaint,
                  filteredLogPaint,
                  projectState.currentLogPoints,
                  projectState.currentFilteredLogPoints,
                  map),
            ),
            ValueListenableBuilder(
              valueListenable: panelExpandedValue,
              builder: (context, snapshot, child) {
                return panel;
              },
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget _getTinyInfoWidget(BuildContext context, ProjectState projectState) {
    var currentLogStats = projectState.getCurrentLogStats();
    int timestampDelta = currentLogStats[2] as int;
    var timeStr = StringUtilities.formatDurationMillis(timestampDelta);
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
            color: SmashColors.mainBackground.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(SmashIcons.iconTime),
                  ),
                  SmashUI.normalText("$timeStr"),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: IconButton(
                        icon: Icon(MdiIcons.resize),
                        onPressed: () {
                          var newValue = panelExpandedValue.value + 1;
                          if (newValue == 3) {
                            newValue = 0;
                          }
                          panelExpandedValue.value = newValue;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getInfoWidget(
      BuildContext context, ProjectState projectState, bool withChart) {
    var currentLogStats = projectState.getCurrentLogStats();
    double distanceMeter = currentLogStats[0] as double;
    double distanceMeterFiltered = currentLogStats[1] as double;
    int timestampDelta = currentLogStats[2] as int;
    double speedMs = currentLogStats[3];
    double speedKmH = speedMs * 3600 / 1000;
    List<dynamic> progAndAltitudes = currentLogStats[4];
    double minElev = double.infinity;
    double maxElev = double.negativeInfinity;

    List<dynamic> progAltitudData = [];
    progAndAltitudes.forEach((xy) {
      var tmp = xy[1];
      if (tmp < minElev) {
        minElev = tmp;
      }
      if (tmp > maxElev) {
        maxElev = tmp;
      }
      progAltitudData.add(xy);
    });

    if (_doFlatChart && (maxElev - minElev) < 25) {
      maxElev = minElev + 25;
    }
    int minElevInt = minElev.round();
    int maxElevInt = maxElev.round();

    var timeStr = StringUtilities.formatDurationMillis(timestampDelta);
    var distStr = StringUtilities.formatMeters(distanceMeter);
    var distFilteredStr = StringUtilities.formatMeters(distanceMeterFiltered);
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
            color: SmashColors.mainBackground.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(SmashIcons.iconTime),
                  ),
                  SmashUI.normalText("$timeStr"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5.0,
                      ),
                      child: Icon(SmashIcons.iconDistance),
                    ),
                    SmashUI.normalText("$distStr"),
                    Padding(
                      padding: const EdgeInsets.only(right: 3.0, left: 5.0),
                      child: Icon(SmashIcons.iconFilter),
                    ),
                    SmashUI.normalText("$distFilteredStr"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5.0,
                      ),
                      child: Icon(SmashIcons.iconSpeed),
                    ),
                    SmashUI.normalText(speedKmH.toStringAsFixed(0) + " Km/h"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5.0,
                      ),
                      child: Icon(MdiIcons.elevationRise),
                    ),
                    SmashUI.normalText(
                        "${((progAltitudData.last[1]) as double).toStringAsFixed(0)} m"),
                  ],
                ),
              ),
              if (withChart && maxElevInt != minElevInt)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("${maxElevInt + 1}",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              if (withChart)
                GestureDetector(
                  onDoubleTap: () {
                    _doFlatChart = !_doFlatChart;
                    String msg = "Show exagerated elev chart.";
                    if (_doFlatChart) {
                      msg = "Show proper ratio chart.";
                    }
                    final snackBar = SnackBar(
                      content: Text(msg),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                    child: SizedBox(
                      height: 100,
                      width: 180,
                      child: LineChart(
                        getProfileData(progAltitudData, minElevInt, maxElevInt),
                      ),
                    ),
                  ),
                ),
              if (withChart && maxElevInt != minElevInt)
                Text("${minElevInt - 1}",
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  child: Icon(MdiIcons.resize),
                  onTap: () {
                    var newValue = panelExpandedValue.value + 1;
                    if (newValue == 3) {
                      newValue = 0;
                    }
                    panelExpandedValue.value = newValue;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData getProfileData(List<dynamic> xyList, int minElev, int maxElev) {
    // don't smooth if rounding, might be removed
    // var length = xyList.length;
    // if (length > 30) {
    //   var avg = FeatureSlidingAverage(xyList);
    //   xyList = avg.smooth(21, 0.8);
    // } else
    // if (length > 10) {
    //   var avg = FeatureSlidingAverage(xyList);
    //   xyList = avg.smooth(7, 0.9);
    // }

    // do elev * 10 and round to have dm resolution (works because the chart has no labels)
    var factor = 10.0;

    return LineChartData(
      minY: (minElev.toDouble() - 1.0) * factor,
      maxY: (maxElev.toDouble() + 1.0) * factor,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: SmashColors.mainBackground.withOpacity(0.8),
        ),
      ),
      gridData: FlGridData(
        // show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        topTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: xyList
              .map((e) => FlSpot(e[0], (e[1] * factor).roundToDouble()))
              .toList(),
          isCurved: false,
          color: Colors.black.withAlpha(160),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.black.withAlpha(20),
          ),
        )
      ],
    );
  }
}

class CurrentLogPathPainter extends CustomPainter {
  Paint? logPaint;
  Paint? filtereLogPaint;
  List<Coordinate> currentLogPoints;
  List<Coordinate> currentFilteredLogPoints;
  FlutterMapState map;

  CurrentLogPathPainter(this.logPaint, this.filtereLogPaint,
      this.currentLogPoints, this.currentFilteredLogPoints, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    if (logPaint != null) {
      Path path1 = Path();
      CustomPoint posPixel1 =
          map.project(LatLngExt.fromCoordinate(currentLogPoints[0]));
      CustomPoint pixelOrigin = map.pixelOrigin;
      double center1X = posPixel1.x - pixelOrigin.x.toDouble();
      double center1Y = (posPixel1.y - pixelOrigin.y.toDouble());
      path1.moveTo(center1X, center1Y);

      for (int i = 1; i < currentLogPoints.length; i++) {
        CustomPoint posPixel1 =
            map.project(LatLngExt.fromCoordinate(currentLogPoints[i]));
        CustomPoint pixelOrigin = map.pixelOrigin;
        double center1X = posPixel1.x - pixelOrigin.x.toDouble();
        double center1Y = (posPixel1.y - pixelOrigin.y.toDouble());
        path1.lineTo(center1X, center1Y);
      }
      canvas.drawPath(path1, logPaint!);
    }

    if (filtereLogPaint != null) {
      Path path2 = Path();
      CustomPoint posPixel2 =
          map.project(LatLngExt.fromCoordinate(currentFilteredLogPoints[0]));
      CustomPoint pixelOrigin = map.pixelOrigin;
      double center2X = posPixel2.x - pixelOrigin.x.toDouble();
      double center2Y = (posPixel2.y - pixelOrigin.y.toDouble());
      path2.moveTo(center2X, center2Y);

      for (int i = 1; i < currentFilteredLogPoints.length; i++) {
        CustomPoint posPixel2 =
            map.project(LatLngExt.fromCoordinate(currentFilteredLogPoints[i]));
        CustomPoint pixelOrigin = map.pixelOrigin;
        double center2X = posPixel2.x - pixelOrigin.x.toDouble();
        double center2Y = (posPixel2.y - pixelOrigin.y.toDouble());
        path2.lineTo(center2X, center2Y);
      }

      canvas.drawPath(path2, filtereLogPaint!);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
