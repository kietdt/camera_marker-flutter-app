import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/model/answer.dart';

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
    await add(answer);
    return answer.id;
  }

  Future<void> updateAnswer(Answer answer) async {
    int index = entities.indexWhere((element) => element.id == answer.id);
    await set(index, answer);
  }

  Future<void> deleteAnswer(Answer? answer) async {
    int index = entities.indexWhere((element) => element.id == answer?.id);
    await delete(index);
  }

  Future<void> deleteAnswerList(List<Answer> answers) async {
    for (int i = 0; i < answers.length; i++) {
      await deleteAnswer(answers[i]);
    }
  }
}
