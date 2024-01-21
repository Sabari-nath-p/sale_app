import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:seematti/MVC/Controller.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';

import '../HomeMain.dart';
import '../../../utiles/colors.dart';
import '../../../utiles/functionSupporter.dart';
import '../../../utiles/textstyles.dart';

class SalesGraph extends StatefulWidget {
  SalesGraph({
    super.key,
  });

  @override
  State<SalesGraph> createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  double highSale = 0;
  double lastSale = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadData();

    // loadNotifier();

    //no//////print(highSale);
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   // loadData();
  //   ////print("working");
  // }

  bool checkDecimal(double value) {
    String temp = value.toString();
    List tm = temp.split(".");
    //no//////print(tm[1]);
    if (tm[1] == '5') {
      return false;
    } else
      return true;
  }

  Controller ctrl = Get.put(Controller());

  double findHigh() {
    int start = 0;
    for (var data in ctrl.SalesData!.data!.salesDetails!) {
      if (data.netSaleAmount! > start) {
        start = data.netSaleAmount!;
      }
    }

    return start.toDouble() + start / 10;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
            minWidth: 338,
            maxWidth: (ctrl.SalesData!.data!.salesDetails!.length < 4)
                ? 340
                : (90 * ctrl.SalesData!.data!.salesDetails!.length).toDouble() +
                    10),
        child: LineChart(LineChartData(
            minX: 0,

            // maxX: widget.salesGraphData.length.toDouble(),

            maxY: findHigh(),
            // maxX: 5,
            titlesData: FlTitlesData(
                //  show: false,
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    //  drawBelowEverything: false,
                    sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => tx500(
                            (checkDecimal(value))
                                ? ""
                                : (ctrl.SalesData!.data!.salesDetails!.length >
                                        (value - .5).toInt())
                                    ? StringtoFormate(ctrl
                                        .SalesData!
                                        .data!
                                        .salesDetails![(value - .5).toInt()]
                                        .item!)
                                    : "",
                            size: 12),
                        interval: .5,
                        showTitles: true))),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                preventCurveOverShooting: true,
                spots: [
                  FlSpot(0, 0),
                  for (int i = 0;
                      i < ctrl.SalesData!.data!.salesDetails!.length;
                      i++)
                    FlSpot(
                        i + .5,
                        int.parse(ctrl
                                .SalesData!.data!.salesDetails![i].netSaleAmount
                                .toString())
                            .toDouble()),
                  //  FlSpot(1, 850),
                  FlSpot(
                      ctrl.SalesData!.data!.salesDetails!.length.toDouble(),
                      int.parse(ctrl
                              .SalesData!
                              .data!
                              .salesDetails![
                                  ctrl.SalesData!.data!.salesDetails!.length -
                                      1]
                              .netSaleAmount
                              .toString())
                          .toDouble()),
                  // FlSpot(2, 1500),
                  // FlSpot(3, 900),
                  // FlSpot(4, 1300),
                  // FlSpot(5, 700)
                ],
                isCurved: true,
                color: primaryColor,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor,
                      primaryColor,
                      primaryColor.withOpacity(.9),
                      primaryColor.withOpacity(.8),
                      primaryColor.withOpacity(.7),
                      primaryColor.withOpacity(
                        .5,
                      ),
                      primaryColor.withOpacity(
                        .4,
                      ),
                      primaryColor.withOpacity(
                        .3,
                      ),
                      primaryColor.withOpacity(
                        .2,
                      ),
                      primaryColor.withOpacity(
                        .1,
                      ),
                    ],
                  ),
                ),
              )
            ],
            gridData: FlGridData(show: false))),
      ),
    );
  }
}
