import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';

import 'base_path.dart';

class TbAnswer extends BaseTable<Answer> {
  @override
  String get path => BasePath.ANSWER;

  @override
  List<Answer> fromJson(List jsons) {
    return List<Answer>.from(jsons.map((e) => Answer.fromJson(e)));
  }

  @override
  List<Map<String, dynamic>> toJson(List<Answer> entries) {
    return List<Map<String, dynamic>>.from(entries.map((e) => e.toJson()));
  }

  Future<String?> addNewAnswer(Answer answer) async {
    answer.id = newId();
    answer.createdAt = DateTime.now();
    answer.updatedAt = DateTime.now();
    await add(answer);
    return answer.id;
  }

  Future<void> updateAnswer(Answer answer) async {
    int index = entities.indexWhere((element) => element.id == answer.id);
    if (index >= 0) {
      answer.updatedAt = DateTime.now();
      await set(index, answer);
    }
  }

  Future<void> deleteAnswer(Answer? answer, Exam? exam) async {
    int index = entities.indexWhere((element) => element.id == answer?.id);

    // xóa id answer trong bảng exam
    if (exam != null) {
      exam.answerIds!.removeWhere((element) => element == answer?.id);
      await DataBaseCtr().tbExam.updateExam(exam);
    }
    await delete(index);
  }

  Future<void> deleteAnswerList(List<Answer> answers, Exam? exam) async {
    for (int i = 0; i < answers.length; i++) {
      await deleteAnswer(answers[i], exam);
    }
  }
}
