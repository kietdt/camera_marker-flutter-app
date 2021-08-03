import 'dart:async';

import 'package:camera_marker/base/base_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bounding_box.dart';
import 'camera_screen.dart';
import 'yuv_transform_creen_ctr.dart';

// typedef void Callback(List<dynamic> list, int h, int w);

class YuvTransformScreen extends StatefulWidget {
  @override
  YuvTransformScreenState createState() => YuvTransformScreenState();
}

class YuvTransformScreenState
    extends BaseActivity<YuvTransformScreen, YuvTransformScreenCtr> {
  @override
  YuvTransformScreenCtr initController() {
    return YuvTransformScreenCtr(this);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose all streams!
    controller!.subscription.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }

  @override
  Future inactive() {
    if (controller!.cameraCtr != null &&
        controller!.cameraCtr!.value.isInitialized) {
      controller!.cameraCtr?.dispose();
    }
    // controller!.resetRootView();
    return super.inactive();
  }

  @override
  Future resumed() {
    if (controller!.cameraCtr != null &&
        controller!.cameraCtr!.value.isInitialized) {
      controller!.onNewCameraSelected(controller!.cameraCtr!.description);
    }
    return super.resumed();
  }

  @override
  Widget body() {
    return SafeArea(
        child: Stack(children: <Widget>[
      Column(children: <Widget>[
        Expanded(
            child: Obx(() => CameraScreenWidget(
                key: ValueKey(controller!.isAvailable.value),
                controller: controller!.cameraCtr)))
      ]),
      Obx(() => BoundingBox(
          // ignore: invalid_use_of_protected_member
          controller!.recognitions.value,
          controller!.originHeight.value,
          controller!.originWidth.value,
          screen.height - (statusBar + navigateBar),
          screen.width))
    ]));
  }
}
