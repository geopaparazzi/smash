import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as IMG;
import 'package:logger/logger.dart';

/// Pure dart classes and methods for HydroloGIS projects.

/// File path and folder utilities.
class FileUtilities {
  static String joinPaths(String path1, String path2) {
    if (path2.startsWith("/")) {
      path2 = path2.substring(1);
      if (!path1.endsWith("/")) {
        path1 = path1 + "/";
      }
    }
    return join(path1, path2);
  }

  static String nameFromFile(String filePath, bool withExtension) {
    if (withExtension) {
      return basename(filePath);
    } else {
      return basenameWithoutExtension(filePath);
    }
  }

  static String parentFolderFromFile(String filePath) {
    return dirname(filePath);
  }

  static String readFile(String filePath) {
    return File(filePath).readAsStringSync();
  }

  static void writeStringToFile(String filePath, String stringToWrite) {
    return File(filePath).writeAsStringSync(stringToWrite);
  }

  static void writeBytesToFile(String filePath, List<int> bytesToWrite) {
    return File(filePath).writeAsBytesSync(bytesToWrite);
  }

  static void copyFile(String fromPath, String toPath) {
    File from = File(fromPath);
    from.copySync(toPath);
  }

  /*
   * Get the list of files names from a given [parentPath] and optionally filtered by [ext].
   */
  static List<String> getFilesInPathByExt(String parentPath, [String ext]) {
    List<String> filenameList = List();

    try {
      Directory(parentPath).listSync().forEach((FileSystemEntity fse) {
        String path = fse.path;
        String filename = basename(path);
        if (ext == null || filename.endsWith(ext)) {
          filenameList.add(filename);
        }
      });
    } catch (e) {
      print(e);
    }
    return filenameList;
  }

  static List<List<dynamic>> listFiles(String parentPath,
      {bool doOnlyFolder = false, List<String> allowedExtensions, bool doHidden = false, bool order = true}) {
    List<List<dynamic>> pathAndNameList = [];

    try {
      var list = Directory(parentPath).listSync();
      for (var fse in list) {
        String path = fse.path;
        String filename = basename(path);
        if (filename.startsWith(".")) {
          continue;
        }
        String parentname = dirname(path);

        var isDirectory = FileSystemEntity.isDirectorySync(path);
        if (doOnlyFolder && !isDirectory) {
          continue;
        }

        if (isDirectory) {
          pathAndNameList.add(<dynamic>[parentname, filename, isDirectory]);
        } else if (allowedExtensions != null) {
          for (var ext in allowedExtensions) {
            if (filename.endsWith(ext)) {
              pathAndNameList.add(<dynamic>[parentname, filename, isDirectory]);
              break;
            }
          }
        } else {
          pathAndNameList.add(<dynamic>[parentname, filename, isDirectory]);
        }
      }
    } catch (e) {
      print(e);
    }

    pathAndNameList.sort((o1, o2) {
      String n1 = o1[1];
      String n2 = o2[1];
      return n1.compareTo(n2);
    });

    return pathAndNameList;
  }
}

/// Image utilities
class ImageUtilities {
  static IMG.Image imageFromBytes(List<int> bytes) {
    IMG.Image img = IMG.decodeImage(bytes);
    return img;
  }

//  static void imageBytes2File(File file, List<int> bytes) {
//    IMG.Image img = imageFromBytes(bytes);
//
//    IMG.writeJpg(img)
//
//  }

  static List<int> bytesFromImageFile(String path) {
    File imgFile = File(path);
    return imgFile.readAsBytesSync();
  }

  static List<int> resizeImage(Uint8List bytes, {int newWidth: 100, int longestSizeTo}) {
    IMG.Image image = IMG.decodeImage(bytes);

    IMG.Image thumbnail;
    if (longestSizeTo != null) {
      if (image.width > image.height) {
        thumbnail = IMG.copyResize(
          image,
          width: longestSizeTo,
        );
      } else {
        thumbnail = IMG.copyResize(
          image,
          height: longestSizeTo,
        );
      }
    } else {
      thumbnail = IMG.copyResize(
        image,
        width: newWidth,
      );
    }
    var encodeJpg = IMG.encodeJpg(thumbnail);
    return encodeJpg;
  }
}

