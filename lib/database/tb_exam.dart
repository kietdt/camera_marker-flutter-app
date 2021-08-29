import 'package:camera_marker/database/base_table.dart';
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

  Future<void> addClass(Exam exam) async {
    exam.id = newId();
    await add(exam);
  }

  Future<void> updateClass(Exam exam) async {
    int index = entities.indexWhere((element) => element.id == exam.id);
    await set(index);
  }

  Future<void> deleteClass(Exam exam) async {
    int index = entities.indexWhere((element) => element.id == exam.id);
    await delete(index);
  }
}
