/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image/image.dart' as IMG;
import 'package:latlong/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4dart;
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/filemanagement.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/projection.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';

class WorldImageSource extends RasterLayerSource {
  String _absolutePath;
  String _name;
  double opacityPercentage = 100;
  bool isVisible = true;
  LatLngBounds _imageBounds = LatLngBounds();
  bool loaded = false;
  MemoryImage _memoryImage;

  WorldImageSource.fromMap(Map<String, dynamic> map) {
    String relativePath = map[LAYERSKEY_FILE];
    _name = FileUtilities.nameFromFile(relativePath, false);
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map[LAYERSKEY_ISVISIBLE];

    opacityPercentage = map[LAYERSKEY_OPACITY] ?? 100;
  }

  WorldImageSource(this._absolutePath);

  static String getWorldFile(String imagePath) {
    String folder = FileUtilities.parentFolderFromFile(imagePath);
    var name = FileUtilities.nameFromFile(imagePath, false);
    var ext = FileUtilities.getExtension(imagePath);
    var wldExt;
    if (ext == FileManager.JPG_EXT) {
      wldExt = FileManager.JPG_WLD_EXT;
    } else if (ext == FileManager.PNG_EXT) {
      wldExt = FileManager.PNG_WLD_EXT;
    } else if (ext == FileManager.TIF_EXT) {
      wldExt = FileManager.TIF_WLD_EXT;
    } else {
      return null;
    }

    var wldPath = FileUtilities.joinPaths(folder, name + "." + wldExt);
    var wldFile = File(wldPath);
    if (wldFile.existsSync()) {
      return wldPath;
    }
    return null;
  }

  Future<void> load(BuildContext context) async {
    if (!loaded) {
      // print("LOAD WORLD FILE");
      _name = FileUtilities.nameFromFile(_absolutePath, false);
      File imageFile = new File(_absolutePath);

      var ext = FileUtilities.getExtension(_absolutePath);
      IMG.Image _decodedImage;
      var bytes = imageFile.readAsBytesSync();
      if (ext == FileManager.JPG_EXT) {
        _decodedImage = IMG.decodeJpg(bytes);
        _memoryImage = MemoryImage(bytes);
      } else if (ext == FileManager.PNG_EXT) {
        _decodedImage = IMG.decodePng(bytes);
        _memoryImage = MemoryImage(bytes);
      } else if (ext == FileManager.TIF_EXT) {
        _decodedImage = IMG.decodeTiff(bytes);
        _memoryImage = MemoryImage(IMG.encodeJpg(_decodedImage));
      }

      var width = _decodedImage.width;
      var height = _decodedImage.height;

      var worldFile = getWorldFile(_absolutePath);
      var tfwList = FileUtilities.readFileToList(worldFile);
      var xRes = double.parse(tfwList[0]);
      var yRes = -double.parse(tfwList[3]);
      var xExtent = width * xRes;
      var yExtent = height * yRes;

      var west = double.parse(tfwList[4]) - xRes / 2.0;
      var north = double.parse(tfwList[5]) + yRes / 2.0;
      var east = west + xExtent;
      var south = north - yExtent;

      var originPrj = SmashPrj.fromImageFile(_absolutePath);

      var ll = proj4dart.Point(x: west, y: south);
      var ur = proj4dart.Point(x: east, y: north);
      var llDest = SmashPrj.transformToWgs84(originPrj, ll);
      var urDest = SmashPrj.transformToWgs84(originPrj, ur);

      _imageBounds = LatLngBounds(
        LatLng(llDest.y, llDest.x),
        LatLng(urDest.y, urDest.x),
      );

      loaded = true;
    }
  }

  bool hasData() {
    return true;
  }

  String getAbsolutePath() {
    return _absolutePath;
  }

  String getUrl() {
    return null;
  }

  String getName() {
    return _name;
  }

  String getAttribution() {
    return "";
  }

  bool isActive() {
    return isVisible;
  }

  void setActive(bool active) {
    isVisible = active;
  }

  String toJson() {
    var relativePath = Workspace.makeRelative(_absolutePath);
    var json = '''
    {
        "$LAYERSKEY_LABEL": "$_name",
        "$LAYERSKEY_FILE":"$relativePath",
        "$LAYERSKEY_ISVISIBLE": $isVisible,
        "$LAYERSKEY_OPACITY": $opacityPercentage
    }
    ''';
    return json;
  }

  @override
  Future<List<LayerOptions>> toLayers(BuildContext context) async {
    await load(context);

    List<LayerOptions> layers = [
      OverlayImageLayerOptions(overlayImages: [
        OverlayImage(
            gaplessPlayback: true,
            imageProvider: _memoryImage,
            bounds: _imageBounds,
            opacity: opacityPercentage / 100.0),
      ]),
    ];

    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() {
    return Future.value(_imageBounds);
  }

  @override
  void disposeSource() {
    _absolutePath = null;
    _name = null;

    _imageBounds = LatLngBounds();
    loaded = false;
    _memoryImage = null;
  }
}

/// The tiff properties page.
class TiffPropertiesWidget extends StatefulWidget {
  WorldImageSource _source;
  TiffPropertiesWidget(this._source);

  @override
  State<StatefulWidget> createState() {
    return TiffPropertiesWidgetState(_source);
  }
}

class TiffPropertiesWidgetState extends State<TiffPropertiesWidget> {
  WorldImageSource _source;
  double _opacitySliderValue = 100;
  bool _somethingChanged = false;

  TiffPropertiesWidgetState(this._source);

  @override
  void initState() {
    _opacitySliderValue = _source.opacityPercentage;
    if (_opacitySliderValue > 100) {
      _opacitySliderValue = 100;
    }
    if (_opacitySliderValue < 100) {
      _opacitySliderValue = 100;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _source.opacityPercentage = _opacitySliderValue;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tiff Properties"),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    elevation: SmashUI.DEFAULT_ELEVATION,
                    shape: SmashUI.defaultShapeBorder(),
                    child: Column(
                      children: <Widget>[
                        SmashUI.titleText("Opacity"),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Slider(
                                  activeColor: SmashColors.mainSelection,
                                  min: 0.0,
                                  max: 100,
                                  divisions: 10,
                                  onChanged: (newRating) {
                                    _somethingChanged = true;
                                    setState(
                                        () => _opacitySliderValue = newRating);
                                  },
                                  value: _opacitySliderValue,
                                )),
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: SmashUI.normalText(
                                '${_opacitySliderValue.toInt()}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
