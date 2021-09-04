import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:get/get.dart';

import 'answer_fill_vew.dart';

class AnswerFillViewCtr extends BaseController<AnswerFillViewState> {
  AnswerFillViewCtr(AnswerFillViewState state) : super(state) {
    initListAnswer(state.widget.value);
  }

  int maxCol = 4;

  late int answerLength = state.widget.exam?.question ?? 0;
  late RxList<RxInt> listAnswer =
      List.generate(answerLength, (index) => (-1).obs).obs;

  void initListAnswer(List<AnswerValue?>? answerValue) {
    if (answerValue != null) {
      listAnswer.value = List.generate(
          answerValue.length,
          (index) => AnswerValueEnum.values
              .indexOf(answerValue[index]!.valueEnum!)
              .obs);
    }
  }

  void onCheck(int rowIndex, int colIndex) {
    listAnswer[rowIndex] = colIndex.obs;
    onValueChange(getValue());
  }

  void onValueChange(List<AnswerValue?> value) {
    if (state.widget.onValueChange != null) {
      state.widget.onValueChange!(value);
    }
  }

  List<AnswerValue?> getValue() {
    return List.generate(listAnswer.length, (index) {
      if (listAnswer[index].value >= 0) {
        return AnswerValue(
            // index: index,
            valueEnum: AnswerValueEnum.values[listAnswer[index].value]);
      }
      return null;
    });
  }
}
