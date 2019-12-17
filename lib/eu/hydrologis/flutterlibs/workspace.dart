/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';

/// The name of the app, used to handle project folders and similar.
const APP_NAME = "smash";
const MAPS_FOLDER = "maps";
const CONFIG_FOLDER = "config";
const PROJECTS_FOLDER = "projects";
const EXPORT_FOLDER = "export";

/// Application workspace utilities.
class Workspace {
  /// Get the folder into which user created data can be saved.
  ///
  /// These are for example project databases, the configuration folder
  /// named after the app containing the log db, tags and similar.
  ///
  /// On Android this will be the internal sdcard storage,
  /// while on IOS that will be the Documents folder.
  static Future<Directory> getRootFolder() async {
    if (Platform.isIOS) {
      var dir = await getApplicationDocumentsDirectory();
      return dir;
    } else if (Platform.isAndroid) {
      var dir = await _getAndroidStorageFolder();
      return dir;
    } else {
      // TODO
      return null;
    }
  }

  /// Get the temporary or cache folder.
  ///
  /// Data in here are not visible to the user and might be deleted at anytime.
  static Future<Directory> getCacheFolder() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir;
  }

  /// Get the application folder.
  ///
  /// The [APP_NAME] is used and can be changed for other apps.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getApplicationFolder() async {
    var rootFolder = await getRootFolder();
    var applicationFolderPath =
        FileUtilities.joinPaths(rootFolder.path, APP_NAME);
    Directory configFolder = Directory(applicationFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  /// Get the default projects folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getProjectsFolder() async {
    var applicationFolder = await getApplicationFolder();
    var projectsFolderPath =
        FileUtilities.joinPaths(applicationFolder.path, PROJECTS_FOLDER);
    Directory configFolder = Directory(projectsFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  /// Get the application configuration folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getConfigurationFolder() async {
    var applicationFolder = await getApplicationFolder();
    var configFolderPath =
        FileUtilities.joinPaths(applicationFolder.path, CONFIG_FOLDER);
    Directory configFolder = Directory(configFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  /// Get the maps folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getMapsFolder() async {
    var applicationFolder = await getApplicationFolder();
    var mapsFolderPath =
        FileUtilities.joinPaths(applicationFolder.path, MAPS_FOLDER);
    Directory mapsFolder = Directory(mapsFolderPath);
    if (!mapsFolder.existsSync()) {
      mapsFolder.createSync();
    }
    return mapsFolder;
  }

  /// Get the export folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getExportsFolder() async {
    var applicationFolder = await getApplicationFolder();
    var mapsFolderPath =
        FileUtilities.joinPaths(applicationFolder.path, EXPORT_FOLDER);
    Directory mapsFolder = Directory(mapsFolderPath);
    if (!mapsFolder.existsSync()) {
      mapsFolder.createSync();
    }
    return mapsFolder;
  }

  /// Get the default storage folder.
  ///
  /// On Android this is supposed to be root of the internal sdcard.
  /// If unable to get it, this falls back on the internal appfolder,
  /// inside which the app is supposed to be able to write.
  ///
  /// Returns the file of the folder to use..
  static Future<Directory> _getAndroidStorageFolder() async {
    var storageInfo = await PathProviderEx.getStorageInfo();
    var internalStorage = _getAndroidInternalStorage(storageInfo);
    if (internalStorage.isNotEmpty) {
      return Directory(internalStorage[0]);
    } else {
      var directory = await getExternalStorageDirectory();
      return Directory(directory.path);
    }
  }

  static List<String> _getAndroidInternalStorage(
      List<StorageInfo> storageInfo) {
    String rootDir;
    String appFilesDir;
    if (storageInfo.isNotEmpty) {
      rootDir = storageInfo[0].rootDir;
      appFilesDir = storageInfo[0].appFilesDir;
    }
    if (rootDir == null || appFilesDir == null) return null;
    return [rootDir, appFilesDir];
  }

  /// Get the folder into which the app can create data, which are
  /// not available to the user.
//  static Future<Directory> getApplicationDataFolder() async {
//    if (Platform.isIOS) {
//      var directory = await getApplicationSupportDirectory();
//      return directory;
//    } else if (Platform.isAndroid) {
//      var directory = await getApplicationSupportDirectory();
//      return directory;
//    }
//    return get;
//  }

//
//  static List<String> getExternalStorage(List<StorageInfo> storageInfo) {
//    if (Platform.isAndroid) {
//      String rootDir;
//      String appFilesDir;
//      if (storageInfo.length > 1) {
//        rootDir = storageInfo[1].rootDir;
//        appFilesDir = storageInfo[1].appFilesDir;
//      }
//      if (rootDir == null || appFilesDir == null) return null;
//      return [rootDir, appFilesDir];
//    }
//  }
}
