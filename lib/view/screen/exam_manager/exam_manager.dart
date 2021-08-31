import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

import 'exam_manager_ctr.dart';

class ExamManagerPayLoad {
  final Exam? exam;

  ExamManagerPayLoad(this.exam);
}

class ExamManager extends StatefulWidget {
  final ExamManagerPayLoad? payload;

  const ExamManager({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExamManagerState();
  }
}

class ExamManagerState extends BaseScaffold<ExamManager, ExamManagerCtr> {
  @override
  ExamManagerCtr initController() {
    return ExamManagerCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Quản Lý Kì Thi").toAppBar();
  }

  @override
  Widget body() {
    return SizedBox();
  }
}
