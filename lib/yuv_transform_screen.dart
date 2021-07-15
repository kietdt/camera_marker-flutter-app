import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera_marker/camera_handler.dart';
import 'package:camera_marker/service/image_result_processor_service.dart';
import 'package:camera_marker/method_channelling/yuv_chanelling.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'bounding_box.dart';
import 'camera_screen.dart';

// typedef void Callback(List<dynamic> list, int h, int w);

class YuvTransformScreen extends StatefulWidget {
  @override
  _YuvTransformScreenState createState() => _YuvTransformScreenState();
}

class _YuvTransformScreenState extends State<YuvTransformScreen>
    with CameraHandler, WidgetsBindingObserver {
  List<StreamSubscription> _subscription = [];
  late ImageResultProcessorService _imageResultProcessorService;
  bool _isProcessing = false;
  YuvChannelling _yuvChannelling = YuvChannelling();
  MethodChannel platform =
      const MethodChannel('tomer.blecher.yuv_transform/yuv');

  late List<dynamic> recognitions = [];
  double imageHeight = 0;
  double imageWidth = 0;

  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;

  @override
  void initState() {
    super.initState();
    // Registers the page to observer for life cycle managing.
    _imageResultProcessorService = ImageResultProcessorService();
    WidgetsBinding.instance!.addObserver(this);
    _subscription.add(_imageResultProcessorService.queue.listen((event) {
      _isProcessing = false;
    }));
    onNewCameraSelected(cameras[cameraType]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    // Dispose all streams!
    _subscription.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller!.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        print("Camera error: ${controller!.value.errorDescription}");
      }
    });

    try {
      await controller!.initialize().then((_) {
        controller!.startImageStream((CameraImage image) async {
          if (_isProcessing) return;
          _isProcessing = true;
          List<int> strides = new Int32List(image.planes.length * 2);
          int index = 0;
          // We need to transform the image to Uint8List so that the native code could
          // transform it to byte[]
          List<Uint8List> data = image.planes.map((plane) {
            strides[index] = (plane.bytesPerRow);
            index++;
            strides[index] = (plane.bytesPerPixel)!;
            index++;
            return plane.bytes;
          }).toList();
          platform.invokeMethod('yuv_transform', {
            'platforms': data,
            'height': image.height,
            'width': image.width,
            'strides': strides
          }).then((value) {
            final parsedList = jsonDecode(value);
            final recognitions = [];
            for (var points in parsedList) {
              var rng = math.Random();
              print(points);
              recognitions.add({
                "rect": {
                  "x": points[0],
                  "y": points[1],
                  "w": points[2],
                  "h": points[3],
                },
                "detectedClass": "${points[4]}",
                "confidenceInClass": rng.nextInt(100),
              });
            }
            setRecognitions(
                recognitions, image.height.toDouble(), image.width.toDouble());
            _isProcessing = false;
          });
        });
      });
    } on CameraException catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    // if (_isProcessing)
    //   return; //Do not detect another image until you finish the previous.
    // _isProcessing = true;
    await _yuvChannelling.yuv_transform(image);
  }

  /* 
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  void setRecognitions(
      List<dynamic> recognitions, double imageHeight, double imageWidth) {
    this.recognitions = recognitions;
    this.imageHeight = imageHeight;
    this.imageWidth = imageWidth;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: CameraScreenWidget(
                    controller: controller,
                  ),
                ),
              ],
            ),
            BoundingBox(
              this.recognitions,
              math.max(this.imageHeight, this.imageWidth),
              math.min(this.imageHeight, this.imageWidth),
              screen.height,
              screen.width,
            ),
          ],
        ),
      ),
    );
  }
}
