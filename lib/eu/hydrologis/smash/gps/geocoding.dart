/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:dart_jts/dart_jts.dart' hide Position, Distance;
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:smashlibs/smashlibs.dart';

/// Geocoding widget that makes use of the [MainEventHandler] to move to the
/// chosen location.
class GeocodingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeocodingPageState();
}

class GeocodingPageState extends State<GeocodingPage> {
  late List<Address> _addresses = [];
  var textEditingController = TextEditingController();
  late TextFormField textField;
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
    List<Address> addresses = [];
    try {
      addresses = await Geocoder.local.findAddressesFromQuery(query);
    } on Exception catch (e, s) {
      SMLogger().e("Unable to geocode $query", e, s);
    }
    searching = false;
    if (addresses.isEmpty) {
      SmashDialogs.showWarningDialog(context, "Could not find any address.");
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
                address.coordinates.longitude!, address.coordinates.latitude!);
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
        title: Text(SL.of(context).geocoding_geocoding), //"Geocoding"
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String query = textEditingController.text;
              if (query.trim().isEmpty) {
                SmashDialogs.showWarningDialog(
                    context,
                    SL
                        .of(context)
                        .geocoding_nothingToLookFor); //"Nothing to look for. Insert an address."
                return;
              }
              search(context, query);
              setState(() {
                searching = true;
              });
            },
            icon: Icon(Icons.refresh),
            tooltip:
                SL.of(context).geocoding_launchGeocoding, //"Launch Geocoding"
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
                ? Center(
                    child: SmashCircularProgress(
                        label: SL
                            .of(context)
                            .geocoding_searching)) //"Searching..."
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
