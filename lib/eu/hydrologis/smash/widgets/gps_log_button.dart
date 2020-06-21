/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class LoggingButton extends StatefulWidget {
  final double _iconSize;
  final _key;
  LoggingButton(this._key, this._iconSize);

  @override
  State<StatefulWidget> createState() => _LoggingButtonState();
}

class _LoggingButtonState extends State<LoggingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      return GestureDetector(
        child: IconButton(
            key: widget._key,
            icon: DashboardUtils.getLoggingIcon(gpsState.status),
            iconSize: widget._iconSize,
            onPressed: () {
              _toggleLoggingFunction(context, gpsState);
            }),
        onLongPress: () {
          ProjectState projectState =
              Provider.of<ProjectState>(context, listen: false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LogListWidget(projectState.projectDb)));
        },
        onDoubleTap: () async {
          Dialog settingsDialog = Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GpsLogsSetting(),
            ),
          );
          await showDialog(
              context: context,
              builder: (BuildContext context) => settingsDialog);
        },
      );
    });
  }

  _toggleLoggingFunction(BuildContext context, GpsState gpsLoggingState) async {
    if (gpsLoggingState.isLogging) {
      var stopLogging = await showConfirmDialog(context, "Stop Logging?",
          "Stop logging and close the current GPS log?");
      if (stopLogging) {
        await gpsLoggingState.stopLogging();
        ProjectState projectState =
            Provider.of<ProjectState>(context, listen: false);
        projectState.reloadProject(context);
      }
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

        String userString = await showInputDialog(
          context,
          "New Log",
          "Enter a name for the new log",
          hintText: '',
          defaultText: logName,
          validationFunction: noEmptyValidator,
        );

        if (userString != null) {
          if (userString.trim().length == 0) userString = logName;
          int logId = await gpsLoggingState.startLogging(logName);
          if (logId == null) {
            // TODO show error
          }
        }
      } else {
        showOperationNeedsGps(context);
      }
    }
  }
}
