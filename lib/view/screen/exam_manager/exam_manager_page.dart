import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_image_view.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

import 'exam_manager_ctr.dart';

//created by kietdt 08/08/2021
//contact email: dotuankiet1403@gmail.com
class ExamManagerPayLoad {
  final Exam? exam;

  ExamManagerPayLoad(this.exam);
}

class ExamManager extends StatefulWidget {
  final ExamManagerPayLoad? payload;

  const ExamManager({Key? key, this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExamManagerState();
  }
}

class ExamManagerState extends BaseScaffold<ExamManager, ExamManagerCtr> {
  @override
  ExamManagerCtr initController() {
    return ExamManagerCtr(this);
  }

  @override
  void initState() {
    super.initState();
    appBar = BaseAppBar(back: true, text: "Quản Lý Kì Thi").toAppBar();
  }

  @override
  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        itemRow(
          item("Đáp án", "lib/asset/ic_answer.png", controller.navigateAnswer),
          item("Chấm bài", "lib/asset/ic_marking.png", controller.navigateScan),
        ),
        itemRow(
          item("Bài đã chấm", "lib/asset/ic_graded.png",
              controller.navigateHistory),
          item("Thống kê", "lib/asset/ic_statistics.png",
              controller.navigateStatistics),
        ),
      ],
    );
  }

  Widget itemRow(Widget first, Widget second) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        first,
        second,
      ],
    );
  }

  Widget item(String title, String image, Function() onTap) {
    double width = screen.width / 2.3;
    double height = screen.height / 2.5;
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: ResourceManager().color.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(7))),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [itemImage(image), SizedBox(height: 7), itemTitle(title)],
          )),
    );
  }

  Widget itemImage(String image) {
    double size = screen.width / 6;

    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(width: 2, color: ResourceManager().color.primary)),
        child: CustomImageView(image,
            width: size, height: size, color: ResourceManager().color.primary));
  }

  Widget itemTitle(String title) {
    double textSize = screen.width / 20;
    return Text(title,
        style: ResourceManager().text.boldStyle.copyWith(
            fontSize: textSize, color: ResourceManager().color.primary));
  }
}
