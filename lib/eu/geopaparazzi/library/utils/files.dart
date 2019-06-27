/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/utils.dart';

/// File path and folder utilities.
class FileUtils {
  static String joinPaths(String path1, String path2) {
    return join(path1, path2);
  }

  /*
   * Get the list of files names from a given [parentPath] and optionally filtered by [ext].
   */
  static List<String> getFilesInPathByExt(String parentPath, [String ext]) {
    List<String> filenameList = List();

    try {
      Directory(parentPath).listSync().forEach((FileSystemEntity fse) {
        String path = fse.path;
        String filename = basename(path);
        if (ext == null || filename.endsWith(ext)) {
          filenameList.add(filename);
        }
      });
    } catch (e) {
      print(e);
    }
    return filenameList;
  }

  static Future<Directory> getTmpFolder() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir;
  }

  static Future<Directory> getAppFolderPath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  static Future<List<StorageInfo>> getStorageInfo() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    return storageInfo;
  }

  /// Get the default storage folder.
  ///
  /// On Android this is supposed to be root of the internal sdcard.
  /// If unable to get it, this falls back on the internal appfolder,
  /// inside which the app is supposed to be able to write.
  ///
  /// Returns the file of the folder to use..
  static Future<Directory> getDefaultStorageFolder() async {
    var storageInfo = await getStorageInfo();
    var intenalStorage = getInternalStorage(storageInfo);
    if (intenalStorage.isNotEmpty) {
      return new Directory(intenalStorage[0]);
    } else {
      var directory = await getAppFolderPath();
      return new Directory(directory.path);
    }
  }

  /// Get the application configuration folder.
  ///
  /// An optional [appName] can be passed to allow other apps to use this.
  ///
  /// Returns the file of the folder to use.
  static Future<Directory> getApplicationConfigurationFolder(
      {appName: GpConstants.APP_NAME}) async {
    var storageInfo = await getDefaultStorageFolder();
    var configFolderPath =
        joinPaths(storageInfo.path, appName == null ? GpConstants.APP_NAME : appName);
    Directory configFolder = Directory(configFolderPath);
    if (!configFolder.existsSync()) {
      configFolder.createSync();
    }
    return configFolder;
  }

  static List<String> getInternalStorage(List<StorageInfo> storageInfo) {
    if (Platform.isAndroid) {
      String rootDir;
      String appFilesDir;
      if (storageInfo.length > 0) {
        rootDir = storageInfo[0].rootDir;
        appFilesDir = storageInfo[0].appFilesDir;
      }
      if (rootDir == null || appFilesDir == null) return null;
      return [rootDir, appFilesDir];
    }
  }

  static List<String> getExternalStorage(List<StorageInfo> storageInfo) {
    if (Platform.isAndroid) {
      String rootDir;
      String appFilesDir;
      if (storageInfo.length > 1) {
        rootDir = storageInfo[1].rootDir;
        appFilesDir = storageInfo[1].appFilesDir;
      }
      if (rootDir == null || appFilesDir == null) return null;
      return [rootDir, appFilesDir];
    }
  }
}
