import 'package:camera_marker/resource/route_name.dart';
import 'package:camera_marker/screen/camera_transform/yuv_transform_screen.dart';
import 'package:camera_marker/screen/dash_board/dash_board_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static RouteManager? _internal;
  RouteManager._();

  BaseRouteName routeName = BaseRouteName();
  Map<String, Widget Function(BuildContext)>? routes;

  String? initialRoute;

  factory RouteManager() {
    if (_internal == null) _internal = RouteManager._();
    return _internal!;
  }

  void init() {
    initialRoute = routeName.dashBoard;
    routes = _initRoute();
  }

  Map<String, Widget Function(BuildContext)> _initRoute() {
    return {
      routeName.dashBoard: (context) => DashBoardPage(),
      routeName.cameraScan: (context) => YuvTransformScreen()
    };
  }
}
