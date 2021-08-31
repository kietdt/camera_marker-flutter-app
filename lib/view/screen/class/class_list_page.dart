import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/class.dart';
import 'package:camera_marker/view/extend/list_select/list_select.dart';
import 'package:flutter/material.dart';

import 'class_list_ctr.dart';

class ClassListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClassListState();
  }
}

class ClassListState extends ListSelect<ClassListPage, ClassListCtr, MyClass> {
  @override
  ClassListCtr initController() {
    return ClassListCtr(this);
  }

  @override
  Widget child(MyClass? item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(top: controller!.mainPadding),
      decoration: BoxDecoration(
          color: ResourceManager().color.white,
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
            "Mã lớp: ${item?.code}",
            style: ResourceManager().text.boldStyle.copyWith(
                color: ResourceManager().color.primary, fontSize: 25),
          ),
          _itemDesc("Tên lớp", item?.name),
          _itemDesc("Mô tả", item?.desc),
          _itemDesc("Ngày tạo", Utils.dateToStr(item?.createdAt)),
          _itemDesc("Ngày cập nhật", Utils.dateToStr(item?.updatedAt)),
        ],
      ),
    );
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
              style: ResourceManager().text.boldStyle.copyWith(fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              decs ?? "",
              style: ResourceManager().text.normalStyle.copyWith(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
