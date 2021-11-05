import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/base/utils.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'statistics_ctr.dart';

class StatisticsPagePayload {
  final Exam? exam;

  StatisticsPagePayload({this.exam});
}

class StatisticsPage extends StatefulWidget {
  final StatisticsPagePayload? payload;

  const StatisticsPage({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatisticsState();
  }
}

class StatisticsState extends BaseScaffold<StatisticsPage, StatisticsCtr> {
  @override
  StatisticsCtr initController() {
    return StatisticsCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(
      back: true,
      text: "Thống kê",
      action: [_export()],
    ).toAppBar();
  }

  @override
  Future onResumed() {
    if (controller.excelPath.isNotEmpty) {
      Utils.deletefile(controller.excelPath);
      controller.excelPath = "";
    }
    return super.onResumed();
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
                asset: "lib/asset/ic_rank.png",
                text: "Xếp loại",
                onTap: controller.onChartPressed,
                bgColor: Color(0xff5285cd)),
          ),
          line(),
          Expanded(
            child: _item(
                asset: "lib/asset/ic_question.png",
                text: "Tỉ lệ đúng",
                onTap: controller.onQuestionPressed,
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

  Widget _export() {
    return InkWell(
        onTap: controller.onExportPressed,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.offline_share,
              color: ResourceManager().color.white,
            )));
  }

  Widget exportOption() {
    return Column(
      children: List.generate(2, (index) {
        return InkWell(
          onTap: () => controller.onOptionSelected(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Icon(
                      controller.optionSelected.value == index
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: ResourceManager().color.primary,
                    )),
                SizedBox(width: 7),
                Text(controller.optionDes[index]),
              ],
            ),
          ),
        );
      }),
    );
  }
}
