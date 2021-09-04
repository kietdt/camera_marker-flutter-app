import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/dialog/dialog_noti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'answer_fill_page.dart';

class AnswerFillCtr extends BaseController<AnswerFillState> {
  AnswerFillCtr(AnswerFillState state) : super(state);

  final PageController pageController = PageController();

  late final AnimationController animationController = AnimationController(
      vsync: state, duration: Duration(milliseconds: 300), value: 0);

  var tabSeselected = 0.obs;
  var keyCode = "".obs;
  var keyAnswer = "".obs;

  late int? codeSelected = state.widget.payload?.answer?.code;
  late List<AnswerValue?>? answerSelected = state.widget.payload?.answer?.value;

  Exam? get exam => state.widget.payload?.exam;
  bool get isUpdate => state.widget.payload?.type == AnswerFillType.Update;

  void onTabChange(int index) {
    pageController.animateTo(state.screen.width * index,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onPageChange(int index) {
    tabSeselected.value = index;
    switch (index) {
      case 0:
        animationController.reverse();
        break;
      case 1:
        animationController.forward();
        break;
    }
  }

  void onCodeChange(int code) {
    this.codeSelected = code;
    print(code);
  }

  void onValueChange(List<AnswerValue?>? value) {
    this.answerSelected = value;
  }

  void onSave() async {
    if (await validate()) {
      if (isUpdate) {
        Answer answer = state.widget.payload!.answer!;
        answer.code = this.codeSelected;
        answer.value = this.answerSelected;
        await DataBaseCtr().tbAnswer.updateAnswer(answer);
        Get.until(
            (route) => route.settings.name == RouteManager().routeName.answer);
        topSnackBar("Thông báo", "Cập nhật đáp án thành công");
      } else {
        Answer answer =
            Answer(code: this.codeSelected, value: this.answerSelected);
        String? id = await DataBaseCtr().tbAnswer.addNewAnswer(answer);
        answer.id = id;
        await DataBaseCtr().tbExam.addAnswer(answer: answer, exam: exam);

        DialogConfirm.show(
            message: "Nạp đáp án thành công\nTiếp tục thêm đáp án?",
            rightTitle: "Tiếp tục",
            leftTitle: "Quay về",
            onRight: () {
              if (state.widget.payload?.fromScan ?? false) {
                Get.back();
              } else {
                clear();
              }
            },
            onLeft: () => Get.until((route) {
                  print("================>${route.settings.name}");
                  return route.settings.name == RouteManager().routeName.answer;
                }));
      }
    }
  }

  Future<bool> validate() async {
    if (this.codeSelected == null) {
      await DialogNoti.show(
          message: "Chọn mã đề để tiếp tục",
          image: "lib/asset/ic_warning.png",
          hasImage: true);
      onTabChange(0);
      return false;
    } else if (this.codeSelected! < 100) {
      await DialogNoti.show(
          message: "Chọn đủ kí tự của mã đề để tiếp tục",
          image: "lib/asset/ic_warning.png",
          hasImage: true);
      onTabChange(0);
      return false;
    }

    if (!isUpdate ||
        (state.widget.payload?.answer?.code != this.codeSelected)) {
      List<Answer?>? _answers =
          DataBaseCtr().tbExam.getById(state.widget.payload?.exam?.id)?.answer;
      List<int?>? codes = List.generate(
          _answers?.length ?? 0, (index) => _answers?[index]?.code);

      if (codes.contains(this.codeSelected)) {
        await DialogNoti.show(
            message: "Mã đề ${this.codeSelected} đã tồn tại",
            image: "lib/asset/ic_warning.png",
            hasImage: true);
        onTabChange(0);
        return false;
      }
    }

    int index =
        this.answerSelected?.indexWhere((element) => element == null) ?? 0;
    if (index >= 0) {
      await DialogNoti.show(
          message: "Bạn chưa chọn đáp án ${index + 1}",
          image: "lib/asset/ic_warning.png",
          hasImage: true);
      onTabChange(1);
      return false;
    }
    return true;
  }

  void clear() {
    keyCode.value = Uuid().v4();
    keyAnswer.value = Uuid().v4();
    this.codeSelected = null;
    this.answerSelected = null;
    onTabChange(0);
  }
}
