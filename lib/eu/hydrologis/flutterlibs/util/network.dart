import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/layers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/mapsforge.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/icons.dart' as ICONS;
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';

import 'offline_maps.dart';

class DownloadCircularProgressWidget extends StatefulWidget {
  String _downloadUrl;
  String _destinationFilePath;

  DownloadCircularProgressWidget(this._downloadUrl, this._destinationFilePath);

  @override
  State<StatefulWidget> createState() {
    return DownloadCircularProgressWidgetState();
  }
}

class DownloadCircularProgressWidgetState extends State<DownloadCircularProgressWidget> {
  bool _downloading = false;
  String _progressString = "";

  @override
  void initState() {
    super.initState();

    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      await dio.download(widget._downloadUrl, widget._destinationFilePath, onReceiveProgress: (rec, total) {
        setState(() {
          _downloading = true;
          _progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });

      File f = File(widget._destinationFilePath);
      if (f.existsSync()) {
        TileSource ts = TileSource.Mapsforge(f.path);
        LayerManager().addLayer(ts);
      }
    } catch (e) {
      GpLogger().err("An error occurred while downloading from: ${widget._downloadUrl}", e);
    }

    setState(() {
      _downloading = false;
      _progressString = "Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _downloading
            ? Container(
                height: 120,
                width: 200,
                child: Card(
                  color: SmashColors.mainBackground,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      SmashUI.normalText("Downloading file: $_progressString"),
                    ],
                  ),
                ),
              )
            : SmashUI.normalText("Not downloading."));
  }
}

class DownloadMapFromListTileProgressWidget extends StatefulWidget {
  final String _downloadUrl;
  final String _destinationFilePath;
  final String _name;

  DownloadMapFromListTileProgressWidget(this._downloadUrl, this._destinationFilePath, this._name);

  @override
  State<StatefulWidget> createState() {
    return DownloadMapFromListTileProgressWidgetState();
  }
}

class DownloadMapFromListTileProgressWidgetState extends State<DownloadMapFromListTileProgressWidget> {
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
    Dio dio = Dio();

    File file = File(widget._destinationFilePath);
    if (!file.parent.existsSync()) {
      await file.parent.create(recursive: true);
    }

    try {
      await dio.download(widget._downloadUrl, widget._destinationFilePath, onReceiveProgress: (rec, total) {
        setState(() {
          _downloading = true;
          _progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }, cancelToken: cancelToken);

      if (!cancelToken.isCancelled) {
        await buildCache(widget._destinationFilePath);

        var tileSource = TileSource.Mapsforge(widget._destinationFilePath);
        LayerManager().addLayer(tileSource);
        // TODO fix the below
//        widget._mainEventsHandler.reloadLayersFunction();
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _downloading = false;
      _downloadFinished = true;
      _progressString = cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
    });
  }

  Future<void> buildCache(String mapsforgePath) async {
    setState(() {
      _progressString = "Building base cache for performance increase (might take some time...";
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
                  ICONS.getIcon('timer'),
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
          showWarningDialog(context, "This file is already in the process of being downloaded.");
          return;
        }
        bool doDownload = await showConfirmDialog(context, "Download", "Download file ${name} to the device? This can take some time.");
        if (doDownload) {
          await downloadFile();
        }
      },
    );
  }
}

/// The notes properties page.
class MapsDownloadWidget extends StatefulWidget {
  Directory _mapsFolder;

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
        title: Text("Available maps (${_visualizeList.length})"),
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
                labelText: "Search map by name",
                hintText: "Search map by name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _visualizeList.length,
            itemBuilder: (context, index) {
              var item = _visualizeList[index];

              return DownloadMapFromListTileProgressWidget(item[1], FileUtilities.joinPaths(widget._mapsFolder.path, item[0]), item[0]);
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

class FileDownloadListTileProgressWidget extends StatefulWidget {
  final String _downloadUrl;
  final String _destinationFilePath;
  final String _name;
  final bool showUrl;
  final String authHeader;

  FileDownloadListTileProgressWidget(this._downloadUrl, this._destinationFilePath, this._name, {this.showUrl = false, this.authHeader});

  @override
  State<StatefulWidget> createState() {
    return FileDownloadListTileProgressWidgetState();
  }
}

class FileDownloadListTileProgressWidgetState extends State<FileDownloadListTileProgressWidget> {
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
    Dio dio = Dio();

    File file = File(widget._destinationFilePath);
    if (!file.parent.existsSync()) {
      await file.parent.create(recursive: true);
    }

    Options options;
    if (widget.authHeader != null) {
      options = Options(headers: {"Authorization": widget.authHeader});
    }

    try {
      await dio.download(widget._downloadUrl, widget._destinationFilePath, onReceiveProgress: (rec, total) {
        setState(() {
          _downloading = true;
          _progressString = total <= 0 ? "Downloading... please wait..." : ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }, cancelToken: cancelToken, options: options);
    } catch (e) {
      print(e);
    }

    setState(() {
      _downloading = false;
      _downloadFinished = true;
      _progressString = cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
    });
  }

  @override
  Widget build(BuildContext context) {
    var name = widget._name;
    if (name == null) {
      name = FileUtilities.nameFromFile(widget._destinationFilePath, true);
    }
    if (!_downloading && !_downloadFinished) {
      _progressString = widget._downloadUrl;
      if (!widget.showUrl) {
        _progressString = null;
      }
    }

    File dFile = File(widget._destinationFilePath);
    var fileExists = dFile.existsSync();
    return ListTile(
      leading: _downloading
          ? CircularProgressIndicator()
          : fileExists
              ? Icon(
                  MdiIcons.cloudCheck,
                  color: SmashColors.mainSelection,
                )
              : Icon(
                  ICONS.SmashIcons.forPath(name),
                  color: SmashColors.mainDecorations,
                ),
      title: Text(name),
      subtitle: _progressString != null ? Text(_progressString) : Container(),
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
        if (dFile.existsSync()) {
          showWarningDialog(context, "This file already exists, will not overwrite.");
          return;
        }

        if (_downloading) {
          showWarningDialog(context, "This file is already in the process of being downloaded.");
          return;
        }
        bool doDownload = await showConfirmDialog(context, "Download", "Download file $name to the device? This can take some time.");
        if (doDownload) {
          await downloadFile();
        }
      },
    );
  }
}
