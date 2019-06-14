import 'dart:async';
import 'dart:io';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/geopaparazzi.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/geopaparazzi_models.dart';
import 'package:scoped_model/scoped_model.dart';

class GeopaparazziMapWidget extends StatefulWidget {
  GeopaparazziProjectModel _model;
  GeopaparazziMapWidget(this._model, {Key key}) : super(key: key);

  @override
  GeopaparazziMapWidgetState createState() => new GeopaparazziMapWidgetState();
}

class GeopaparazziMapWidgetState extends State<GeopaparazziMapWidget>
    with SingleTickerProviderStateMixin
    implements PositionListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MarkerLayerOptions _geopapMarker;
  PolylineLayerOptions _geopapLogs;
  TileLayerOptions _osmLayer;
  var _currentZoom = 7.0;
  Position _lastPosition;
  bool _isFirstLoad = true;

  MapController _mapController;

  void set geopapMarkers(MarkerLayerOptions geopapMarker) {
    _geopapMarker = geopapMarker;
  }

  void set geopapLogs(PolylineLayerOptions geopapLogs) {
    _geopapLogs = geopapLogs;
  }

  void showSnackBar(SnackBar bar) {
    _scaffoldKey.currentState.showSnackBar(bar);
  }

  @override
  void initState() {
    super.initState();
    GpsHandler().addPositionListener(this);
    _mapController = MapController();
    _osmLayer = new TileLayerOptions(
      urlTemplate: "https://{s}.tile.openstreetmap.org/"
          "{z}/{x}/{y}.png",
      backgroundColor: GeopaparazziColors.mainBackground,
      maxZoom: 19,
      subdomains: ['a', 'b', 'c'],
    );
    loadProject();
  }

  Future loadProject() async {
    if (widget._model.projectPath != null) {
      GeopaparazziMapLoader loader =
          new GeopaparazziMapLoader(new File(widget._model.projectPath), this);
      await loader.loadNotes();
    }
  }

  @override
  void dispose() {
    GpsHandler().removePositionListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    if(_isFirstLoad){
//      loadProject(context);
//      _isFirstLoad = false;
//    }


    var layers = <LayerOptions>[];
    layers.add(_osmLayer);

    if (_geopapLogs != null) layers.add(_geopapLogs);
    if (_geopapMarker != null) layers.add(_geopapMarker);

    if (_lastPosition != null) {
      layers.add(
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              anchorPos: AnchorPos.align(AnchorAlign.center),
              point:
                  new LatLng(_lastPosition.latitude, _lastPosition.longitude),
              builder: (ctx) => new Container(
                    child: Icon(
                      Icons.my_location,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
            )
          ],
        ),
      );
    }

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Map View"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              File file = await FilePicker.getFile(
                  type: FileType.ANY, fileExtension: 'gpap');
              if (file != null) {
                GeopaparazziMapLoader loader =
                    new GeopaparazziMapLoader(file, this);
                loader.loadNotes();
              }
            },
            icon: Icon(Icons.layers),
            tooltip: "Add geopap Porject",
          )
        ],
      ),
      body: Center(
          child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(46.32, 11.46),
          zoom: _currentZoom,
        ),
        layers: layers,
        mapController: _mapController,
      )),
      floatingActionButton: AnimatedFloatingActionButton(
          //Fab list
          fabButtons: <Widget>[zoomIn(), zoomOut(), centerOnGps()],
          colorStartAnimation: GeopaparazziColors.mainDecorations,
          colorEndAnimation: GeopaparazziColors.mainSelection,
          animatedIconData: AnimatedIcons.menu_close),
    );
  }

  Widget zoomIn() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentZoom = _currentZoom + 1;
            if (_currentZoom > 19) _currentZoom = 19;
            _mapController.move(_mapController.center, _currentZoom);
          });
        },
        tooltip: 'Zoom in',
        child: Icon(
          Icons.zoom_in,
          color: GeopaparazziColors.mainBackground,
        ),
        heroTag: null,
      ),
    );
  }

  Widget zoomOut() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentZoom = _currentZoom - 1;
            if (_currentZoom < 0) _currentZoom = 0;
            _mapController.move(_mapController.center, _currentZoom);
          });
        },
        tooltip: 'Zoom out',
        child: Icon(
          Icons.zoom_out,
          color: GeopaparazziColors.mainBackground,
        ),
        heroTag: null,
      ),
    );
  }

  Widget centerOnGps() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_lastPosition != null)
              _mapController.move(
                  LatLng(_lastPosition.latitude, _lastPosition.longitude),
                  _mapController.zoom);
          });
        },
        tooltip: 'Center on GPS',
        child: Icon(Icons.center_focus_strong,
            color: GeopaparazziColors.mainBackground),
        heroTag: null,
      ),
    );
  }

  @override
  void onPositionUpdate(Position position) {
    setState(() {
      _lastPosition = position;
    });
  }
}
