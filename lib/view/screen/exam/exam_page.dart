import 'package:camera_marker/base/base_activity.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

import 'exam_ctr.dart';

class ExamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExamPageState();
  }
}

class ExamPageState extends BaseActivity<ExamPage, ExamPageCtr> {
  @override
  void initState() {
    appBar = BaseAppBar(back: true, text: "Kì thi").toAppBar();
    super.initState();
  }

  @override
  ExamPageCtr initController() {
    return ExamPageCtr(this);
  }

  @override
  Widget body() {
    return controller!.exams.length > 0 ? SizedBox() : empty();
  }

  @override
  Widget floatingActionButton() {
    return Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(right: 30, bottom: 30),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: ResourceManager().color!.primary, width: 2)),
        child: InkWell(
            onTap: controller!.addExam,
            child: Icon(Icons.add, color: ResourceManager().color!.primary)));
  }

  Widget empty() {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Image.asset("lib/asset/ic_empty.png",
          width: 100, height: 100, color: ResourceManager().color!.primary),
      SizedBox(height: 10),
      Text("Chưa có kì thi nào",
          style: ResourceManager()
              .text!
              .normalStyle
              .copyWith(color: ResourceManager().color!.primary, fontSize: 16))
    ]));
  }
}
