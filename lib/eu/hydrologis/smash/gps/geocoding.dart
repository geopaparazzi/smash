/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:dart_hydrologis_db/dart_hydrologis_db.dart';
import 'package:dart_jts/dart_jts.dart' hide Position, Distance;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:smashlibs/smashlibs.dart';
import 'package:smash/eu/hydrologis/smash/models/map_state.dart';
import '../../../../generated/l10n.dart';

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
        labelText: SL.of(context).geocoding_enterAddress,
        hintText: SL.of(context).geocoding_addressExample);
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
    } on Exception catch (e, s) {
      SMLogger().e(SL.of(context).geocoding_unableGeocode(query), e, s);
    }
    searching = false;
    if (addresses == null || addresses.isEmpty) {
      SmashDialogs.showWarningDialog(
          context, SL.of(context).geocoding_noAddressFound);
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
        subtitle: Text(SL.of(context).geocoding_latLon(
            address.coordinates.latitude, address.coordinates.longitude)),
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).geocoding_title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              String query = textEditingController.text;
              if (query.trim().isEmpty) {
                SmashDialogs.showWarningDialog(
                    context, SL.of(context).geocoding_nothingToSearch);
                return;
              }
              search(context, query);
              setState(() {
                searching = true;
              });
            },
            icon: Icon(Icons.refresh),
            tooltip: SL.of(context).geocoding_launchGeocoding,
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
                        label: SL.of(context).geocoding_searching))
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
