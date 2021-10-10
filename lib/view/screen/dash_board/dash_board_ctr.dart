import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/http_manager.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:get/get.dart';

import 'dash_board_page.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class DashBoardCtr extends BaseController<DashBoardState> {
  DashBoardCtr(DashBoardState state) : super(state) {
    getConfig();
  }

  double get space => 50;

  ConfigRespo? configRespo;

  void onExamPressed() {
    Get.toNamed(RouteManager().routeName.exam);
  }

  void onClassPressed() {
    Get.toNamed(RouteManager().routeName.classList);
  }

  void onTemplatePressed() {
    Get.toNamed(RouteManager().routeName.templateList);
  }

  void getConfig() async {
    showLoading();
    var json = await HttpManager().getConfig();
    hideLoading();

    if (json?["data"] != null) {
      configRespo = ConfigRespo.fromJson(json!["data"]);
      configRespo?.template
          ?.removeWhere((element) => !(element.visible ?? true));
      Utils.statusPrint("CONFIG", "SUCCESS");
      DataBaseCtr().tbTemplate.setList(configRespo?.template ?? []);
      Utils.statusPrint("SET",
          "thumbnail: ${DataBaseCtr().tbTemplate.entities.first.thumbnail}");
    }
  }
}
