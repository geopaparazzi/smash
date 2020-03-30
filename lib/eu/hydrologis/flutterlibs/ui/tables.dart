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

class TableUtilities {
  static TableCell cellForString(String data, {color: Colors.black}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SmashUI.normalText(data, color: color),
      ),
    );
  }

  static Table fromMap(Map<String, dynamic> map,
      {bool withBorder = false, Color borderColor = Colors.blueAccent}) {
    List<TableRow> rows = [];

    map.forEach((key, value) {
      var row = TableRow(
        children: [
          cellForString(key),
          cellForString(value.toString()),
        ],
      );
      rows.add(row);
    });

    return Table(
      border: withBorder
          ? TableBorder(
              bottom: BorderSide(color: borderColor, width: 2),
              left: BorderSide(color: borderColor, width: 2),
              right: BorderSide(color: borderColor, width: 2),
              top: BorderSide(color: borderColor, width: 2),
              horizontalInside: BorderSide(color: borderColor, width: 1),
              verticalInside: BorderSide(color: borderColor, width: 1),
            )
          : null,
      columnWidths: {
        0: FlexColumnWidth(0.4),
        1: FlexColumnWidth(0.6),
      },
      children: rows,
    );
  }
}
