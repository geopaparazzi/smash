/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:typed_data';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:sqflite/sqflite.dart';

abstract class QueryObjectBuilder<T> {
  String querySql();

  String insertSql();

  Map<String, dynamic> toMap(T item);

  T fromMap(Map<String, dynamic> map);
}

class SqliteDb {
  Database _db;
  String _dbPath;

  SqliteDb(this._dbPath);

  Future<void> openOrCreate({Function dbCreateFunction}) async {
    _db = await openDatabase(
      _dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        if (dbCreateFunction != null) {
          await dbCreateFunction(db);
        }
      },
    );
  }

  String get path => _dbPath;

  bool isOpen() {
    if (_db == null) return false;
    return _db.isOpen;
  }

  Future<void> close() async {
    return await _db.close();
  }

  /// Get a list of items defined by the [queryObj].
  ///
  /// Optionally a custom [whereString] piece can be passed in. This needs to start with the word where.
  Future<List<T>> getQueryObjectsList<T>(QueryObjectBuilder<T> queryObj,
      {whereString: ""}) async {
    String querySql = "${queryObj.querySql()} $whereString";
    var res = await query(querySql);
    List<T> items = [];
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      var obj = queryObj.fromMap(map);
      items.add(obj);
    }
    return items;
  }

  Future<void> execute(String insertSql, [List<dynamic> arguments]) async {
    return _db.execute(insertSql, arguments);
  }

  Future<List<Map<String, dynamic>>> query(String querySql,
      [List<dynamic> arguments]) async {
    return _db.rawQuery(querySql, arguments);
  }

  Future<int> insert(String insertSql, [List<dynamic> arguments]) async {
    return _db.rawInsert(insertSql, arguments);
  }

  Future<int> insertMap(String table, Map<String, dynamic> values) async {
    return _db.insert(table, values);
  }

  Future<int> update(String updateSql) async {
    return _db.rawUpdate(updateSql);
  }

  Future<int> updateMap(
      String table, Map<String, dynamic> values, String where) async {
    return _db.update(table, values, where: where);
  }

  Future<int> delete(String deleteSql) async {
    return _db.rawDelete(deleteSql);
  }

  Future<T> transaction<T>(Future<T> action(Transaction txn),
      {bool exclusive}) async {
    return await _db.transaction(action, exclusive: exclusive);
  }

  Future<List<String>> getTables(bool doOrder) async {
    List<String> tableNames = [];
    String orderBy = " ORDER BY name";
    if (!doOrder) {
      orderBy = "";
    }
    String sql =
        "SELECT name FROM sqlite_master WHERE type='table' or type='view'" +
            orderBy;
    var res = await query(sql);
    for (int i = 0; i < res.length; i++) {
      var name = res[i]['name'];
      tableNames.add(name);
    }
    return tableNames;
  }

  Future<bool> hasTable(String tableName) async {
    String sql = "SELECT name FROM sqlite_master WHERE type='table'";
    var res = await query(sql);
    tableName = tableName.toLowerCase();
    for (int i = 0; i < res.length; i++) {
      String name = res[i]['name'];
      if (name.toLowerCase() == tableName) return true;
    }
    return false;
  }

  /// Get the table columns from a non spatial db.
  ///
  /// @param db the db.
  /// @param tableName the name of the table to get the columns for.
  /// @return the list of table column information.
  /// @throws Exception
  Future<List<List<dynamic>>> getTableColumns(String tableName) async {
    String sql = "PRAGMA table_info(" + tableName + ")";
    List<List<dynamic>> columnsList = [];
    var res = await query(sql);
    for (int i = 0; i < res.length; i++) {
      var map = res[i];
      String colName = map['name'];
      String colType = map['type'];
      int isPk = map['pk'];
      columnsList.add([colName, colType, isPk]);
    }
    return columnsList;
  }
}

/// An mbtiles wrapper class to read and write mbtiles databases.
class MBTilesDb {
  /// We have a fixed tile size.
  static const TILESIZE = 256;

  // TABLE tiles (zoom_level INTEGER, tile_column INTEGER, tile_row INTEGER, tile_data BLOB);
  static const TABLE_TILES = "tiles";
  static const COL_TILES_ZOOM_LEVEL = "zoom_level";
  static const COL_TILES_TILE_COLUMN = "tile_column";
  static const COL_TILES_TILE_ROW = "tile_row";
  static const COL_TILES_TILE_DATA = "tile_data";

  static const SELECTQUERY =
      "SELECT $COL_TILES_TILE_DATA from $TABLE_TILES where $COL_TILES_ZOOM_LEVEL=? AND $COL_TILES_TILE_COLUMN=? AND $COL_TILES_TILE_ROW=?";

