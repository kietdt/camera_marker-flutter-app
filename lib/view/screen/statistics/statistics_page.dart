import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';

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
            text:
                "${widget.payload?.exam?.title} (${widget.payload?.exam?.myClass?.code})")
        .toAppBar();
  }

  @override
  Widget body() {
    return SizedBox();
  }
}
