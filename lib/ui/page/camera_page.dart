import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/utils/log.dart';
import 'package:path/path.dart' as pathDart;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const _tag = "camera_page";

class CameraPage extends StatefulWidget {
  static const routeName = '/camera';

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final enableChangeMode = false;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  Future<List<CameraDescription>> cameras = availableCameras();
  int cameraIndex = 0;
  bool isVideoMode = true;
  bool isRecording = false;
  Flash flash = Flash.AUTO;
  String path;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          camera(),
          TopButtonsRow(flash, isVideoMode, onFlashClicked),
          bottomButtonsRow(),
        ],
      ),
    );
  }

  camera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator
          return Container(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  bottomButtonsRow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isRecording) Chronometer(),
          Material(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Container(
                height: 96,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.switch_camera,
                      ),
                      onPressed: () async {
                        cameraIndex =
                            (cameraIndex + 1) % ((await cameras).length);
                        initializeCamera();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isRecording ? Icons.stop : Icons.brightness_1,
                        color: isVideoMode ? Colors.red : null,
                      ),
                      iconSize: 72,
                      onPressed: () async {
                        if (isVideoMode) {
                          if (isRecording) {
                            await _controller.stopVideoRecording();
                            _uploadVideo();
                          } else {
                            path = await getNewPath();
                            await _controller.startVideoRecording(path);
                          }
                          setState(() {
                            isRecording = !isRecording;
                          });
                        } else {
                          await _controller.takePicture(path);
                        }
                      },
                    ),
                    Opacity(
                      opacity: enableChangeMode ? 1.0 : 0.0,
                      child: IconButton(
                        icon: Icon(
                          isVideoMode ? Icons.photo_camera : Icons.videocam,
                        ),
                        onPressed: () {
                          setState(() {
                            isVideoMode = !isVideoMode;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getNewPath() async {
    return pathDart.join(
      (await getApplicationDocumentsDirectory()).path,
      '${DateTime.now()}' + (isVideoMode ? '.mp4' : '.png'),
    );
  }

  initializeCamera() {
    _initializeControllerFuture = cameras.then((cameras) async {
      await _controller?.dispose();

      _controller = CameraController(
          cameras.elementAt(cameraIndex), ResolutionPreset.high);

      // If the controller is updated then update the UI.
      _controller.addListener(() {
        if (mounted) setState(() {});
      });

      await _controller.initialize();

      if (mounted) {
        setState(() {});
      }
    });

    setState(() {});
  }

  onFlashClicked() {
    setState(() {
      switch (flash) {
        case Flash.OFF:
          flash = Flash.ON;
          break;
        case Flash.ON:
          flash = Flash.AUTO;
          break;
        case Flash.AUTO:
          flash = Flash.OFF;
          break;
      }
    });
  }

  void _uploadVideo() async {
    Log.d(_tag, "Upload video");
    final _apiService = Provider.of<ApiService>(context);
    final urlResponse = await _apiService.getContentUrl();
    if (urlResponse == null) {
      Log.e(_tag, "Can't get url");
    } else {
      final uploadResponse =
          await _apiService.uploadVideo(File(path).path, urlResponse.uploadLink);
      if (uploadResponse == null) {
        Log.e(_tag, "Can't upload video");
      } else {
        Log.d(_tag, "Succes uploaded");
        final sendResponse = await _apiService.sendVideo(
          urlResponse.downloadLink,
          "anus",
        );
        if (sendResponse == null) {
          Log.e(_tag, "Can't send video");
        } else {
          Log.e(_tag, "Succes sended");
        }
      }
    }
  }
}

class TopButtonsRow extends StatelessWidget {
  TopButtonsRow(this.flash, this.showMicOff, this.onFlashClicked);

  final Flash flash;

  final bool showMicOff;

  final VoidCallback onFlashClicked;

  @override
  Widget build(BuildContext context) {
    IconData flashIconData;

    switch (flash) {
      case Flash.OFF:
        flashIconData = Icons.flash_off;
        break;
      case Flash.ON:
        flashIconData = Icons.flash_on;
        break;
      case Flash.AUTO:
        flashIconData = Icons.flash_auto;
        break;
    }

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              if (showMicOff) Icon(Icons.mic_off, color: Colors.grey[500]),
              IconButton(
                icon: Icon(
                  flashIconData,
                  color: Colors.white,
                ),
                onPressed: () {
                  onFlashClicked();

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text("Not supported in camera plugin"),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chronometer extends StatefulWidget {
  @override
  _ChronometerState createState() => _ChronometerState();
}

class _ChronometerState extends State<Chronometer> {
  DateTime startTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(Duration(seconds: 1)),
      builder: (context, _) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0x77000000),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  recordedTimeStr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
              ),
              Icon(
                Icons.fiber_manual_record,
                color: Colors.red,
                size: 20,
              )
            ],
          ),
        );
      },
    );
  }

  String recordedTimeStr() {
    Duration recordTime = DateTime.now().difference(startTime);

    int minutes = recordTime.inMinutes;
    int seconds = recordTime.inSeconds % 60;

    String minutesStr;
    String secondsStr;

    if (minutes < 10) {
      minutesStr = "0$minutes";
    } else {
      minutesStr = "$minutes";
    }

    if (seconds < 10) {
      secondsStr = "0$seconds";
    } else {
      secondsStr = "$seconds";
    }

    return "$minutesStr:$secondsStr";
  }
}

enum Flash { OFF, ON, AUTO }
