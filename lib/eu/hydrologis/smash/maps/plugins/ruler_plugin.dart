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
import 'package:latlong2/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:smashlibs/smashlibs.dart';

/// A plugin that handles tap info from vector layers
class RulerPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is RulerPluginOptions) {
      return RulerPluginLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for RulerPluginPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is RulerPluginOptions;
  }
}

class RulerPluginOptions extends LayerOptions {
  Color tapAreaColor = SmashColors.mainSelectionBorder;
  double tapAreaPixelSize;

  RulerPluginOptions({this.tapAreaPixelSize = 10});
}

class RulerPluginLayer extends StatefulWidget {
  final RulerPluginOptions rulerPluginLayerOpts;
  final MapState map;
  final Stream<void> stream;

  RulerPluginLayer(this.rulerPluginLayerOpts, this.map, this.stream);

  @override
  _RulerPluginLayerState createState() => _RulerPluginLayerState();
}

class _RulerPluginLayerState extends State<RulerPluginLayer> {
  LatLng? runningPointLL;
  double? _x;
  double? _y;
  double? lengthMeters;

  List<Offset>? pointsList;

  @override
  Widget build(BuildContext context) {
    return Consumer<RulerState>(builder: (context, rulerState, child) {
      if (!rulerState.isEnabled) {
        return Container();
      }

      List<Widget> stackWidgets = [];
      if (pointsList != null) {
        stackWidgets.add(
          CustomPaint(
              size: Size.infinite,
              painter: LinePainter(
                pointsList: pointsList!,
              )),
        );
      }
      stackWidgets.add(
        GestureDetector(
          onTapDown: (detail) {
            _x = detail.localPosition.dx;
            _y = detail.localPosition.dy;
            dragStart(rulerState, detail.localPosition);
          },
          onPanDown: (detail) {
            _x = detail.localPosition.dx;
            _y = detail.localPosition.dy;
            dragStart(rulerState, detail.localPosition);
          },
          onHorizontalDragUpdate: (detail) {
            dragUpdate(rulerState, detail.localPosition);
          },
          onVerticalDragUpdate: (detail) {
            dragUpdate(rulerState, detail.localPosition);
          },
          onHorizontalDragEnd: (detail) {
            dragEnd(rulerState);
          },
          onVerticalDragEnd: (detail) {
            dragEnd(rulerState);
          },
        ),
      );

      return Stack(
        children: stackWidgets,
      );
    });
  }

  void dragStart(RulerState rulerState, Offset p) {
    if (_x != null && _y != null) {
      pointsList = [];
      // print(p);
      pointsList!.add(p);
      lengthMeters = 0.0;
      CustomPoint pixelOrigin = widget.map.getPixelOrigin();
      runningPointLL = widget.map
          .unproject(CustomPoint(pixelOrigin.x + p.dx, pixelOrigin.y + (p.dy)));
      rulerState.lengthMeters = lengthMeters;
      setState(() {});
    }
  }

  void dragUpdate(RulerState rulerState, Offset p) {
    if (_x != null && _y != null) {
      if (pointsList != null) {
        pointsList!.add(p);
        CustomPoint pixelOrigin = widget.map.getPixelOrigin();
        var tmpPointLL = widget.map.unproject(
            CustomPoint(pixelOrigin.x + p.dx, pixelOrigin.y + (p.dy)));
        lengthMeters = lengthMeters! +
            CoordinateUtilities.getDistance(runningPointLL!, tmpPointLL);
        rulerState.lengthMeters = lengthMeters;
        runningPointLL = tmpPointLL;
        setState(() {});
      }
    }
  }

  void dragEnd(RulerState rulerState) {
    if (rulerState.lengthMeters != null) {
      rulerState.lengthMeters = null;
      setState(() {
        pointsList = null;
        lengthMeters = null;
      });
    }
  }
}

class LinePainter extends CustomPainter {
  LinePainter({required this.pointsList});
  List<Offset> pointsList;
  final Paint paintObject = Paint();
  @override
  void paint(Canvas canvas, Size size) {
    _drawPath(canvas);
  }

  void _drawPath(Canvas canvas) {
    Path path = Path();
    paintObject.color = SmashColors.mainSelectionBorder;
    paintObject.strokeWidth = 3;
    paintObject.style = PaintingStyle.fill;
    if (pointsList.length < 2) {
      return;
    }
    paintObject.style = PaintingStyle.stroke;
    path.moveTo(pointsList[0].dx, pointsList[0].dy);
    for (int i = 1; i < pointsList.length - 1; i++) {
      if (pointsList[i] == null) {
        continue;
      }
      path.lineTo(pointsList[i].dx, pointsList[i].dy);
    }
    canvas.drawPath(path, paintObject);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}
