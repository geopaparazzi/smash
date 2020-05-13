/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:dart_jts/dart_jts.dart' hide Position, Distance;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';

/// Geocoding widget that makes use of the [MainEventHandler] to move to the
/// chosen location.
class GeocodingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeocodingPageState();
}

class GeocodingPageState extends State<GeocodingPage> {
  List<Address> _addresses = List();
  var textEditingController = TextEditingController();
  TextFormField textField;
  bool searching = false;

  @override
  void initState() {
    var inputDecoration = InputDecoration(
        labelText: "Enter search address", hintText: "Via Ipazia, 2");
    textField = TextFormField(
      controller: textEditingController,
      decoration: inputDecoration,
    );
    super.initState();
  }

  Future<void> search(BuildContext context, String query) async {
    List<Address> addresses;
    try {
      addresses = await Geocoder.local.findAddressesFromQuery(query);
    } catch (e) {
      GpLogger().err("Unable to geocode $query", e);
    }
    searching = false;
    if (addresses == null || addresses.isEmpty) {
      showWarningDialog(context, "Could not find any address.");
    } else {
      setState(() {
        _addresses.clear();
        _addresses.addAll(addresses);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> _list = List.from(_addresses.map((address) {
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.navigation),
          onPressed: () {
            SmashMapState mapState =
                Provider.of<SmashMapState>(context, listen: false);
            mapState.center = Coordinate(
                address.coordinates.longitude, address.coordinates.latitude);
            Navigator.pop(context);
          },
        ),
        title: Text("${address.addressLine}"),
        subtitle: Text(
            "Lat: ${address.coordinates.latitude} Lon: ${address.coordinates.longitude}"),
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Geocoding"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String query = textEditingController.text;
              if (query.trim().isEmpty) {
                showWarningDialog(
                    context, "Nothing to look for. Insert an address.");
                return;
              }
              search(context, query);
              setState(() {
                searching = true;
              });
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
            searching
                ? Center(child: SmashCircularProgress(label: "Searching..."))
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: _list),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
