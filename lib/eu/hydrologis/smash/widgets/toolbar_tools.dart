/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/models/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/eu/hydrologis/smash/models/mapbuilder.dart';
import 'package:smash/eu/hydrologis/smash/models/ruler_state.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

enum ToolbarState {
  MAIN_VIEW,
  EDITING,
}

class BottomToolsBar extends StatefulWidget {
  final _iconSize;
  BottomToolsBar(this._iconSize, {Key key}) : super(key: key);

  @override
  _BottomToolsBarState createState() => _BottomToolsBarState();
}

class _BottomToolsBarState extends State<BottomToolsBar> {
  ToolbarState toolbarState = ToolbarState.MAIN_VIEW;

  @override
  Widget build(BuildContext context) {
    // if (toolbarState == ToolbarState.MAIN_VIEW) {
    return BottomAppBar(
      color: SmashColors.mainDecorations,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // TODO GeomEditorButton(widget._iconSize),
          FeatureQueryButton(widget._iconSize),
          RulerButton(widget._iconSize),
          Spacer(),
          Consumer<SmashMapState>(builder: (context, mapState, child) {
            return DashboardUtils.makeToolbarZoomBadge(
              IconButton(
                onPressed: () {
                  mapState.zoomIn();
                },
                tooltip: 'Zoom in',
                icon: Icon(
                  SmashIcons.zoomInIcon,
                  color: SmashColors.mainBackground,
                ),
                iconSize: widget._iconSize,
              ),
              mapState.zoom.toInt(),
              iconSize: widget._iconSize,
            );
          }),
          Consumer<SmashMapState>(builder: (context, mapState, child) {
            return IconButton(
              onPressed: () {
                mapState.zoomOut();
              },
              tooltip: 'Zoom out',
              icon: Icon(
                SmashIcons.zoomOutIcon,
                color: SmashColors.mainBackground,
              ),
              iconSize: widget._iconSize,
            );
          }),
        ],
      ),
    );
    // }
  }
}

class FeatureQueryButton extends StatefulWidget {
  final _iconSize;

  FeatureQueryButton(this._iconSize, {Key key}) : super(key: key);

  @override
  _FeatureQueryButtonState createState() => _FeatureQueryButtonState();
}

class _FeatureQueryButtonState extends State<FeatureQueryButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InfoToolState>(builder: (context, infoState, child) {
      return GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.layersSearch,
              color: infoState.isEnabled
                  ? SmashColors.mainSelection
                  : SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            infoState.setEnabled(!infoState.isEnabled);
          });
        },
      );
    });
  }
}

class RulerButton extends StatefulWidget {
  final _iconSize;

  RulerButton(this._iconSize, {Key key}) : super(key: key);

  @override
  _RulerButtonState createState() => _RulerButtonState();
}

class _RulerButtonState extends State<RulerButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RulerState>(builder: (context, rulerState, child) {
      return GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.ruler,
              color: rulerState.isEnabled
                  ? SmashColors.mainSelection
                  : SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            rulerState.setEnabled(!rulerState.isEnabled);
          });
        },
      );
    });
  }
}

class GeomEditorButton extends StatefulWidget {
  final _iconSize;

  GeomEditorButton(this._iconSize, {Key key}) : super(key: key);

  @override
  _GeomEditorButtonState createState() => _GeomEditorButtonState();
}

class _GeomEditorButtonState extends State<GeomEditorButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GeometryEditorState>(
        builder: (context, editorState, child) {
      return GestureDetector(
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            child: Icon(
              MdiIcons.vectorLine,
              color: editorState.isEnabled
                  ? SmashColors.mainSelection
                  : SmashColors.mainBackground,
              size: widget._iconSize,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            editorState.isEnabled = !editorState.isEnabled;
            SmashMapBuilder mapBuilder =
                Provider.of<SmashMapBuilder>(context, listen: false);
            mapBuilder.reBuild();
          });
        },
      );
    });
  }
}
