import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/base_path.dart';
import 'package:camera_marker/database/base_table.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/result.dart';

import 'database_ctr.dart';

//created by kietdt 06/09/2021
//contact email: dotuankiet1403@gmail.com
class TbResult extends BaseTable<Result> {
  @override
  String get path => BasePath.RESULT;

  @override
  List<Result> fromJson(List jsons) {
    return List<Result>.from(jsons.map((e) => Result.fromJson(e)));
  }

  @override
  List<Map<String, dynamic>> toJson(List<Result> entries) {
    return List<Map<String, dynamic>>.from(entries.map((e) => e.toJson()));
  }

  Future<String?> addNewResult(Result result) async {
    result.id = newId();
    result.createdAt = DateTime.now();
    await add(result);
    return result.id;
  }

  Future<void> updateResult(Result result) async {
    int index = entities.indexWhere((element) => element.id == result.id);
    await set(index, result);
  }

  Future<void> deleteResult(Result? result, Exam? exam) async {
    int index = entities.indexWhere((element) => element.id == result?.id);
    result = entities[index];

    // xóa id result trong bảng exam
    if (exam != null) {
      exam.resultIds!.removeWhere((element) => element == result?.id);
      await DataBaseCtr().tbExam.updateExam(exam);
    }

    //xóa hình ảnh
    await Utils.deletefile(result.pngPath);
    await Utils.deletefile(result.image ?? "");

    await delete(index);
  }

  Future<void> deleteResultList(List<Result> results, Exam? exam) async {
    for (int i = 0; i < results.length; i++) {
      await deleteResult(results[i], exam);
    }
  }
}
