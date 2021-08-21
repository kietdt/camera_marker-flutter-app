import 'dart:math';

import 'package:camera_marker/base/base_activity.dart';
import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/view/child/empty_page.dart';
import 'package:camera_marker/view/child/floating_action_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'class_list_ctr.dart';

class ClassListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClassListState();
  }
}

class ClassListState extends BaseActivity<ClassListPage, ClassListCtr>
    with TickerProviderStateMixin {
  @override
  ClassListCtr initController() {
    return ClassListCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Lớp", action: [_deleteAction()])
        .toAppBar();
  }

  @override
  Widget body() {
    // ignore: invalid_use_of_protected_member
    return Obx(() => controller!.classList.value.isNotEmpty
        // ignore: invalid_use_of_protected_member
        ? _class(controller!.classList.value)
        : EmptyPageView(
            message: "Chưa có lớp nào",
          ));
  }

  @override
  Widget? floatingActionButton() {
    return AnimatedBuilder(
        animation: controller!.deleteCtr,
        child: Obx(() => FloatingActionAdd(
              color: controller!.showSelect.value
                  ? ResourceManager().color!.delete
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

  Widget _class(List<Class> temps) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: controller!.mainPadding),
      margin: EdgeInsets.only(bottom: controller!.mainPadding),
      child: ListView.builder(
          itemCount: temps.length,
          itemBuilder: (ctx, index) => _itemClass(temps[index], index)),
    );
  }

  Widget _itemClass(Class? temp, int index) {
    return Row(
      children: [
        _checkBox(index),
        Expanded(
          child: InkWell(
            onTap: () => controller!.showUpdate(temp, index),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.only(top: controller!.mainPadding),
              decoration: BoxDecoration(
                  color: ResourceManager().color!.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mã lớp: ${temp?.code}",
                    style: ResourceManager().text!.boldStyle.copyWith(
                        color: ResourceManager().color!.primary, fontSize: 25),
                  ),
                  _itemDesc("Tên lớp", temp?.name),
                  _itemDesc("Mô tả", temp?.desc),
                  _itemDesc("Ngày tạo", Utils.dateToStr(temp?.createdAt)),
                  _itemDesc("Ngày cập nhật", Utils.dateToStr(temp?.updatedAt)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _deleteAction() {
    return InkWell(
        onTap: controller!.onSelect,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.delete)));
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
                  activeColor: ResourceManager().color!.primary,
                  checkColor: ResourceManager().color!.white,
                  onChanged: (value) => controller!.oncheckBox(index))),
            ),
          );
        });
  }

  Widget _itemDesc(String? title, String? decs) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              title ?? "",
              style: ResourceManager().text!.boldStyle.copyWith(fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              decs ?? "",
              style: ResourceManager().text!.normalStyle.copyWith(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
