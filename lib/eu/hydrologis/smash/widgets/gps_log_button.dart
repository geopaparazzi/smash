/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/validators.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';


/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class LoggingButton extends StatefulWidget {
  double _iconSize;

  LoggingButton(this._iconSize);

  @override
  State<StatefulWidget> createState() => _LoggingButtonState();
}

class _LoggingButtonState extends State<LoggingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      return GestureDetector(
        child: IconButton(
            icon: DashboardUtils.getLoggingIcon(gpsState.status),
            iconSize: widget._iconSize,
            onPressed: () {
              _toggleLoggingFunction(context, gpsState);
            }),
        onLongPress: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LogListWidget()));
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
        projectState.reloadProject();
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