/// Time related utilities
class TimeUtilities {
  /// An ISO8601 date formatter (yyyy-MM-dd HH:mm:ss).
  static final DateFormat ISO8601_TS_FORMATTER = DateFormat("yyyy-MM-dd HH:mm:ss");

  /// An ISO8601 time formatter (HH:mm:ss).
  static final DateFormat ISO8601_TS_TIME_FORMATTER = DateFormat("HH:mm:ss");

  /// An ISO8601 day formatter (yyyy-MM-dd).
  static final DateFormat ISO8601_TS_DAY_FORMATTER = DateFormat("yyyy-MM-dd");

  /// A date formatter (yyyyMMdd_HHmmss) useful for file names (it contains no spaces).
  static final DateFormat DATE_TS_FORMATTER = DateFormat("yyyyMMdd_HHmmss");

  /// A date formatter (yyyyMMdd) useful for file names (it contains no spaces).
  static final DateFormat DAY_TS_FORMATTER = DateFormat("yyyyMMdd");

  /// A date formatter (yyyyMMdd_HH) useful for file names (it contains no spaces).
  static final DateFormat DAYHOUR_TS_FORMATTER = DateFormat("yyyyMMdd_HH");

  /// A date formatter (yyyyMMdd_HHmm) useful for file names (it contains no spaces).
  static final DateFormat DAYHOURMINUTE_TS_FORMATTER = DateFormat("yyyyMMdd_HHmm");
}

/// Network related utilities
class NetworkUtilities {
  /// Get the first ip address found in the [NetworkInterface.list()].
  static Future<String> getFirstIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        return addr.address;
      }
    }
    return null;
  }
}

/// A simple websocket service client class
///
abstract class HyServerSocketService {
  Logger log = Logger();
  bool _isConnected = false;

  WebSocket webSocket;
  String _host;
  String _port;

  /// Create the object ad connect using [_host] and [_port].
  /// If _host is not set, the ipaddress of the device is guessed.
  HyServerSocketService(this._port, [this._host]) {
    assert(_port != null);

    checkConnection();
  }

  void checkConnection() {
    if (!_isConnected) {
      log.i("Connecting to socket service.");
      connect();
      log.i("Connected to socket service: $_isConnected");
    }
  }

  Future<void> connect() async {
    if (_host == null) {
      _host = await NetworkUtilities.getFirstIpAddress();
    }
    webSocket = await WebSocket.connect('ws://$_host:$_port');
    webSocket.listen((data) {
      onMessage(data);
    });
  }

  Future<void> onMessage(data);
}

/// Mercator tiling system utils.
///
/// <p>Code copied from: http://code.google.com/p/gmap-tile-generator/
///  and adapted.</p>
class MercatorUtils {
  static const originShift = 2 * pi * 6378137 / 2.0;
  static const METER_TO_FEET_CONVERSION_FACTOR = 3.2808399;

  /// Converts TMS tile coordinates to Osm slippy map Tile coordinates.
  ///
  /// @param tx   the x tile number.
  /// @param ty   the y tile number.
  /// @param zoom the current zoom level.
  /// @return the converted values.
  static List<int> tmsTile2OsmTile(int tx, int ty, int zoom) {
    return [tx, ((pow(2, zoom) - 1) - ty).toInt()];
  }

  /// Converts Osm slippy map tile coordinates to TMS Tile coordinates.
  ///
  /// @param tx   the x tile number.
  /// @param ty   the y tile number.
  /// @param zoom the current zoom level.
  /// @return the converted values.
  static List<int> osmTile2TmsTile(int tx, int ty, int zoom) {
    return [tx, ((pow(2, zoom) - 1) - ty).toInt()];
  }

  /// Converts TMS tile coordinates to Microsoft QuadTree.
  ///
  /// @param tx   tile x.
  /// @param ty   tile y.
  /// @param zoom zoomlevel.
  /// @return the quadtree key.
  static String quadTree(int tx, int ty, int zoom) {
    StringBuffer quadKey = StringBuffer(); //$NON-NLS-1$
    ty = ((pow(2, zoom) - 1) - ty).toInt();
    for (int i = zoom; i < 0; i--) {
      int digit = 0;
      int mask = 1 << (i - 1);
      if ((tx & mask) != 0) {
        digit += 1;
      }
      if ((ty & mask) != 0) {
        digit += 2;
      }
      quadKey.write(digit); //$NON-NLS-1$
    }
    return quadKey.toString();
  }

