import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/manager/http_manager.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:get/get.dart';

import 'dash_board_page.dart';

class DashBoardCtr extends BaseController<DashBoardState> {
  DashBoardCtr(DashBoardState state) : super(state) {
    getConfig();
  }

  double get space => 50;

  ConfigRespo? configRespo;

  void onExamPressed() {
    Get.toNamed(RouteManager().routeName.exam);
  }

  void getConfig() async {
    showLoading();
    var json = await HttpManager().getConfig();
    hideLoading();

    if (json != null) {
      configRespo = ConfigRespo.fromJson(json["data"]);
      print("GET========CONFIG=========>SUCCESS");
    }
  }
}
