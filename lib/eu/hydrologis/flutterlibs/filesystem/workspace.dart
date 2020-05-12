/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';

/// The name of the app, used to handle project folders and similar.
const APP_NAME = "smash";
const MAPS_FOLDER = "maps";
const CONFIG_FOLDER = "config";
const FORMS_FOLDER = "forms";
const PROJECTS_FOLDER = "projects";
const EXPORT_FOLDER = "export";

const IOS_DOCUMENTSFOLDER = "Documents";

/// Application workspace utilities.
class Workspace {
  static String _rootFolder;

  static Future<void> init() async {
    var rootDir = await getRootFolder();
    _rootFolder = rootDir.path;
  }

  /// Make an [absolutePath] relative to the current rootfolder.
  static String makeRelative(String absolutePath) {
    var relativePath = absolutePath.replaceFirst(_rootFolder, "");
    return relativePath;
  }

  /// Make a [relativePath] absolute using to the current rootfolder.
  static String makeAbsolute(String relativePath) {
    if (relativePath.startsWith(_rootFolder)) return relativePath;
    var absolutePath = FileUtilities.joinPaths(_rootFolder, relativePath);
    return absolutePath;
  }

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
    var applicationFolderPath = FileUtilities.joinPaths(rootFolder.path, APP_NAME);
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
    var projectsFolderPath = FileUtilities.joinPaths(applicationFolder.path, PROJECTS_FOLDER);
    Directory configFolder = Directory(projectsFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  /// Get the application configuration folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getConfigFolder() async {
    var applicationFolder = await getApplicationFolder();
    var configFolderPath = FileUtilities.joinPaths(applicationFolder.path, CONFIG_FOLDER);
    Directory configFolder = Directory(configFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  /// Get the application configuration folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getFormsFolder() async {
    var applicationFolder = await getApplicationFolder();
    var formsFolderPath = FileUtilities.joinPaths(applicationFolder.path, FORMS_FOLDER);
    Directory formsFolder = Directory(formsFolderPath);
    if (!formsFolder.existsSync()) {
      formsFolder.createSync();
    }
    return formsFolder;
  }

  /// Get the maps folder.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getMapsFolder() async {
    var applicationFolder = await getApplicationFolder();
    var mapsFolderPath = FileUtilities.joinPaths(applicationFolder.path, MAPS_FOLDER);
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
    var mapsFolderPath = FileUtilities.joinPaths(applicationFolder.path, EXPORT_FOLDER);
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

  static List<String> _getAndroidInternalStorage(List<StorageInfo> storageInfo) {
    String rootDir;
    String appFilesDir;
    if (storageInfo.isNotEmpty) {
      rootDir = storageInfo[0].rootDir;
      appFilesDir = storageInfo[0].appFilesDir;
    }
    if (rootDir == null || appFilesDir == null) return null;
    return [rootDir, appFilesDir];
  }

  /// Return the last used folder from the preferences.
  ///
  /// The paths are kept in the preferences as relative paths.
  /// This is neccessary, since on IOS systems the launch root
  /// changes at every application launch and the ApplicationDocumentsDirectory
  /// changes.
  static Future<String> getLastUsedFolder() async {
    var rootDir = await getRootFolder();
    var rootPath = rootDir.path;
    var lastFolder = await GpPreferences().getString(KEY_LAST_USED_FOLDER, "");
    if (lastFolder.length == 0) {
      lastFolder = rootPath;
    } else {
      // add the root folder
      lastFolder = FileUtilities.joinPaths(rootPath, lastFolder);
    }
    return lastFolder;
  }

  static Future<void> setLastUsedFolder(String absolutePath) async {
    var rootDir = await getRootFolder();
    var rootPath = rootDir.path;
    String relativePath = absolutePath.replaceFirst(rootPath, "");
    await GpPreferences().setString(KEY_LAST_USED_FOLDER, relativePath);
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
