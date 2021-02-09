/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smashlibs/smashlibs.dart';

/// Plugin to show the current GPS log
class CurrentGpsLogPlugin implements MapPlugin {
  @override
  Widget createLayer(LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is CurrentGpsLogPluginOption) {
      return CurrentGpsLogLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for CurrentGpsLogPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is CurrentGpsLogPluginOption;
  }
}

class CurrentGpsLogPluginOption extends LayerOptions {
  Color logColor;
  double logWidth;

  CurrentGpsLogPluginOption({
    this.logColor = Colors.red,
    this.logWidth = 4,
  });
}

class CurrentGpsLogLayer extends StatelessWidget {
  final CurrentGpsLogPluginOption currentGpsLogLayerOpts;
  final MapState map;
  final Stream<Null> stream;
  Paint logPaint;
  Paint filteredLogPaint;
  bool doOrig = true;
  bool doFiltered = true;

  CurrentGpsLogLayer(this.currentGpsLogLayerOpts, this.map, this.stream) {
    /// The log view modes [originalData, filteredData].
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      if (gpsState.isLogging && gpsState.currentLogPoints.length > 1) {
        if (gpsState.logMode == SmashPreferencesKeys.LOGVIEWMODES[0]) {
          doOrig = false;
        } else {
          logPaint = Paint()
            ..color = (gpsState.logMode == SmashPreferencesKeys.LOGVIEWMODES[1])
                ? currentGpsLogLayerOpts.logColor
                : currentGpsLogLayerOpts.logColor.withAlpha(100)
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentGpsLogLayerOpts.logWidth;
        }
        if (gpsState.filteredLogMode == SmashPreferencesKeys.LOGVIEWMODES[0]) {
          doFiltered = false;
        } else {
          filteredLogPaint = Paint()
            ..color = (gpsState.filteredLogMode == SmashPreferencesKeys.LOGVIEWMODES[1])
                ? currentGpsLogLayerOpts.logColor
                : currentGpsLogLayerOpts.logColor.withAlpha(100)
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentGpsLogLayerOpts.logWidth;
        }

        var currentLogStats = gpsState.getCurrentLogStats();
        double distanceMeter = currentLogStats[0] as double;
        double distanceMeterFiltered = currentLogStats[1] as double;
        int timestampDelta = currentLogStats[2] as int;

        var timeStr = StringUtilities.formatDurationMillis(timestampDelta);
        var distStr = StringUtilities.formatMeters(distanceMeter);
        var distFilteredStr = StringUtilities.formatMeters(distanceMeterFiltered);

        return Stack(
          children: [
            CustomPaint(
              painter: CurrentLogPathPainter(logPaint, filteredLogPaint, gpsState.currentLogPoints, gpsState.currentFilteredLogPoints, map),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(color: SmashColors.mainBackground.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmashUI.normalText("Time: $timeStr"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SmashUI.normalText("Dist: $distStr ($distFilteredStr)"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

class CurrentLogPathPainter extends CustomPainter {
  var logPaint;
  var filtereLogPaint;
  List<LatLng> currentLogPoints;
  List<LatLng> currentFilteredLogPoints;
  MapState map;

  CurrentLogPathPainter(this.logPaint, this.filtereLogPaint, this.currentLogPoints, this.currentFilteredLogPoints, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    if (logPaint != null) {
      Path path1 = Path();
      CustomPoint posPixel1 = map.project(currentLogPoints[0]);
      CustomPoint pixelOrigin = map.getPixelOrigin();
      double center1X = posPixel1.x - pixelOrigin.x;
      double center1Y = (posPixel1.y - pixelOrigin.y);
      path1.moveTo(center1X, center1Y);

      for (int i = 1; i < currentLogPoints.length; i++) {
        CustomPoint posPixel1 = map.project(currentLogPoints[i]);
        CustomPoint pixelOrigin = map.getPixelOrigin();
        double center1X = posPixel1.x - pixelOrigin.x;
        double center1Y = (posPixel1.y - pixelOrigin.y);
        path1.lineTo(center1X, center1Y);
      }
      canvas.drawPath(path1, logPaint);
    }

    if (filtereLogPaint != null) {
      Path path2 = Path();
      CustomPoint posPixel2 = map.project(currentFilteredLogPoints[0]);
      CustomPoint pixelOrigin = map.getPixelOrigin();
      double center2X = posPixel2.x - pixelOrigin.x;
      double center2Y = (posPixel2.y - pixelOrigin.y);
      path2.moveTo(center2X, center2Y);

      for (int i = 1; i < currentFilteredLogPoints.length; i++) {
        CustomPoint posPixel2 = map.project(currentFilteredLogPoints[i]);
        CustomPoint pixelOrigin = map.getPixelOrigin();
        double center2X = posPixel2.x - pixelOrigin.x;
        double center2Y = (posPixel2.y - pixelOrigin.y);
        path2.lineTo(center2X, center2Y);
      }

      canvas.drawPath(path2, filtereLogPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
