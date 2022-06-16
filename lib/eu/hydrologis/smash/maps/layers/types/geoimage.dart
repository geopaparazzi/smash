/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide Projection;
import 'package:geoimage/geoimage.dart';
import 'package:image/image.dart' as IMG;
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proj4dart/proj4dart.dart' as proj4dart;
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/util/experimentals.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class GeoImageSource extends RasterLayerSource {
  String? _absolutePath;
  String? _name;
  double opacityPercentage = 100;
  bool isVisible = true;
  LatLngBounds? _imageBounds;

  MyMemoryImage? _memoryImage;
  late int _srid;
  List<int>? rgbToHide;

  GeoImageSource.fromMap(Map<String, dynamic> map) {
    String relativePath = map[LAYERSKEY_FILE];
    _name = FileUtilities.nameFromFile(relativePath, false);
    _absolutePath = Workspace.makeAbsolute(relativePath);

    _srid = map[LAYERSKEY_SRID];
    isVisible = map[LAYERSKEY_ISVISIBLE];

    opacityPercentage = (map[LAYERSKEY_OPACITY] ?? 100).toDouble();

    var c2hide = map[LAYERSKEY_COLORTOHIDE];
    if (c2hide != null) {
      var split = c2hide.split(",");
      this.rgbToHide = [
        int.parse(split[0]),
        int.parse(split[1]),
        int.parse(split[2]),
      ];
    }
  }

  GeoImageSource(this._absolutePath) {
    _name = FileUtilities.nameFromFile(_absolutePath!, false);
  }

  Future<void> load(BuildContext? context) async {
    if (!isLoaded) {
      // print("LOAD WORLD FILE");
      _name = FileUtilities.nameFromFile(_absolutePath!, false);

      // GeoImage geoImage = GeoImage(File(_absolutePath));
      // geoImage.read();

      // var geoInfo = geoImage.geoInfo;

      // var fromPrj = SmashPrj.fromDataFile(_absolutePath);
      // if (fromPrj != null) {
      //   var srid = SmashPrj.getSrid(fromPrj);
      //   if (srid == null) {
      //     srid = SmashPrj.getSridFromDataFile(_absolutePath);
      //   }
      //   if (srid == null) {
      //     _srid = await SmashPrj.getSridFromMatchingInPreferences(fromPrj);
      //   } else {
      //     _srid = srid;
      //   }
      // }

      Map<String, dynamic> params = {
        "path": _absolutePath,
      };
      if (rgbToHide != null) {
        params['r'] = rgbToHide![0];
        params['g'] = rgbToHide![1];
        params['b'] = rgbToHide![2];
      }
      var res = await compute(getImage, params);
      _memoryImage = res[0];
      GeoInfo geoInfo = res[1];
      if (geoInfo.srid != -1) {
        _srid = geoInfo.srid;
      } else if (geoInfo.prjWkt != null) {
        _srid = SmashPrj.getSridFromWkt(geoInfo.prjWkt!)!;
      }
      var fromPrj = SmashPrj.fromSrid(_srid);

      // var worldFile = getWorldFile(_absolutePath);
      // var tfwList = FileUtilities.readFileToList(worldFile);
      // var xRes = double.parse(tfwList[0]);
      // var yRes = -double.parse(tfwList[3]);
      // var xExtent = width * xRes;
      // var yExtent = height * yRes;

      // var west = double.parse(tfwList[4]) - xRes / 2.0;
      // var north = double.parse(tfwList[5]) + yRes / 2.0;
      // var east = west + xExtent;
      // var south = north - yExtent;
      if (fromPrj == null) {
        isLoaded = false;
        return;
      }

      var wEnv = geoInfo.worldEnvelope;
      var ll = proj4dart.Point(x: wEnv.getMinX(), y: wEnv.getMinY());
      var ur = proj4dart.Point(x: wEnv.getMaxX(), y: wEnv.getMaxY());
      var llDest = SmashPrj.transformToWgs84(fromPrj, ll);
      var urDest = SmashPrj.transformToWgs84(fromPrj, ur);

      _imageBounds = LatLngBounds(
        LatLng(llDest.y, llDest.x),
        LatLng(urDest.y, urDest.x),
      );

      isLoaded = true;
    }
  }

  static List<dynamic> getImage(var map) {
    var path = map['path'];
    var r = map['r'];
    var g = map['g'];
    var b = map['b'];
    List<int?> rgb = [r, g, b];
    File imageFile = new File(path);

    GeoImage geoImage = GeoImage(imageFile);
    geoImage.read();

    var geoInfo = geoImage.geoInfo;

    IMG.Image _decodedImage = geoImage.image!;

    var ext = FileUtilities.getExtension(path);
    List<int>? bytes = geoImage.imageBytes;
    // IMG.Image _decodedImage = IMG.decodeImage(bytes);
    bool changed = false;
    if (EXPERIMENTAL_HIDE_COLOR_RASTER__ENABLED && r != null) {
      ImageUtilities.colorToAlphaImg(_decodedImage, r, g, b);
      changed = true;
    }

    var _memoryImage;
    if (ext == FileManager.JPG_EXT) {
      if (changed) {
        bytes = IMG.encodeJpg(_decodedImage);
      }
      _memoryImage = MyMemoryImage(bytes as Uint8List, rgb);
    } else if (ext == FileManager.PNG_EXT) {
      if (changed) {
        bytes = IMG.encodePng(_decodedImage);
      }
      _memoryImage = MyMemoryImage(bytes as Uint8List, rgb);
    } else if (GeoimageUtils.isTiff(path)) {
      // if (changed) {
      bytes = IMG.encodeJpg(_decodedImage, quality: 90);
      // }
      _memoryImage = MyMemoryImage(bytes as Uint8List, rgb);
    }
    return [_memoryImage, geoInfo];
  }

  bool hasData() {
    return true;
  }

  String? getAbsolutePath() {
    return _absolutePath;
  }

  String? getUrl() {
    return null;
  }

  IconData getIcon() => SmashIcons.iconTypeRaster;

  String? getUser() => null;

  String? getPassword() => null;

  String? getName() {
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
    var relativePath = Workspace.makeRelative(_absolutePath!);
    var json = '''
    {
        "$LAYERSKEY_LABEL": "$_name",
        "$LAYERSKEY_FILE":"$relativePath",
        "$LAYERSKEY_ISVISIBLE": $isVisible,
        "$LAYERSKEY_SRID": $_srid,
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
            imageProvider: _memoryImage!,
            bounds: _imageBounds!,
            opacity: opacityPercentage / 100.0),
      ]),
    ];

    return layers;
  }

  @override
  Future<LatLngBounds> getBounds() async {
    if (_imageBounds == null) {
      await load(null);
    }
    return _imageBounds!;
  }

  @override
  void disposeSource() {
    _absolutePath = null;
    _name = null;

    _imageBounds = LatLngBounds();
    isLoaded = false;
    _memoryImage = null;
  }

  @override
  bool hasProperties() {
    return true;
  }

  Widget getPropertiesWidget() {
    return TiffPropertiesWidget(this);
  }

  @override
  bool isZoomable() {
    return true;
  }

  @override
  int getSrid() {
    return _srid;
  }
}

/// The tiff properties page.
class TiffPropertiesWidget extends StatefulWidget {
  final GeoImageSource _source;
  TiffPropertiesWidget(this._source);

  @override
  State<StatefulWidget> createState() {
    return TiffPropertiesWidgetState(_source);
  }
}

class TiffPropertiesWidgetState extends State<TiffPropertiesWidget> {
  GeoImageSource _source;
  double _opacitySliderValue = 100;
  Color _hideColor = Colors.white;
  bool _somethingChanged = false;
  bool useHideColor = false;

  TiffPropertiesWidgetState(this._source);

  @override
  void initState() {
    _opacitySliderValue = _source.opacityPercentage;
    if (_opacitySliderValue > 100) {
      _opacitySliderValue = 100;
    }
    if (_opacitySliderValue < 0) {
      _opacitySliderValue = 0;
    }

    var rgbToHide = _source.rgbToHide;
    if (rgbToHide != null) {
      useHideColor = true;
      _hideColor =
          Color.fromARGB(255, rgbToHide[0], rgbToHide[1], rgbToHide[2]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_somethingChanged) {
            _source.opacityPercentage = _opacitySliderValue;
            if (useHideColor) {
              _source.rgbToHide = [
                _hideColor.red,
                _hideColor.green,
                _hideColor.blue
              ];
            } else {
              _source.rgbToHide = null;
            }
            _source.isLoaded = false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                SL.of(context).geoImage_tiffProperties), //"Tiff Properties"
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: SmashUI.defaultPadding(),
                child: Card(
                  shape: SmashUI.defaultShapeBorder(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(MdiIcons.opacity),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child:
                              Text(SL.of(context).geoImage_opacity), //"Opacity"
                        ),
                        subtitle: Row(
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
                      ),
                    ],
                  ),
                ),
              ),
              if (EXPERIMENTAL_HIDE_COLOR_RASTER__ENABLED)
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: Card(
                    shape: SmashUI.defaultShapeBorder(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(MdiIcons.eyedropperVariant),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(SL
                                .of(context)
                                .geoImage_colorToHide), //"Color to hide"
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: SmashUI.defaultPadding(),
                                  child:
                                      ColorPickerButton(_hideColor, (newColor) {
                                    _hideColor = ColorExt.fromColor(newColor);
                                    _somethingChanged = true;
                                  }),
                                ),
                              ),
                              Checkbox(
                                value: useHideColor,
                                onChanged: (value) {
                                  setState(() {
                                    useHideColor = value!;
                                    _somethingChanged = true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class MyMemoryImage extends ImageProvider<MyMemoryImage> {
  /// Creates an object that decodes a [Uint8List] buffer as an image.
  ///
  /// The arguments must not be null.
  const MyMemoryImage(this.bytes, this.rgbToHide) : assert(bytes != null);

  /// The bytes to decode into an image.
  final Uint8List? bytes;
  final List<int?> rgbToHide;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale = 1.0;

  @override
  Future<MyMemoryImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MyMemoryImage>(this);
  }

  @override
  ImageStreamCompleter load(MyMemoryImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: 'MyMemoryImage(${describeIdentity(key.bytes)})',
    );
  }

  Future<ui.Codec> _loadAsync(MyMemoryImage key, DecoderCallback decode) async {
    assert(key == this);

    return await PaintingBinding.instance.instantiateImageCodec(bytes!);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MyMemoryImage &&
        other.bytes == bytes &&
        other.scale == scale &&
        other.rgbToHide == rgbToHide;
  }

  @override
  int get hashCode {
    if (rgbToHide != null) {
      return hashValues(
          bytes.hashCode, scale, rgbToHide[0], rgbToHide[1], rgbToHide[2]);
    }
    return hashValues(bytes.hashCode, scale);
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MyMemoryImage')}(${describeIdentity(bytes)}, scale: $scale)';
}
