import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/resource_manager.dart';
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(top: controller.mainPadding),
      decoration: BoxDecoration(
          color: ResourceManager().color.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.title ?? "",
            style: ResourceManager()
                .text
                .boldStyle
                .copyWith(color: ResourceManager().color.primary, fontSize: 25),
          ),
          _itemDesc("Câu trả lời", item?.question.toString()),
          _itemDesc("Lớp", item?.myClass?.titleDisplay ?? "Đã xóa",
              color: item?.myClass?.titleDisplay == null
                  ? ResourceManager().color.error
                  : null),
          _itemDesc("Điểm", item?.maxPoint?.toStringAsFixed(2)),
          _itemDesc("Mẫu đề thi", item?.template?.title),
          _itemDesc("Thời gian bắt đầu",
              Utils.dateToStr(item?.startAt, pattern: Utils.DMYHM)),
          _itemDesc("Thời gian thi", item?.minutesText),
        ],
      ),
    );
  }

  Widget _itemDesc(String? title, String? decs, {Color? color}) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(children: [
          Container(
            width: 140,
            child: Text(
              title ?? "",
              style: ResourceManager().text.boldStyle.copyWith(fontSize: 15),
            ),
          ),
          Expanded(
              child: Text(decs ?? "",
                  style: ResourceManager()
                      .text
                      .normalStyle
                      .copyWith(fontSize: 15, color: color)))
        ]));
  }
}