  /// Get lat-long bounds from tile index.
  ///
  /// @param tx       tile x.
  /// @param ty       tile y.
  /// @param zoom     zoomlevel.
  /// @param tileSize tile size.
  /// @return [minx, miny, maxx, maxy]
  static List<double> tileLatLonBounds(int tx, int ty, int zoom, int tileSize) {
    List<double> bounds = tileBounds3857(tx.toDouble(), ty.toDouble(), zoom, tileSize);
    List<double> mins = metersToLatLon(bounds[0], bounds[1]);
    List<double> maxs = metersToLatLon(bounds[2], bounds[3]);
    return [mins[1], maxs[0], maxs[1], mins[0]];
  }

  /// Returns bounds of the given tile in EPSG:3857 coordinates
  ///
  /// @param tx       tile x.
  /// @param ty       tile y.
  /// @param zoom     zoomlevel.
  /// @param tileSize tile size.
  /// @return [minx, miny, maxx, maxy]
  static List<double> tileBounds3857(double tx, double ty, int zoom, int tileSize) {
    List<double> min = pixelsToMeters(tx * tileSize, ty * tileSize, zoom, tileSize);
    double minx = min[0], miny = min[1];
    List<double> max = pixelsToMeters((tx + 1) * tileSize, (ty + 1) * tileSize, zoom, tileSize);
    double maxx = max[0], maxy = max[1];
    return [minx, miny, maxx, maxy];
  }

  /// <p>Code copied from: http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Lon..2Flat._to_tile_numbers </p>
  /// 20131128: corrections added to correct going over or under max/min extent
  /// - was causing http 400 Bad Requests
  /// - updated openstreetmap wiki
  ///
  /// @param zoom
  /// @return [\zoom, xtile, ytile_osm]
  static List<int> getTileNumber(final double lat, final double lon, final int zoom) {
    int xtile = ((lon + 180) / 360 * (1 << zoom)).floor();
    int ytile_osm = ((1 - log(tan(degToRadian(lat)) + 1 / cos(degToRadian(lat))) / pi) / 2 * (1 << zoom)).floor();
    if (xtile < 0) xtile = 0;
    if (xtile >= (1 << zoom)) xtile = ((1 << zoom) - 1);
    if (ytile_osm < 0) ytile_osm = 0;
    if (ytile_osm >= (1 << zoom)) ytile_osm = ((1 << zoom) - 1);
    return [zoom, xtile, ytile_osm];
  }

  /// Converts XY point from Spherical Mercator EPSG:900913 to lat/lon in WGS84
  /// Datum
  ///
  /// @param mx x
  /// @param my y
  /// @return lat long
  static List<double> metersToLatLon(double mx, double my) {
    double lon = (mx / originShift) * 180.0;
    double lat = (my / originShift) * 180.0;

    lat = 180 / pi * (2 * atan(exp(lat * pi / 180.0)) - pi / 2.0);
    return [lat, lon];
  }

  /// Equatorial radius of earth is required for distance computation.
  static final double EQUATORIALRADIUS = 6378137.0;

  /// Convert a longitude coordinate (in degrees) to a horizontal distance in meters from the
  /// zero meridian
  ///
  /// @param longitude in degrees
  /// @return longitude in meters in spherical mercator projection
  static double longitudeToMetersX(double longitude) {
    return EQUATORIALRADIUS * degToRadian(longitude);
  }

  /// Convert a meter measure to a longitude
  ///
  /// @param x in meters
  /// @return longitude in degrees in spherical mercator projection
  static double metersXToLongitude(double x) {
    return radianToDeg(x / EQUATORIALRADIUS);
  }

  /// Convert a meter measure to a latitude
  ///
  /// @param y in meters
  /// @return latitude in degrees in spherical mercator projection
  static double metersYToLatitude(double y) {
    return radianToDeg(atan(sinh(y / EQUATORIALRADIUS)));
  }

