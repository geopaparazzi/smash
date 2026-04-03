/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

/// Class to hold the state of the GPS info button, updated by the gps state notifier.
///
class LoggingButton extends StatefulWidget {
  final double _iconSize;
  LoggingButton(this._iconSize);

  @override
  State<StatefulWidget> createState() => _LoggingButtonState();
}

class _LoggingButtonState extends State<LoggingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      ProjectState projectState =
          Provider.of<ProjectState>(context, listen: false);

      Color color;
      IconData iconData;
      switch (gpsState.status) {
        case GpsStatus.LOGGING:
          {
            iconData = SmashIcons.logIcon;
            color = SmashColors.mainSelection;
            break;
          }
        case GpsStatus.OFF:
        case GpsStatus.ON_WITH_FIX:
        case GpsStatus.ON_NO_FIX:
        case GpsStatus.NOPERMISSION:
          {
            iconData = SmashIcons.logIcon;
            color = SmashColors.mainDecorations;
            break;
          }
        default:
          {
            iconData = SmashIcons.logIcon;
            color = SmashColors.mainDecorations;
          }
      }

      return SmashUI.makeBackgroundCircle(
          GestureDetector(
            child: Padding(
              padding: SmashUI.defaultPadding(),
              child: InkWell(
                child: Icon(iconData,
                    size: widget._iconSize, color: SmashColors.mainBackground),
              ),
            ),
            onTap: () {
              if (gpsState.status != GpsStatus.NOGPS &&
                  gpsState.status != GpsStatus.OFF) {
                _toggleLoggingFunction(context, projectState, gpsState);
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
          ),
          padding: 0,
          background: color);
    });
  }

  _toggleLoggingFunction(BuildContext context, ProjectState projectState,
      GpsState gpsState) async {
    if (projectState.isLogging) {
      var stopLogging = await SmashDialogs.showConfirmDialog(
          context,
          SL.of(context).gpsLogButton_stopLogging, //"Stop Logging?"
          SL
              .of(context)
              .gpsLogButton_stopLoggingAndCloseLog); //"Stop logging and close the current GPS log?"
      if (stopLogging != null && stopLogging) {
        projectState.stopLogging(gpsState);
        projectState.reloadProject(context);
      }
    } else {
      if (GpsHandler().hasFix()) {
        String logName =
            "log_${TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now())}";

        final NameAndTagsResult? res =
            await GpsLogDialogs.showNameAndTagsDialog(
          context,
          SL.of(context).gpsLogButton_newLog, //"New Log"
          SL
              .of(context)
              .gpsLogButton_enterNameForNewLog, //"Enter a name for the new log"
          validationFunction: (s) =>
              (s == null || s.trim().isEmpty) ? "Required" : null,
          defaultText: logName,
        );

        if (res != null) {
          String n = res.name.trim();
          if (n.length == 0) n = logName;
          int? logId = projectState.startLogging(n, gpsState, tags: res.tags);
          if (logId == null) {
            SMLogger().e(
                "${SL.of(context).gpsLogButton_couldNotStartLogging} $n",
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

class NameAndTagsResult {
  final String name;
  final List<String> tags;
  NameAndTagsResult(this.name, this.tags);
}

class GpsLogDialogs {
  static Future<NameAndTagsResult?> showNameAndTagsDialog(
    BuildContext context,
    String title,
    String label, {
    String defaultText = '',
    String hintText = '',
    String okText = 'Ok',
    String cancelText = 'Cancel',
    bool isPassword = false,
    List<String>? initialSelectedTags,
    String? Function(String?)? validationFunction,
  }) async {
    List<String> selectedTags = (initialSelectedTags ?? <String>[])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    String? errorText;
    final nameController = TextEditingController(text: defaultText);

    return showDialog<NameAndTagsResult>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            final nameField = TextFormField(
              controller: nameController,
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
              ),
              obscureText: isPassword,
              validator: (inputText) {
                errorText = validationFunction?.call(inputText);
                return errorText;
              },
              textInputAction: TextInputAction.next,
            );

            var isLandscape = ScreenUtilities.isLandscape(ctx);
            var sWidth = ScreenUtilities.getWidth(ctx);
            var w = isLandscape ? sWidth * 0.6 : sWidth;
            return AlertDialog(
              title: Text(title),
              content: ConstrainedBox(
                constraints: BoxConstraints(minWidth: w, maxWidth: w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      nameField,
                      const SizedBox(height: 16),
                      SmashTagEditor(
                        title: "",
                        tags: selectedTags,
                        onTagsChanged: (next) {
                          setState(() {
                            selectedTags = next;
                          });
                        },
                        onAllTagsChanged: (nextAll) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(cancelText),
                  onPressed: () => Navigator.of(dialogCtx).pop(null),
                ),
                TextButton(
                  child: Text(okText),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final nameError = validationFunction?.call(name);
                    errorText = nameError;

                    if (errorText == null && name.isNotEmpty) {
                      Navigator.of(dialogCtx).pop(
                        NameAndTagsResult(
                            name, List<String>.from(selectedTags)),
                      );
                    } else {
                      setState(() {}); // refresh validation
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
