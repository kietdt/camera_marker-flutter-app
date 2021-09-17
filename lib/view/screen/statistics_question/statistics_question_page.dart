import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

import 'statistics_question_ctr.dart';

class StatisticsQuestionPagePayload {
  final Exam? exam;
  final Answer? answer;

  StatisticsQuestionPagePayload({this.exam, this.answer});
}

class StatisticsQuestionPage extends StatefulWidget {
  final StatisticsQuestionPagePayload? payload;

  const StatisticsQuestionPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatisticsQuestionState();
  }
}

class StatisticsQuestionState
    extends BaseScaffold<StatisticsQuestionPage, StatisticsQuestionCtr> {
  @override
  StatisticsQuestionCtr initController() {
    return StatisticsQuestionCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Tỉ lệ đúng").toAppBar();
  }

  @override
  Widget body() {
    return Column(
      children: [header()],
    );
  }

  Widget header() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: controller.mainPadding)
            .copyWith(top: controller.mainPadding),
        padding: EdgeInsets.all(controller.mainPadding).copyWith(right: 0),
        decoration: BoxDecoration(
            color: ResourceManager().color.card,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              )
            ]),
        child: _item(title: "Câu hỏi", content: "Tỉ lệ đúng (%)"));
  }

  Widget _item({String? title, String? content}) {
    TextStyle _style = ResourceManager()
        .text
        .boldStyle
        .copyWith(fontSize: 17, color: ResourceManager().color.primary);
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: Text(
              title ?? "",
              textAlign: TextAlign.start,
              style: _style,
            )),
        Expanded(
          flex: 4,
          child: Text(
            content ?? "",
            textAlign: TextAlign.start,
            style: _style,
          ),
        )
      ],
    );
  }
}
