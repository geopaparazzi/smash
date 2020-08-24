/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/ruler_state.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
          });
        },
      );
    });
  }
}
