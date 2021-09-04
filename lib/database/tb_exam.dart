import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';

import 'base_path.dart';

class TbExam extends BaseTable<Exam> {
  @override
  String get path => BasePath.EXAM;

  @override
  List<Exam> fromJson(List jsons) {
    return List<Exam>.from(jsons.map((e) => Exam.fromJson(e)));
  }

  @override
  List<Map<String, dynamic>> toJson(List<Exam> entries) {
    return List<Map<String, dynamic>>.from(entries.map((e) => e.toJson()));
  }

  Future<void> addNewExam(Exam exam) async {
    exam.id = newId();
    await add(exam);
  }

  Future<void> updateExam(Exam exam) async {
    int index = entities.indexWhere((element) => element.id == exam.id);
    await set(index, exam);
  }

  Future<void> deleteExam(Exam exam) async {
    int index = entities.indexWhere((element) => element.id == exam.id);

    //delete Answer related
    Exam? _temp = getById(exam.id);
    List.generate(
        _temp?.answer.length ?? 0,
        (index) async =>
            await DataBaseCtr().tbAnswer.deleteAnswer(_temp?.answer[index]));

    await delete(index);
  }

  Exam? getById(String? id) {
    int index = entities.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return entities[index];
    }
    return null;
  }

  Future<void> addAnswer({required Exam? exam, required Answer? answer}) async {
    if (exam != null && answer != null) {
      List<String> ids = exam.answerIds ?? [];
      if (!ids.contains(answer.id)) {
        ids.add(answer.id ?? "");
      }
      exam.answerIds = ids;
      await updateExam(exam);
    }
  }
}
