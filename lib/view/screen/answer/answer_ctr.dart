import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/extend/list_select/list_select_ctr.dart';
import 'package:camera_marker/view/screen/answer_fill/answer_fill_page.dart';
import 'package:camera_marker/view/screen/camera_transform/yuv_transform_screen.dart';
import 'package:get/get.dart';

import 'answer_page.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class AnswerCtr extends ListSelectCtr<AnswerState, Answer> {
  AnswerCtr(AnswerState state) : super(state) {
    getData();
  }

  @override
  String get title => "Đáp án";

  @override
  String get emptyMessage => "Chưa có đáp án";

  @override
  bool get showAdd => false;

  @override
  void onDelete() {
    List<Answer> temp = [];
    List.generate(selecteList.length, (index) {
      if (selecteList[index]) {
        temp.add(items[index]);
      }
    });
    if (temp.length > 0) {
      DialogConfirm.show(
          message: "Bạn có chắc muốn xóa ${temp.length} đáp án đang chọn?",
          onRight: () {
            temp.forEach((element) async {
              await DataBaseCtr()
                  .tbAnswer
                  .deleteAnswer(element, state.widget.payload?.exam);
            });
            onSelect();
            getData();
            topSnackBar("Thông báo", "Đã xóa ${temp.length} đáp án");
          });
    } else {
      if (!(Get.isSnackbarOpen ?? false)) {
        topSnackBar("Thông báo", "Bạn hãy chọn một đáp án để xóa");
      }
    }
  }

  @override
  void showNew() {
    //do nothing
  }

  @override
  void showUpdate(Answer? item, int index) async {
    await Get.toNamed(RouteManager().routeName.answerFill,
        arguments: AnswerFillPayload.update(
            exam: state.widget.payload?.exam, answer: item));
    getData();
  }

  void onScan() async {
    await Get.toNamed(RouteManager().routeName.cameraScan,
        arguments:
            YuvTransformScreenPayload.fill(exam: state.widget.payload?.exam));
    getData();
  }

  void onFill() async {
    await Get.toNamed(RouteManager().routeName.answerFill,
        arguments: AnswerFillPayload.addNew(exam: state.widget.payload?.exam));
    getData();
  }

  @override
  void getData() {
    Exam? exam = DataBaseCtr().tbExam.getById(state.widget.payload?.exam?.id);
    items.value = exam?.answer ?? [];
    initSelectedList();
  }
}
