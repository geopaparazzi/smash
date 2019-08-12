/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydro_flutter_libs/hydro_flutter_libs.dart';
import 'dashboard.dart';

class PermissionsWidget extends StatefulWidget {
  PermissionsWidget({Key key}) : super(key: key);

  @override
  _PermissionsWidgetState createState() => new _PermissionsWidgetState();
}

class _PermissionsWidgetState extends State<PermissionsWidget> {
  bool _locationPermission = false;
  bool _storagePermission = false;
  bool _loadDashboard = false;

  @override
  Widget build(BuildContext context) {
    if (_loadDashboard) {
      return DashboardWidget();
    } else if (_storagePermission && _locationPermission) {
      Future.delayed(Duration(seconds: 0), () async {
        await TagsManager().readFileTags();
        var layerManager = LayerManager();
        await layerManager.initialize();
        appGpsLoggingHandler = SmashLoggingHandler();
        var pos = await GpPreferences().getLastPosition();
        var gpProject = GPProject();
        if (pos != null) {
          gpProject.lastCenterLon = pos[0];
          gpProject.lastCenterLat = pos[1];
          gpProject.lastCenterZoom = pos[2];
        }
        setState(() {
          _loadDashboard = true;
        });
      });
    } else {
      if (!_locationPermission) {
        PermissionManager()
            .add(PERMISSIONS.LOCATION)
            .check()
            .then((allRight) async {
          if (allRight) {
            setState(() {
              _locationPermission = true;
            });
          }
        });
      } else {
        // location is ok, ask for storage
        if (!_storagePermission) {
          PermissionManager()
              .add(PERMISSIONS.STORAGE)
              .check()
              .then((allRight) async {
            if (allRight) {
              setState(() {
                _storagePermission = true;
              });
            }
          });
        }
      }
    }
    return Container(
      color: SmashColors.mainBackground,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
