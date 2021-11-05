import 'dart:io';

import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/http_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:camera_marker/view/dialog/dialog_confirm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearMix {
  void onTap(Function onsuccess) {
    DialogConfirm.show(
        message:
            "Quá trình này sẽ đưa ứng dụng về trạng thái ban đầu, các dữ liệu: Lớp, kì thi và những bài đã chấm sẽ được xóa hết!",
        onRight: () => onClear(onsuccess));
  }

  void onClear(Function onsuccess) async {
    String root = await Utils.localPath();
    String last =
        Platform.pathSeparator + root.split(Platform.pathSeparator).last;
    root = root.replaceAll(last, "");
    await Utils.deletefile(root + "${Platform.pathSeparator}app_imageDir");
    await Utils.deletefile(root + "${Platform.pathSeparator}export");
    await Utils.deletefile(root + "${Platform.pathSeparator}photo");

    var _pref = await SharedPreferences.getInstance();
    _pref.clear();
    DataBaseCtr().clearSingleTon();
    await getConfig();
    onsuccess();
  }

  Future<void> getConfig() async {
    // showLoading();
    var json = await HttpManager().getConfig();
    // hideLoading();

    if (json?["data"] != null) {
      var configRespo = ConfigRespo.fromJson(json!["data"]);
      configRespo.template
          ?.removeWhere((element) => !(element.visible ?? true));
      Utils.statusPrint("GET TEMPLATE", "SUCCESS");
      DataBaseCtr().tbTemplate.setList(configRespo.template ?? []);
      Utils.statusPrint("SET",
          "thumbnail: ${DataBaseCtr().tbTemplate.entities.first.thumbnail}");
    }
  }
}
