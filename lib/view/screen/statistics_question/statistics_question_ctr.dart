import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/answer.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/statistics.dart';
import 'package:camera_marker/view/dialog/bottom_exam_code.dart';
import 'package:camera_marker/view/screen/statistics_question/statistics_question_page.dart';
import 'package:get/get.dart';

class StatisticsQuestionCtr extends BaseController<StatisticsQuestionState> {
  StatisticsQuestionCtr(StatisticsQuestionState state) : super(state) {
    statistics = Statistics(exam: exam);
    answertSelected = answers.first.obs;
    correctPercent = statistics.correctByExamCode(answertSelected.value).obs;
  }

  late Statistics statistics;

  late Rx<Answer?> answertSelected;
  late Rx<List<CorrectPercent>?> correctPercent;

  double get mainPadding => 15;

  Exam? get exam => state.widget.payload?.exam;

  List<Answer> get answers => exam?.answer ?? [];

  void onFilterPressed() {
    BottomExamcode.show(
        answers: answers,
        onSelected: onFilter,
        height: state.screen.height / 2,
        answerSelected: answertSelected.value);
  }

  void onFilter(Answer? answer) {
    answertSelected.value = answer;
    correctPercent.value = List<CorrectPercent>.from(
        statistics.correctByExamCode(answertSelected.value) ?? []);
  }
}
