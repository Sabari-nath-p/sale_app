import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seematti/components/salesdetailscard.dart';

import '../utiles/colors.dart';
import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';
import 'branchwiseSaled.dart';

class BranchWiseView extends StatefulWidget {
  var saleData;
  var branchData;
  var profitData;
  BranchWiseView(
      {super.key,
      required this.saleData,
      required this.branchData,
      required this.profitData});

  @override
  State<BranchWiseView> createState() => _BranchWiseViewState();
}

class _BranchWiseViewState extends State<BranchWiseView> {
  late List SalesData;
  late List ProfileData;
  late List BranchData;
  int branchWiseController = 0;

  @override
  void initState() {
    // TODO: implement initState
    SalesData = widget.saleData;
    ProfileData = widget.profitData;
    BranchData = widget.branchData;
    super.initState();
  }

  String SearchText = "";

  @override
  Widget build(BuildContext context) {
    int totalProfits = (ProfileData.isNotEmpty)
        ? ProfileData[ProfileData.length - 1]["totalProfit"]
        : 0;
    int totalSales = (ProfileData.isNotEmpty)
        ? SalesData[SalesData.length - 1]["totalSales"]
        : 0;
    return Column(
      children: [
        Container(
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 1),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff767680).withOpacity(.12)),
          child: Row(
            children: [
              width(8),
              Icon(
                Icons.search,
                size: 22,
                color: Color(0xff3C3C43),
              ),
              width(6),
              Expanded(
                child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        SearchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: "Search",
                      isCollapsed: true,
                      hintStyle: TextStyle(
                          fontFamily: "lato",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3C3C43)),
                    )),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          padding: EdgeInsets.all(2),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff767680).withOpacity(.12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    branchWiseController = 0;
                  });
                },
                child: Container(
                  height: 30,
                  width: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (branchWiseController == 0) ? Colors.white : null),
                  child: (branchWiseController == 0)
                      ? tx600("Sales", size: 14, color: primaryColor)
                      : tx500("Sales", size: 14, color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    branchWiseController = 1;
                  });
                },
                child: Container(
                  height: 30,
                  width: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (branchWiseController == 1) ? Colors.white : null),
                  child: (branchWiseController == 1)
                      ? tx600("Profit", size: 14, color: primaryColor)
                      : tx500("Profit", size: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        height(20),
        if (SearchText == "")
          Container(
            height: 150,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    //width: 148,
                    child: PieChart(
                      PieChartData(
                          sections: [
                            if (branchWiseController == 0 &&
                                SalesData.isNotEmpty)
                              for (int i = 0; i < BranchData.length; i++)
                                PieChartSectionData(
                                  value: double.parse(
                                          SalesData[i]["totalSales"].toString())
                                      .toDouble(),
                                  radius: 30,
                                  showTitle: false,
                                  color: ColorList[i % 4],
                                ),
                            if (branchWiseController == 1 &&
                                SalesData.isNotEmpty)
                              for (int i = 0; i < BranchData.length; i++)
                                PieChartSectionData(
                                  value: double.parse(ProfileData[i]
                                              ["totalProfit"]
                                          .toString())
                                      .toDouble(),
                                  radius: 30,
                                  showTitle: false,
                                  color: ColorList[i % 4],
                                ),
                          ],
                          centerSpaceRadius: 55,
                          sectionsSpace: 2,
                          centerSpaceColor: Colors.transparent),
                    )),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          tx700(BranchData.length.toString(),
                              size: 22, color: Colors.black),
                          tx600("Branches", size: 14, color: Colors.black)
                        ],
                      ),
                    ))
              ],
            ),
          ),
        if (SearchText == "")
          Column(
            children: [
              height(30),
              if (branchWiseController == 0)
                tx700(ToFixed(totalSales), size: 22, color: Colors.black),
              if (branchWiseController == 1)
                tx700(ToFixed(totalProfits), size: 22, color: Colors.black),
              height(8),
              if (branchWiseController == 0)
                tx500("Today's sale - All Branches",
                    size: 13, color: Colors.black),
              if (branchWiseController == 1)
                tx500("Today's profit - All Branches",
                    size: 13, color: Colors.black),
              height(22),
            ],
          ),
        if (branchWiseController == 0)
          for (int i = 0; i < BranchData.length; i++)
            if (BranchData[i]["branch"]
                    .toString()
                    .toUpperCase()
                    .contains(SearchText.toUpperCase()) ||
                SearchText == "")
              BranchWiseSales(
                color: ColorList[i % 4],
                BranchData: BranchData[i],
                Amountdata: SalesData[i],
                isSale: true,
              ),
        if (branchWiseController == 1)
          for (int i = 0; i < BranchData.length; i++)
            if (BranchData[i]["branch"]
                    .toString()
                    .toUpperCase()
                    .contains(SearchText.toUpperCase()) ||
                SearchText == "")
              BranchWiseSales(
                color: ColorList[i % 4],
                BranchData: BranchData[i],
                Amountdata: ProfileData[i],
                isSale: false,
              ),
      ],
    );
  }
}
