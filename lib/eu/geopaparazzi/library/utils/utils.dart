/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:smash/eu/geopaparazzi/library/utils/colors.dart';
import 'package:intl/intl.dart';

class GpConstants {
  static const String APP_NAME = "smash";

  /// An ISO8601 date formatter (yyyy-MM-dd HH:mm:ss).
  static final DateFormat ISO8601_TS_FORMATTER =
      DateFormat("yyyy-MM-dd HH:mm:ss");

  /// A date formatter (yyyyMMdd_HHmmss) useful for file names (it contains no spaces).
  static final DateFormat DATE_TS_FORMATTER = DateFormat("yyyyMMdd_HHmmss");

  static final TextStyle SMALL_DIALOG_TEXT_STYLE =
      TextStyle(fontSize: 12, color: SmashColors.mainTextColorNeutral);
  static final TextStyle MEDIUM_DIALOG_TEXT_STYLE =
      TextStyle(fontSize: 18, color: SmashColors.mainTextColorNeutral);
  static final TextStyle LARGE_DIALOG_TEXT_STYLE =
      TextStyle(fontSize: 24, color: SmashColors.mainTextColorNeutral);

  static final TextStyle SMALL_DIALOG_TEXT_STYLE_NEUTRAL =
      TextStyle(fontSize: 12, color: SmashColors.mainTextColorNeutral);
  static final TextStyle MEDIUM_DIALOG_TEXT_STYLE_NEUTRAL =
      TextStyle(fontSize: 18, color: SmashColors.mainTextColorNeutral);
  static final TextStyle LARGE_DIALOG_TEXT_STYLE_NEUTRAL =
      TextStyle(fontSize: 24, color: SmashColors.mainTextColorNeutral);

  static const double SMALL_DIALOG_ICON_SIZE = 24;
  static const double MEDIUM_DIALOG_ICON_SIZE = 36;
  static const double LARGE_DIALOG_ICON_SIZE = 48;

  static const double DEFAULT_PADDING = 10.0;
  static const double DEFAULT_ELEVATION = 5.0;
}
