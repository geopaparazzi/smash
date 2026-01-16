/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/mainview_utils.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smash/eu/hydrologis/smash/widgets/settings.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

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

        // String? userString = await showInputDialog(
        //   context,
        //   SL.of(context).gpsLogButton_newLog, //"New Log"
        //   SL
        //       .of(context)
        //       .gpsLogButton_enterNameForNewLog, //"Enter a name for the new log"
        //   hintText: '',
        //   defaultText: logName,
        //   validationFunction: noEmptyValidator,
        // );

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

//   static Future<String?> showInputDialog(
//       BuildContext context, String title, String label,
//       {defaultText: '',
//       hintText: '',
//       okText: 'Ok',
//       cancelText: 'Cancel',
//       isPassword: false,
//       Function? validationFunction}) async {
//     String? errorText;

//     var textEditingController = new TextEditingController(text: defaultText);
//     var inputDecoration = new InputDecoration(
//       labelText: label,
//       hintText: hintText,
//     );
//     var _textWidget = new TextFormField(
//       controller: textEditingController,
//       autofocus: true,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       decoration: inputDecoration,
//       obscureText: isPassword,
//       validator: (inputText) {
//         if (validationFunction != null) {
//           errorText = validationFunction(inputText);
//         } else {
//           errorText = null;
//         }
//         return errorText;
//       },
//     );

//     return showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       // dialog is dismissible with a tap on the barrier
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Builder(builder: (context) {
//             var width = MediaQuery.of(context).size.width;
//             return Container(
//               width: width,
//               child: new Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[new Expanded(child: _textWidget)],
//               ),
//             );
//           }),
//           actions: <Widget>[
//             TextButton(
//               child: Text(cancelText),
//               onPressed: () {
//                 Navigator.of(context).pop(null);
//               },
//             ),
//             TextButton(
//               child: Text(okText),
//               onPressed: () {
//                 if (errorText == null) {
//                   Navigator.of(context).pop(textEditingController.text);
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
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
    // Load default/available tags from prefs
    List<String> allTags = (await GpPreferences()
            .getStringList(SmashPreferencesKeys.KEY_GPS_LOG_TAGS, [])) ??
        <String>[];
    allTags = allTags
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final List<String> selectedTags = (initialSelectedTags ?? <String>[])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    String? errorText;
    final nameController = TextEditingController(text: defaultText);

    final tagController = TextEditingController();
    final tagFocusNode = FocusNode();

    return showDialog<NameAndTagsResult>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            void addSelectedTag(String raw) {
              final tag = raw.trim();
              if (tag.isEmpty) return;

              if (!selectedTags.contains(tag)) {
                selectedTags.add(tag);
                selectedTags.sort();
              }

              // If new, also add to defaults and persist
              if (!allTags.contains(tag)) {
                allTags.add(tag);
                allTags.sort();
                GpPreferences().setStringListSync(
                    SmashPreferencesKeys.KEY_GPS_LOG_TAGS, allTags);
              }

              setState(() {});
            }

            void removeSelectedTagAt(int index) {
              selectedTags.removeAt(index);
              setState(() {});
            }

            void addFromInput() {
              final v = tagController.text;
              addSelectedTag(v);
              tagController.clear();
              tagFocusNode.requestFocus();
            }

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

            // Available tags = defaults minus selected
            final availableTags =
                allTags.where((t) => !selectedTags.contains(t)).toList();

            return AlertDialog(
              title: Text(title),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(ctx).size.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      nameField,
                      const SizedBox(height: 16),

                      Text('Current tags',
                          style: Theme.of(ctx).textTheme.labelLarge),
                      const SizedBox(height: 8),

                      // Selected tags list (removable)
                      if (selectedTags.isEmpty)
                        Text(
                          'No tags yet.',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        )
                      else
                        Tags(
                          alignment: WrapAlignment.start,
                          itemCount: selectedTags.length,
                          itemBuilder: (int index) {
                            final item = selectedTags[index];
                            return ItemTags(
                              key: Key('sel_$index'),
                              index: index,
                              title: item,
                              active: true,
                              pressEnabled: true,
                              activeColor: SmashColors.mainDecorations,
                              color: SmashColors.mainDecorations,
                              textActiveColor: SmashColors.mainBackground,
                              borderRadius: BorderRadius.circular(12),
                              removeButton: ItemTagsRemoveButton(
                                backgroundColor: SmashColors.mainBackground,
                                color: SmashColors.mainDecorations,
                                onRemoved: () {
                                  removeSelectedTagAt(index);
                                  return true;
                                },
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 16),

                      Text('Available tags',
                          style: Theme.of(ctx).textTheme.labelLarge),
                      const SizedBox(height: 8),

                      // Available tags area (tap to add)
                      if (availableTags.isEmpty)
                        Text(
                          'No available tags.',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final t in availableTags)
                              ActionChip(
                                label: SmashUI.normalText(t,
                                    color: SmashColors.mainBackground),
                                backgroundColor: Colors.lightGreen,
                                onPressed: () {
                                  addSelectedTag(t);
                                  tagController.clear();
                                  tagFocusNode.requestFocus();
                                },
                              ),
                          ],
                        ),

                      const SizedBox(height: 10),
                      // Input row: type + add
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tagController,
                              focusNode: tagFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'or type a new tag and press +',
                              ),
                              onSubmitted: (_) => addFromInput(),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: addFromInput,
                          ),
                        ],
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
