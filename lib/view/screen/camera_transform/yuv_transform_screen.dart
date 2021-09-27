import 'dart:async';
import 'dart:math';

import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bounding_box.dart';
import 'camera_screen.dart';
import 'yuv_transform_creen_ctr.dart';

// typedef void Callback(List<dynamic> list, int h, int w);

enum YuvTransformScreenType { Fill, Result }

class YuvTransformScreenPayload {
  final YuvTransformScreenType? type;
  final Exam? exam;

  YuvTransformScreenPayload({this.type, this.exam});

  factory YuvTransformScreenPayload.fill({Exam? exam}) =>
      YuvTransformScreenPayload(type: YuvTransformScreenType.Fill, exam: exam);

  factory YuvTransformScreenPayload.result({Exam? exam}) =>
      YuvTransformScreenPayload(
          type: YuvTransformScreenType.Result, exam: exam);
}

class YuvTransformScreen extends StatefulWidget {
  final YuvTransformScreenPayload? payload;

  const YuvTransformScreen({Key? key, this.payload}) : super(key: key);

  @override
  YuvTransformScreenState createState() => YuvTransformScreenState();
}

class YuvTransformScreenState
    extends BaseScaffold<YuvTransformScreen, YuvTransformScreenCtr> {
  @override
  YuvTransformScreenCtr initController() {
    return YuvTransformScreenCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(text: "Quét", back: true).toAppBar();
  }

  @override
  void dispose() {
    // Dispose all streams!
    controller.subscription.forEach((element) {
      element.cancel();
    });
    controller.cameraCtr?.dispose();
    super.dispose();
  }

  @override
  Future onInactive() {
    if (controller.cameraCtr != null &&
        controller.cameraCtr!.value.isInitialized) {
      controller.cameraCtr?.dispose();
    }
    // controller.resetRootView();
    return super.onInactive();
  }

  @override
  Future onPaused() {
    if (controller.cameraCtr != null &&
        controller.cameraCtr!.value.isInitialized) {
      controller.cameraCtr?.dispose();
    }
    return super.onPaused();
  }

  @override
  Future onResumed() {
    if (controller.cameraCtr != null &&
        controller.cameraCtr!.value.isInitialized) {
      controller.onNewCameraSelected(controller.cameraCtr!.description);
    }
    return super.onResumed();
  }

  @override
  Widget body() {
    return SafeArea(
        child: Stack(children: <Widget>[
      Column(children: <Widget>[
        Expanded(
            child: Obx(() => CameraScreenWidget(
                key: ValueKey(controller.isAvailable.value),
                controller: controller.cameraCtr)))
      ]),
      Obx(() => BoundingBox(
          // ignore: invalid_use_of_protected_member
          controller.recognitions.value,
          controller.originHeight.value,
          controller.originWidth.value,
          screen.height - (statusBar + navigateBar + BaseAppBar.height),
          screen.width))
    ]));
  }
}
