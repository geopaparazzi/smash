/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

/// File path and folder utilities.
class FileUtils {
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
