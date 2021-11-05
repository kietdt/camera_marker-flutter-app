import 'dart:io';

import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/view/screen/result/result_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultCtr extends BaseController<ResultState> {
  ResultCtr(ResultState state) : super(state) {
    String? _url = state.widget.payload?.result?.image;
    iamge = FileImage(File(_url ?? "")).obs;
  }

  late Rx<ImageProvider> iamge;
}
