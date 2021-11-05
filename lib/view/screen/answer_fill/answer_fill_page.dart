import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/screen/answer_fill/code_fill_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'answer_fill_ctr.dart';
import 'answer_fill_vew.dart';

enum AnswerFillType { New, Update }

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class AnswerFillPayload {
  final Exam? exam;
  final Answer? answer;
  final AnswerFillType? type;
  final bool fromScan;

  AnswerFillPayload({this.exam, this.answer, this.type, this.fromScan = false});

  factory AnswerFillPayload.addNew(
          {Exam? exam, Answer? answer, bool fromScan = false}) =>
      AnswerFillPayload(
          exam: exam,
          answer: answer,
          fromScan: fromScan,
          type: AnswerFillType.New);

  factory AnswerFillPayload.update({Exam? exam, Answer? answer}) =>
      AnswerFillPayload(
          exam: exam, answer: answer, type: AnswerFillType.Update);
}

class AnswerFillPage extends StatefulWidget {
  final AnswerFillPayload? payload;

  const AnswerFillPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AnswerFillState();
  }
}

class AnswerFillState extends BaseScaffold<AnswerFillPage, AnswerFillCtr>
    with SingleTickerProviderStateMixin {
  @override
  AnswerFillCtr initController() {
    return AnswerFillCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Bảng trả lời", action: action())
        .toAppBar();
  }

  @override
  Widget body() {
    return Column(
      children: [
        _tabbar(),
        Expanded(
          child: _pager(),
        ),
      ],
    );
  }

  List<Widget> action() {
    return [
      InkWell(
          onTap: controller.onSave,
          child: Container(
              margin: EdgeInsets.only(right: 15, left: 7),
              child: Icon(Icons.save)))
    ];
  }

  Widget _pager() {
    return PageView(
      controller: controller.pageController,
      children: [
        Obx(() => CodeFillView(
              key: ValueKey(controller.keyCode.value),
              code: widget.payload?.answer?.examCode,
              onCodeChange: controller.onCodeChange,
              exam: widget.payload?.exam,
            )),
        Obx(() => AnswerFillView(
              key: ValueKey(controller.keyCode.value),
              value: widget.payload?.answer?.value,
              onValueChange: controller.onValueChange,
              exam: widget.payload?.exam,
            ))
      ],
      onPageChanged: controller.onPageChange,
    );
  }

  Widget _tabbar() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _tabbarItem("Mã đề", 0)),
            Expanded(child: _tabbarItem("Đáp án", 1)),
          ],
        ),
        Row(
          children: [
            _tabbarIndicator(),
          ],
        )
      ],
    );
  }

  Widget _tabbarItem(String title, int index) {
    return InkWell(
      onTap: () => controller.onTabChange(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration:
            BoxDecoration(color: ResourceManager().color.card, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          )
        ]),
        child: Obx(() => Text(
              title,
              textAlign: TextAlign.center,
              style: ResourceManager().text.normalStyle.copyWith(
                  fontSize: 20,
                  color: controller.tabSeselected.value == index
                      ? ResourceManager().color.primary
                      : ResourceManager().color.black),
            )),
      ),
    );
  }

  Widget _tabbarIndicator() {
    double width = screen.width / 2;
    double height = 2;
    return AnimatedBuilder(
        animation: controller.animationController,
        child: Container(
          width: width,
          height: height,
          color: ResourceManager().color.primary,
        ),
        builder: (_, child) {
          return Transform.translate(
              offset: Offset((width * controller.animationController.value), 0),
              child: child);
        });
  }
}
