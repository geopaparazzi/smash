/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';


class GpsToolsWidget extends StatefulWidget {
  GpsToolsWidget();

  @override
  State<StatefulWidget> createState() => _GpsToolsWidgetState();
}

class _GpsToolsWidgetState extends State<GpsToolsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SmashMapState>(builder: (context, mapState, child) {
      Widget toolsWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SmashUI.titleText(
              "Tools",
              textAlign: TextAlign.center,
              color: SmashColors.mainBackground,
              bold: true,
            ),
          ),
          CheckboxListTile(
            value: mapState.centerOnGps,
            title: SmashUI.normalText("Center on GPS",
                color: SmashColors.mainBackground),
            onChanged: (value) {
              mapState.centerOnGps = value;
            },
          ),
          Platform.isAndroid &&
              false // TODO enable this once the rotation issue has been sorted out
              ? CheckboxListTile(
            value: mapState.rotateOnHeading,
            title: SmashUI.normalText("Rotate map with GPS",
                color: SmashColors.mainBackground),
            onChanged: (value) {
              mapState.rotateOnHeading = value;
            },
          )
              : Container(),
        ],
      );
      return Container(
        child: toolsWidget,
      );
    });
  }
}
