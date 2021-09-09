import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:camera_marker/view/dialog/dialog_exam.dart';
import 'package:camera_marker/view/extend/list_select/list_select_ctr.dart';
import 'package:camera_marker/view/screen/exam_manager/exam_manager_page.dart';
import 'package:get/get.dart';

import 'exam_page.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ExamPageCtr extends ListSelectCtr<ExamPageState, Exam> {
  ExamPageCtr(ExamPageState state) : super(state) {
    getData();
  }

  @override
  String get title => "Kì thi";

  @override
  void onDelete() {
    List<Exam> temp = [];
    List.generate(selecteList.length, (index) {
      if (selecteList[index]) {
        temp.add(items[index]);
      }
    });
    if (temp.length > 0) {
      DialogConfirm.show(
          message: "Bạn có chắc muốn xóa ${temp.length} kì thi đang chọn?",
          onRight: () {
            temp.forEach((element) {
              DataBaseCtr().tbExam.deleteExam(element);
            });
            onSelect();
            getData();
            topSnackBar("Thông báo", "Đã xóa ${temp.length} Kì thi");
          });
    } else {
      if (!(Get.isSnackbarOpen ?? false)) {
        topSnackBar("Thông báo", "Bạn hãy chọn một kì thi để xóa");
      }
    }
  }

  @override
  void showNew() {
    DialogExam.showNew(onConfirm: addExam);
  }

  @override
  void showUpdate(Exam? item, int index) {
    DialogConfirm.show(
        title: "Chọn hành động",
        leftTitle: "Cập nhật",
        rightTitle: "Quản lý",
        barrierDismissible: true,
        hasImage: false,
        fact: "Fact: bạn cũng có thể nhấn 2 lần để vào trang quản lý kì thi",
        onRight: () => navigateManage(item),
        onLeft: () => showDialogUpdate(item),
        leftColor: ResourceManager().color.primary);
  }

  @override
  void onChildDoubleTap(Exam? item, int index) {
    super.onChildDoubleTap(item, index);
    navigateManage(item);
  }

  void showDialogUpdate(Exam? item) {
    DialogExam.showUpdate(onConfirm: updateExam, exam: item);
  }

  void addExam(Exam exam) async {
    await DataBaseCtr().tbExam.addNewExam(exam);
    topSnackBar("Thông báo", "Thêm mới thành công");
    getData();
  }

  void updateExam(Exam exam) async {
    await DataBaseCtr().tbExam.updateExam(exam);
    topSnackBar("Thông báo", "Cập nhật thành công");
    getData();
  }

  void navigateManage(Exam? exam) {
    Get.toNamed(RouteManager().routeName.examManager,
        arguments: ExamManagerPayLoad(exam));
  }

  @override
  void getData() {
    items.value = List<Exam>.from(DataBaseCtr().tbExam.entities);
    initSelectedList();
  }
}
