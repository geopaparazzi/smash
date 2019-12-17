import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';

enum PERMISSIONS { STORAGE, LOCATION }

class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();

  factory PermissionManager() => _instance;

  PermissionManager._internal();

  List<PERMISSIONS> _permissionsToCheck = [];

  PermissionManager add(PERMISSIONS permission) {
    _permissionsToCheck.add(permission);
    return this;
  }

  Future<bool> check() async {
    bool granted = true;
    for (int i = 0; i < _permissionsToCheck.length; i++) {
      if (_permissionsToCheck[i] == PERMISSIONS.STORAGE && !Platform.isIOS) {
        granted = await _checkStoragePermissions();
      } else if (_permissionsToCheck[i] == PERMISSIONS.LOCATION) {
        granted = await _checkLocationPermissions();
      }
    }

    return granted;
  }

  Future<bool> _checkStoragePermissions() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      GpLogger().d("Storage permission is not granted.");
      Map<PermissionGroup, PermissionStatus> permissionsMap =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissionsMap[PermissionGroup.storage] != PermissionStatus.granted) {
        GpLogger().d("Unable to grant permission: ${PermissionGroup.storage}");
        return false;
      }
    }
    GpLogger().d("Storage permission granted.");
    return true;
  }

  Future<bool> _checkLocationPermissions() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission != PermissionStatus.granted) {
      GpLogger().d("Location permission is not granted.");
      Map<PermissionGroup, PermissionStatus> permissionsMap =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      if (permissionsMap[PermissionGroup.location] !=
          PermissionStatus.granted) {
        GpLogger().d("Unable to grant permission: ${PermissionGroup.location}");
        return false;
      }
    }
    GpLogger().d("Location permission granted.");
    return true;
  }
}
