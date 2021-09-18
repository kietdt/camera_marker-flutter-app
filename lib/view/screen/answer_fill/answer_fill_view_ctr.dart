import 'dart:math';

import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:get/get.dart';

import 'answer_fill_vew.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class AnswerFillViewCtr extends BaseController<AnswerFillViewState> {
  AnswerFillViewCtr(AnswerFillViewState state) : super(state) {
    initListAnswer(state.widget.value);
  }

  int maxCol = 4;
  double sqSize = 50;

  late int answerLength = state.widget.exam?.question ?? 0;
  late RxList<Rx<AnswerValue?>?>? listAnswer =
      List.generate(answerLength, (index) => AnswerValue.empty().obs).obs;

  bool get isMulti => state.widget.exam?.template?.isMulti ?? false;

  void initListAnswer(List<AnswerValue?>? answerValue) {
    if (answerValue != null) {
      List<Rx<AnswerValue?>?> _temp = List<Rx<AnswerValue>>.generate(
          //chỉ lấy đúng chiều dài số lượng câu hỏi đã tạo ở kì thi
          min(answerValue.length, answerLength),
          (index) => answerValue[index]!.obs);

      while (_temp.length < answerLength) {
        _temp.add(AnswerValue.empty().obs);
      }
      listAnswer?.value = _temp;
      onValueChange(getValue());
    }
  }

  void onCheck(int rowIndex, int colIndex) {
    int? index = listAnswer?[rowIndex]
        ?.value
        ?.valueEnum
        ?.indexWhere((element) => element == AnswerValueEnum.values[colIndex]);
    AnswerValue? _temp = listAnswer?[rowIndex]?.value;
    listAnswer?[rowIndex]?.value = AnswerValue.empty();

    if (isMulti) {
      if (index != null && index >= 0) {
        _temp?.removeValueEnum(index);
      } else {
        _temp?.addValueEnum(AnswerValueEnum.values[colIndex]);
      }
    } else {
      _temp = AnswerValue(valueEnum: [AnswerValueEnum.values[colIndex]]);
    }

    listAnswer?[rowIndex]?.value = _temp;

    onValueChange(getValue());
  }

  void onValueChange(List<AnswerValue?>? value) {
    if (state.widget.onValueChange != null) {
      state.widget.onValueChange!(value);
    }
  }

  List<AnswerValue?>? getValue() {
    return List.generate(listAnswer?.length ?? 0, (i) => listAnswer?[i]?.value);
  }

  bool isCheck(List<AnswerValueEnum>? list, int rowIndex, int colIndex) {
    int? index = list
        ?.indexWhere((element) => element == AnswerValueEnum.values[colIndex]);

    return (index != null && index >= 0);
  }
}
