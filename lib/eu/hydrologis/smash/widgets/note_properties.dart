/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// The notes properties view.
class NotePropertiesWidgetState extends State<NotePropertiesWidget> {
  Note _note;
  double _sizeSliderValue = 10;
  double _maxSize = 100.0;
  ColorExt _noteColor;
  String _marker = 'mapMarker';
  bool _somethingChanged = false;
  var chosenIconsList = [];

  NotePropertiesWidgetState(this._note);

  @override
  void initState() {
    _sizeSliderValue = _note?.noteExt?.size;
    if (_sizeSliderValue > _maxSize) {
      _sizeSliderValue = _maxSize;
    }
    _noteColor = ColorExt(_note.noteExt.color);
    _marker = _note.noteExt.marker;

    chosenIconsList.addAll(GpPreferences()
        .getStringListSync(KEY_ICONS_LIST, DEFAULT_NOTES_ICONDATA));
    if (!chosenIconsList.contains(_marker)) {
      chosenIconsList.insert(0, _marker);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<GridTile> _iconButtons = [];
    chosenIconsList.forEach((iconName) {
      var color = SmashColors.mainDecorations;
      if (iconName == _marker) color = SmashColors.mainSelection;
      var but = GridTile(
          child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        color: SmashColors.mainBackground,
        child: IconButton(
          icon: Icon(getSmashIcon(iconName)),
          color: color,
          onPressed: () {
            _marker = iconName;
            _somethingChanged = true;
            setState(() {});
          },
        ),
      ));
      _iconButtons.add(but);
    });

    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _note.noteExt.color = ColorExt.asHex(_noteColor);
            _note.noteExt.marker = _marker;
            _note.noteExt.size = _sizeSliderValue;

            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            await projectState.projectDb.updateNote(_note);
            projectState.reloadProject(context);
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Note Properties"),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.pencil),
                                  color: SmashColors.mainDecorationsDarker,
                                  onPressed: () async {
                                    String result = await showInputDialog(
                                      context,
                                      "Change note text",
                                      "Please enter a new text for the note",
                                      defaultText: _note.text,
                                      validationFunction: noEmptyValidator,
                                    );
                                    if (result != null) {
                                      _note.text = result;
                                      _somethingChanged = true;
                                      setState(() {});
                                    }
                                  },
                                ),
                                SmashUI.normalText(_note.text,
                                    color: SmashColors.mainDecorationsDarker),
                              ],
                            ),
                          ),
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.4),
                              1: FlexColumnWidth(0.6),
                            },
                            children: _getInfoTableCells(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: MaterialColorPicker(
                        shrinkWrap: true,
                        allowShades: false,
                        circleSize: 45,
                        onColorChange: (Color color) {
                          _noteColor = ColorExt.fromColor(color);
                          _somethingChanged = true;
                        },
                        onMainColorChange: (mColor) {
                          _noteColor = ColorExt.fromColor(mColor);
                          _somethingChanged = true;
                        },
                        selectedColor: Color(_noteColor.value),
                        colors: SmashColorPalette.getColorSwatchValues(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SmashUI.normalText("Size"),
                          Flexible(
                              flex: 1,
                              child: Slider(
                                activeColor: SmashColors.mainSelection,
                                min: 5,
                                max: _maxSize,
                                divisions: 99,
                                onChanged: (newRating) {
                                  _somethingChanged = true;
                                  setState(() => _sizeSliderValue = newRating);
                                },
                                value: _sizeSliderValue,
                              )),
                          Container(
                            width: 50.0,
                            alignment: Alignment.center,
                            child: SmashUI.normalText(
                              '${_sizeSliderValue.toInt()}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return GridView.count(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            crossAxisCount:
                                orientation == Orientation.portrait ? 5 : 10,
                            childAspectRatio: 1,
                            padding: EdgeInsets.all(5),
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: _iconButtons,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _getInfoTableCells(BuildContext context) {
    return [
      TableRow(
        children: [
          TableUtilities.cellForString("Timestamp"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(DateTime.fromMillisecondsSinceEpoch(_note.timeStamp))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Altitude"),
          TableUtilities.cellForString(
              _note.altim.toStringAsFixed(KEY_ELEV_DECIMALS)),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Longitude"),
          TableUtilities.cellForString(
              _note.lon.toStringAsFixed(KEY_LATLONG_DECIMALS)),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Latitude"),
          TableUtilities.cellForString(
              _note.lat.toStringAsFixed(KEY_LATLONG_DECIMALS)),
        ],
      ),
    ];
  }
}

/// The notes properties page.
class NotePropertiesWidget extends StatefulWidget {
  var _note;

  NotePropertiesWidget(this._note);

  @override
  State<StatefulWidget> createState() {
    return NotePropertiesWidgetState(_note);
  }
}
