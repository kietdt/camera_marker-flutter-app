import 'package:camera_marker/base/base_fragment.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

import 'base_controller.dart';

//created by Kietdt 28/07/2021
//contact email: dotuankiet1403@gmail.com
abstract class BaseScaffold<S extends StatefulWidget, C extends BaseController>
    extends BaseFragment<S, C> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PreferredSizeWidget? appBar;
  Widget? floatingActionButton() => null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      buildBackground(),
      GestureDetector(
        child: _scaffold(),
        onTap: controller?.hideKeyboard,
      ),
      buildLoading(),
    ]);
  }

  PreferredSizeWidget? buildAppbar() => null;

  Widget buildBackground() =>
      Container(color: ResourceManager().color.background);

  _scaffold() {
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppbar() ?? appBar,
      body: body(),
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget body();
}
