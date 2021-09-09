import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'result_ctr.dart';

class ResultPagePayload {
  final Result? result;
  final Exam? exam;

  ResultPagePayload({this.result, this.exam});
}

class ResultPage extends StatefulWidget {
  final ResultPagePayload? payload;

  const ResultPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends BaseScaffold<ResultPage, ResultCtr> {
  @override
  ResultCtr initController() {
    return ResultCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(
            back: true,
            text: "Kết quả - ${widget.payload?.result?.studentCode}")
        .toAppBar();
  }

  @override
  Widget body() {
    return Column(
      children: [
        Text(
            "======${widget.payload?.result?.correct}======${widget.payload?.result?.point.toStringAsFixed(2)}"),
        Obx(() => Center(
              child: FadeInImage(
                  placeholder: AssetImage("lib/asset/loading.gif"),
                  imageErrorBuilder: (_, object, stackTrace) => Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInImage(
                              placeholder: AssetImage("lib/asset/loading.gif"),
                              image: AssetImage("lib/asset/loading.gif")),
                        ],
                      )),
                  image: controller.iamge.value),
            )),
      ],
    );
  }
}
