import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomExamcode extends StatelessWidget {
  final List<Answer>? answers;
  final Answer? answerSelected;
  final Function(Answer?)? onSelected;
  final double height;

  BottomExamcode(
      {Key? key,
      this.answers,
      this.onSelected,
      this.answerSelected,
      required this.height})
      : super(key: key);

  static show(
      {List<Answer>? answers,
      Function(Answer?)? onSelected,
      required double height,
      Answer? answerSelected}) {
    return Get.bottomSheet(BottomExamcode(
      answers: answers,
      onSelected: onSelected,
      height: height,
      answerSelected: answerSelected,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 7),
          child: Container(
            width: 60,
            height: 7,
            decoration: BoxDecoration(
                color: ResourceManager().color.des,
                borderRadius: BorderRadius.all(Radius.circular(3))),
          ),
        ),
        Expanded(
          child: Container(
            height: height,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: ResourceManager().color.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(7))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(),
                Expanded(
                  child: _list(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Chọn mã đề",
          style: ResourceManager()
              .text
              .superboldStyle
              .copyWith(fontSize: 25, color: ResourceManager().color.primary),
        )
      ]),
    );
  }

  Widget _list() {
    return ListView.separated(
        itemBuilder: (ctx, index) => _item(answers?[index]),
        separatorBuilder: (ctx, index) => Divider(),
        itemCount: answers?.length ?? 0);
  }

  Widget _item(Answer? answer) {
    return InkWell(
      onTap: () => onSelect(answer),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              answer?.examCode ?? "",
              style: ResourceManager().text.boldStyle.copyWith(
                  fontSize: 30,
                  color: answer?.examCode == answerSelected?.examCode
                      ? ResourceManager().color.primary
                      : ResourceManager().color.des),
            ),
            Visibility(
                visible: answer?.examCode == answerSelected?.examCode,
                child: Icon(
                  Icons.check,
                  color: ResourceManager().color.primary,
                ))
          ],
        ),
      ),
    );
  }

  void onSelect(Answer? answer) {
    if (onSelected != null) {
      onSelected!(answer);
    }
    Get.back();
  }
}
