/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:badges/badges.dart';
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/tables.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/screen.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class GpsInfoButton extends StatefulWidget {
  final double _iconSize;

  GpsInfoButton(this._iconSize);

  @override
  State<StatefulWidget> createState() => _GpsInfoButtonState();
}

class _GpsInfoButtonState extends State<GpsInfoButton> {
  _GpsInfoButtonState();

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      bool showAllGpsPointCount =
          GpPreferences().getBooleanSync(KEY_GPS_SHOW_ALL_POINTS, false);
      bool showFilteredGpsPointCount =
          GpPreferences().getBooleanSync(KEY_GPS_SHOW_FILTERED_POINTS, false);

      Widget button = GestureDetector(
        onLongPress: () {
          var color = SmashColors.mainDecorations;
          if (!gpsState.hasFix()) {
            color = SmashColors.gpsOnNoFix;
          }

          var isLandscape = ScreenUtilities.isLandscape(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: color,
            content: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: getGpsInfoContainer(isLandscape),
            ),
            duration: Duration(seconds: 15),
          ));
        },
        child: Transform.scale(
          scale: 1.3,
          child: FloatingActionButton(
            elevation: 1,
            backgroundColor: SmashColors.mainDecorations,
            child: DashboardUtils.getGpsStatusIcon(
                gpsState.status, widget._iconSize),
            onPressed: () {
              if (gpsState.hasFix() || gpsState.status == GpsStatus.ON_NO_FIX) {
                var pos = gpsState.lastGpsPosition;
                SmashMapState mapState =
                    Provider.of<SmashMapState>(context, listen: false);
                if (pos != null) {
                  var newCenter = Coordinate(pos.longitude, pos.latitude);
                  mapState.center = newCenter;
                }
              }
            },
          ),
        ),
      );

      if (showFilteredGpsPointCount) {
        button = DashboardUtils.makeToolbarBadge(
            button, GpsHandler().filteredPointsCount,
            badgeColor: SmashColors.mainDecorations);
      }
      if (showAllGpsPointCount) {
        button = DashboardUtils.makeToolbarBadge(
            button, GpsHandler().allPointsCount,
            badgeColor: SmashColors.mainDecorations,
            badgePosition: BadgePosition.bottomLeft());
      }

      return button;
    });
  }

  Widget getGpsInfoContainer(bool isLandscape) {
    var color = SmashColors.mainBackground;

    return Consumer<GpsState>(builder: (context, gpsState, child) {
      Widget gpsInfo;
      if (gpsState.lastGpsPosition != null) {
        var pos = gpsState.lastGpsPosition;

        Widget tableWidget;

        if (isLandscape) {
          tableWidget = Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FlexColumnWidth(0.4),
                      1: FlexColumnWidth(0.6),
                    },
                    children: [
                      getLatTableRow(color, pos),
                      getLonTableRow(color, pos),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FlexColumnWidth(0.4),
                      1: FlexColumnWidth(0.6),
                    },
                    children: [
                      getAltitudeTableRow(color, pos),
                      getAccuracyTableRow(color, pos),
                      getHeadingTableRow(color, pos),
                      getSpeedTableRow(color, pos),
                      getTimestampTableRow(color, pos),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          tableWidget = Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(0.4),
              1: FlexColumnWidth(0.6),
            },
            children: [
              getLatTableRow(color, pos),
              getLonTableRow(color, pos),
              getAltitudeTableRow(color, pos),
              getAccuracyTableRow(color, pos),
              getHeadingTableRow(color, pos),
              getSpeedTableRow(color, pos),
              getTimestampTableRow(color, pos),
            ],
          );
        }
        gpsInfo = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          //              crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SmashUI.titleText(
                "Last GPS position",
                textAlign: TextAlign.center,
                bold: true,
                color: color,
              ),
            ),
            tableWidget,
          ],
        );
      } else {
        gpsInfo = SmashUI.titleText(
          "No GPS info available...",
          color: color,
        );
      }

      return Container(
        child: gpsInfo,
      );
    });
  }

  TableRow getTimestampTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Timestamp", color: color),
        TableUtilities.cellForString(
            "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(pos.time.round()))}",
            color: color),
      ],
    );
  }

  TableRow getSpeedTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Speed", color: color),
        TableUtilities.cellForString("${pos.speed.toInt()} m/s", color: color),
      ],
    );
  }

  TableRow getHeadingTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Heading", color: color),
        TableUtilities.cellForString("${pos.heading.round()} deg",
            color: color),
      ],
    );
  }

  TableRow getAccuracyTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Accuracy", color: color),
        TableUtilities.cellForString("${pos.accuracy.round()} m", color: color),
      ],
    );
  }

  TableRow getAltitudeTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Altitude", color: color),
        TableUtilities.cellForString(
            "${pos.altitude.toStringAsFixed(KEY_ELEV_DECIMALS)} m",
            color: color),
      ],
    );
  }

  TableRow getLatTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Latitude", color: color),
        TableCell(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: "Copy latitude to clipboard.",
                child: RaisedButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: pos.latitude
                            .toStringAsFixed(KEY_LATLONG_DECIMALS)));
                  },
                  child: SmashUI.normalText(
                      "${pos.latitude.toStringAsFixed(KEY_LATLONG_DECIMALS)} deg",
                      color: color),
                ),
              )),
        ),
      ],
    );
  }

  TableRow getLonTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString("Longitude", color: color),
        TableCell(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: "Copy longitude to clipboard.",
                child: RaisedButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: pos.longitude
                            .toStringAsFixed(KEY_LATLONG_DECIMALS)));
                  },
                  child: SmashUI.normalText(
                      "${pos.longitude.toStringAsFixed(KEY_LATLONG_DECIMALS)} deg",
                      color: color),
                ),
              )),
        ),
      ],
    );
  }
}
