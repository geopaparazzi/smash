/**
 * Class to support geo-url parsing and creating.
 *
 * @author Andrea Antonello
 */
class UrlUtilities {
  static final String OSM_MAPS_URL = "https://www.openstreetmap.org";
  static final String SHORT_OSM_MAPS_URL = "https://www.osm.org";

  /// Create an OSM url from coordinates.
  ///
  /// @param lat             lat
  /// @param lon             lon
  /// @param withMarker      if <code>true</code>, marker is added.
  /// @return url string.
  static String osmUrlFromLatLong(double lat, double lon,
      {bool withMarker = true}) {
    // https://www.osm.org/?mlat=45.79668&mlon=9.12342#map=18/45.79668/9.12342 -> with marker
    // https://www.osm.org/#map=18/45.79668/9.12275

    var markerPiece = withMarker ? '?mlat=$lat&mlon=$lon' : '';
    return "$SHORT_OSM_MAPS_URL/$markerPiece#map=18/$lat/$lon";
  }

  /// Gets the data from a osm url.
  ///
  /// @param urlString the url to parse.
  /// @return a SimplePosition. It needs to be checked for internal nulls (in case this failed)
  //  static SimplePosition getLatLonTextFromOsmUrl(String urlString) {
  //     // http://www.openstreetmap.org/?mlat=42.082&mlon=9.822#map=6/42.082/9.822&layers=N
  //     // http://www.osm.org/?mlat=45.79668&mlon=9.12342#map=18/45.79668/9.12342 -> with marker
  //     // http://www.osm.org/#map=18/45.79668/9.12275

  //     SimplePosition simplePosition = new SimplePosition();
  //     if (urlString == null) return simplePosition;

  //     if (urlString.startsWith(OSM_MAPS_URL) || urlString.startsWith(SHORT_OSM_MAPS_URL)) {
  //         String[] urlSplit = urlString.split("#|&|\\?");
  //         HashMap<String, String> paramsMap = new HashMap<String, String>();
  //         for (String string : urlSplit) {
  //             if (string.indexOf('=') != -1) {
  //                 String[] keyValue = string.split("=");
  //                 if (keyValue.length == 2) {
  //                     paramsMap.put(keyValue[0].toLowerCase(), keyValue[1]);
  //                 }
  //             }
  //         }

  //         // check if there is a dash for adding text
  //         String textStr = new Date().toString();
  //         int lastDashIndex = urlString.lastIndexOf('#');
  //         if (lastDashIndex != -1) {
  //             // everything after a dash is taken as text
  //             String tmpTextStr = urlString.substring(lastDashIndex + 1);
  //             if (!tmpTextStr.startsWith("map=")) {
  //                 textStr = tmpTextStr;
  //             }
  //         }

  //         String coordsStr = paramsMap.get("map");
  //         if (coordsStr != null) {
  //             String[] split = coordsStr.split("/");
  //             if (split.length == 3) {
  //                 try {
  //                     double lat = Double.parseDouble(split[1]);
  //                     double lon = Double.parseDouble(split[2]);
  //                     int zoom = (int) Double.parseDouble(split[0]);
  //                     simplePosition.latitude = lat;
  //                     simplePosition.longitude = lon;
  //                     simplePosition.text = textStr;
  //                     simplePosition.zoomLevel = zoom;
  //                 } catch (NumberFormatException e) {
  //                     // ingore this
  //                 }
  //             }
  //         }
  //     }
  //     return simplePosition;
  // }

}