  static double sinh(double radians) {
    return (exp(radians) - exp(-radians)) / 2;
  }

  /// Convert a latitude coordinate (in degrees) to a vertical distance in meters from the
  /// equator
  ///
  /// @param latitude in degrees
  /// @return latitude in meters in spherical mercator projection
  static double latitudeToMetersY(double latitude) {
    return EQUATORIALRADIUS * log(tan(pi / 4 + 0.5 * degToRadian(latitude)));
  }

  /// Convert a east-longitude,west-longitude coordinate (in degrees) to distance in meters
  ///
  /// @param east_longitude longitude in degrees
  /// @param west_longitude longitude in degrees
  /// @return meters in spherical mercator projection
  static double longitudeToMeters(double east_longitude, double west_longitude) {
    return longitudeToMetersX(east_longitude) - longitudeToMetersX(west_longitude);
  }

  /// Convert a north-latitude,south-latitude coordinate (in degrees) to distance in meters
  ///
  /// @param north_latitude latitude in degrees
  /// @param south_latitude latitude in degrees
  /// @return meters in spherical mercator projection
  static double latitudeToMeters(double north_latitude, double south_latitude) {
    return latitudeToMetersY(north_latitude) - latitudeToMetersY(south_latitude);
  }

  /// Converts given lat/lon in WGS84 Datum to XY in Spherical Mercator
  /// EPSG:900913
  ///
  /// @param lat
  /// @param lon
  /// @return
  static List<double> latLonToMeters(double lat, double lon) {
    double mx = lon * originShift / 180.0;
    double my = log(tan((90 + lat) * pi / 360.0)) / (pi / 180.0);
    my = my * originShift / 180.0;
    return [mx, my];
  }

  /// Converts pixel coordinates in given zoom level of pyramid to EPSG:900913
  ///
  /// @param px       pixel x.
  /// @param py       pixel y.
  /// @param zoom     zoomlevel.
  /// @param tileSize tile size.
  /// @return converted coordinate.
  static List<double> pixelsToMeters(double px, double py, int zoom, int tileSize) {
    double res = getResolution(zoom, tileSize);
    double mx = px * res - originShift;
    double my = py * res - originShift;
    return [mx, my];
  }

  ///
  /// @param px
  /// @param py
  /// @return
  static List<int> pixelsToTile(int px, int py, int tileSize) {
    int tx = (px / tileSize - 1).ceil();
    int ty = (py / tileSize - 1).ceil();
    return [tx, ty];
  }

  /// Converts EPSG:900913 to pyramid pixel coordinates in given zoom level
  ///
  /// @param mx
  /// @param my
  /// @param zoom
  /// @return
  static List<int> metersToPixels(double mx, double my, int zoom, int tileSize) {
    double res = getResolution(zoom, tileSize);
    int px = ((mx + originShift) / res).round();
    int py = ((my + originShift) / res).round();
    return [px, py];
  }

  /// Returns tile for given mercator coordinates
  ///
  /// @return
  static List<int> metersToTile(double mx, double my, int zoom, int tileSize) {
    List<int> p = metersToPixels(mx, my, zoom, tileSize);
    return pixelsToTile(p[0], p[1], tileSize);
  }

  /// Resolution (meters/pixel) for given zoom level (measured at Equator)
  ///
  /// @param zoom     zoomlevel.
  /// @param tileSize tile size.
  /// @return resolution.
  static double getResolution(int zoom, int tileSize) {
    // return (2 * Math.PI * 6378137) / (this.tileSize * 2**zoom)
    double initialResolution = 2 * pi * 6378137 / tileSize;
    return initialResolution / pow(2, zoom);
  }

  /// Convert meters to feet.
  ///
  /// @param meters the value in meters to convert to feet.
  /// @return meters converted to feet.
  static double toFeet(final double meters) {
    return meters * METER_TO_FEET_CONVERSION_FACTOR;
  }

  static double degToRadian(final double deg) => deg * (pi / 180.0);

  static double radianToDeg(final double rad) => rad * (180.0 / pi);
}
