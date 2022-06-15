/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/mapsforge.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

import 'offline_maps.dart';

class DownloadMapFromListTileProgressWidget extends StatefulWidget {
  final String _downloadUrl;
  final String _destinationFilePath;
  final String _name;

  DownloadMapFromListTileProgressWidget(
      this._downloadUrl, this._destinationFilePath, this._name);

  @override
  State<StatefulWidget> createState() {
    return DownloadMapFromListTileProgressWidgetState();
  }
}

class DownloadMapFromListTileProgressWidgetState
    extends State<DownloadMapFromListTileProgressWidget> {
  bool _downloading = false;
  bool _downloadFinished = false;
  String _progressString = "";
  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    _progressString = widget._downloadUrl;
    super.initState();
  }

  Future<void> downloadFile() async {
    Dio dio = NetworkHelper.getNewDioInstance();

    File file = File(widget._destinationFilePath);
    if (!file.parent.existsSync()) {
      await file.parent.create(recursive: true);
    }

    try {
      await dio.download(widget._downloadUrl, widget._destinationFilePath,
          onReceiveProgress: (rec, total) {
        setState(() {
          _downloading = true;
          _progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }, cancelToken: cancelToken);

      if (!cancelToken.isCancelled) {
        await buildCache(widget._destinationFilePath);

        var tileSource = TileSource.Mapsforge(widget._destinationFilePath);
        LayerManager().addLayerSource(tileSource);
        // TODO fix the below
//        widget._mainEventsHandler.reloadLayersFunction();
      }
    } on Exception catch (e, s) {
      SMLogger().e("Error downloading file ${widget._downloadUrl}", e, s);
    }

    setState(() {
      _downloading = false;
      _downloadFinished = true;
      _progressString = cancelToken.isCancelled
          ? SL.of(context).network_cancelledByUser //"Cancelled by user."
          : SL.of(context).network_completed; //"Completed."
    });
  }

  Future<void> buildCache(String mapsforgePath) async {
    setState(() {
      _progressString = SL
          .of(context)
          .network_buildingBaseCachePerformance; //"Building base cache for performance increase (might take some time..."
    });
    await fillBaseCache(File(mapsforgePath));
  }

  @override
  Widget build(BuildContext context) {
    var name = widget._name;
    if (name == null) {
      name = FileUtilities.nameFromFile(widget._destinationFilePath, true);
    }
    if (!_downloading && !_downloadFinished) {
      _progressString = widget._downloadUrl;
    }

    File dFile = File(widget._destinationFilePath);
    var fileExists = dFile.existsSync();
    return ListTile(
      leading: _downloading
          ? CircularProgressIndicator()
          : fileExists
              ? Icon(
                  Icons.check,
                  color: SmashColors.mainDecorations,
                )
              : Icon(
                  getSmashIcon('timer'),
                  color: SmashColors.mainSelection,
                ),
      title: SmashUI.normalText(name),
      subtitle: Text(_progressString),
      trailing: Icon(
        Icons.file_download,
        color: SmashColors.mainDecorations,
      ),
      onLongPress: () {
        if (_downloading) {
          cancelToken.cancel("cancelled");
          if (dFile.existsSync()) {
            dFile.deleteSync();
          }
        }
      },
      onTap: () async {
        if (_downloading) {
          SmashDialogs.showWarningDialog(
              context,
              SL
                  .of(context)
                  .network_thisFIleAlreadyBeingDownloaded); //"This file is already in the process of being downloaded."
          return;
        }
        bool? doDownload = await SmashDialogs.showConfirmDialog(
                context,
                SL.of(context).network_download, //"Download"
                "${SL.of(context).network_downloadFile} $name " //"Download file"
                "${SL.of(context).network_toTheDeviceTakeTime}") //"to the device? This can take some time."
            ??
            false;
        if (doDownload) {
          await downloadFile();
        }
      },
    );
  }
}

/// The notes properties page.
class MapsDownloadWidget extends StatefulWidget {
  final Directory _mapsFolder;

  MapsDownloadWidget(this._mapsFolder);

  @override
  State<StatefulWidget> createState() {
    return MapsDownloadWidgetState();
  }
}

class MapsDownloadWidgetState extends State<MapsDownloadWidget> {
  TextEditingController editingController = TextEditingController();
  List<List<String>> _completeList = MAPLINKS;
  List<List<String>> _visualizeList = [];

  @override
  void initState() {
    _visualizeList = []..addAll(_completeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${SL.of(context).network_availableMaps} (${_visualizeList.length})"), //Available maps
      ),
      body: Container(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: InputDecoration(
                labelText: SL
                    .of(context)
                    .network_searchMapByName, //"Search map by name"
                hintText: SL
                    .of(context)
                    .network_searchMapByName, //"Search map by name"
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _visualizeList.length,
            itemBuilder: (context, index) {
              var item = _visualizeList[index];

              return DownloadMapFromListTileProgressWidget(
                  item[1],
                  FileUtilities.joinPaths(widget._mapsFolder.path, item[0]),
                  item[0]);
            },
          ),
        ),
      ])),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      query = query.toLowerCase();
      _visualizeList.clear();
      _completeList.forEach((item) {
        String name = item[0];
        if (name.toLowerCase().contains(query)) {
          _visualizeList.add(item);
        }
      });
      setState(() {});
      return;
    } else {
      setState(() {
        _visualizeList = []..addAll(_completeList);
      });
    }
  }
}
