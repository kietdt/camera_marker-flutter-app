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
  late List<Widget> actionLeft = [];
  late List<Widget> actionRight = [];

  late List<Widget> actions = [_deleteAction()];

  @override
  void initState() {
    super.initState();
    actions.insertAll(0, actionLeft);
    actions.addAll(actionRight);
    appBar = BaseAppBar(back: true, text: controller.title, action: actions)
        .toAppBar();
  }

  @override
  Widget body() {
    // ignore: invalid_use_of_protected_member
    return Obx(() => controller.items.value.isNotEmpty
        // ignore: invalid_use_of_protected_member
        ? list(controller.items.value as List<D>)
        : EmptyPageView(message: controller.emptyMessage));
  }

  @override
  Widget? floatingActionButton() {
    return Obx(() => Visibility(
        visible: controller.showSelect.value || controller.showAdd,
        child: AnimatedBuilder(
            animation: controller.deleteCtr,
            child: Obx(() => FloatingActionAdd(
                  color: controller.showSelect.value
                      ? ResourceManager().color.delete
                      : null,
                  onTap: controller.showSelect.value
                      ? controller.onDelete
                      : controller.showNew,
                )),
            builder: (ctx, child) => Transform.rotate(
                  angle: controller.deleteCtr.value * (pi / 4),
                  child: child,
                ))));
  }

  Widget list(List<D> items) {
    return Container(
      margin: EdgeInsets.only(bottom: controller.mainPadding),
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: controller.mainPadding),
              child: itemCheckBox(items[index], index))),
    );
  }

  Widget itemCheckBox(D? item, int index) {
    return Row(
      children: [
        _checkBox(index),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: controller.mainPadding),
            child: InkWell(
                onDoubleTap: () => controller.onDoubleTap(item, index),
                onTap: () => controller.onTap(item, index),
                child: child(item)),
          ),
        ),
      ],
    );
  }

  Widget _checkBox(int index) {
    return AnimatedBuilder(
        animation: controller.deleteCtr,
        builder: (_, child) {
          return Visibility(
            visible: controller.showSelect.value,
            child: Container(
              width: 25 * controller.deleteCtr.value,
              alignment: Alignment.centerLeft,
              child: Obx(() => Checkbox(
                  // ignore: invalid_use_of_protected_member
                  value: controller.selecteList.value[index],
                  activeColor: ResourceManager().color.primary,
                  checkColor: ResourceManager().color.white,
                  onChanged: (value) => controller.oncheckBox(index))),
            ),
          );
        });
  }

  Widget _deleteAction() {
    return Obx(() => Visibility(
        visible: controller.items.length > 0,
        child: InkWell(
            onTap: controller.onSelect,
            child: Container(
                margin: EdgeInsets.only(right: 15, left: 7),
                child: Icon(Icons.delete)))));
  }

  Widget child(D? item);
}
