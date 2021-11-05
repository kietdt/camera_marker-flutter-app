import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_noti.dart';
import 'package:camera_marker/view/screen/answer/answer_page.dart';
import 'package:camera_marker/view/screen/camera_transform/yuv_transform_screen.dart';
import 'package:camera_marker/view/screen/history/history_page.dart';
import 'package:camera_marker/view/screen/statistics/statistics_page.dart';
import 'package:get/get.dart';

import 'exam_manager_page.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ExamManagerCtr extends BaseController<ExamManagerState> {
  ExamManagerCtr(ExamManagerState state) : super(state);

  void navigateAnswer() {
    //đáp án
    Get.toNamed(RouteManager().routeName.answer,
        arguments: AnswerPayload(exam: state.widget.payload?.exam));
  }

  void navigateScan() async {
    //chấm thi
    Exam? exam = state.widget.payload?.exam;
    int index = (exam?.canResult() ?? -1);
    if (index >= 0) {
      DialogNoti.show(
          message:
              "Mã đề ${exam?.answer[index].examCode} chưa điền đủ số lượng đáp án");
    } else {
      Get.toNamed(RouteManager().routeName.cameraScan,
          arguments: YuvTransformScreenPayload.result(exam: exam));
    }
  }

  void navigateHistory() {
    //Bài đã chấm
    Get.toNamed(RouteManager().routeName.history,
        arguments: HistoryPagePayload(exam: state.widget.payload?.exam));
  }

  void navigateStatistics() {
    //Kết quả
    Exam? exam = state.widget.payload?.exam;
    if ((exam?.result.length ?? 0) <= 0) {
      DialogNoti.show(message: "Hãy chấm bài để xem kết quả");
    } else {
      Get.toNamed(RouteManager().routeName.statistics,
          arguments: StatisticsPagePayload(exam: state.widget.payload?.exam));
    }
  }
}
