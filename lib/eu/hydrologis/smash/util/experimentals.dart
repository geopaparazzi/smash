import 'dart:io';

import 'package:flutter_map/plugin_api.dart';

/// Enable rotation of map
const EXPERIMENTAL_ROTATION__ENABLED = false;

/// Enable color substitution in raster tiles/images
const EXPERIMENTAL_HIDE_COLOR_RASTER__ENABLED = true;

class ExceptionsToTrack {
  /// Cached uses sqfile on Linux which is not supported.
  static TileProvider getDefaultForOnlineServices() {
    TileProvider tileProvider = NetworkTileProvider();
    // if (Platform.isLinux) {
    //   tileProvider = NetworkTileProvider();
    // }
    return tileProvider;
  }
}
