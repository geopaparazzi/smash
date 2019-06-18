/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';

double SIMPLE_DIALOGS_HEIGHT = 150;
double SIMPLE_DIALOGS_ICONSIZE = 80;

/// Confirm dialog using custom [title] and [prompt].
///
/// To be used as:
///
/// showConfirmDialog().then((result) {
///     if (result == true) {
///         setState(() {
///             // do stuff
///         });
///     }
/// });
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
          content: Container(
            height: SIMPLE_DIALOGS_HEIGHT,
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
          content: Container(
            height: SIMPLE_DIALOGS_HEIGHT,
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

void showInfoDialog(BuildContext context, String prompt,
    {String title: "Info"}) async {
  await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: SIMPLE_DIALOGS_HEIGHT,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.info_outline,
                    color: GeopaparazziColors.mainDecorations,
                    size: SIMPLE_DIALOGS_ICONSIZE,
                  ),
                ),
                Text(prompt),
              ],
            ),
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

Future<String> showInputDialog(BuildContext context, String title, String label,
    {hintText: '', okText: 'Ok', cancelText: 'Cancel'}) async {
  String userInput = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: label, hintText: hintText),
              onChanged: (value) {
                userInput = value;
              },
            ))
          ],
        ),
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
              Navigator.of(context).pop(userInput);
            },
          ),
        ],
      );
    },
  );
}

Future<String> showComboDialog(
    BuildContext context, String title, List<String> items) async {
  List<SimpleDialogOption> widgets = items.map((str) => SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, str);
        },
        child: Text(str),
      ));

  String selection = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: widgets,
        );
      });
  return selection;
}

showOperationNeedsGps(context) {
  showWarningDialog(
      context, "This option is available only when the GPS has a fix.");
}
