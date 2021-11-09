import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/mix/camera_handler.dart';
import 'package:camera_marker/mix/permission_mix.dart';
import 'package:camera_marker/mix/rotate_mix.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/draw_info.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/recognition.dart';
import 'package:camera_marker/model/result.dart';
import 'package:camera_marker/service/image_result_processor_service.dart';
import 'package:camera_marker/service/method_channelling/yuv_chanelling.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/dialog/dialog_noti.dart';
import 'package:camera_marker/view/screen/answer_fill/answer_fill_page.dart';
import 'package:camera_marker/view/screen/result/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'yuv_transform_screen.dart';

class YuvTransformScreenCtr extends BaseController<YuvTransformScreenState>
    with CameraHandler, RotateMix, PermissionMix {
  YuvTransformScreenCtr(YuvTransformScreenState state) : super(state) {
    initCamera();

    //TODO: fake data

    // if (isFill) {
    //   showLoading();
    //   Future.delayed(Duration(milliseconds: 1000)).then((value) {
    //     hideLoading();
    //     onScanFill(Answer.sample4);
    //   });
    // } else {
    //   showLoading();
    //   Future.delayed(Duration(milliseconds: 1000)).then((value) {
    //     hideLoading();
    //     onScanResult(Result.result4);
    //   });
    // }
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

  bool get isFill => state.widget.payload?.type == YuvTransformScreenType.Fill;

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
          print(List.generate(state.widget.payload?.exam?.answer.length ?? 0,
              (index) => state.widget.payload?.exam?.answer[index].toJson()));
          platform.invokeMethod('yuv_transform', {
            'platforms': data,
            'height': image.height,
            'width': image.width,
            'strides': strides,
            'type': isFill ? "answer" : "result",
            // 'type': "test",
            'template_id': state.widget.payload?.exam?.templateId,
            'exam': {
              'title': state.widget.payload?.exam?.title ?? "",
              'class_code': state.widget.payload?.exam?.myClass?.code ?? "",
            },
            'answer': List.generate(
                state.widget.payload?.exam?.answer.length ?? 0,
                (index) => state.widget.payload?.exam?.answer[index].toJson())
          }).then((value) async {
            print("==========Value gửi từ native===========>$value");

            Map<String, dynamic> _json = json.decode(value);
            if ((_json["answer"] ?? false)) {
              if (isFill) {
                await onScanFill(_json);
              } else {
                await onScanResult(_json);
              }
            } else {
              onResult(_json, image);
            }
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
    print(value);
    DrawInfo data = DrawInfo.fromJson(value);
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

  Future<void> onScanFill(Map<String, dynamic> json) async {
    Answer answer = Answer.fromJson(json);
    cameraCtr?.dispose();
    await Get.toNamed(RouteManager().routeName.answerFill,
        arguments: AnswerFillPayload.addNew(
            exam: state.widget.payload?.exam, answer: answer, fromScan: true));
    initCamera();
  }

  Future<void> onScanResult(Map<String, dynamic> json) async {
    Exam? exam = DataBaseCtr().tbExam.getById(state.widget.payload?.exam?.id);
    Result result = Result.fromJson(json);

    cameraCtr?.dispose();

    result.correct =
        DataBaseCtr().tbExam.getById(exam?.id)?.correct(result) ?? 0;
    result.question = exam?.question;
    result.examId = exam?.id;

    if ((result.correct ?? -1) <= -1) {
      await DialogNoti.show(message: "Không tồn tại mã đề ${result.examCode}");
    } else {
      await resultProcess(result: result, exam: exam);
    }

    initCamera();
  }

  Future<void> resultProcess({Result? result, Exam? exam}) async {
    Result? _history;
    int index = exam?.result.indexWhere(
            (element) => element.studentCode == result?.studentCode) ??
        -1;

    if (index >= 0) {
      _history = exam?.result[index];
    }

    if (_history != null) {
      var _callBack = await DialogConfirm.show(
          message:
              "Mã số sinh viên ${result?.studentCode} đã được chấm trước đó, bạn có muốn cập nhật kết quả mới?",
          rightTitle: "Cập nhật");
      if (_callBack is String && _callBack == DialogConfirm.CALLBACK_ONRIGHT) {
        _history.value = result?.value;
        _history.correct = result?.correct;
        await DataBaseCtr().tbResult.updateResult(_history);
        await navigateResult(result: _history, exam: exam);
      }
    } else {
      result?.id = await DataBaseCtr().tbResult.addNewResult(result);
      await DataBaseCtr().tbExam.addResult(exam: exam, result: result);
      await navigateResult(result: result, exam: exam);
    }
  }

  Future<void> navigateResult({Result? result, Exam? exam}) async {
    if (result != null) {
      // if (!(result.image?.contains(result.pngName) ?? false)) {
      //   //copy file ảnh từ native sang đường dẫn quản lý ở flutter
      //   await Utils.copyFile(result.pngPath, file: File(result.image ?? ""));
      //   // sau khi copy thì xóa file ở native để giải phóng bộ nhớ
      //   // await Utils.deletefile(result.image ?? "");
      // }
      await Get.toNamed(RouteManager().routeName.result,
          arguments: ResultPagePayload(exam: exam, result: result));
    }
  }
}
