/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

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
import 'package:smash/eu/hydrologis/smash/widgets/gps_tools_widget.dart';

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
      return GestureDetector(
        onLongPress: () {
          if (gpsState.hasFix()) {
            var isLandscape = ScreenUtilities.isLandscape(context);
            if (isLandscape) {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: SmashColors.mainDecorations,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: getGpsInfoContainer(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: GpsToolsWidget(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: getBottomButtons(context),
                    ),
                  ],
                ),
                duration: Duration(seconds: 5),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: SmashColors.mainDecorations,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: getGpsInfoContainer(),
                    ),
                    Divider(
                      color: SmashColors.mainBackground,
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: GpsToolsWidget(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: getBottomButtons(context),
                    ),
                  ],
                ),
                duration: Duration(seconds: 15),
              ));
            }
          }
        },
        child: Transform.scale(
          scale: 1.3,
          child: FloatingActionButton(
            elevation: 1,
            backgroundColor: SmashColors.mainDecorations,
            child: DashboardUtils.getGpsStatusIcon(gpsState.status, widget._iconSize),
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
    });
  }

  Widget getBottomButtons(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          gpsState.lastGpsPosition != null
              ? IconButton(
            icon: Icon(
              Icons.content_copy,
              color: SmashColors.mainBackground,
            ),
            tooltip: "Copy position to clipboard.",
            iconSize: SmashUI.MEDIUM_ICON_SIZE,
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text: gpsState.lastGpsPosition.toString()));
            },
          )
              : Container(),
          Spacer(
            flex: 1,
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: SmashColors.mainBackground,
            ),
            iconSize: SmashUI.MEDIUM_ICON_SIZE,
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      );
    });
  }

  Widget getGpsInfoContainer() {
    var color = SmashColors.mainBackground;

    return Consumer<GpsState>(builder: (context, gpsState, child) {
      Widget gpsInfo;
      if (gpsState.hasFix() && gpsState.lastGpsPosition != null) {
        var pos = gpsState.lastGpsPosition;
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
            Table(
              columnWidths: {
                0: FlexColumnWidth(0.4),
                1: FlexColumnWidth(0.6),
              },
              children: [
                TableRow(
                  children: [
                    TableUtilities.cellForString("Latitude", color: color),
                    TableUtilities.cellForString(
                        "${pos.latitude.toStringAsFixed(KEY_LATLONG_DECIMALS)} deg",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Longitude", color: color),
                    TableUtilities.cellForString(
                        "${pos.longitude.toStringAsFixed(KEY_LATLONG_DECIMALS)} deg",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Altitude", color: color),
                    TableUtilities.cellForString(
                        "${pos.altitude.toStringAsFixed(KEY_ELEV_DECIMALS)} m",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Accuracy", color: color),
                    TableUtilities.cellForString("${pos.accuracy.round()} m",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Heading", color: color),
                    TableUtilities.cellForString("${pos.heading.round()} deg",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Speed", color: color),
                    TableUtilities.cellForString("${pos.speed.toInt()} m/s",
                        color: color),
                  ],
                ),
                TableRow(
                  children: [
                    TableUtilities.cellForString("Timestamp", color: color),
                    TableUtilities.cellForString(
                        "${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(pos.time.round()))}",
                        color: color),
                  ],
                ),
              ],
            ),
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
}
