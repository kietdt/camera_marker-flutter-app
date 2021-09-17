import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/statistics.dart';
import 'package:flutter/material.dart';

import 'statistics_chart_page.dart';

class StatisticsChartCtr extends BaseController<StatisticsChartState> {
  StatisticsChartCtr(StatisticsChartState state) : super(state) {
    initCount();
  }

  late Statistics statistics = Statistics(exam: state.widget.payload?.exam);

  Map<String, double> get dataChart => {
        statistics.veryGood.description: statistics.percentVeryGood,
        statistics.good.description: statistics.percentGood,
        statistics.average.description: statistics.percentAverage,
        statistics.weak.description: statistics.percentWeak,
        statistics.poor.description: statistics.percentPoor,
      };

  List<Color> get colorList => [
        statistics.veryGood.color,
        statistics.good.color,
        statistics.average.color,
        statistics.weak.color,
        statistics.poor.color,
      ];

  void initCount() {
    print(
        "VERYGOOD==========>${(statistics.percentVeryGood * 100).toStringAsFixed(2)}");
    print(
        "GOOD==========>${(statistics.percentGood * 100).toStringAsFixed(2)}");
    print(
        "AVERAGE==========>${(statistics.percentAverage * 100).toStringAsFixed(2)}");
    print(
        "WEAK==========>${(statistics.percentWeak * 100).toStringAsFixed(2)}");
    print(
        "POOR==========>${(statistics.percentPoor * 100).toStringAsFixed(2)}");
  }
}
