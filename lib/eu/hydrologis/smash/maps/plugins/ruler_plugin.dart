/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:smashlibs/smashlibs.dart';

/// A plugin that handles tap info from vector layers
class RulerPluginLayer extends StatefulWidget {
  final Color tapAreaColor = SmashColors.mainSelectionBorder;
  final double tapAreaPixelSize;

  RulerPluginLayer({this.tapAreaPixelSize = 10});

  @override
  _RulerPluginLayerState createState() => _RulerPluginLayerState();
}

class _RulerPluginLayerState extends State<RulerPluginLayer> {
  Coordinate? runningPointLL;
  double? _x;
  double? _y;
  double? lengthMeters;

  List<Offset>? pointsList;
  late FlutterMapState map;

  @override
  Widget build(BuildContext context) {
    map = FlutterMapState.maybeOf(context)!;
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
      CustomPoint pixelOrigin = map.pixelOrigin;
      var tmp = map
          .unproject(CustomPoint(pixelOrigin.x + p.dx, pixelOrigin.y + (p.dy)));
      runningPointLL = Coordinate(tmp.longitude, tmp.latitude);
      rulerState.lengthMeters = lengthMeters;
      setState(() {});
    }
  }

  void dragUpdate(RulerState rulerState, Offset p) {
    if (_x != null && _y != null) {
      if (pointsList != null) {
        pointsList!.add(p);
        CustomPoint pixelOrigin = map.pixelOrigin;
        var tmp = map.unproject(
            CustomPoint(pixelOrigin.x + p.dx, pixelOrigin.y + (p.dy)));
        var tmpPointLL = Coordinate(tmp.longitude, tmp.latitude);
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
