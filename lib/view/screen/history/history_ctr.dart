import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/result.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/extend/list_select/list_select_ctr.dart';
import 'package:camera_marker/view/screen/result/result_page.dart';
import 'package:get/get.dart';

import 'history_page.dart';

class HistoryCtr extends ListSelectCtr<HistoryState, Result> {
  HistoryCtr(HistoryState state) : super(state) {
    getData();
  }

  double get sizeNext => 25;

  @override
  bool get showAdd => false;

  @override
  String get title => "Bài đã chấm";

  @override
  void onDelete() {
    List<Result> temp = [];
    List.generate(selecteList.length, (index) {
      if (selecteList[index]) {
        temp.add(items[index]);
      }
    });
    if (temp.length > 0) {
      DialogConfirm.show(
          message: "Bạn có chắc muốn xóa ${temp.length} bài đã chấm đang chọn?",
          onRight: () {
            temp.forEach((element) async {
              await DataBaseCtr()
                  .tbResult
                  .deleteResult(element, state.widget.payload?.exam);
            });
            onSelect();
            getData();
            topSnackBar("Thông báo", "Đã xóa ${temp.length} bài đã chấm");
          });
    } else {
      if (!(Get.isSnackbarOpen)) {
        topSnackBar("Thông báo", "Bạn hãy chọn một bài đã chấm để xóa");
      }
    }
  }

  @override
  void showNew() {
    //do nothing
  }

  @override
  void showUpdate(Result? item, int index) {
    Get.toNamed(RouteManager().routeName.result,
        arguments:
            ResultPagePayload(exam: state.widget.payload?.exam, result: item));
  }

  @override
  void getData() {
    Exam? exam = DataBaseCtr().tbExam.getById(state.widget.payload?.exam?.id);
    List<Result> _temp = exam?.result ?? [];
    _temp.sort((a, b) =>
        int.tryParse(a.studentCode ?? "0")
            ?.compareTo(int.tryParse(b.studentCode ?? "0") ?? 0) ??
        -1);
    items.value = _temp;
    initSelectedList();
  }
}
