import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utiles/colors.dart';
import '../utiles/functionSupporter.dart';
import '../utiles/textstyles.dart';

class SalesGraph extends StatefulWidget {
  List salesGraphData;
  SalesGraph({super.key, required this.salesGraphData});

  @override
  State<SalesGraph> createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  double highSale = 0;
  double lastSale = 0;
  loadData() {
    for (var data in widget.salesGraphData)
      if (highSale < int.parse(data["netSaleAmount"].toString()).toDouble()) {
        setState(() {
          highSale = int.parse(data["netSaleAmount"].toString()).toDouble();
        });
      }
    highSale = highSale + highSale * 40 / 100;
    //  if (widget.salesGraphData.isNotEmpty) {
    double temp = int.parse(widget
            .salesGraphData[widget.salesGraphData.length - 1]["netSaleAmount"]
            .toString())
        .toDouble();
    lastSale = (temp - temp * 20 / 100).toDouble();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();

    //noprint(highSale);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadData();
  }

  bool checkDecimal(double value) {
    String temp = value.toString();
    List tm = temp.split(".");
    //noprint(tm[1]);
    if (tm[1] == '5') {
      return false;
    } else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        minX: 0,
        maxX: widget.salesGraphData.length.toDouble(),
        minY: 0,
        maxY: highSale,
        // maxX: 5,
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                drawBelowEverything: false,
                sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) => tx500(
                        (checkDecimal(value))
                            ? ""
                            : (widget.salesGraphData.length >
                                    (value - .5).toInt())
                                ? StringtoFormate(
                                    widget.salesGraphData[(value - .5).toInt()]
                                        ["item"])
                                : "",
                        size: 12),
                    interval: .5,
                    showTitles: true))),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 0),
              for (int i = 0; i < widget.salesGraphData.length; i++)
                FlSpot(
                    i + .5,
                    int.parse(widget.salesGraphData[i]["netSaleAmount"]
                            .toString())
                        .toDouble()),
              //  /   FlSpot(1, 850),
              FlSpot(widget.salesGraphData.length.toDouble(), lastSale)
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
        gridData: FlGridData(show: false)));
  }
}
