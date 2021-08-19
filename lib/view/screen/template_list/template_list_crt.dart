import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:camera_marker/view/screen/template_detail/template_detail_page.dart';

import 'template_list_page.dart';
import 'package:get/get.dart';

class TemplateListCtr extends BaseController<TemplateListState> {
  TemplateListCtr(TemplateListState state) : super(state) {
    init();
  }

  var templates = List<Template>.empty().obs;

  double get mainPadding => 15;

  void init() {
    templates.value = DataBaseCtr().tbTemplate.entities;
  }

  void onItemPressed(Template template) {
    Get.toNamed(RouteManager().routeName.tempPlateDetail,
        arguments: TemplateDetailPayload(template));
  }
}
