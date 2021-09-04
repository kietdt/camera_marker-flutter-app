import 'package:camera_marker/base/base_fragment.dart';
import 'package:camera_marker/base/check_box.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'answer_fill_view_ctr.dart';

class AnswerFillView extends StatefulWidget {
  final List<AnswerValue?>? value;
  final Exam? exam;
  final Function(List<AnswerValue?>?)? onValueChange;

  const AnswerFillView({Key? key, this.value, this.onValueChange, this.exam})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AnswerFillViewState();
  }
}

class AnswerFillViewState
    extends BaseFragment<AnswerFillView, AnswerFillViewCtr> {
  @override
  AnswerFillViewCtr initController() {
    return AnswerFillViewCtr(this);
  }

  @override
  Widget body() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: ResourceManager().color.card,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: _buildTop()),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20).copyWith(top: 0),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: ResourceManager().color.card,
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: Column(
                children: List.generate(
                    controller.answerLength, (rowIndex) => itemRow(rowIndex)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: controller.maxCol,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                controller.maxCol,
                (index) => Text(
                      AnswerValueEnum.values[index]
                          .toString()
                          .replaceAll("AnswerValueEnum.", ""),
                      style: ResourceManager().text.boldStyle.copyWith(
                          fontSize: 20, color: ResourceManager().color.primary),
                    )),
          ),
        )
      ],
    );
  }

  Widget itemRow(int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            (rowIndex + 1).toString(),
            style: ResourceManager()
                .text
                .boldStyle
                .copyWith(fontSize: 17, color: ResourceManager().color.primary),
          ),
        ),
        Expanded(
          flex: controller.maxCol,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                controller.maxCol, (colIndex) => checkBox(rowIndex, colIndex)),
          ),
        )
      ],
    );
  }

  Widget checkBox(int rowIndex, int colIndex) {
    double size = 50;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.centerLeft,
      child: Obx(() => CustomCheckbox(
          // ignore: invalid_use_of_protected_member
          value: controller.listAnswer[rowIndex].value == colIndex,
          shape: CircleBorder(),
          activeColor: ResourceManager().color.primary,
          width: size - 20,
          checkColor: ResourceManager().color.white,
          onChanged: (value) => controller.onCheck(rowIndex, colIndex))),
    );
  }
}
