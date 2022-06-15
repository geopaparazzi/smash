/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/models/gps_state.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

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
        child: Padding(
          padding: SmashUI.defaultPadding(),
          child: InkWell(
            key: widget._key,
            child: DashboardUtils.getLoggingIcon(gpsState.status,
                size: widget._iconSize),
            // iconSize: widget._iconSize,
          ),
        ),
        onTap: () {
          if (gpsState.status != GpsStatus.NOGPS &&
              gpsState.status != GpsStatus.OFF) {
            _toggleLoggingFunction(context, gpsState);
          }
        },
        onLongPress: () {
          ProjectState projectState =
              Provider.of<ProjectState>(context, listen: false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LogListWidget(projectState.projectDb!)));
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
      var stopLogging = await SmashDialogs.showConfirmDialog(
          context,
          SL.of(context).gpsLogButton_stopLogging, //"Stop Logging?"
          SL
              .of(context)
              .gpsLogButton_stopLoggingAndCloseLog); //"Stop logging and close the current GPS log?"
      if (stopLogging != null && stopLogging) {
        gpsLoggingState.stopLogging();
        ProjectState projectState =
            Provider.of<ProjectState>(context, listen: false);
        projectState.reloadProject(context);
      }
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

        String? userString = await SmashDialogs.showInputDialog(
          context,
          SL.of(context).gpsLogButton_newLog, //"New Log"
          SL
              .of(context)
              .gpsLogButton_enterNameForNewLog, //"Enter a name for the new log"
          hintText: '',
          defaultText: logName,
          validationFunction: noEmptyValidator,
        );

        if (userString != null) {
          if (userString.trim().length == 0) userString = logName;
          int? logId = gpsLoggingState.startLogging(userString);
          if (logId == null) {
            SMLogger().e(
                "${SL.of(context).gpsLogButton_couldNotStartLogging} $userString",
                null,
                null); //Could not start logging:
          }
        }
      } else {
        SmashDialogs.showOperationNeedsGps(context);
      }
    }
  }
}
