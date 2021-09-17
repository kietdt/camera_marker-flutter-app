import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/view/screen/statistics_chart/statistics_chart_page.dart';
import 'package:camera_marker/view/screen/statistics_question/statistics_question_page.dart';
import 'package:get/get.dart';

import 'statistics_page.dart';

class StatisticsCtr extends BaseController<StatisticsState> {
  StatisticsCtr(StatisticsState state) : super(state);

  void onChartPressed() {
    Get.toNamed(RouteManager().routeName.statisticsChart,
        arguments:
            StatisticsChartPagePayload(exam: state.widget.payload?.exam));
  }

  void onQuestionPressed() {
    Get.toNamed(RouteManager().routeName.statisticsQuestion,
        arguments:
            StatisticsQuestionPagePayload(exam: state.widget.payload?.exam));
  }
}
