import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

import 'dash_board_ctr.dart';

class DashBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends BaseScaffold<DashBoardPage, DashBoardCtr> {
  @override
  DashBoardCtr initController() {
    return DashBoardCtr(this);
  }

  @override
  Widget body() {
    return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Expanded(
            child: _item(
                asset: "lib/asset/ic_exam.png",
                text: "Kì thi",
                onTap: controller!.onExamPressed,
                bgColor: ResourceManager().color.primary),
          ),
          line(),
          Expanded(
            child: _item(
                asset: "lib/asset/ic_class.png",
                text: "Lớp",
                onTap: controller!.onClassPressed,
                bgColor: Color(0xff5285cd)),
          ),
          line(),
          Expanded(
            child: _item(
                asset: "lib/asset/ic_template.png",
                text: "Mẫu đề thi",
                onTap: controller!.onTemplatePressed,
                bgColor: ResourceManager().color.lightBlue),
          ),
        ]));
  }

  Widget _item(
      {required String asset,
      required String text,
      required void Function() onTap,
      required Color bgColor}) {
    double size = screen.height / 10;
    double padding = screen.height / 24;
    double textSize = screen.height / 24;
    return InkWell(
        onTap: onTap,
        child: Center(
            child: Container(
                color: bgColor,
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ResourceManager().color.white,
                                      width: 6)),
                              child: CustomImageView(asset,
                                  width: size,
                                  height: size,
                                  color: ResourceManager().color.white)))),
                  SizedBox(width: 15),
                  Expanded(
                      flex: 5,
                      child: Text(text,
                          style: ResourceManager().text.boldStyle.copyWith(
                              color: ResourceManager().color.white,
                              fontSize: textSize))),
                  next()
                ]))));
  }

  Widget line() {
    return Container(height: 2, color: ResourceManager().color.white);
  }

  Widget next() {
    return Container(
        child: Icon(Icons.navigate_next,
            color: ResourceManager().color.white, size: 40));
  }
}
