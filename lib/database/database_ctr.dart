import 'package:camera_marker/database/tb_result.dart';

import 'tb_answer.dart';
import 'tb_class.dart';
import 'tb_exam.dart';
import 'tb_template.dart';

class DataBaseCtr {
  DataBaseCtr._();
  static DataBaseCtr? _singleton;

  factory DataBaseCtr() {
    if (_singleton == null) _singleton = DataBaseCtr._();
    return _singleton!;
  }

  late TbTemplate tbTemplate = TbTemplate();
  late TbClass tbClass = TbClass();
  late TbExam tbExam = TbExam();
  late TbAnswer tbAnswer = TbAnswer();
  late TbResult tbResult = TbResult();

  Future<void> init() async {
    await tbTemplate.loadTable();
    await tbClass.loadTable();
    await tbExam.loadTable();
    await tbAnswer.loadTable();
    await tbResult.loadTable();
  }
}
