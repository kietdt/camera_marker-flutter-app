import 'package:camera_marker/base/base_activity.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:flutter/material.dart';

import 'dash_board_ctr.dart';

class DashBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends BaseActivity<DashBoardPage, DashBoardCtr> {
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
          SizedBox(height: controller!.space),
          _item(
              asset: "lib/asset/ic_exam.png",
              text: "Kì thi",
              onTap: controller!.onExamPressed),
          SizedBox(height: controller!.space),
          _item(
              asset: "lib/asset/ic_class.png",
              text: "Lớp",
              onTap: controller!.onExamPressed),
          SizedBox(height: controller!.space),
          _item(
              asset: "lib/asset/ic_template.png",
              text: "Mẫu đề thi",
              onTap: controller!.onExamPressed),
          SizedBox(height: controller!.space),
        ]));
  }

  Widget _item(
      {required String asset, required String text, required Function onTap}) {
    double size = 70;
    return Center(
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ResourceManager().color!.primary)),
            child: Image.asset(asset, width: size, height: size)),
        SizedBox(height: 15),
        Text(text,
            style: ResourceManager()
                .text!
                .boldStyle
                .copyWith(color: ResourceManager().color!.des))
      ]),
    );
  }
}
