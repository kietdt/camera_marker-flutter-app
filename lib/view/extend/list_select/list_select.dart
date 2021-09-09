import 'dart:math';

import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/view/child/empty_page.dart';
import 'package:camera_marker/view/child/floating_action_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'list_select_ctr.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
abstract class ListSelect<S extends StatefulWidget, C extends ListSelectCtr, D>
    extends BaseScaffold<S, C> with TickerProviderStateMixin {
  late List<Widget> actionLeft = [];
  late List<Widget> actionRight = [];

  late List<Widget> actions = [_deleteAction()];

  Widget header() => SizedBox();

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
    return Column(
      children: [
        header(),
        Expanded(
          child: Obx(() => controller.items.value.isNotEmpty
              // ignore: invalid_use_of_protected_member
              ? list(controller.items.value as List<D>)
              : EmptyPageView(message: controller.emptyMessage)),
        ),
      ],
    );
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
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          itemCount: items.length,
          itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: controller.mainPadding),
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: itemCheckBox(items[index], index)))),
    );
  }

  Widget itemCheckBox(D? item, int index) {
    return AnimatedBuilder(
      animation: controller.deleteCtr,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
            offset: Offset(
                (controller.checkBoxSize * controller.deleteCtr.value) -
                    controller.checkBoxSize,
                0),
            child: child);
      },
      child: Stack(
        children: [
          Container(
            width: (screen.width -
                (2 * controller.mainPadding) +
                controller.checkBoxSize),
            child: Row(
              children: [
                _checkBox(index),
                Container(
                  width: screen.width - (2 * controller.mainPadding),
                  margin: EdgeInsets.only(top: controller.mainPadding),
                  child: InkWell(
                      onDoubleTap: () => controller.onDoubleTap(item, index),
                      onTap: () => controller.onTap(item, index),
                      child: child(item)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkBox(int index) {
    return Container(
      width: 25,
      alignment: Alignment.centerLeft,
      child: Obx(() => Checkbox(
          // ignore: invalid_use_of_protected_member
          value: controller.selecteList.value[index],
          activeColor: ResourceManager().color.primary,
          checkColor: ResourceManager().color.white,
          onChanged: (value) => controller.oncheckBox(index))),
    );
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
