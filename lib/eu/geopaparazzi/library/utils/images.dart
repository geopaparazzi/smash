/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';
import 'dart:typed_data';

//import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smash/eu/geopaparazzi/library/database/project_tables.dart';
import 'package:smash/eu/geopaparazzi/library/models/models.dart';
import 'package:smash/eu/geopaparazzi/library/utils/logging.dart';
import 'package:image/image.dart' as IMG;

class ImageUtilities {
  static Image imageFromBytes(Uint8List bytes) {
    Image img = Image.memory(bytes);
    return img;
  }

  static Uint8List bytesFromImageFile(String path) {
    File imgFile = File(path);
    return imgFile.readAsBytesSync();
  }

  static Uint8List resizeImage(Uint8List bytes, {int newWidth: 100}) {
    IMG.Image image = IMG.decodeImage(bytes);
    IMG.Image thumbnail = IMG.copyResize(
      image,
      width: newWidth,
    );
    var encodeJpg = IMG.encodeJpg(thumbnail);
    return encodeJpg;
  }

  /// Saves the image in file [path] into the db.
  ///
  /// [dbImageToCompleteAndSave] is passed in with the necessary spatial data
  /// (but missing imageDataId, which will be filled here.
  static Future<bool> saveImageToSmashDb(
      String path, DbImage dbImageToCompleteAndSave) async {
    var imageBytes = bytesFromImageFile(path);
    var thumbBytes = resizeImage(imageBytes, newWidth: 200);

    var db = await gpProjectModel.getDatabase();

    DbImageData imgData = DbImageData()
      ..thumb = thumbBytes
      ..data = imageBytes;

    return await db.transaction((tx) async {
      int imgDataId = await tx.insert(TABLE_IMAGE_DATA, imgData.toMap());
      dbImageToCompleteAndSave.imageDataId = imgDataId;
      int imgId =
          await tx.insert(TABLE_IMAGES, dbImageToCompleteAndSave.toMap());
      if (imgId == null) {
        GpLogger().e("Could not save image to db: $path");
        return false;
      }
      return true;
    });
  }
}
//
//class ImageZoomWidget extends StatelessWidget {
//  var _bytes;
//  var _title;
//
//  ImageZoomWidget(this._title, this._bytes);
//
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//        child: Column(children: <Widget>[
//      AppBar(
//        title: Text(_title),
//      ),
//      Expanded(
//        child: ExtendedImage.memory(
//          _bytes,
//          fit: BoxFit.contain,
//          //enableLoadState: false,
//          mode: ExtendedImageMode.Gesture,
//          initGestureConfigHandler: (state) {
//            return GestureConfig(
//                minScale: 0.9,
//                animationMinScale: 0.7,
//                maxScale: 5.0,
//                animationMaxScale: 5.5,
//                speed: 1.0,
//                inertialSpeed: 100.0,
//                initialScale: 1.0,
//                inPageView: false);
//          },
//        ),
//      )
//    ]));
//  }
//}
//
///// A widget to view, zoom and pan a smash image.
//class SmashImageZoomWidget extends StatelessWidget {
//  var _bytes;
//  var _title;
//  var _image;
//
//  SmashImageZoomWidget(this._image);
//
//  Future<Null> getImageData() async {
//    var db = await gpProjectModel.getDatabase();
//    _bytes = await db.getImageDataBytes(_image.id);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _title = _image.text;
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(_title),
//      ),
//      body: FutureBuilder<void>(
//        future: getImageData(),
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.done) {
//            // If the Future is complete, display the preview.
//            return OrientationBuilder(builder: (context, orientation) {
//              if (orientation == Orientation.portrait) {
//                return Center(
//                    child: Column(
//                        mainAxisSize: MainAxisSize.max,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                      Expanded(
//                        child: ExtendedImage.memory(
//                          _bytes,
//                          fit: BoxFit.contain,
//                          //enableLoadState: false,
//                          mode: ExtendedImageMode.Gesture,
//                          initGestureConfigHandler: (state) {
//                            return GestureConfig(
//                                minScale: 0.9,
//                                animationMinScale: 0.7,
//                                maxScale: 5.0,
//                                animationMaxScale: 5.5,
//                                speed: 1.0,
//                                inertialSpeed: 100.0,
//                                initialScale: 1.0,
//                                inPageView: false);
//                          },
//                        ),
//                      )
//                    ]));
//              } else {
//                return Center(
//                    child: Row(
//                        mainAxisSize: MainAxisSize.max,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                      Expanded(
//                        child: ExtendedImage.memory(
//                          _bytes,
//                          fit: BoxFit.contain,
//                          //enableLoadState: false,
//                          mode: ExtendedImageMode.Gesture,
//                          initGestureConfigHandler: (state) {
//                            return GestureConfig(
//                                minScale: 0.9,
//                                animationMinScale: 0.7,
//                                maxScale: 5.0,
//                                animationMaxScale: 5.5,
//                                speed: 1.0,
//                                inertialSpeed: 100.0,
//                                initialScale: 1.0,
//                                inPageView: false);
//                          },
//                        ),
//                      )
//                    ]));
//              }
//            });
//          } else {
//            // Otherwise, display a loading indicator.
//            return Center(child: CircularProgressIndicator());
//          }
//        },
//      ),
//    );
//  }
//}