  // TABLE METADATA (name TEXT, value TEXT);
  static const TABLE_METADATA = "metadata";
  static const COL_METADATA_NAME = "name";
  static const COL_METADATA_VALUE = "value";

  static const SELECT_METADATA =
      "select $COL_METADATA_NAME, $COL_METADATA_VALUE from $TABLE_METADATA";

  // INDEXES on Metadata and Tiles tables
  static const INDEX_TILES =
      "CREATE UNIQUE INDEX tile_index ON $TABLE_TILES ($COL_TILES_ZOOM_LEVEL, $COL_TILES_TILE_COLUMN, $COL_TILES_TILE_ROW)";
  static const INDEX_METADATA =
      "CREATE UNIQUE INDEX name ON $TABLE_METADATA ($COL_METADATA_NAME)";

  static const insertTileSql =
      "INSERT INTO $TABLE_TILES ($COL_TILES_ZOOM_LEVEL, $COL_TILES_TILE_COLUMN, $COL_TILES_TILE_ROW, $COL_TILES_TILE_DATA) values (?,?,?,?)";
  static const CREATE_METADATA =
      "CREATE TABLE $TABLE_METADATA ($COL_METADATA_NAME TEXT, $COL_METADATA_VALUE TEXT)";
  static const CREATE_TILES =
      "CREATE TABLE $TABLE_TILES ($COL_TILES_ZOOM_LEVEL INTEGER, $COL_TILES_TILE_COLUMN INTEGER, $COL_TILES_TILE_ROW INTEGER, $COL_TILES_TILE_DATA BLOB)";

  SqliteDb database;
  String databasePath;

  Map<String, String> metadataMap;

  String tileRowType = "osm"; // could be tms in some cases

  /// Constructor based on an existing ADb object.
  ///
  /// @param database the [SqliteDb] database.
  MBTilesDb(String databasePath) {
    this.databasePath = databasePath;
  }

  Future<void> open() async {
    database = SqliteDb(databasePath);
    await database.openOrCreate(dbCreateFunction: (db) async {
      await db.execute(CREATE_TILES);
      await db.execute(CREATE_METADATA);
      await db.execute(INDEX_TILES);
      await db.execute(INDEX_METADATA);
    });
  }

  /// Set the row type.
  ///
  /// @param tileRowType can be "osm" (default) or "tms".
  void setTileRowType(String tileRowType) {
    this.tileRowType = tileRowType;
  }

  /// Populate the metadata table.
  ///
  /// @param n nord bound.
  /// @param s south bound.
  /// @param w west bound.
  /// @param e east bound.
  /// @param name name of the dataset.
  /// @param format format of the images. png or jpg.
  /// @param minZoom lowest zoomlevel.
  /// @param maxZoom highest zoomlevel.
  /// @throws Exception
  Future fillMetadata(double n, double s, double w, double e, String name,
      String format, int minZoom, int maxZoom) async {
    await database.delete("delete from $TABLE_METADATA");

    String query = toMetadataQuery("name", name);
    await database.execute(query);
    query = toMetadataQuery("description", name);
    await database.execute(query);
    query = toMetadataQuery("format", format);
    await database.execute(query);
    query = toMetadataQuery("minZoom", minZoom.toString());
    await database.execute(query);
    query = toMetadataQuery("maxZoom", maxZoom.toString());
    await database.execute(query);
    query = toMetadataQuery("type", "baselayer");
    await database.execute(query);
    query = toMetadataQuery("version", "1.1");
    await database.execute(query);
    // left, bottom, right, top
    query = toMetadataQuery("bounds", "$w,$s,$e,$n");
    await database.execute(query);
  }

  String toMetadataQuery(String key, String value) {
    return "INSERT INTO $TABLE_METADATA ($COL_METADATA_NAME, $COL_METADATA_VALUE) values ('$key', '$value')";
  }

  /// Add a single tile.
  ///
  /// @param x the x tile index.
  /// @param y the y tile index.
  /// @param z the zoom level.
  /// @return the tile image bytes.
  /// @throws Exception
  void addTile(int x, int y, int z, Uint8List imageBytes) async {
    await database.insert(insertTileSql, [z, x, y, imageBytes]);
  }

  ///**
// * Add a list of tiles in batch mode.
// *
// * @param tilesList the list of tiles.
// * @throws Exception
// */
//public synchronized void addTilesInBatch( List<Tile> tilesList ) throws Exception {
//database.execOnConnection(connection -> {
//boolean autoCommit = connection.getAutoCommit();
//connection.setAutoCommit(false);
//try (IHMPreparedStatement pstmt = connection.prepareStatement(insertTileSql);) {
//for( Tile tile : tilesList ) {
//pstmt.setInt(1, tile.z);
//pstmt.setInt(2, tile.x);
//pstmt.setInt(3, tile.y);
//pstmt.setBytes(4, tile.imageBytes);
//pstmt.addBatch();
//}
//pstmt.executeBatch();
//return "";
//} finally {
//connection.setAutoCommit(autoCommit);
//}
//});
//}
//

