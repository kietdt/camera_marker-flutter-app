import 'package:camera_marker/base/base_view.dart';
import 'package:camera_marker/base/check_box.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'code_fill_ctr.dart';


//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class CodeFillView extends StatefulWidget {
  final Exam? exam;
  final String? code;
  final Function(String)? onCodeChange;

  CodeFillView({Key? key, this.code, this.onCodeChange, this.exam})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CodeFillViewState();
  }
}

class CodeFillViewState extends BaseView<CodeFillView, CodeFillViewCtr> {
  @override
  CodeFillViewCtr initController() {
    return CodeFillViewCtr(this);
  }

  @override
  Widget body() {
    return Column(
      children: [
        _buidCode(),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: ResourceManager().color.card,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: List.generate(10, (rowIndex) => itemRow(rowIndex)),
                ),
              ),
            ),
          ),
        ),
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
            rowIndex.toString(),
            style: ResourceManager()
                .text
                .boldStyle
                .copyWith(fontSize: 17, color: ResourceManager().color.primary),
          ),
        ),
        Expanded(
          flex: controller.maxColumn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(controller.maxColumn,
                (colIndex) => checkBox(rowIndex, colIndex)),
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
          value: controller.listCode[colIndex].value == rowIndex,
          shape: CircleBorder(),
          activeColor: ResourceManager().color.primary,
          width: size - 20,
          checkColor: ResourceManager().color.white,
          onChanged: (value) => controller.onCheck(rowIndex, colIndex))),
    );
  }

  Widget _buidCode() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 40, top: 20),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: controller.random,
                    child: Stack(
                      children: [
                        Container(width: 50, child: _itemCode(0, title: "Ra")),
                      ],
                    ),
                  )),
              Expanded(
                flex: controller.maxColumn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(controller.listCode.length,
                      (index) => _itemCode(controller.listCode[index].value)),
                ),
              ),
            ],
          )),
    );
  }

  Widget _itemCode(int digit, {String? title}) {
    double size = 50;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: ResourceManager().color.card,
          border: Border.all(width: 2, color: ResourceManager().color.des),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Text(title ?? (digit >= 0 ? digit.toString() : ""),
          textAlign: TextAlign.center,
          style: ResourceManager()
              .text
              .boldStyle
              .copyWith(fontSize: 30, color: ResourceManager().color.primary)),
    );
  }
}
