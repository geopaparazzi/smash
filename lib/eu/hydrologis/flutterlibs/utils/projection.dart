import 'package:proj4dart/proj4dart.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'dart:io';

class SmashPrj {
  static final Projection EPSG4326 = Projection.WGS84;
  static final Projection EPSG3857 = Projection('EPSG:3857');

  SmashPrj();

  static Projection fromWkt(String wkt) {
    if (wkt
        .replaceAll(" ", "")
        .toLowerCase()
        .contains("AUTHORITY[\"EPSG\",\"3857\"]")) {
      // this is a temporary fix due to a proj4dart issue
      return EPSG3857;
    }
    return Projection.parse(wkt);
  }

  static Point transform(Projection from, Projection to, Point point) {
    return from.transform(to, point);
  }
  static Point transformToWgs84(Projection from, Point point) {
    return from.transform(EPSG4326, point);
  }

  static Projection fromFile(String prjFilePath) {
    var prjFile = File(prjFilePath);
    if (prjFile.existsSync()) {
      var wktPrj = FileUtilities.readFile(prjFilePath);
      return fromWkt(wktPrj);
    }
    return null;
  }

  static Projection fromImageFile(String imageFilePath) {
    String prjPath = getPrjForImage(imageFilePath);
    return fromFile(prjPath);
  }

  static String getPrjForImage(String imageFilePath) {
    String folder = FileUtilities.parentFolderFromFile(imageFilePath);
    var name = FileUtilities.nameFromFile(imageFilePath, false);
    var prjPath = FileUtilities.joinPaths(folder, name + ".prj");
    return prjPath;
  }
}
