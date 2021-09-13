import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/model/statistics.dart';

import 'statistics_page.dart';

class StatisticsCtr extends BaseController<StatisticsState> {
  StatisticsCtr(StatisticsState state) : super(state) {
    initCount();
  }

  late Statistics statistics = Statistics(exam: state.widget.payload?.exam);

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
