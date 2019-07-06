/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';

class ImageUtilities {
  static Image imageFromBytes(Uint8List bytes) {
    Image img = Image.memory(bytes);
    return img;
  }
}

class ImageZoomWidget extends StatelessWidget {
  var _bytes;
  var _title;

  ImageZoomWidget(this._title, this._bytes);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: <Widget>[
      AppBar(
        title: Text(_title),
      ),
      Expanded(
        child: ExtendedImage.memory(
          _bytes,
          fit: BoxFit.contain,
          //enableLoadState: false,
          mode: ExtendedImageMode.Gesture,
          gestureConfig: GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 5.0,
              animationMaxScale: 5.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false),
        ),
      )
    ]));
  }
}


/// A widget to view, zoom and pan a smash image.
class SmashImageZoomWidget extends StatelessWidget {
  var _bytes;
  var _title;
  var _image;

  SmashImageZoomWidget(this._image);

  Future<Null> getImageData() async {
    var db = await gpProjectModel.getDatabase();
    _bytes = await db.getImageDataBytes(_image.id);
  }

  @override
  Widget build(BuildContext context) {
    _title = _image.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder<void>(
        future: getImageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(children: <Widget>[
              Expanded(
                child: ExtendedImage.memory(
                  _bytes,
                  fit: BoxFit.contain,
                  //enableLoadState: false,
                  mode: ExtendedImageMode.Gesture,
                  gestureConfig: GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.7,
                      maxScale: 10.0,
                      animationMaxScale: 10.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false),
                ),
              )
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
