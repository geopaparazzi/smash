import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/dartlibs/dartlibs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/forms/forms.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/gp_database.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/objects/images.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/objects/logs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/geopaparazzi/objects/notes.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/layers.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/mapsforge.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/icons.dart' as ICONS;
import 'package:smash/eu/hydrologis/flutterlibs/util/logging.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:smash/eu/hydrologis/smash/gss.dart';

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

class DownloadCircularProgressWidgetState
    extends State<DownloadCircularProgressWidget> {
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
      await dio.download(widget._downloadUrl, widget._destinationFilePath,
          onReceiveProgress: (rec, total) {
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
      GpLogger().err(
          "An error occurred while downloading from: ${widget._downloadUrl}",
          e);
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
                      SmashCircularProgress(
                          label: "Downloading file: $_progressString"),
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
    Dio dio = Dio();

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
      _progressString =
          cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
    });
  }

  Future<void> buildCache(String mapsforgePath) async {
    setState(() {
      _progressString =
          "Building base cache for performance increase (might take some time...";
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
          showWarningDialog(context,
              "This file is already in the process of being downloaded.");
          return;
        }
        bool doDownload = await showConfirmDialog(context, "Download",
            "Download file ${name} to the device? This can take some time.");
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

class FileDownloadListTileProgressWidget extends StatefulWidget {
  final String _downloadUrl;
  final String _destinationFilePath;
  final String _name;
  final bool showUrl;
  final String authHeader;

  FileDownloadListTileProgressWidget(
      this._downloadUrl, this._destinationFilePath, this._name,
      {this.showUrl = false, this.authHeader});

  @override
  State<StatefulWidget> createState() {
    return FileDownloadListTileProgressWidgetState();
  }
}

class FileDownloadListTileProgressWidgetState
    extends State<FileDownloadListTileProgressWidget> {
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
      await dio.download(widget._downloadUrl, widget._destinationFilePath,
          onReceiveProgress: (rec, total) {
        setState(() {
          _downloading = true;

          double recMb = rec / 1024 / 1024;

          _progressString = total <= 0
              ? "Downloading ${recMb.round()}MB, please wait..."
              : ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }, cancelToken: cancelToken, options: options);
    } catch (e) {
      print(e);
    }

    setState(() {
      _downloading = false;
      _downloadFinished = true;
      _progressString =
          cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
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
          setState(() {
            _downloading = false;
            _downloadFinished = true;
            _progressString = "Cancelled by user.";
          });
          try {
            if (dFile.existsSync()) {
              dFile.deleteSync();
            }
          } catch (e) {
            print(e);
          }
          cancelToken.cancel("cancelled");
        }
      },
      onTap: () async {
        if (dFile.existsSync()) {
          showWarningDialog(
              context, "This file already exists, will not overwrite.");
          return;
        }

        if (_downloading) {
          showWarningDialog(context,
              "This file is already in the process of being downloaded.");
          return;
        }
        bool doDownload = await showConfirmDialog(context, "Download",
            "Download file $name to the device? This can take some time.");
        if (doDownload) {
          await downloadFile();
        }
      },
    );
  }
}

/// Widget to trace upload of geopaparazzi items upload.
///
/// These can be notes, images or gpslogs.
class ProjectDataUploadListTileProgressWidget extends StatefulWidget {
  final String _uploadUrl;
  final dynamic _item;
  final String authHeader;
  final GeopaparazziProjectDb _projectDb;
  final Dio _dio;
  final ValueNotifier orderNotifier;
  final int order;

  ProjectDataUploadListTileProgressWidget(
      this._dio, this._projectDb, this._uploadUrl, this._item,
      {this.authHeader, this.orderNotifier, this.order});

  @override
  State<StatefulWidget> createState() {
    return ProjectDataUploadListTileProgressWidgetState();
  }
}

class ProjectDataUploadListTileProgressWidgetState
    extends State<ProjectDataUploadListTileProgressWidget> {
  bool _uploading = true;
  dynamic _item;
  String _progressString = "";
  String _errorString = "";
  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    _item = widget._item;
    super.initState();

    if (widget.orderNotifier == null) {
      // if no order notifier is available, start the upload directly
      upload();
    } else {
      if (widget.orderNotifier.value == widget.order) {
        upload();
      } else {
        widget.orderNotifier.addListener(() {
          if (widget.orderNotifier.value == widget.order) {
            upload();
          }
        });
      }
    }
  }

  Future<void> upload() async {
    Options options;
    if (widget.authHeader != null) {
      options = Options(headers: {"Authorization": widget.authHeader});
    }

    bool hasError = false;
    try {
      if (_item is Note) {
        hasError = await handleNote(options, hasError);
      } else if (_item is DbImage) {
        hasError = await handleImage(options, hasError);
      } else if (_item is Log) {
        hasError = await handleLog(options, hasError);
      }
    } catch (e) {
      hasError = true;
      handleError(e);
    }
    if (widget.orderNotifier == null) {
      setState(() {
        _uploading = false;
        _progressString =
            cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
      });
    } else {
      _uploading = false;
      _progressString =
          cancelToken.isCancelled ? "Cancelled by user." : "Completed.";
      if (!hasError) {
        widget.orderNotifier.value = widget.orderNotifier.value + 1;
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String name;
    String description;
    if (_item is Note) {
      name = _item.form == null || _item.form.length == 0
          ? "simple note"
          : "form note";
      description = _item.text;
    } else if (_item is DbImage) {
      name = "image";
      description = _item.text;
    } else if (_item is Log) {
      name = "gps log";
      description = _item.text;
    }
    if (widget.orderNotifier == null) {
      return getTile(name, description);
    } else {
      return ValueListenableBuilder(
        valueListenable: widget.orderNotifier,
        builder: (context, value, child) {
          return getTile(name, description);
        },
      );
    }
  }

  Widget getTile(String name, String description) {
    return ListTile(
      leading: _uploading
          ? CircularProgressIndicator()
          : _errorString.length > 0
              ? Icon(
                  ICONS.SmashIcons.finishedError,
                  color: SmashColors.mainSelection,
                )
              : Icon(
                  ICONS.SmashIcons.finishedOk,
                  color: SmashColors.mainDecorations,
                ),
      title: Text(name),
      subtitle: _errorString.length == 0
          ? (_uploading ? Text(_progressString) : Text(description))
          : SmashUI.normalText(_errorString,
              bold: true, color: SmashColors.mainSelection),
//      trailing: Icon(
//        ICONS.SmashIcons.upload,
//        color: SmashColors.mainDecorations,
//      ),
      onTap: () {},
    );
  }

  Future<bool> handleLog(Options options, bool hasError) async {
    Log log = _item;
    LogProperty props = await widget._projectDb.getLogProperties(log.id);

    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.LOG_OBJID))
      ..add(MapEntry(LOGS_COLUMN_ID, "${log.id}"))
      ..add(MapEntry(LOGS_COLUMN_TEXT, log.text))
      ..add(MapEntry(LOGS_COLUMN_STARTTS, "${log.startTime}"))
      ..add(MapEntry(LOGS_COLUMN_ENDTS, "${log.endTime}"))
      ..add(MapEntry(LOGSPROP_COLUMN_WIDTH, "${props.width ?? 3}"))
      ..add(MapEntry(LOGSPROP_COLUMN_VISIBLE, "${props.isVisible ?? 1}"))
      ..add(MapEntry(LOGSPROP_COLUMN_COLOR, "${props.color ?? "#FF0000"}"));

    List<LogDataPoint> logPoints =
        await widget._projectDb.getLogDataPoints(log.id);
    List<Map<String, dynamic>> logPointsList = [];
    for (var logPoint in logPoints) {
      logPointsList.add(logPoint.toMap());
    }
    var logsJson = jsonEncode(logPointsList);
    formData.fields.add(MapEntry(TABLE_GPSLOG_DATA, logsJson));

    await widget._dio.post(
      widget._uploadUrl,
      data: formData,
      options: options,
      onSendProgress: (received, total) {
        var msg;
        if (total <= 0) {
          msg =
              "Uploading ${(received / 1024.0 / 1024.0).round()}MB, please wait...";
        } else {
          msg = ((received / total) * 100.0).toStringAsFixed(0) + "%";
        }
        setState(() {
          _uploading = true;
          _progressString = msg;
        });
      },
      cancelToken: cancelToken,
    ).catchError((err) {
      hasError = true;
      handleError(err);
    });
    if (!cancelToken.isCancelled && !hasError) {
      log.isDirty = 0;
      widget._projectDb.updateLogDirty(log.id, false);
    }
    return hasError;
  }

  Future<bool> handleImage(Options options, bool hasError) async {
    DbImage image = _item;
    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.IMAGE_OBJID))
      ..add(MapEntry(IMAGES_COLUMN_ID, "${image.id}"))
      ..add(MapEntry(IMAGES_COLUMN_TEXT, image.text))
      ..add(MapEntry(IMAGES_COLUMN_IMAGEDATA_ID, "${image.imageDataId}"))
      ..add(MapEntry(IMAGES_COLUMN_TS, "${image.timeStamp}"))
      ..add(MapEntry(IMAGES_COLUMN_LON, "${image.lon}"))
      ..add(MapEntry(IMAGES_COLUMN_LAT, "${image.lat}"))
      ..add(MapEntry(IMAGES_COLUMN_ALTIM, "${image.altim}"));
    if (image.noteId != null) {
      formData.fields..add(MapEntry(IMAGES_COLUMN_NOTE_ID, "${image.noteId}"));
    }
    var imageBytes =
        await widget._projectDb.getImageDataBytes(image.imageDataId);
    formData.files.add(MapEntry(
      TABLE_IMAGE_DATA,
      MultipartFile.fromBytes(imageBytes, filename: image.text),
    ));

    await widget._dio.post(
      widget._uploadUrl,
      data: formData,
      options: options,
      onSendProgress: (received, total) {
        print("$received / $total");
        var msg;
        if (total <= 0) {
          msg =
              "Uploading ${(received / 1024.0 / 1024.0).round()}MB, please wait...";
        } else {
          msg = ((received / total) * 100.0).toStringAsFixed(0) + "%";
        }
        setState(() {
          _uploading = true;
          _progressString = msg;
        });
      },
      cancelToken: cancelToken,
    ).catchError((err) {
      hasError = true;
      handleError(err);
    });
    if (!cancelToken.isCancelled && !hasError) {
      image.isDirty = 0;
      widget._projectDb.updateImageDirty(image.id, false);
    }
    return hasError;
  }

  Future<bool> handleNote(Options options, bool hasError) async {
    Note note = _item;
    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.NOTE_OBJID))
      ..add(MapEntry(NOTES_COLUMN_ID, "${note.id}"))
      ..add(MapEntry(NOTES_COLUMN_TEXT, note.text))
      ..add(MapEntry(NOTES_COLUMN_DESCRIPTION, note.description))
      ..add(MapEntry(NOTES_COLUMN_TS, "${note.timeStamp}"))
      ..add(MapEntry(NOTES_COLUMN_LON, "${note.lon}"))
      ..add(MapEntry(NOTES_COLUMN_LAT, "${note.lat}"))
      ..add(MapEntry(NOTES_COLUMN_ALTIM, "${note.altim}"));
    if (note.style != null) {
      formData.fields.add(MapEntry(NOTES_COLUMN_STYLE, note.style));
    }
    if (note.form != null) {
      formData.fields.add(MapEntry(NOTES_COLUMN_FORM, note.form));

      List<String> imageIds = FormUtilities.getImageIds(note.form);
      if (imageIds.isNotEmpty) {
        List<MapEntry<String, MultipartFile>> mapEntriesList = [];
        for (var imageId in imageIds) {
          var dbImage =
              await widget._projectDb.getImageById(int.parse(imageId));
          var imageBytes =
              await widget._projectDb.getImageDataBytes(dbImage.imageDataId);

          MapEntry<String, MultipartFile> multipartFile = MapEntry("files[]",
              MultipartFile.fromBytes(imageBytes, filename: dbImage.text));
          mapEntriesList.add(multipartFile);
        }
        formData.files.addAll(mapEntriesList);
      }
    }
    // TODO add note ext data

    await widget._dio.post(
      widget._uploadUrl,
      data: formData,
      options: options,
      onSendProgress: (received, total) {
        var msg;
        if (total <= 0) {
          msg =
              "Uploading ${(received / 1024.0 / 1024.0).round()}MB, please wait...";
        } else {
          msg = ((received / total) * 100.0).toStringAsFixed(0) + "%";
        }
        setState(() {
          _uploading = true;
          _progressString = msg;
        });
      },
      cancelToken: cancelToken,
    ).catchError((err) {
      hasError = true;
      handleError(err);
    });
    if (!cancelToken.isCancelled && !hasError) {
      widget._projectDb.updateNoteDirty(note.id, false);
    }
    return hasError;
  }

  void handleError(err) {
    if (err is DioError) {
      if (err.message.contains("403")) {
        _errorString = "Permission on server denied.";
      } else {
        _errorString = err.message;
      }
    } else {
      _errorString = err.toString();
    }
  }
}
