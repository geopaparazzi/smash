/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:badges/badges.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class GpsInfoButton extends StatefulWidget {
  final double _iconSize;
  final _key;
  GpsInfoButton(this._key, this._iconSize);

  @override
  State<StatefulWidget> createState() => _GpsInfoButtonState();
}

class _GpsInfoButtonState extends State<GpsInfoButton> {
  _GpsInfoButtonState();

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      var mapState = Provider.of<SmashMapState>(context, listen: false);

      Widget button = GestureDetector(
        onLongPress: () {
          var color = SmashColors.mainDecorations;
          if (!gpsState.hasFix()) {
            color = SmashColors.gpsOnNoFix;
          }

          var isLandscape = ScreenUtilities.isLandscape(context);
          showModalBottomSheet(
            showDragHandle: true,
            elevation: 10,
            backgroundColor: color,
            context: context,
            builder: (ctx) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: getGpsInfoContainer(isLandscape),
            ),
          );
        },
        child: SizedBox(
          height: widget._iconSize * 1.4,
          width: widget._iconSize * 1.4,
          child: Stack(
            // fit: StackFit.loose,
            children: [
              Transform.scale(
                scale: 1.4,
                child: FloatingActionButton(
                  key: widget._key,
                  elevation: 1,
                  backgroundColor: SmashColors.mainDecorations,
                  child: DashboardUtils.getGpsStatusIcon(
                      gpsState.status, widget._iconSize),
                  onPressed: () {
                    if (gpsState.hasFix() ||
                        gpsState.status == GpsStatus.ON_NO_FIX) {
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
              if (mapState.centerOnGps)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    MdiIcons.magnet,
                    size: widget._iconSize / 2,
                    color: SmashColors.mainSelection,
                  ),
                )
            ],
          ),
        ),
      );

      return button;
    });
  }

  Widget getGpsInfoContainer(bool isLandscape) {
    var color = SmashColors.mainBackground;
    var mapState = Provider.of<SmashMapState>(context, listen: false);

    return Consumer<GpsState>(builder: (context, gpsState, child) {
      Widget gpsInfo;
      if (gpsState.lastGpsPosition != null) {
        var pos = gpsState.lastGpsPosition!;

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
                      getAllGpsPointsTableRow(color, pos),
                      getFilteresGpsPointsTableRow(color, pos),
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
              getAllGpsPointsTableRow(color, pos),
              getFilteresGpsPointsTableRow(color, pos),
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                onPressed: () {
                  var mapState =
                      Provider.of<SmashMapState>(context, listen: false);
                  mapState.centerOnGps = !mapState.centerOnGps;
                  setState(() {});
                },
                icon: Icon(
                  mapState.centerOnGps ? MdiIcons.magnetOn : MdiIcons.magnet,
                  size: 32,
                ),
                color: mapState.centerOnGps
                    ? SmashColors.mainSelection
                    : SmashColors.mainBackground,
              ),
            ),
          ],
        );
      } else {
        gpsInfo = SmashUI.titleText(
          SL
              .of(context)
              .gpsInfoButton_noGpsInfoAvailable, //"No GPS info available..."
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
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_timestamp,
            color: color), //"Timestamp"
        TableUtilities.cellForString(
            "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(pos.time.round()))}",
            color: color),
      ],
    );
  }

  TableRow getAllGpsPointsTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).allGpsPointsCount,
            color: color),
        TableUtilities.cellForString("${GpsHandler().allPointsCount}",
            color: color),
      ],
    );
  }

  TableRow getFilteresGpsPointsTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).filteredGpsPointsCount,
            color: color),
        TableUtilities.cellForString("${GpsHandler().filteredPointsCount}",
            color: color),
      ],
    );
  }

  TableRow getSpeedTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_speed,
            color: color), //"Speed"
        TableUtilities.cellForString("${pos.speed.toInt()} m/s", color: color),
      ],
    );
  }

  TableRow getHeadingTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_heading,
            color: color), //"Heading"
        TableUtilities.cellForString("${pos.heading.round()} deg",
            color: color),
      ],
    );
  }

  TableRow getAccuracyTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_accuracy,
            color: color), //"Accuracy"
        TableUtilities.cellForString("${pos.accuracy.round()} m", color: color),
      ],
    );
  }

  TableRow getAltitudeTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_altitude,
            color: color), //"Altitude"
        TableUtilities.cellForString(
            "${pos.altitude.toStringAsFixed(SmashPreferencesKeys.KEY_ELEV_DECIMALS)} m",
            color: color),
      ],
    );
  }

  TableRow getLatTableRow(ColorExt color, SmashPosition pos) {
    return TableRow(
      children: [
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_latitude,
            color: color), //"Latitude"
        TableCell(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: SL
                    .of(context)
                    .gpsInfoButton_copyLatitudeToClipboard, //"Copy latitude to clipboard."
                child: ElevatedButton(
                  style: SmashUI.defaultElevateButtonStyle(
                      color: SmashColors.mainDecorationsDarker),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: pos.latitude.toStringAsFixed(
                            SmashPreferencesKeys.KEY_LATLONG_DECIMALS)));
                  },
                  child: SmashUI.normalText(
                      "${pos.latitude.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)} deg",
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
        TableUtilities.cellForString(SL.of(context).gpsInfoButton_longitude,
            color: color), //"Longitude"
        TableCell(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: SL
                    .of(context)
                    .gpsInfoButton_copyLongitudeToClipboard, //"Copy longitude to clipboard."
                child: ElevatedButton(
                  style: SmashUI.defaultElevateButtonStyle(
                      color: SmashColors.mainDecorationsDarker),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: pos.longitude.toStringAsFixed(
                            SmashPreferencesKeys.KEY_LATLONG_DECIMALS)));
                  },
                  child: SmashUI.normalText(
                      "${pos.longitude.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)} deg",
                      color: color),
                ),
              )),
        ),
      ],
    );
  }
}
