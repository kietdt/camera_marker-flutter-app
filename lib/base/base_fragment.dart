import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'base_controller.dart';

abstract class BaseFragment<S extends StatefulWidget, C extends BaseController>
    extends State<S> with AutomaticKeepAliveClientMixin<S> {
  BaseController? _controller;

  BaseController? get controller => _controller;

  BaseController initController();

  @override
  void initState() {
    this._controller = Get.put(initController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [Obx(() => body()), buildLoading()],
    );
  }

  Widget body();

  Widget buildLoading() {
    return Obx(() => Visibility(
        visible: _controller?.loading.value ?? false,
        child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.1),
            child: SpinKitWanderingCubes(
                size: 52,
                color:
                    Colors.blue.shade200)))); // tạm thời để build loading rỗng
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller?.onDispose();
    super.dispose();
  }
}
