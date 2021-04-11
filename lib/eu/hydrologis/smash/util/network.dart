/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:convert';
import 'dart:io';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/gss/gss_utilities.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/mapsforge.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/images.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/logs.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/notes.dart';
import 'package:smash/eu/hydrologis/smash/project/objects/othertables.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
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
        bool doDownload = await SmashDialogs.showConfirmDialog(
            context,
            SL.of(context).network_download, //"Download"
            "${SL.of(context).network_downloadFile} $name " //"Download file"
            "${SL.of(context).network_toTheDeviceTakeTime}"); //"to the device? This can take some time."
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
    var dbPath = widget._projectDb.path;
    var projectName = FileUtilities.nameFromFile(dbPath, false);
    try {
      if (_item is Note) {
        hasError = await handleNote(options, projectName, hasError);
      } else if (_item is DbImage) {
        hasError = await handleImage(options, projectName, hasError);
      } else if (_item is Log) {
        hasError = await handleLog(options, projectName, hasError);
      }
    } catch (e) {
      hasError = true;
      handleError(e);
    }
    if (widget.orderNotifier == null) {
      setState(() {
        _uploading = false;
        _progressString = cancelToken.isCancelled
            ? SL.of(context).network_cancelledByUser //"Cancelled by user."
            : SL.of(context).network_completed; //"Completed."
      });
    } else {
      _uploading = false;
      _progressString = cancelToken.isCancelled
          ? SL.of(context).network_cancelledByUser //"Cancelled by user."
          : SL.of(context).network_completed; //"Completed."
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
                  SmashIcons.finishedError,
                  color: SmashColors.mainSelection,
                )
              : Icon(
                  SmashIcons.finishedOk,
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

  Future<bool> handleLog(
      Options options, String projectName, bool hasError) async {
    Log log = _item;
    LogProperty props = widget._projectDb.getLogProperties(log.id);

    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.LOG_OBJID))
      ..add(MapEntry(PROJECT_NAME, projectName))
      ..add(MapEntry(LOGS_COLUMN_ID, "${log.id}"))
      ..add(MapEntry(LOGS_COLUMN_TEXT, log.text))
      ..add(MapEntry(LOGS_COLUMN_STARTTS, "${log.startTime}"))
      ..add(MapEntry(LOGS_COLUMN_ENDTS, "${log.endTime}"))
      ..add(MapEntry(LOGSPROP_COLUMN_WIDTH, "${props.width ?? 3}"))
      ..add(MapEntry(LOGSPROP_COLUMN_VISIBLE, "${props.isVisible ?? 1}"))
      ..add(MapEntry(LOGSPROP_COLUMN_COLOR, "${props.color ?? "#FF0000"}"));

    List<LogDataPoint> logPoints = widget._projectDb.getLogDataPoints(log.id);
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
              "${SL.of(context).network_uploading} ${(received / 1024.0 / 1024.0).round()}MB, ${SL.of(context).network_pleaseWait}"; //Uploading //please wait...
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

  Future<bool> handleImage(
      Options options, String projectName, bool hasError) async {
    DbImage image = _item;
    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.IMAGE_OBJID))
      ..add(MapEntry(PROJECT_NAME, projectName))
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
    var imageBytes = widget._projectDb.getImageDataBytes(image.imageDataId);
    formData.files.add(MapEntry(
      TABLE_IMAGE_DATA + "_" + IMAGESDATA_COLUMN_IMAGE,
      MultipartFile.fromBytes(imageBytes, filename: image.text),
    ));

    var thumbBytes = widget._projectDb.getThumbnailBytes(image.imageDataId);
    formData.files.add(MapEntry(
      TABLE_IMAGE_DATA + "_" + IMAGESDATA_COLUMN_THUMBNAIL,
      MultipartFile.fromBytes(thumbBytes, filename: image.text),
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
              "${SL.of(context).network_uploading} ${(received / 1024.0 / 1024.0).round()}MB, ${SL.of(context).network_pleaseWait}"; //Uploading //please wait...
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

  Future<bool> handleNote(
      Options options, String projectName, bool hasError) async {
    Note note = _item;
    var formData = FormData();
    formData.fields
      ..add(MapEntry(GssUtilities.OBJID_TYPE_KEY, GssUtilities.NOTE_OBJID))
      ..add(MapEntry(PROJECT_NAME, projectName))
      ..add(MapEntry(NOTES_COLUMN_ID, "${note.id}"))
      ..add(MapEntry(NOTES_COLUMN_TEXT, note.text))
      ..add(MapEntry(NOTES_COLUMN_DESCRIPTION, note.description))
      ..add(MapEntry(NOTES_COLUMN_TS, "${note.timeStamp}"))
      ..add(MapEntry(NOTES_COLUMN_LON, "${note.lon}"))
      ..add(MapEntry(NOTES_COLUMN_LAT, "${note.lat}"))
      ..add(MapEntry(NOTES_COLUMN_ALTIM, "${note.altim}"));
    if (note.form != null) {
      formData.fields.add(MapEntry(NOTES_COLUMN_FORM, note.form));

      List<String> imageIds = FormUtilities.getImageIds(note.form);

      if (imageIds.isNotEmpty) {
        for (var imageId in imageIds) {
          var dbImage = widget._projectDb.getImageById(int.parse(imageId));
          var imageBytes =
              widget._projectDb.getImageDataBytes(dbImage.imageDataId);
          var thumbBytes =
              widget._projectDb.getThumbnailBytes(dbImage.imageDataId);
          var key =
              "${TABLE_IMAGE_DATA}_${IMAGESDATA_COLUMN_IMAGE}_${dbImage.id}";
          formData.files.add(MapEntry(
            key,
            MultipartFile.fromBytes(imageBytes, filename: dbImage.text),
          ));
          key =
              "${TABLE_IMAGE_DATA}_${IMAGESDATA_COLUMN_THUMBNAIL}_${dbImage.id}";
          formData.files.add(MapEntry(
            key,
            MultipartFile.fromBytes(thumbBytes, filename: dbImage.text),
          ));
        }
      }
    }

    NoteExt noteExt = note.noteExt;
    if (noteExt != null) {
      formData.fields
        ..add(MapEntry(NOTESEXT_COLUMN_MARKER, noteExt.marker))
        ..add(MapEntry(NOTESEXT_COLUMN_SIZE, "${noteExt.size}"))
        ..add(MapEntry(NOTESEXT_COLUMN_ROTATION, "${noteExt.rotation}"))
        ..add(MapEntry(NOTESEXT_COLUMN_COLOR, noteExt.color))
        ..add(MapEntry(NOTESEXT_COLUMN_ACCURACY, "${noteExt.accuracy}"))
        ..add(MapEntry(NOTESEXT_COLUMN_HEADING, "${noteExt.heading}"))
        ..add(MapEntry(NOTESEXT_COLUMN_SPEED, "${noteExt.speed}"))
        ..add(MapEntry(
            NOTESEXT_COLUMN_SPEEDACCURACY, "${noteExt.speedaccuracy}"));
    }

    await widget._dio.post(
      widget._uploadUrl,
      data: formData,
      options: options,
      onSendProgress: (received, total) {
        var msg;
        if (total <= 0) {
          msg =
              "${SL.of(context).network_uploading} ${(received / 1024.0 / 1024.0).round()}MB, ${SL.of(context).network_pleaseWait}"; //Uploading //please wait...
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
        _errorString = SL
            .of(context)
            .network_permissionOnServerDenied; //"Permission on server denied."
      } else if (err.message.contains("Connection refused")) {
        _errorString = SL
            .of(context)
            .network_couldNotConnectToServer; //"Could not connect to the server. Is it online? Check your address."
      } else {
        _errorString = err.message;
      }
    } else {
      _errorString = err.toString();
    }
  }
}
