import 'package:rainbow_color/rainbow_color.dart';
import 'package:smash/eu/hydrologis/smash/widgets/log_list.dart';
import 'package:smashlibs/smashlibs.dart';

class LineColorUtility {
  static Rainbow getColorInterpolator(double min, double max) {
    return Rainbow(rangeStart: min, rangeEnd: max, spectrum: [
      ColorExt("#FFFF00"),
      ColorExt("#00FF00"),
      ColorExt("#00FFFF"),
      ColorExt("#0000FF"),
      ColorExt("#FF00FF"),
      ColorExt("#FF0000"),
    ]);
  }

  /// Checks if the log color also has information about the elevation coloring.
  ///
  /// Returns two values as [logColorString, doElevationColor] (string and bool).
  static List<dynamic> splitLogColor(Log4ListWidget logItem) {
    return splitLogColorString(logItem.color);
  }

  static List<dynamic> splitLogColorString(String colorObject) {
    if (colorObject.contains("@")) {
      var split = colorObject.split("@");

      bool doElev = split[1].toLowerCase() == 'elev';
      return [split[0], doElev];
    }

    return [colorObject, false];
  }

  /// Sets the log color properly,
  static Log4ListWidget setColor(Log4ListWidget toSet, String color,
      {bool doElev}) {
    String add = doElev != null && doElev ? "@elev" : "";
    toSet.color = color + add;
    return toSet;
  }
}
