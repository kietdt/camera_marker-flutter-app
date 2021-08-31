import 'dart:math';

import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/view/child/empty_page.dart';
import 'package:camera_marker/view/child/floating_action_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'list_select_ctr.dart';

abstract class ListSelect<S extends StatefulWidget, C extends ListSelectCtr, D>
    extends BaseScaffold<S, C> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(
        back: true,
        text: controller!.title,
        action: [_deleteAction()]).toAppBar();
  }

  @override
  Widget body() {
    // ignore: invalid_use_of_protected_member
    return Obx(() => controller!.items.value.isNotEmpty
        // ignore: invalid_use_of_protected_member
        ? list(controller!.items.value as List<D>)
        : EmptyPageView(message: controller!.emptyMessage));
  }

  @override
  Widget? floatingActionButton() {
    return AnimatedBuilder(
        animation: controller!.deleteCtr,
        child: Obx(() => FloatingActionAdd(
              color: controller!.showSelect.value
                  ? ResourceManager().color.delete
                  : null,
              onTap: controller!.showSelect.value
                  ? controller!.onDelete
                  : controller!.showNew,
            )),
        builder: (ctx, child) => Transform.rotate(
              angle: controller!.deleteCtr.value * (pi / 4),
              child: child,
            ));
  }

  Widget list(List<D> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: controller!.mainPadding),
      margin: EdgeInsets.only(bottom: controller!.mainPadding),
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) => itemCheckBox(items[index], index)),
    );
  }

  Widget itemCheckBox(D? item, int index) {
    return Row(
      children: [
        _checkBox(index),
        Expanded(
          child: InkWell(
              onTap: () => controller!.onTap(item, index), child: child(item)),
        ),
      ],
    );
  }

  Widget _checkBox(int index) {
    return AnimatedBuilder(
        animation: controller!.deleteCtr,
        builder: (_, child) {
          return Visibility(
            visible: controller!.showSelect.value,
            child: Container(
              width: 25 * controller!.deleteCtr.value,
              alignment: Alignment.centerLeft,
              child: Obx(() => Checkbox(
                  // ignore: invalid_use_of_protected_member
                  value: controller!.selecteList.value[index],
                  activeColor: ResourceManager().color.primary,
                  checkColor: ResourceManager().color.white,
                  onChanged: (value) => controller!.oncheckBox(index))),
            ),
          );
        });
  }

  Widget _deleteAction() {
    return Obx(() => Visibility(
        visible: controller!.items.length > 0,
        child: InkWell(
            onTap: controller!.onSelect,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.delete)))));
  }

  Widget child(D? item);
}
