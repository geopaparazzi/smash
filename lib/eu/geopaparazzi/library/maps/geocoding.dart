/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:smash/eu/geopaparazzi/library/utils/dialogs.dart';
import 'package:smash/eu/geopaparazzi/library/utils/eventhandlers.dart';
import 'package:latlong/latlong.dart';

// From a query
//final query = "1600 Amphiteatre Parkway, Mountain View";
//var addresses = await Geocoder.local.findAddressesFromQuery(query);
//var first = addresses.first;
//print("${first.featureName} : ${first.coordinates}");
//
//// From coordinates
//final coordinates = new Coordinates(1.10, 45.50);
//addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//first = addresses.first;
//print("${first.featureName} : ${first.addressLine}");

class GeocodingPage extends StatefulWidget {
  MainEventHandler _eventsHandler;

  GeocodingPage(this._eventsHandler);

  @override
  State<StatefulWidget> createState() => GeocodingPageState();
}

class GeocodingPageState extends State<GeocodingPage> {
  List<Address> _addresses = List();

  @override
  Widget build(BuildContext context) {
    List<ListTile> _list = List.from(_addresses.map((address) {
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.navigation),
          onPressed: () {
            widget._eventsHandler.setMapCenter(LatLng(
                address.coordinates.latitude, address.coordinates.longitude));
            Navigator.pop(context);
          },
        ),
        title: Text("${address.addressLine}"),
        subtitle: Text(
            "Lat: ${address.coordinates.latitude} Lon: ${address.coordinates.longitude}"),
      );
    }));

    var textEditingController = new TextEditingController();
    var inputDecoration = new InputDecoration(
        labelText: "Enter search address", hintText: "Via Ipazia, 2");
    var textField = TextFormField(
      controller: textEditingController,
      decoration: inputDecoration,
    );
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Geocoding"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String query = textEditingController.text;
              List<Address> addresses =
                  await Geocoder.local.findAddressesFromQuery(query);
              if (addresses == null || addresses.length == 0) {
                showWarningDialog(context, "Could not find any address.");
              } else {
                setState(() {
                  _addresses.clear();
                  _addresses.addAll(addresses);
                });
              }
            },
            icon: Icon(Icons.refresh),
            tooltip: "Launch Geocoding",
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: textField,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Column(children: _list),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
