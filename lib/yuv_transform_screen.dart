import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:camera_marker/mix/rotate_mix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera_marker/camera_handler.dart';
import 'package:camera_marker/service/image_result_processor_service.dart';
import 'package:camera_marker/method_channelling/yuv_chanelling.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'bounding_box.dart';
import 'camera_screen.dart';
import 'model/draw_info.dart';

// typedef void Callback(List<dynamic> list, int h, int w);

class YuvTransformScreen extends StatefulWidget {
  @override
  _YuvTransformScreenState createState() => _YuvTransformScreenState();
}

class _YuvTransformScreenState extends State<YuvTransformScreen>
    with CameraHandler, WidgetsBindingObserver, RotateMix {
  List<StreamSubscription> _subscription = [];
  late ImageResultProcessorService _imageResultProcessorService;
  bool _isProcessing = false;
  YuvChannelling _yuvChannelling = YuvChannelling();
  MethodChannel platform =
      const MethodChannel('tomer.blecher.yuv_transform/yuv');

  late List<dynamic> recognitions = [];
  double originHeight = 0;
  double originWidth = 0;

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
            onResult(value, image);
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

  void onResult(dynamic value, CameraImage image) {
    DrawInfo data = DrawInfo.fromJson(json.decode(value));
    // chiều dài của ảnh khi xử lý ở native
    double rotateWidth = data.width!;
    // chiều cao của ảnh khi xử lý ở native
    double rotateHeight = data.height!;
    // góc xoay ảnh ở native
    num radians = (3 * pi / 2);

    final parsedList = data.points;

    // khởi tạo ma trận affine
    initMatrix(radians);

    final recognitions = [];
    if (parsedList != null) {
      for (var points in parsedList) {
        var rng = Random();
        // dời gốc tọa độ vào trọng tâm của hình để sử dụng affine rotate
        // vì hệ tọa độ đang xử lý có y hướng xuống
        // nên phải đổi point[1] => -point[1]
        // để sử dụng thuật toán affine
        Offset pointShift = shiftPoint(Offset(points[0], -points[1]),
            Offset(rotateWidth / 2, -rotateHeight / 2));
        // tìm tọa độ góc trái trên của rectangle sau khi xoay
        List<double> rectangle =
            topLeftRotate(pointShift, Size(points[2], points[3]));
        // xoay tọa độ bằng cách nhân tọa độ với ma trận affine
        pointShift = Offset(rectangle[0], rectangle[1]);
        // xoay cạnh của ảnh
        Size rectSize = Size(rectangle[2], rectangle[3]);
        // dời lại gốc tọa độ lên góc trái trên để vẽ ô vuông
        // sử dụng chiều dại và chiều rộng của ảnh sau khi đã rotate, tức là chiều dài của ảnh trước khi gửi qua native
        pointShift =
            shiftPoint(pointShift, Offset(-originWidth / 2, originHeight / 2));
        pointShift = Offset(pointShift.dx, -pointShift.dy);

        recognitions.add({
          "rect": {
            "x": pointShift.dx,
            "y": pointShift.dy,
            "w": rectSize.width,
            "h": rectSize.height,
          },
          "detectedClass": "${points[4]}",
          "confidenceInClass": rng.nextInt(100),
        });
      }
    }
    setRecognitions(
        recognitions, image.height.toDouble(), image.width.toDouble());
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
    this.originHeight = imageHeight;
    this.originWidth = imageWidth;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double statusBar = MediaQuery.of(context).padding.top;
    double navigateBar = MediaQuery.of(context).padding.bottom;

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
              this.originHeight,
              this.originWidth,
              screen.height - (statusBar + navigateBar),
              screen.width,
            ),
          ],
        ),
      ),
    );
  }
}
