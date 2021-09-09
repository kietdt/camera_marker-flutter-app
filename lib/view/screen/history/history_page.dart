import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/result.dart';
import 'package:camera_marker/view/extend/list_select/list_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'history_ctr.dart';

class HistoryPagePayload {
  final Exam? exam;

  HistoryPagePayload({this.exam});
}

class HistoryPage extends StatefulWidget {
  final HistoryPagePayload? payload;

  const HistoryPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HistoryState();
  }
}

class HistoryState extends ListSelect<HistoryPage, HistoryCtr, Result> {
  @override
  HistoryCtr initController() {
    return HistoryCtr(this);
  }

  @override
  Widget header() {
    return Obx(() => Visibility(
          visible: controller.items.length > 0,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: controller.mainPadding)
                  .copyWith(top: controller.mainPadding),
              padding:
                  EdgeInsets.all(controller.mainPadding).copyWith(right: 0),
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
              child: _item(title: "SBD", content: "ĐIỂM", isHeader: true)),
        ));
  }

  @override
  Widget child(Result? item) {
    return Container(
        padding: EdgeInsets.all(controller.mainPadding).copyWith(right: 0),
        decoration: BoxDecoration(
            color: ResourceManager().color.background,
            border:
                Border(bottom: BorderSide(color: ResourceManager().color.des))),
        child: _item(
            title: item?.studentCode, content: item?.point.toStringAsFixed(2)));
  }

  Widget _item({String? title, String? content, bool isHeader = false}) {
    TextStyle _style = ResourceManager()
        .text
        .boldStyle
        .copyWith(fontSize: 17, color: ResourceManager().color.primary);
    return Row(
      children: [
        Expanded(
            flex: 7,
            child: Text(
              title ?? "",
              style: _style,
            )),
        Expanded(
          flex: 3,
          child: Text(
            content ?? "",
            style: _style,
          ),
        ),
        Opacity(opacity: !isHeader ? 1 : 0, child: next())
      ],
    );
  }

  Widget next() {
    return Container(
        child: Icon(Icons.navigate_next,
            color: ResourceManager().color.black, size: controller.sizeNext));
  }
}
