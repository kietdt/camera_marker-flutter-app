import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/mix/camera_handler.dart';
import 'package:camera_marker/mix/permission_mix.dart';
import 'package:camera_marker/mix/rotate_mix.dart';
import 'package:camera_marker/model/draw_info.dart';
import 'package:camera_marker/model/recognition.dart';
import 'package:camera_marker/service/image_result_processor_service.dart';
import 'package:camera_marker/service/method_channelling/yuv_chanelling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'yuv_transform_screen.dart';

class YuvTransformScreenCtr extends BaseController<YuvTransformScreenState>
    with CameraHandler, RotateMix, PermissionMix {
  YuvTransformScreenCtr(YuvTransformScreenState state) : super(state) {
    initCamera();
  }

  List<StreamSubscription> subscription = [];
  late ImageResultProcessorService imageResultProcessorService;
  bool _isProcessing = false;
  YuvChannelling yuvChannelling = YuvChannelling();
  MethodChannel platform =
      const MethodChannel('tomer.blecher.yuv_transform/yuv');

  //observe value
  var recognitions = List<Recognition>.empty(growable: true).obs;
  RxDouble originHeight = 0.0.obs;
  RxDouble originWidth = 0.0.obs;
  RxString isAvailable = Uuid().v4().obs; // camera available

  void initCamera() async {
    await requestCameraPermission();
    // Fetch all available cameras.
    cameras = await availableCameras();
    imageResultProcessorService = ImageResultProcessorService();
    subscription.add(imageResultProcessorService.queue.listen((event) {
      _isProcessing = false;
    }));
    onNewCameraSelected(cameras[cameraType]);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraCtr != null) {
      await cameraCtr?.dispose();
    }
    cameraCtr = CameraController(cameraDescription, ResolutionPreset.medium,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    // If the cameraCtr is updated then update the UI.
    cameraCtr!.addListener(() {
      resetCameraView();
      if (cameraCtr!.value.hasError) {
        print("Camera error: ${cameraCtr!.value.errorDescription}");
      }
    });

    try {
      showLoading();
      await cameraCtr!.initialize().then((_) {
        cameraCtr!.startImageStream((CameraImage image) async {
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
      hideLoading();
    } on CameraException catch (e) {
      showCameraException(e);
    }
    resetCameraView();
  }

  void resetCameraView() {
    isAvailable.value = Uuid().v4();
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

    List<Recognition> recognitions = [];
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

        recognitions.add(Recognition(
            offset: Offset(pointShift.dx, pointShift.dy),
            size: Size(rectSize.width, rectSize.height),
            detectedClass: "${points[4]}",
            confidenceInClass: rng.nextInt(100)));
      }
    }
    setRecognitions(
        recognitions, image.height.toDouble(), image.width.toDouble());
  }

  // void _processCameraImage(CameraImage image) async {
  //   // if (_isProcessing)
  //   //   return; //Do not detect another image until you finish the previous.
  //   // _isProcessing = true;
  //   await yuvChannelling.yuv_transform(image);
  // }

  /* 
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  void setRecognitions(
      List<Recognition> recognitions, double imageHeight, double imageWidth) {
    this.recognitions.value = List<Recognition>.from(recognitions);
    this.originHeight.value = imageHeight;
    this.originWidth.value = imageWidth;
  }
}