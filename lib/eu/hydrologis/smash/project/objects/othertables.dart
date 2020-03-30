/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/database/database.dart';
import 'package:latlong/latlong.dart';
import 'dart:typed_data';

/*
 * The metadata table name.
 */
final String TABLE_METADATA = "metadata";

/*
 * Bookmarks table name.
 */
final String TABLE_BOOKMARKS = "bookmarks";


final String BOOKMARK_COLUMN_ID = "_id";
final String BOOKMARK_COLUMN_LON = "lon";
final String BOOKMARK_COLUMN_LAT = "lat";
final String BOOKMARK_COLUMN_TEXT = "text";
final String BOOKMARK_COLUMN_ZOOM = "zoom";
