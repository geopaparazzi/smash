/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dart_jts/dart_jts.dart';
import 'package:image/image.dart' as IMG;
import 'package:logger/logger.dart';

/// A simple websocket service client class
///
// abstract class HyServerSocketService {
//   Logger log = Logger();
//   bool _isConnected = false;

//   WebSocket webSocket;
//   String _host;
//   String _port;

//   /// Create the object ad connect using [_host] and [_port].
//   /// If _host is not set, the ipaddress of the device is guessed.
//   HyServerSocketService(this._port, [this._host]) {
//     assert(_port != null);

//     checkConnection();
//   }

//   void checkConnection() {
//     if (!_isConnected) {
//       log.i("Connecting to socket service.");
//       connect();
//       log.i("Connected to socket service: $_isConnected");
//     }
//   }

//   Future<void> connect() async {
//     if (_host == null) {
//       _host = await NetworkUtilities.getFirstIpAddress();
//     }
//     webSocket = await WebSocket.connect('ws://$_host:$_port');
//     webSocket.listen((data) {
//       onMessage(data);
//     });
//   }

//   Future<void> onMessage(data);
// }

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

  /// <p>Code copied from: http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Lon..2Flat._to_tile_numbers </p>
  /// 20131128: corrections added to correct going over or under max/min extent
  /// - was causing http 400 Bad Requests
  /// - updated openstreetmap wiki
  ///
  /// @param zoom
  /// @return [\zoom, xtile, ytile_osm]
  static List<int> getTileNumber(
      final double lat, final double lon, final int zoom) {
    int xtile = ((lon + 180) / 360 * (1 << zoom)).floor();
    int ytile_osm =
        ((1 - log(tan(degToRadian(lat)) + 1 / cos(degToRadian(lat))) / pi) /
                2 *
                (1 << zoom))
            .floor();
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
  static double longitudeToMeters(
      double east_longitude, double west_longitude) {
    return longitudeToMetersX(east_longitude) -
        longitudeToMetersX(west_longitude);
  }

  /// Convert a north-latitude,south-latitude coordinate (in degrees) to distance in meters
  ///
  /// @param north_latitude latitude in degrees
  /// @param south_latitude latitude in degrees
  /// @return meters in spherical mercator projection
  static double latitudeToMeters(double north_latitude, double south_latitude) {
    return latitudeToMetersY(north_latitude) -
        latitudeToMetersY(south_latitude);
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
  static List<double> pixelsToMeters(
      double px, double py, int zoom, int tileSize) {
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
  static List<int> metersToPixels(
      double mx, double my, int zoom, int tileSize) {
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

  static Coordinate convert3857To4326(Coordinate coordinate3857) {
    List<double> latLon = metersToLatLon(coordinate3857.x, coordinate3857.y);
    return new Coordinate(latLon[1], latLon[0]);
  }

  static Coordinate convert4326To3857(Coordinate coordinate4326) {
    List<double> xy = latLonToMeters(coordinate4326.y, coordinate4326.x);
    return new Coordinate(xy[0], xy[1]);
  }

  static Envelope convert3857To4326Env(Envelope envelope3857) {
    Coordinate ll3857 =
        new Coordinate(envelope3857.getMinX(), envelope3857.getMinY());
    Coordinate ur3857 =
        new Coordinate(envelope3857.getMaxX(), envelope3857.getMaxY());

    Coordinate ll4326 = convert3857To4326(ll3857);
    Coordinate ur4326 = convert3857To4326(ur3857);

    Envelope env4326 = new Envelope.fromCoordinates(ll4326, ur4326);
    return env4326;
  }

  static Envelope convert4326To3857Env(Envelope envelope4326) {
    Coordinate ll4326 =
        new Coordinate(envelope4326.getMinX(), envelope4326.getMinY());
    Coordinate ur4326 =
        new Coordinate(envelope4326.getMaxX(), envelope4326.getMaxY());

    Coordinate ll3857 = convert4326To3857(ll4326);
    Coordinate ur3857 = convert4326To3857(ur4326);

    Envelope env3857 = new Envelope.fromCoordinates(ll3857, ur3857);
    return env3857;
  }

  static List<int> getTileNumberFrom3857Coord(Coordinate coord3857, int zoom) {
    Coordinate coord4326 = convert3857To4326(coord3857);
    return getTileNumber(coord4326.y, coord4326.x, zoom);
  }

  static List<int> getTileNumberFrom4326Coord(Coordinate coord4326, int zoom) {
    return getTileNumber(coord4326.y, coord4326.x, zoom);
  }

  /**
   * Returns bounds of the given tile in EPSG:4326 coordinates
   *
   * @param tx       tile x.
   * @param ty       tile y.
   * @param zoom     zoomlevel.
   * @return the Envelope.
   */
  static Envelope tileBounds4326(final int x, final int y, final int zoom) {
    double north = tile2lat(y, zoom);
    double south = tile2lat(y + 1, zoom);
    double west = tile2lon(x, zoom);
    double east = tile2lon(x + 1, zoom);
    Envelope envelope = new Envelope(west, east, south, north);
    return envelope;
  }

  /// Returns bounds of the given tile in EPSG:3857 coordinates
  ///
  /// @param tx       tile x.
  /// @param ty       tile y.
  /// @param zoom     zoomlevel.
  /// @return the Envelope.
  static Envelope tileBounds3857(final int x, final int y, final int zoom) {
    Envelope env4326 = tileBounds4326(x, y, zoom);
    Coordinate ll4326 = new Coordinate(env4326.getMinX(), env4326.getMinY());
    Coordinate ur4326 = new Coordinate(env4326.getMaxX(), env4326.getMaxY());

    Coordinate ll3857transf = MercatorUtils.convert4326To3857(ll4326);
    Coordinate ur3857transf = MercatorUtils.convert4326To3857(ur4326);

    return new Envelope.fromCoordinates(ll3857transf, ur3857transf);
  }

  /// Get the tiles that fit into a given tile at lower zoomlevel.
  ///
  /// @param origTx the original tile x.
  /// @param origTy the original tile y.
  /// @param origZoom the original tile zoom.
  /// @param higherZoom the requested zoom.
  /// @param tileSize the used tile size.
  /// @return the ordered list of tiles.
  static List<List<int>> getTilesAtHigherZoom(
      int origTx, int origTy, int origZoom, int higherZoom, int tileSize) {
    Envelope boundsLL = tileBounds4326(origTx, origTy, origZoom);

    int delta = higherZoom - origZoom;
    int splits = pow(2, delta).toInt();

    double intervalX = boundsLL.getWidth() / splits;
    double intervalY = boundsLL.getHeight() / splits;

    List<List<int>> tilesList = [];
    for (double y = boundsLL.getMaxY() - intervalY / 2.0;
        y > boundsLL.getMinY();
        y = y - intervalY) {
      for (double x = boundsLL.getMinX() + intervalX / 2.0;
          x < boundsLL.getMaxX();
          x = x + intervalX) {
        List<int> tileNumber = getTileNumber(y, x, higherZoom);
        tilesList.add(tileNumber);
      }
    }
    return tilesList;
  }

  static double tile2lon(int x, int z) {
    return x / pow(2.0, z) * 360.0 - 180.0;
  }

  static double tile2lat(int y, int z) {
    double n = pi - (2.0 * pi * y) / pow(2.0, z);
    return radianToDeg(atan(sinh(n)));
  }
}


