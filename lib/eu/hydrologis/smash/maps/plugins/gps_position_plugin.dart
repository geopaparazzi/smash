/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';

/// Plugin to show the current GPS position
class GpsPositionPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is GpsPositionPluginOption) {
      return GpsPositionLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for GpsPositionPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is GpsPositionPluginOption;
  }
}

class GpsPositionPluginOption extends LayerOptions {
  Color markerColor;
  Color markerColorStale;
  Color markerColorLogging = SmashColors.gpsLogging;
  double markerSize;

  GpsPositionPluginOption({
    this.markerColor = Colors.black,
    this.markerColorStale = Colors.grey,
    this.markerColorLogging,
    this.markerSize = 10,
  });
}

class GpsPositionLayer extends StatelessWidget {
  final GpsPositionPluginOption gpsPositionLayerOpts;
  final MapState map;
  final Stream<Null> stream;

  GpsPositionLayer(this.gpsPositionLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      var pos = gpsState.lastGpsPosition;
      if (pos == null || gpsState.status == GpsStatus.OFF) {
        return Container();
      } else {
        LatLng posLL = LatLng(pos.latitude, pos.longitude);
        var mapState = Provider.of<SmashMapState>(context, listen: false);
        var mapController = mapState.mapController;
        if (mapController != null) {
          if (mapState.rotateOnHeading) {
            var heading = gpsState.lastGpsPosition.heading;
            if (heading < 0) {
              heading = 360 + heading;
            }
            map.rotation = gpsState.lastGpsPosition.heading;
//            mapController.rotate(-heading);
          } else {
            map.rotation = 0;
//            mapController.rotate(0);
          }
          if (mapState.centerOnGps) {
            mapController.move(posLL, map.zoom);
          }
        } else {
          if (mapState.centerOnGps) {
            map.move(posLL, map.zoom);
          }
          if (mapState.rotateOnHeading) {
            map.rotation = gpsState.lastGpsPosition.heading;
          }
        }

        var bounds = map.getBounds();
        if (!bounds.contains(posLL)) {
          return Container();
        }

        var color = gpsState.status == GpsStatus.ON_WITH_FIX
            ? gpsPositionLayerOpts.markerColor
            : (gpsState.status == GpsStatus.ON_NO_FIX
                ? gpsPositionLayerOpts.markerColorStale
                : gpsPositionLayerOpts.markerColorLogging);

        CustomPoint posPixel = map.project(posLL);
        var pixelBounds = map.getLastPixelBounds();
        var height = pixelBounds.bottomLeft.y - pixelBounds.topLeft.y;
        CustomPoint pixelOrigin = map.getPixelOrigin();
        double centerX =
            posPixel.x - pixelOrigin.x - gpsPositionLayerOpts.markerSize / 2;
        double centerY = height -
            (posPixel.y - pixelOrigin.y) -
            gpsPositionLayerOpts.markerSize / 2;
        double delta = 3;
        return IgnorePointer(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: centerX - delta / 2.0,
                bottom: centerY - delta / 2.0,
                child: Icon(
                  Icons.my_location,
                  size: gpsPositionLayerOpts.markerSize + delta,
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: centerX,
                bottom: centerY,
                child: Icon(
                  Icons.my_location,
                  size: gpsPositionLayerOpts.markerSize,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
