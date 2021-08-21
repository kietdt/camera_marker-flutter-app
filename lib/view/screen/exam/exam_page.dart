import 'package:camera_marker/base/base_activity.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/view/child/empty_page.dart';
import 'package:camera_marker/view/child/floating_action_add.dart';
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
    return FloatingActionAdd(
      onTap: controller!.addExam,
    );
  }

  Widget empty() {
    return EmptyPageView(message: "Chưa có kì thi nào");
  }
}