  /// Get a Tile's image bytes from the database.
  ///
  /// @param tx the x tile index.
  /// @param tyOsm the y tile index, the osm way.
  /// @param zoom the zoom level.
  /// @return the tile image bytes.
  /// @throws Exception
  Future<Uint8List> getTile(int tx, int tyOsm, int zoom) async {
    int ty = tyOsm;
    if (tileRowType == "tms") {
      var tmsTileXY = MercatorUtils.osmTile2TmsTile(tx, tyOsm, zoom);
      ty = tmsTileXY[1];
    }

    List<Map<String, dynamic>> result =
        await database.query(SELECTQUERY, [zoom, tx, ty]);
    if (result.length == 1) {
      return result[0][COL_TILES_TILE_DATA];
    }
    return null;
  }

  /// Get the db envelope.
  ///
  /// @return the array [w, e, s, n] of the dataset.
  Future<List<double>> getBounds() async {
    await checkMetadata();
    String boundsWSEN = metadataMap["bounds"];
    if (boundsWSEN == null) {
      return [-180, 180, -90, 90];
    }
    var split = boundsWSEN.split(",");
    double w = double.parse(split[0]);
    double s = double.parse(split[1]);
    double e = double.parse(split[2]);
    double n = double.parse(split[3]);
    return [w, e, s, n];
  }

  ///**
// * Get the bounds of a zoomlevel in tile indexes.
// *
// * <p>This comes handy when one wants to navigate all tiles of a zoomlevel.
// *
// * @param zoomlevel the zoom level.
// * @return the tile indexes as [minTx, maxTx, minTy, maxTy].
// * @throws Exception
// */
//public int[] getBoundsInTileIndex( int zoomlevel ) throws Exception {
//String sql = "select min(tile_column), max(tile_column), min(tile_row), max(tile_row) from tiles where zoom_level="
//    + zoomlevel;
//return database.execOnConnection(connection -> {
//try (IHMStatement statement = connection.createStatement(); IHMResultSet resultSet = statement.executeQuery(sql);) {
//if (resultSet.next()) {
//int minTx = resultSet.getInt(1);
//int maxTx = resultSet.getInt(2);
//int minTy = resultSet.getInt(3);
//int maxTy = resultSet.getInt(4);
//return new int[]{minTx, maxTx, minTy, maxTy};
//}
//}
//return null;
//});
//}
//
//public List<Integer> getAvailableZoomLevels() throws Exception {
//String sql = "select distinct zoom_level from tiles order by zoom_level";
//return database.execOnConnection(connection -> {
//List<Integer> zoomLevels = new ArrayList<>();
//try (IHMStatement statement = connection.createStatement(); IHMResultSet resultSet = statement.executeQuery(sql);) {
//while( resultSet.next() ) {
//int z = resultSet.getInt(1);
//zoomLevels.add(z);
//}
//}
//return zoomLevels;
//});
//}
//
  ///**
// * Get the image format of the db.
// *
// * @return the image format (jpg, png).
// * @throws Exception
// */
//public String getImageFormat() throws Exception {
//checkMetadata();
//return metadataMap.get("format");
//}
//
//public String getName() throws Exception {
//checkMetadata();
//return metadataMap.get("name");
//}
//public String getDescription() throws Exception {
//checkMetadata();
//return metadataMap.get("description");
//}
//
//public String getAttribution() throws Exception {
//checkMetadata();
//return metadataMap.get("attribution");
//}
//
//public String getVersion() throws Exception {
//checkMetadata();
//return metadataMap.get("version");
//}
//
//public int getMinZoom() throws Exception {
//checkMetadata();
//String minZoomStr = metadataMap.get("minzoom");
//if (minZoomStr != null) {
//return Integer.parseInt(minZoomStr);
//}
//return -1;
//}
//
//public int getMaxZoom() throws Exception {
//checkMetadata();
//String maxZoomStr = metadataMap.get("maxzoom");
//if (maxZoomStr != null) {
//return Integer.parseInt(maxZoomStr);
//}
//return -1;
//}
//
  Future checkMetadata() async {
    if (metadataMap == null) {
      metadataMap = Map();
      List<Map<String, String>> result = await database.query(SELECT_METADATA);
      result.forEach((map) {
        metadataMap[map[COL_METADATA_NAME].toLowerCase()] =
            map[COL_METADATA_VALUE];
      });
    }
  }

  void close() {
    if (database != null) {
      database.close();
    }
  }

  ///**
// * A simple tile utility class.
// */
//public static class Tile {
//  public int x;
//  public int y;
//  public int z;
//  public byte[] imageBytes;
//}

}
