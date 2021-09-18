import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/statistics.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'statistics_question_ctr.dart';

class StatisticsQuestionPagePayload {
  final Exam? exam;
  StatisticsQuestionPagePayload({this.exam});
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
    appBar = BaseAppBar(
      back: true,
      title: Obx(() => Text(
          Utils.upperAllFirst(
              "Mã đề " + (controller.answertSelected.value?.examCode ?? "")),
          style: ResourceManager().text.boldStyle)),
      action: [_filter()],
    ).toAppBar();
  }

  @override
  Widget body() {
    return Column(
      children: [
        header(),
        Expanded(
          child: _list(),
        )
      ],
    );
  }

  Widget _filter() {
    return InkWell(
        onTap: controller.onFilterPressed,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.filter_alt_outlined,
              color: ResourceManager().color.white,
            )));
  }

  Widget header() {
    return Container(
        margin: EdgeInsets.all(controller.mainPadding),
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

  Widget _list() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: controller.mainPadding),
        child: Obx(() => Column(
              children: List.generate(
                  controller.correctPercent.value?.length ?? 0, (index) {
                CorrectPercent? _correct =
                    controller.correctPercent.value?[index];
                return _listChild(_correct?.question, _correct?.percent);
              }),
            )),
      ),
    );
  }

  Widget _listChild(int? questtion, double? percent) {
    return Container(
        padding: EdgeInsets.all(controller.mainPadding).copyWith(right: 0),
        decoration: BoxDecoration(
            color: ResourceManager().color.background,
            border:
                Border(bottom: BorderSide(color: ResourceManager().color.des))),
        child: _item(
            title: questtion.toString(), content: percent?.toStringAsFixed(2)));
  }

  Widget _item({String? title, String? content}) {
    TextStyle _style = ResourceManager()
        .text
        .boldStyle
        .copyWith(fontSize: 17, color: ResourceManager().color.primary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: screen.width / 5,
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: _style,
          ),
        ),
        Container(
          width: screen.width / 3,
          child: Text(
            content ?? "",
            textAlign: TextAlign.center,
            style: _style,
          ),
        )
      ],
    );
  }
}
