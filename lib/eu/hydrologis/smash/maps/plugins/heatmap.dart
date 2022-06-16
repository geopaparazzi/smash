/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import "dart:math" as math;
import 'dart:ui' as ui;

import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';

/// A heatmap creator.
///
/// Code ported to dart form the https://github.com/mourner/simpleheat project.
class SimpleHeat {
  var defaultRadius = 25;

  var defaultGradient = {
    0.4: 'blue',
    0.6: 'cyan',
    0.7: 'lime',
    0.8: 'yellow',
    1.0: 'red',
  };

  var max = 1;
  var data = <Coordinate>[];

  ui.Canvas? _canvas;
  ui.Size? _size;
  SimpleHeat(ui.Canvas canvas, ui.Size size) {
    _canvas = canvas;
    _size = size;
  }

  void add(Coordinate coord) {
    data.add(coord);
  }

  void clear() {
    data = [];
  }
}

class HeatmapPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is HeatmapPluginOption) {
      return HeatmapLayer(options, mapState);
    }
    throw Exception('Unknown options type for HeatmapPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is HeatmapPluginOption;
  }
}

class HeatmapPluginOption extends LayerOptions {
  HeatmapPluginOption();
}

class HeatmapLayer extends StatelessWidget {
  final HeatmapPluginOption layerOpts;
  final MapState map;

  HeatmapLayer(this.layerOpts, this.map);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectState>(builder: (context, projectState, child) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: HeatmapPainter(projectState, map),
        ),
      );
    });
  }
}

class HeatmapPainter extends CustomPainter {
  ProjectState projectState;
  MapState map;

  HeatmapPainter(this.projectState, this.map);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pictureRecorder = ui.PictureRecorder();
    final tmpCanvas = Canvas(pictureRecorder);

    // var heat = SimpleHeat(canvas, size);
    var minOpacity = 0.05;
    var radius = 30.0;
    var z = 1.0;
    var max = 1.0;

    List<Polyline> lines = projectState.projectData!.geopapLogs!.polylines;
    for (var i = 0; i < lines.length; i++) {
      Polyline line = lines[i];
      var points = line.points;
      for (var point in points) {
        CustomPoint posPixel = map.project(point);
        CustomPoint pixelOrigin = map.getPixelOrigin();
        double pixelX = (posPixel.x - pixelOrigin.x.toDouble());
        double pixelY = (posPixel.y - pixelOrigin.y.toDouble());
        var pointOffset = Offset(pixelX, pixelY);

        if (size.contains(pointOffset)) {
          int globalAlpha = math.min(math.max(z / max, minOpacity), 1).round();
          // draw it
          var gradient = RadialGradient(
            center: const Alignment(0.0, 0.0), // near the top right
            radius: 1.0,
            colors: [
              Color.fromARGB(globalAlpha, 0, 0, 0),
              Color.fromARGB(globalAlpha, 255, 255, 255),
            ],
            stops: [0.0, 0.5],
          );
          // rect is the area we are painting over
          Rect rect = Rect.fromCircle(
            center: pointOffset,
            radius: radius,
          );
          var paint = Paint()..shader = gradient.createShader(rect);

          tmpCanvas.drawCircle(pointOffset, radius, paint);
        }
      }
    }
    // Note that you can draw pictures to other canvases using Canvas.drawPicture().
    ui.Picture picture = pictureRecorder.endRecording();

// And here's your pixel data
    // ui.Image image = await picture.toImage(width, height);
    // ByteData bytes = await image.toByteData();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
