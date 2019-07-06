/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geopaparazzi_light/eu/geopaparazzi/library/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const bool alsoVideo = false;

openCamera(BuildContext context, Function onCameraFileFunction) async {
  var cameras = await availableCameras();

  var controller = CameraController(
    cameras[0],
    ResolutionPreset.medium,
    enableAudio: true,
  );
  await controller.initialize();
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CameraWidget(cameras, controller, onCameraFileFunction)));
}

class CameraWidget extends StatefulWidget {
  List<CameraDescription> _cameras;
  var _controller;
  Function _onCameraFileFunction;

  CameraWidget(this._cameras, this._controller, this._onCameraFileFunction);

  @override
  _CameraWidgetState createState() {
    return _CameraWidgetState(_cameras, _controller);
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  static const HIGH = "high";
  static const MEDIUM = "medium";
  static const LOW = "low";
  CameraController _controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  ResolutionPreset resolutionPreset;

  var _cameras;

  _CameraWidgetState(this._cameras, this._controller);

  @override
  void initState() {
    resolutionPreset = _controller.resolutionPreset;
    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        onNewCameraSelected(_controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentPreset = MEDIUM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color:
                      _controller != null && _controller.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          _cameraTogglesRowWidget(),
          Spacer(flex: 1),
          _captureControlRowWidget(),
          Spacer(flex: 1),
          DropdownButton(
            value: _currentPreset,
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                  value: HIGH,
                  child: Text(
                    HIGH,
                  )),
              DropdownMenuItem(
                  value: MEDIUM,
                  child: Text(
                    MEDIUM,
                  )),
              DropdownMenuItem(
                  value: LOW,
                  child: Text(
                    LOW,
                  )),
            ],
            onChanged: (selected) {
              if (selected == HIGH) {
                resolutionPreset = ResolutionPreset.high;
                _currentPreset = HIGH;
              } else if (selected == MEDIUM) {
                resolutionPreset = ResolutionPreset.medium;
                _currentPreset = MEDIUM;
              } else if (selected == LOW) {
                resolutionPreset = ResolutionPreset.low;
                _currentPreset = LOW;
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    var widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: EdgeInsets.only(right: alsoVideo ? 0.0 : 8.0),
        child: IconButton(
          icon: const Icon(Icons.camera_alt),
          iconSize: 48.0,
          color: SmashColors.mainDecorations,
          onPressed: _controller != null &&
                  _controller.value.isInitialized &&
                  !_controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
      ),
    );
    if (alsoVideo) {
      widgets.add(IconButton(
        icon: const Icon(Icons.videocam),
        color: SmashColors.mainDecorations,
        onPressed: _controller != null &&
                _controller.value.isInitialized &&
                !_controller.value.isRecordingVideo
            ? onVideoRecordButtonPressed
            : null,
      ));

      widgets.add(IconButton(
        icon: const Icon(Icons.stop),
        color: SmashColors.mainDecorations,
        onPressed: _controller != null &&
                _controller.value.isInitialized &&
                _controller.value.isRecordingVideo
            ? onStopButtonPressed
            : null,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (widget._cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in widget._cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: _controller?.description,
              value: cameraDescription,
              onChanged:
                  _controller != null && _controller.value.isRecordingVideo
                      ? null
                      : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      resolutionPreset,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });

        if (filePath != null) {
          widget._onCameraFileFunction(filePath);
//          showInSnackBar('Picture saved to $filePath');
        }
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
