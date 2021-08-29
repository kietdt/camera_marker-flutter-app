import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/extend/list_select/list_select.dart';
import 'package:flutter/material.dart';

import 'exam_ctr.dart';

class ExamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExamPageState();
  }
}

class ExamPageState extends ListSelect<ExamPage, ExamPageCtr, Exam> {
  @override
  ExamPageCtr initController() {
    return ExamPageCtr(this);
  }

  @override
  Widget child(Exam? item) {
    return Container();
  }
}
