import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/geometryeditor_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/info_tool_state.dart';
import 'package:smash/eu/hydrologis/smash/models/tools/ruler_state.dart';
import 'package:provider/provider.dart';

/// A registry of tools that can't be active at the same time
class BottomToolbarToolsRegistry {
  static const RULER = const BottomToolbarToolsRegistry._(0);
  static const FEATUREINFO = const BottomToolbarToolsRegistry._(1);
  static const GEOMEDITOR = const BottomToolbarToolsRegistry._(2);

  static get values => [RULER, FEATUREINFO, GEOMEDITOR];
  final int value;

  const BottomToolbarToolsRegistry._(this.value);

  static void setEnabled(
      BuildContext context, BottomToolbarToolsRegistry type, bool enabled) {
    if (enabled) {
      enable(context, type);
    } else {
      disable(context, type);
    }
  }

  static void enable(BuildContext context, BottomToolbarToolsRegistry type) {
    RulerState rulerState = Provider.of<RulerState>(context, listen: false);
    InfoToolState infoToolState =
        Provider.of<InfoToolState>(context, listen: false);
    GeometryEditorState geomEditorState =
        Provider.of<GeometryEditorState>(context, listen: false);

    if (type == BottomToolbarToolsRegistry.RULER) {
      if (!rulerState.isEnabled) {
        rulerState.setEnabled(true);
      }
    } else {
      if (rulerState.isEnabled) {
        rulerState.setEnabled(false);
      }
    }
    if (type == BottomToolbarToolsRegistry.FEATUREINFO) {
      if (!infoToolState.isEnabled) {
        infoToolState.setEnabled(true);
      }
    } else {
      if (infoToolState.isEnabled) {
        infoToolState.setEnabled(false);
      }
    }
    if (type == BottomToolbarToolsRegistry.GEOMEDITOR) {
      if (!geomEditorState.isEnabled) {
        geomEditorState.setEnabled(true);
      }
    } else {
      if (geomEditorState.isEnabled) {
        geomEditorState.setEnabled(false);
      }
    }
  }

  static void disable(BuildContext context, BottomToolbarToolsRegistry type) {
    RulerState rulerState = Provider.of<RulerState>(context, listen: false);
    InfoToolState infoToolState =
        Provider.of<InfoToolState>(context, listen: false);
    GeometryEditorState geomEditorState =
        Provider.of<GeometryEditorState>(context, listen: false);
    if (type == BottomToolbarToolsRegistry.RULER && rulerState.isEnabled) {
      rulerState.setEnabled(false);
    } else if (type == BottomToolbarToolsRegistry.FEATUREINFO &&
        infoToolState.isEnabled) {
      infoToolState.setEnabled(false);
    } else if (type == BottomToolbarToolsRegistry.GEOMEDITOR &&
        geomEditorState.isEnabled) {
      geomEditorState.setEnabled(false);
    }
  }

  static void disableAll(BuildContext context) {
    RulerState rulerState = Provider.of<RulerState>(context, listen: false);
    InfoToolState infoToolState =
        Provider.of<InfoToolState>(context, listen: false);
    GeometryEditorState geomEditorState =
        Provider.of<GeometryEditorState>(context, listen: false);
    if (rulerState.isEnabled) {
      rulerState.setEnabled(false);
    }
    if (infoToolState.isEnabled) {
      infoToolState.setEnabled(false);
    }
    if (geomEditorState.isEnabled) {
      geomEditorState.setEnabled(false);
    }
  }
}
