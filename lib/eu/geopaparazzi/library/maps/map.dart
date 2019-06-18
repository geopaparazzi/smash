import 'dart:async';
import 'dart:io';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/gps/gps.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/maps/geopaparazzi.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/models/models.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/preferences.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class GeopaparazziMapWidget extends StatefulWidget {
  GeopaparazziMapWidget({Key key}) : super(key: key);

  @override
  GeopaparazziMapWidgetState createState() => new GeopaparazziMapWidgetState();
}

class GeopaparazziMapWidgetState extends State<GeopaparazziMapWidget>
    with SingleTickerProviderStateMixin
    implements PositionListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Marker> _geopapMarkers;
  PolylineLayerOptions _geopapLogs;
  Polyline _currentGeopapLog =
      Polyline(points: [], strokeWidth: 3, color: ColorExt("red"));
  TileLayerOptions _osmLayer;
  Position _lastPosition;

  double _initLon;
  double _initLat;
  double _initZoom;

  MapController _mapController;

  set geopapMarkers(List<Marker> geopapMarkers) {
    _geopapMarkers = geopapMarkers;
  }

  set geopapLogs(PolylineLayerOptions geopapLogs) {
    _geopapLogs = geopapLogs;
  }

  showSnackBar(SnackBar bar) {
    _scaffoldKey.currentState.showSnackBar(bar);
  }

  @override
  void initState() {
    super.initState();
    _initLon = gpProjectModel.lastCenterLon;
    _initLat = gpProjectModel.lastCenterLat;
    _initZoom = gpProjectModel.lastCenterZoom;

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
    if (gpProjectModel.projectPath != null) {
      GeopaparazziMapLoader loader =
          new GeopaparazziMapLoader(new File(gpProjectModel.projectPath), this);
      await loader.loadNotes();
    }
    setState(() {});
  }

  @override
  void dispose() {
    updateCenterPosition();
    // stop listening to gps
    GpsHandler().removePositionListener(this);
    super.dispose();
  }

  void updateCenterPosition() {
    // save last position
    gpProjectModel.lastCenterLon = _mapController.center.longitude;
    gpProjectModel.lastCenterLat = _mapController.center.latitude;
    gpProjectModel.lastCenterZoom = _mapController.zoom;
  }

  @override
  Widget build(BuildContext context) {
    var layers = <LayerOptions>[];
    layers.add(_osmLayer);

    if (_geopapLogs != null) layers.add(_geopapLogs);
    if (_geopapMarkers != null && _geopapMarkers.length > 0) {
      var markerCluster = MarkerClusterLayerOptions(
        maxClusterRadius: 80,
        height: 40,
        width: 40,
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: _geopapMarkers,
        polygonOptions: PolygonOptions(
            borderColor: GeopaparazziColors.mainDecorationsDark,
            color: GeopaparazziColors.mainDecorations.withOpacity(0.2),
            borderStrokeWidth: 3),
        builder: (context, markers) {
          return FloatingActionButton(
            child: Text(markers.length.toString()),
            onPressed: null,
            backgroundColor: GeopaparazziColors.mainDecorationsDark,
            foregroundColor: GeopaparazziColors.mainBackground,
            heroTag: null,
          );
        },
      );
      layers.add(markerCluster);
    }

    if (GpsHandler().currentLogPoints.length > 0) {
      _currentGeopapLog.points.clear();
      _currentGeopapLog.points.addAll(GpsHandler().currentLogPoints);
      layers.add(PolylineLayerOptions(
        polylines: [_currentGeopapLog],
      ));
    }

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
          // here no futurebuilder can be used, because the gps triggers refresh, which makes it cluttered
          child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(_initLat, _initLon),
          zoom: _initZoom,
          plugins: [
            MarkerClusterPlugin(),
          ],
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
            var zoom = _mapController.zoom + 1;
            if (zoom > 19) zoom = 19;
            _mapController.move(_mapController.center, zoom);
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
            var zoom = _mapController.zoom - 1;
            if (zoom < 0) zoom = 0;
            _mapController.move(_mapController.center, zoom);
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

  @override
  void setStatus(GpsStatus currentStatus) {}
}
