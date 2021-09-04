import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/extend/list_select/list_select.dart';
import 'package:flutter/material.dart';

import 'answer_ctr.dart';

class AnswerPayload {
  final Exam? exam;

  AnswerPayload({this.exam});
}

class AnswerPage extends StatefulWidget {
  final AnswerPayload? payload;

  AnswerPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AnswerState();
  }
}

class AnswerState extends ListSelect<AnswerPage, AnswerCtr, Answer> {
  @override
  List<Widget> get actionLeft => _actionChild();

  @override
  AnswerCtr initController() {
    return AnswerCtr(this);
  }

  @override
  Widget child(Answer? item) {
    return Container(
        padding: EdgeInsets.all(controller.mainPadding),
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
        child: _item("Mã đề", item));
  }

  List<Widget> _actionChild() {
    return [
      InkWell(
          onTap: controller.onScan,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              child: Icon(Icons.camera_alt))),
      InkWell(
          onTap: controller.onFill,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              child: Icon(Icons.add))),
    ];
  }

  Widget _item(String title, Answer? answer) {
    TextStyle _style = ResourceManager()
        .text
        .boldStyle
        .copyWith(fontSize: 25, color: ResourceManager().color.primary);
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: _style,
        )),
        Expanded(
          child: Text(
            answer?.code.toString() ?? "",
            style: _style,
          ),
        ),
        next()
      ],
    );
  }

  Widget next() {
    return Container(
        child: Icon(Icons.navigate_next,
            color: ResourceManager().color.black, size: 25));
  }
}
