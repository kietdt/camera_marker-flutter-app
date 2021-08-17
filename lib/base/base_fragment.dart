import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'base_controller.dart';

//created by Kietdt 28/07/2021
//contact email: dotuankiet1403@gmail.com
abstract class BaseFragment<S extends StatefulWidget, C extends BaseController>
    extends State<S>
    with AutomaticKeepAliveClientMixin<S>, WidgetsBindingObserver {
  C? _controller;

  C? get controller => _controller;

  C initController();

  //screen argument
  Size get screen => MediaQuery.of(context).size;
  double get statusBar => MediaQuery.of(context).padding.top;
  double get navigateBar => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    this._controller = initController();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await inactive();
        break;
      case AppLifecycleState.resumed:
        await resumed();
        break;
      case AppLifecycleState.paused:
        await paused();
        break;
      case AppLifecycleState.detached:
        await detached();
        break;
    }
  }

  Future inactive() async {}
  Future resumed() async {}
  Future paused() async {}
  Future detached() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [body(), buildLoading()],
    );
  }

  Widget body();

  Widget buildLoading() {
    return Obx(() => Visibility(
        visible: _controller!.loading.value,
        child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.1),
            child: SpinKitWanderingCubes(
                size: 52, color: ResourceManager().color!.primary))));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller!.onDispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
