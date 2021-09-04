import 'dart:math';

import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:get/get.dart';

import 'code_fill_view.dart';

class CodeFillViewCtr extends BaseController<CodeFillViewState> {
  CodeFillViewCtr(CodeFillViewState state) : super(state) {
    initListcode(state.widget.code);
  }

  int maxColumn = Answer.codeLength;

  late RxList<RxInt> listCode =
      List.generate(maxColumn, (index) => (-1).obs).obs;

  void initListcode(int? code) {
    if (code != null) {
      List<int> _list = [];
      while (code! > 0) {
        int _temp = code % 10;
        _list.insert(0, _temp);
        code = code ~/ 10;
      }
      listCode.value = List.generate(_list.length, (index) => _list[index].obs);
    }
  }

  void onCheck(int rowIndex, int colIndex) {
    listCode[colIndex] = rowIndex.obs;
    onCodeChange(getCode());
  }

  void random() {
    int rd = 0;
    List<int?> codes = List<int?>.generate(
        state.widget.exam?.answer.length ?? 0,
        (index) => state.widget.exam?.answer[index].code);
    while (rd < 100) {
      rd = Random().nextInt(999);
      if (codes.contains(rd)) rd = 0;
    }
    initListcode(rd);
    onCodeChange(rd);
  }

  int getCode() {
    int code = 0;
    List.generate(maxColumn, (index) {
      if (listCode[index].value >= 0) {
        code = code * 10 + listCode[index].value;
      }
    });
    return code;
  }

  void onCodeChange(int code) {
    if (state.widget.onCodeChange != null) {
      state.widget.onCodeChange!(code);
    }
  }
}
