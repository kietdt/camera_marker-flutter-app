import 'dart:math';

import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:get/get.dart';

import 'code_fill_view.dart';


//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class CodeFillViewCtr extends BaseController<CodeFillViewState> {
  CodeFillViewCtr(CodeFillViewState state) : super(state) {
    initListcode(state.widget.code);
  }

  int maxColumn = Answer.codeLength;

  late RxList<RxInt> listCode =
      List.generate(maxColumn, (index) => (-1).obs).obs;

  void initListcode(String? code) {
    if (code != null) {
      listCode.value =
          List.generate(code.length, (index) => int.parse(code[index]).obs);
    }
  }

  void onCheck(int rowIndex, int colIndex) {
    listCode[colIndex] = rowIndex.obs;
    onCodeChange(getCode());
  }

  void random() {
    int rd = 0;
    List<String?> codes = List<String?>.generate(
        state.widget.exam?.answer.length ?? 0,
        (index) => state.widget.exam?.answer[index].code);
    int index = 0;
    while (index >= 0) {
      rd = Random().nextInt(999);
      index = codes.indexWhere((element) => element == rd.toString());
    }
    String _temp = rd.toString();
    while (_temp.length < 3) _temp = "0" + _temp;

    initListcode(_temp);
    onCodeChange(_temp);
  }

  String getCode() {
    String code = "";
    List.generate(maxColumn, (index) {
      if (listCode[index].value >= 0) {
        code += listCode[index].value.toString();
      }
    });
    return code;
  }

  void onCodeChange(String code) {
    if (state.widget.onCodeChange != null) {
      state.widget.onCodeChange!(code);
    }
  }
}
