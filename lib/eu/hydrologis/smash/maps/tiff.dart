/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers.dart';
import 'package:proj4dart/proj4dart.dart' as proj4dart;
import 'package:image/image.dart' as IMG;

class TiffSource extends RasterLayerSource {
  String _absolutePath;
  String _name;
  double opacityPercentage = 100;
  bool isVisible = true;
  LatLngBounds _imageBounds = LatLngBounds();
  bool loaded = false;
  MemoryImage _memoryImage;

  TiffSource.fromMap(Map<String, dynamic> map) {
    String relativePath = map['file'];
    _name = FileUtilities.nameFromFile(relativePath, false);
    _absolutePath = Workspace.makeAbsolute(relativePath);
    isVisible = map['isvisible'];

    opacityPercentage = map['opacity'] ?? 100;
  }

  TiffSource(this._absolutePath);

  static String getWorldFile(String imagePath) {
    String folder = FileUtilities.parentFolderFromFile(imagePath);
    var name = FileUtilities.nameFromFile(imagePath, false);
    var tfwPath = FileUtilities.joinPaths(folder, name + ".tfw");
    var tfwFile = File(tfwPath);
    if (tfwFile.existsSync()) {
      return tfwPath;
    }
    return null;
  }

  static String getPrjFile(String imagePath) {
    String folder = FileUtilities.parentFolderFromFile(imagePath);
    var name = FileUtilities.nameFromFile(imagePath, false);
    var prjPath = FileUtilities.joinPaths(folder, name + ".prj");
    var prjFile = File(prjPath);
    if (prjFile.existsSync()) {
      return prjPath;
    }
    return null;
  }

  Future<void> load(BuildContext context) async {
    if (!loaded) {
      print("LOAD TIFF");
      _name = FileUtilities.nameFromFile(_absolutePath, false);
      File imageFile = new File(_absolutePath);
      var _decodedImage = IMG.decodeTiff(imageFile.readAsBytesSync());
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

      var prjFile = getPrjFile(_absolutePath);
      var wktPrj = FileUtilities.readFile(prjFile);

      var originPrj = proj4dart.Projection.parse(wktPrj);
      var destPrj = proj4dart.Projection.WGS84;

      var ll = proj4dart.Point(x: west, y: south);
      var ur = proj4dart.Point(x: east, y: north);
      var llDest = originPrj.transform(destPrj, ll);
      var urDest = originPrj.transform(destPrj, ur);

      _imageBounds = LatLngBounds(
        LatLng(llDest.y, llDest.x),
        LatLng(urDest.y, urDest.x),
      );

      var encodedPng = IMG.encodePng(_decodedImage);
      _memoryImage = MemoryImage(encodedPng);
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
        "label": "$_name",
        "file":"$relativePath",
        "isvisible": $isVisible,
        "opacity": $opacityPercentage
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
  TiffSource _source;
  Function _reloadLayersFunction;

  TiffPropertiesWidget(this._source, this._reloadLayersFunction);

  @override
  State<StatefulWidget> createState() {
    return TiffPropertiesWidgetState(_source);
  }
}

class TiffPropertiesWidgetState extends State<TiffPropertiesWidget> {
  TiffSource _source;
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
            widget._reloadLayersFunction();
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
