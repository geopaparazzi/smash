/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/icons.dart' as ICONS;
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';

/// Confirm dialog using custom [title] and [prompt].
///
/// To be used as:
///
///     showConfirmDialog().then((result) {
///         if (result == true) {
///             setState(() {
///                 // do stuff
///             });
///         }
///     });
///
Future<bool> showConfirmDialog(
    BuildContext context, String title, String prompt,
    {trueText: 'Yes', falseText: 'No'}) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(prompt),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(trueText),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(falseText),
            )
          ],
        );
      });
}

/// Show a warning dialog, adding an optional [title] and a [prompt] for the user.
void showWarningDialog(BuildContext context, String prompt,
    {String title: "Warning"}) async {
  await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Wrap(
            children: <Widget>[
              Container(
//            height: SIMPLE_DIALOGS_HEIGHT,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.warning,
                        color: Colors.orange,
                        size: SIMPLE_DIALOGS_ICONSIZE,
                      ),
                    ),
                    Text(prompt),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}

/// Show an error dialog, adding an optional [title] and a [prompt] for the user.
void showErrorDialog(BuildContext context, String prompt,
    {String title: "Error"}) async {
  await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: SIMPLE_DIALOGS_ICONSIZE,
                      ),
                    ),
                    Text(prompt),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}

/// Show an info dialog, adding an optional [title] and a [prompt] for the user.
void showInfoDialog(BuildContext context, String prompt,
    {String title,
    double dialogHeight: SIMPLE_DIALOGS_HEIGHT,
    List<Widget> widgets,
    bool doLandscape = false}) async {
  Widget widget;
  if (doLandscape) {
    widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.info_outline,
            color: SmashColors.mainDecorations,
            size: SIMPLE_DIALOGS_ICONSIZE,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(prompt),
            ),
            Column(
              children: []..addAll(widgets != null ? widgets : []),
            )
          ],
        ),
      ],
    );
  } else {
    widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.info_outline,
            color: SmashColors.mainDecorations,
            size: SIMPLE_DIALOGS_ICONSIZE,
          ),
        ),
        Text(prompt),
      ]..addAll(widgets != null ? widgets : []),
    );
  }

  await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null
              ? null
              : Text(
                  title,
                  textAlign: TextAlign.center,
                ),
          content: Container(
            child: widget,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}

/// Show a user input dialog, adding a [title] and a [label].
///
/// Optionally a [hintText] and a [defaultText] can be passed in and the
/// strings for the [okText] and [cancelText] of the buttons.
///
/// If the user pushes the cancel button, null will be returned, if user pushes ok without entering anything the empty string '' is returned.
Future<String> showInputDialog(BuildContext context, String title, String label,
    {defaultText: '',
    hintText: '',
    okText: 'Ok',
    cancelText: 'Cancel',
    Function validationFunction}) async {
  String userInput = defaultText;
  String errorText;

  var textEditingController = new TextEditingController(text: defaultText);
  var inputDecoration =
      new InputDecoration(labelText: label, hintText: hintText);
  var _textWidget = new TextFormField(
    controller: textEditingController,
    autofocus: true,
    autovalidate: true,
    decoration: inputDecoration,
    validator: (inputText) {
      userInput = inputText;
      if (validationFunction != null) {
        errorText = validationFunction(inputText);
      } else {
        errorText = null;
      }
      return errorText;
    },
  );

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Builder(builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[new Expanded(child: _textWidget)],
            ),
          );
        }),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          FlatButton(
            child: Text(okText),
            onPressed: () {
              if (errorText == null) {
                Navigator.of(context).pop(userInput);
              }
            },
          ),
        ],
      );
    },
  );
}

/// Show a multiselection dialog, adding a [title] and a list of [items] to propose.
///
/// [title] can be either a String or a Widget.
///
/// Returns the selected item.
Future<String> showComboDialog(
    BuildContext context, dynamic title, List<String> items,
    [List<String> iconNames]) async {
  List<ListTile> widgets = [];
  for (var i = 0; i < items.length; ++i) {
    widgets.add(ListTile(
      onTap: () {
        Navigator.pop(context, items[i]);
      },
      title: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            iconNames != null
                ? Padding(
                    padding: SmashUI.defaultRigthPadding(),
                    child: Icon(
                      ICONS.getIcon(iconNames[i]),
                      color: SmashColors.mainDecorations,
                    ),
                  )
                : Container(),
            SmashUI.normalText(items[i],
                textAlign: TextAlign.center,
                bold: true,
                color: SmashColors.mainDecorations)
          ],
        ),
      ),
    ));
  }

  String selection = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: title is String
              ? SmashUI.normalText(title,
                  textAlign: TextAlign.center,
                  color: SmashColors.mainDecorationsDarker)
              : title,
          children:
              ListTile.divideTiles(context: context, tiles: widgets).toList(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      });
  return selection;
}

/// Show a warning dialog about the need of a GPS fix to proceed with the action.
showOperationNeedsGps(context) {
  showWarningDialog(
      context, "This option is available only when the GPS has a fix.");
}

showOperationNeedsNetwork(context) {
  showWarningDialog(context,
      "A working network connection is necessary to perform the action.");
}
