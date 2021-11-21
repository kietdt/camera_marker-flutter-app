import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/http_manager.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:camera_marker/view/dialog/dialog_noti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dash_board_page.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class DashBoardCtr extends BaseController<DashBoardState> {
  DashBoardCtr(DashBoardState state) : super(state) {
    getConfig();
  }

  double get space => 50;

  ConfigRespo? configRespo;

  void onExamPressed() async {
    if (DataBaseCtr().tbClass.entities.length > 0) {
      Get.toNamed(RouteManager().routeName.exam);
    } else {
      await DialogNoti.show(
          message: "Để chấm thi, trước tiên hãy tạo lớp học!");
      Get.toNamed(RouteManager().routeName.classList);
    }
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

      //kiểm tra version app mới nhất chưa
      await checkUpdate(configRespo,
          onOldVersion: () => showUpdate(configRespo));

      configRespo?.template
          ?.removeWhere((element) => !(element.visible ?? true));
      Utils.statusPrint("GET TEMPLATE", "SUCCESS");
      DataBaseCtr().tbTemplate.setList(configRespo?.template ?? []);
      Utils.statusPrint("SET",
          "thumbnail: ${DataBaseCtr().tbTemplate.entities.first.thumbnail}");
    }
  }

  void onClearSuccess() {
    topSnackBar("Thông báo", "Toàn bộ dữ liệu đã được xóa");
  }

  Future<void> checkUpdate(ConfigRespo? configRespo,
      {Function()? onUptoDate, required Function() onOldVersion}) async {
    if (configRespo != null) {
      String? storeVersion = configRespo.config?.version;
      String appVersion = ResourceManager().deviceVersion.version;
      if (storeVersion != null) {
        int intStoreVersion = int.parse(storeVersion.replaceAll(".", ""));
        int intAppVersion = int.parse(appVersion.replaceAll(".", ""));
        if (intAppVersion < intStoreVersion) {
          return await onOldVersion();
        }
      }
    }

    if (onUptoDate != null) {
      onUptoDate();
    }
  }

  Future<void> showUpdate(ConfigRespo? configRespo) async {
    var result = "true";
    String? storeVersion = configRespo?.config?.version;
    bool forceUpdate = configRespo?.config?.forceUpdate ?? false;
    String linkUpdate =
        configRespo?.config?.linkUpdate ?? ResourceManager().linkUpdate;
    if (await canLaunch(linkUpdate))
      while (result is String && result.toLowerCase() == "true") {
        result = await DialogNoti.show(
          title: "Thông Báo",
          image: "lib/asset/ic_update.png",
          hasImage: true,
          imagePadding: EdgeInsets.symmetric(horizontal: 7, vertical: 14),
          imageSize: 55,
          barrierDismissible: forceUpdate,
          continuteMessage: "Cập Nhật",
          message:
              "Đã có phiên bản $storeVersion, vui lòng cập nhật để cải thiện trả nghiệm chấm thi của bạn!",
        );
        await launch(linkUpdate);
      }
  }
}
