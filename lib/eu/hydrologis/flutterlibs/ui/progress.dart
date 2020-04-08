/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';

class SmashCircularProgress extends StatelessWidget {
  final String label;

  SmashCircularProgress({this.label, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            SmashUI.normalText(label),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
