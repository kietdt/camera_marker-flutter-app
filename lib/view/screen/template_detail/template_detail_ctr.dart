import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/config.dart';
import 'package:share/share.dart';

import 'template_detail_page.dart';

class TemplateDetailCtr extends BaseController<TemplateDetailState> {
  TemplateDetailCtr(TemplateDetailState state) : super(state);

  double get mainPadding => 10;

  Template? get template => state.widget.payload?.template;
  String get downloadLink => template?.downloadLink ?? "";
  String get templateTitle => template?.title ?? "";
  String get subjectShare =>
      "[${ResourceManager().appName.toUpperCase()} - ${templateTitle.toUpperCase()}]";

  void onSharePressed() {
    Share.share(downloadLink, subject: subjectShare);
  }
}
