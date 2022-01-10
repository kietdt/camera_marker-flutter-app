import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/mix/export_mix.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:camera_marker/view/dialog/dialog_noti.dart';
import 'package:camera_marker/view/screen/statistics_chart/statistics_chart_page.dart';
import 'package:camera_marker/view/screen/statistics_question/statistics_question_page.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'statistics_page.dart';

enum ExportType { Excel, Full }

class StatisticsCtr extends BaseController<StatisticsState> with ExportMix {
  StatisticsCtr(StatisticsState state) : super(state);

  List<String> optionDes = [
    "Chỉ xuất excel",
    "Xuất excel và hình ảnh chấm thi"
  ];

  Exam? get exam => state.widget.payload?.exam;

  RxInt optionSelected = 0.obs;

  String excelPath = "";
  bool isSharing = false;

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

  void onExportPressed() async {
    if (!isSharing) {
      isSharing = true;
      await cleanShareCache();
      var result = await DialogNoti.show(
          title: "Chọn phương thức",
          barrierDismissible: true,
          child: state.exportOption());
      if (result == "true") {
        excelPath =
            await filePath(exam: exam, withPhoto: optionSelected.value == 1);
        print("=======share====path======>$excelPath");
        await Share.shareFiles([excelPath]);
      }
      isSharing = false;
    }
  }

  void onOptionSelected(int index) {
    optionSelected.value = index;
  }

  Future cleanShareCache() async {
    var _pref = await SharedPreferences.getInstance();
    String? excelPath = _pref.getString("excel_path");
    String? photoPath = _pref.getString("photo_path");
    String? zipPath = _pref.getString("zip_path");
    if (excelPath != null) {
      Utils.deletefile(excelPath);
      _pref.remove("excel_path");
    }
    if (photoPath != null) {
      Utils.deletefile(photoPath);
      _pref.remove("excel_path");
    }
    if (zipPath != null) {
      Utils.deletefile(zipPath);
      _pref.remove("excel_path");
    }
  }
}
