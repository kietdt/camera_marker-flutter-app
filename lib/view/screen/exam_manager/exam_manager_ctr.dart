import 'package:camera_marker/base/base_controller.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/view/screen/answer/answer_page.dart';
import 'package:get/get.dart';

import 'exam_manager_page.dart';


//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ExamManagerCtr extends BaseController<ExamManagerState> {
  ExamManagerCtr(ExamManagerState state) : super(state);

  void navigateAnswer() {
    Get.toNamed(RouteManager().routeName.answer,
        arguments: AnswerPayload(exam: state.widget.payload?.exam));
  }
}
