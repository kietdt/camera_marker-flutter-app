import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_exam.dart';
import 'package:camera_marker/view/extend/list_select/list_select_ctr.dart';

import 'exam_page.dart';

class ExamPageCtr extends ListSelectCtr<ExamPageState, Exam> {
  ExamPageCtr(ExamPageState state) : super(state) {
    getExam();
  }

  @override
  void onDelete() {
    // TODO: implement onDelete
  }

  @override
  void showNew() {
    DialogExam.showNew(onConfirm: addExam);
  }

  @override
  void showUpdate(Exam? item, int index) {
    // TODO: implement showUpdate
  }

  void addExam(Exam exam) async {
    await DataBaseCtr().tbExam.addNewExam(exam);
    getExam();
  }

  void getExam() {
    items.value = List<Exam>.from(DataBaseCtr().tbExam.entities);
    initSelectedList();
  }
}
