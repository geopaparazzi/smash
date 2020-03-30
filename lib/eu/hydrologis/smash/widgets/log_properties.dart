/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/tables.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/validators.dart';
import 'package:smash/eu/hydrologis/smash/models/map_progress_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';

/// The log properties page.
class LogPropertiesWidget extends StatefulWidget {
  var _logItem;

  LogPropertiesWidget(this._logItem);

  @override
  State<StatefulWidget> createState() {
    return LogPropertiesWidgetState(_logItem);
  }
}

class LogPropertiesWidgetState extends State<LogPropertiesWidget> {
  Log4ListWidget _logItem;
  double _widthSliderValue;
  ColorExt _logColor;
  double maxWidth = 20.0;
  bool _somethingChanged = false;

  LogPropertiesWidgetState(this._logItem);

  @override
  void initState() {
    _widthSliderValue = _logItem.width;
    if (_widthSliderValue > maxWidth) {
      _widthSliderValue = maxWidth;
    }
    _logColor = ColorExt(_logItem.color);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            // save color and width
            _logItem.width = _widthSliderValue;
            _logItem.color = ColorExt.asHex(_logColor);

            ProjectState projectState =
                Provider.of<ProjectState>(context, listen: false);
            await projectState.projectDb
                .updateGpsLogStyle(_logItem.id, _logItem.color, _logItem.width);
            projectState.reloadProject();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("GPS Log Properties"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: SmashUI.defaultPadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.2),
                              1: FlexColumnWidth(0.8),
                            },
                            children: _getInfoTableCells(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _getInfoTableCells(BuildContext context) {
    return [
      TableRow(
        children: [
          TableUtilities.cellForString("Name"),
          cellForEditableName(context, _logItem),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Start"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(
                  new DateTime.fromMillisecondsSinceEpoch(_logItem.startTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("End"),
          TableUtilities.cellForString(TimeUtilities.ISO8601_TS_FORMATTER
              .format(
                  new DateTime.fromMillisecondsSinceEpoch(_logItem.endTime))),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Color"),
          LimitedBox(
            maxHeight: 400,
            child: MaterialColorPicker(
                shrinkWrap: true,
                allowShades: false,
                onColorChange: (Color color) {
                  _logColor = ColorExt.fromColor(color);
                  _somethingChanged = true;
                },
                onMainColorChange: (mColor) {
                  _logColor = ColorExt.fromColor(mColor);
                  _somethingChanged = true;
                },
                selectedColor: Color(_logColor.value)),
          ),
        ],
      ),
      TableRow(
        children: [
          TableUtilities.cellForString("Width"),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Slider(
                    activeColor: SmashColors.mainSelection,
                    min: 1.0,
                    max: 20.0,
                    divisions: 10,
                    onChanged: (newRating) {
                      _somethingChanged = true;
                      setState(() => _widthSliderValue = newRating);
                    },
                    value: _widthSliderValue,
                  )),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: SmashUI.normalText(
                  '${_widthSliderValue.toInt()}',
                ),
              ),
            ],
          )
        ],
      ),
    ];
  }

  TableCell cellForEditableName(BuildContext context, Log4ListWidget item) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: SmashUI.normalText(item.name,
              color: SmashColors.mainDecorationsDarker),
          onDoubleTap: () {
            _changeLogName(context, item);
          },
        ),
      ),
    );
  }

  _changeLogName(BuildContext context, Log4ListWidget logItem) async {
    String result = await showInputDialog(
      context,
      "Change log name",
      "Please enter a new name for the log",
      defaultText: logItem.name,
      validationFunction: noEmptyValidator,
    );
    if (result != null) {
      ProjectState projectState =
          Provider.of<ProjectState>(context, listen: false);
      await projectState.projectDb.updateGpsLogName(logItem.id, result);
      setState(() {
        logItem.name = result;
      });
    }
  }
}
