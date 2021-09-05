import 'package:camera_marker/resource/route_name.dart';
import 'package:camera_marker/view/screen/answer/answer_page.dart';
import 'package:camera_marker/view/screen/answer_fill/answer_fill_page.dart';
import 'package:camera_marker/view/screen/camera_transform/yuv_transform_screen.dart';
import 'package:camera_marker/view/screen/class/class_list_page.dart';
import 'package:camera_marker/view/screen/dash_board/dash_board_page.dart';
import 'package:camera_marker/view/screen/exam/exam_page.dart';
import 'package:camera_marker/view/screen/exam_manager/exam_manager_page.dart';
import 'package:camera_marker/view/screen/template_detail/template_detail_page.dart';
import 'package:camera_marker/view/screen/template_list/template_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class RouteManager {
  static RouteManager? _internal;
  RouteManager._();

  BaseRouteName routeName = BaseRouteName();
  Map<String, Widget Function(dynamic)>? routes;

  String? initialRoute;

  NavigatorObserver navigatorOnservers = RouteObserver<PageRoute>();

  factory RouteManager() {
    if (_internal == null) _internal = RouteManager._();
    return _internal!;
  }

  void init() {
    initialRoute = routeName.dashBoard;
    routes = _initRoute();
  }

  Route onGenerateRoute(RouteSettings routeSettings) {
    return GetPageRoute(
        curve: Curves.linear,
        settings: routeSettings,
        page: () => routes![routeSettings.name]!(routeSettings.arguments));

    ;
  }

  Map<String, Widget Function(dynamic)> _initRoute() {
    return {
      routeName.dashBoard: (payload) => DashBoardPage(),
      routeName.cameraScan: (payload) => YuvTransformScreen(payload: payload),
      routeName.exam: (payload) => ExamPage(),
      routeName.templateList: (payload) => TemplateList(),
      routeName.tempPlateDetail: (payload) => TemplateDetail(payload: payload),
      routeName.classList: (payload) => ClassListPage(),
      routeName.examManager: (payload) => ExamManager(payload: payload),
      routeName.answer: (payload) => AnswerPage(payload: payload),
      routeName.answerFill: (payload) => AnswerFillPage(payload: payload),
    };
  }
}
