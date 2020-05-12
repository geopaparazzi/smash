/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:smash/eu/hydrologis/flutterlibs/filesystem/workspace.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';

class ShareHandler {
  static Future<void> shareText(String text, {String title: ''}) async {
    await ShareExtend.share(text, "text");
  }

  static Future<void> shareImage(String text, var imageData) async {
    Directory cacheFolder = await Workspace.getCacheFolder();
    var outPath = FileUtilities.joinPaths(cacheFolder.path,
        "smash_tmp_share_${TimeUtilities.DATE_TS_FORMATTER}.jpg");

    FileUtilities.writeBytesToFile(outPath, imageData);

    await ShareExtend.share(outPath, "image");
  }

  static Future<void> shareProject(BuildContext context) async {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    if (projectState.projectPath != null) {
      File projectFile = File("${projectState.projectPath}");
      if (projectFile.existsSync()) {
        await ShareExtend.share(projectFile.path, "file");
      }
    }
  }
}
