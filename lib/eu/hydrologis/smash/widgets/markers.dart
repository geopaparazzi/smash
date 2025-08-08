import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/images.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smash/eu/hydrologis/smash/util/urls.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:provider/provider.dart';

class ImageMarkerIcon extends StatelessWidget {
  final GeopaparazziProjectDb db;
  final dynamic image; // Type this properly!
  final double size;
  final double halfWidth;
  final bool sizeSnackBar;

  const ImageMarkerIcon({
    Key? key,
    required this.db,
    required this.image,
    required this.size,
    required this.halfWidth,
    required this.sizeSnackBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thumb = db.getThumbnail(image.imageDataId!);
    return GestureDetector(
      onTap: () {
        // Use `context` **here**, it's valid!
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: sizeSnackBar ? halfWidth : null,
            behavior: SnackBarBehavior.floating,
            backgroundColor: SmashColors.snackBarColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(0.4),
                      1: FlexColumnWidth(0.6),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableUtilities.cellForString(
                              SL.of(context).dataLoader_image), //"Image"
                          TableUtilities.cellForString(image.text),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableUtilities.cellForString(SL
                              .of(context)
                              .dataLoader_longitude), //"Longitude"
                          TableUtilities.cellForString(image.lon
                              .toStringAsFixed(
                                  SmashPreferencesKeys.KEY_LATLONG_DECIMALS)),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableUtilities.cellForString(
                              SL.of(context).dataLoader_latitude), //"Latitude"
                          TableUtilities.cellForString(image.lat
                              .toStringAsFixed(
                                  SmashPreferencesKeys.KEY_LATLONG_DECIMALS)),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableUtilities.cellForString(
                              SL.of(context).dataLoader_altitude), //"Altitude"
                          TableUtilities.cellForString(image.altim!
                              .toStringAsFixed(
                                  SmashPreferencesKeys.KEY_ELEV_DECIMALS)),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableUtilities.cellForString(SL
                              .of(context)
                              .dataLoader_timestamp), //"Timestamp"
                          TableUtilities.cellForString(TimeUtilities
                              .ISO8601_TS_FORMATTER
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  image.timeStamp))),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: SmashColors.mainDecorations)),
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        thumb!,
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SmashImageZoomWidget(image)));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: SmashColors.mainSelection,
                        ),
                        iconSize: SmashUI.MEDIUM_ICON_SIZE,
                        onPressed: () async {
                          var label =
                              "image: ${image.text}\nlat: ${image.lat.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)}\nlon: ${image.lon.toStringAsFixed(SmashPreferencesKeys.KEY_LATLONG_DECIMALS)}\naltim: ${image.altim!.round()}\nts: ${TimeUtilities.ISO8601_TS_FORMATTER.format(DateTime.fromMillisecondsSinceEpoch(image.timeStamp))}";
                          var urlStr = UrlUtilities.osmUrlFromLatLong(
                              image.lat, image.lon,
                              withMarker: true);
                          label = "$label\n$urlStr";
                          var uint8list =
                              db.getImageDataBytes(image.imageDataId!);
                          await ShareHandler.shareImage(label, uint8list);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: SmashColors.mainSelection,
                        ),
                        iconSize: SmashUI.MEDIUM_ICON_SIZE,
                        onPressed: () async {
                          var doRemove = await SmashDialogs.showConfirmDialog(
                              context,
                              SL
                                  .of(context)
                                  .dataLoader_removeImage, //"Remove Image",
                              "${SL.of(context).dataLoader_areYouSureRemoveImage} " //Are you sure you want to remove image
                              "${image.id}?");
                          if (doRemove!) {
                            db.deleteImage(image.id!);
                            var projectState = Provider.of<ProjectState>(
                                context,
                                listen: false);
                            projectState
                                .reloadProject(context); // TODO check await
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                      Spacer(flex: 1),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: SmashColors.mainDecorationsDarker,
                        ),
                        iconSize: SmashUI.MEDIUM_ICON_SIZE,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            duration: Duration(seconds: 5),
          ),
        );
      },
      child: Icon(
        getSmashIcon('camera'),
        size: size,
        color: SmashColors.mainDecorationsDarker,
      ),
    );
  }
}
