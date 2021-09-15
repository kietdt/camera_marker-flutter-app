import 'package:camera_marker/base/base_appbar.dart';
import 'package:camera_marker/base/base_scaffold.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/model/exam.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

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
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(height: 7),
          chart(),
          SizedBox(height: 22),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: itemLevel(
                        controller.statistics.veryGood.description,
                        controller.statistics.veryGood.color,
                        controller.statistics.countVeryGood.toString(),
                        controller.statistics.maxResult.toString(),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: itemLevel(
                        controller.statistics.good.description,
                        controller.statistics.good.color,
                        controller.statistics.countGood.toString(),
                        controller.statistics.maxResult.toString(),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: itemLevel(
                        controller.statistics.average.description,
                        controller.statistics.average.color,
                        controller.statistics.countAverage.toString(),
                        controller.statistics.maxResult.toString(),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: itemLevel(
                        controller.statistics.weak.description,
                        controller.statistics.weak.color,
                        controller.statistics.countWeak.toString(),
                        controller.statistics.maxResult.toString(),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: itemLevel(
                        controller.statistics.poor.description,
                        controller.statistics.poor.color,
                        controller.statistics.countPoor.toString(),
                        controller.statistics.maxResult.toString(),
                      ),
                    ),
                    SizedBox(width: 15),
                    Spacer()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget chart() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            )
          ],
          shape: BoxShape.circle,
          border: Border.all(width: 5, color: ResourceManager().color.primary)),
      child: PieChart(
        emptyColor: ResourceManager().color.white,
        dataMap: controller.dataChart,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: screen.width / 2,
        colorList: controller.colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        centerText: "",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: false,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: false,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }

  Widget itemLevel(String des, Color color, String count, String max) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: ResourceManager().color.card,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screen.width / 10,
              height: screen.width / 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  des,
                  style:
                      ResourceManager().text.normalStyle.copyWith(fontSize: 14),
                ),
                Text(
                  "$count/$max",
                  style: ResourceManager()
                      .text
                      .superboldStyle
                      .copyWith(fontSize: 19),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
