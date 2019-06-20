/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:intl/intl.dart';

/// An ISO8601 date formatter (yyyy-MM-dd HH:mm:ss).
final DateFormat ISO8601_TS_FORMATTER = DateFormat("yyyy-MM-dd HH:mm:ss");

/// A date formatter (yyyyMMdd_HHmmss) useful for file names (it contains no spaces).
final DateFormat DATE_TS_FORMATTER = DateFormat("yyyyMMdd_HHmmss");
