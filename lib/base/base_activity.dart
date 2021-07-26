import 'package:camera_marker/base/base_fragment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BaseActivity<S extends StatefulWidget, C extends BaseController>
    extends BaseFragment<S, C> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Stack(children: [
        buildBackground(),
        GestureDetector(
          child: _buildScaffold(),
          onTap: controller?.hideKeyboard,
        ),
        buildFrontground(),
        buildLoading(),
      ]),
    );
  }

  PreferredSizeWidget? buildAppbar() => null;
  Widget buildBackground() => Container(color: Colors.black12);
  Widget buildFrontground() => SizedBox();

  _buildScaffold() {
    return Scaffold(
        key: scaffoldKey, appBar: buildAppbar() ?? appBar, body: body());
  }

  Widget body();
}
