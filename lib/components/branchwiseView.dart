import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seematti/MVC/BranchModel.dart';
import 'package:seematti/MVC/Controller.dart';
import 'package:seematti/MVC/SaleDataModel.dart';
import 'package:seematti/components/salesdetailscard.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';
import 'package:sizer/sizer.dart';

import '../utiles/colors.dart';
import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';
import 'branchwiseSaled.dart';

class BranchWiseView extends StatefulWidget {
  BranchWiseView({
    super.key,
  });

  @override
  State<BranchWiseView> createState() => _BranchWiseViewState();
}

class _BranchWiseViewState extends State<BranchWiseView> {
  late List<Sales> SalesData;
  late List<Profit> ProfileData;
  late List<Branches> BranchData;
  int branchWiseController = 0;

  @override
  void initState() {
    // TODO: implement initState
    SalesData = ctrl.SalesData!.data!.sales!;
    ProfileData = ctrl.SalesData!.data!.profit!;
    BranchData = ctrl.SalesData!.data!.branches!;
    super.initState();
    loadNotifier();
  }

  SortAlphabetically() {
    setState(() {
      if (!ctrl.sortBranch) {
        for (int i = 0; i < ctrl.SalesData!.data!.branches!.length - 1; i++) {
          if (ctrl.SalesData!.data!.branches![i].branch!
                  .compareTo(ctrl.SalesData!.data!.branches![i + 1].branch!) >
              0) {
            var temp = ctrl.SalesData!.data!.branches![i + 1];
            ctrl.SalesData!.data!.branches![i + 1] =
                ctrl.SalesData!.data!.branches![i];
            ctrl.SalesData!.data!.branches![i] = temp;

            var tm = ctrl.SalesData!.data!.sales![i + 1];
            ctrl.SalesData!.data!.sales![i + 1] =
                ctrl.SalesData!.data!.sales![i];
            ctrl.SalesData!.data!.sales![i] = tm;

            var tm2 = ctrl.SalesData!.data!.profit![i + 1];
            ctrl.SalesData!.data!.profit![i + 1] =
                ctrl.SalesData!.data!.profit![i];
            ctrl.SalesData!.data!.profit![i] = tm2;
          }
        }
        ctrl.sortBranch = true;
      } else {
        for (int i = 0; i < ctrl.SalesData!.data!.branches!.length - 1; i++) {
          if (ctrl.SalesData!.data!.sales![i].totalSales!
                  .compareTo(ctrl.SalesData!.data!.sales![i + 1].totalSales!) <
              0) {
            var temp = ctrl.SalesData!.data!.branches![i + 1];
            ctrl.SalesData!.data!.branches![i + 1] =
                ctrl.SalesData!.data!.branches![i];
            ctrl.SalesData!.data!.branches![i] = temp;

            var tm = ctrl.SalesData!.data!.sales![i + 1];
            ctrl.SalesData!.data!.sales![i + 1] =
                ctrl.SalesData!.data!.sales![i];
            ctrl.SalesData!.data!.sales![i] = tm;

            var tm2 = ctrl.SalesData!.data!.profit![i + 1];
            ctrl.SalesData!.data!.profit![i + 1] =
                ctrl.SalesData!.data!.profit![i];
            ctrl.SalesData!.data!.profit![i] = tm2;
          }
        }
        ctrl.sortBranch = false;
      }
    });
  }

  loadNotifier() {
    ctrl.SortNotifier.addListener(() {
      SortAlphabetically();
    });
  }

  String SearchText = "";
  Controller ctrl = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    int totalProfits = (ProfileData.isNotEmpty)
        ? ProfileData[ProfileData.length - 1].totalProfit!
        : 0;
    int totalSales = (ProfileData.isNotEmpty)
        ? SalesData[SalesData.length - 1].totalSales!
        : 0;

    SalesData = ctrl.SalesData!.data!.sales!;
    ProfileData = ctrl.SalesData!.data!.profit!;
    BranchData = ctrl.SalesData!.data!.branches!;
    return Column(
      children: [
        Container(
          height: 5.29.h,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 1),
          margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.1.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff767680).withOpacity(.12)),
          child: Row(
            children: [
              width(2.1.w),
              Icon(
                Icons.search,
                size: 22,
                color: Color(0xff3C3C43),
              ),
              width(1.8.w),
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
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3C3C43)),
                    )),
              ),
              Icon(
                Icons.mic,
                size: 22,
                color: Color(0xff3C3C43),
              ),
              width(2.1.w),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: .95.h),
          width: double.infinity,
          padding: EdgeInsets.all(2),
          height: 4.7.h,
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
                  height: 3.5.h,
                  width: 44.7.w,
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
                  height: 3.5.h,
                  width: 45.5.w,
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
        height(2.3.h),
        if (SearchText == "")
          Container(
            height: 17.64.h,
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
                                          SalesData[i].totalSales.toString())
                                      .toDouble(),
                                  radius: 30,
                                  showTitle: false,
                                  color: ColorList[i % 4],
                                ),
                            if (branchWiseController == 1 &&
                                SalesData.isNotEmpty)
                              for (int i = 0; i < BranchData.length; i++)
                                PieChartSectionData(
                                  value: double.parse(
                                          ProfileData[i].totalProfit.toString())
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
              height(3.5.h),
              if (branchWiseController == 0)
                tx700(ToFixed(totalSales), size: 22, color: Colors.black),
              if (branchWiseController == 1)
                tx700(ToFixed(totalProfits), size: 22, color: Colors.black),
              height(.95.h),
              if (branchWiseController == 0)
                tx500(
                    ctrl.SelectedBranch.isNotEmpty
                        ? "Sales - ${StringtoFormate(ctrl.SelectedBranch!.first!.branch!)}"
                        : "Sales -  All Branch",
                    size: 13,
                    color: Colors.black),
              if (branchWiseController == 1)
                tx500(
                    ctrl.SelectedBranch.isNotEmpty
                        ? "Profit - ${StringtoFormate(ctrl.SelectedBranch!.first!.branch!)}"
                        : "Profit -  All Branch",
                    size: 13,
                    color: Colors.black),
              height(2.5.h),
            ],
          ),
        if (branchWiseController == 0)
          for (int i = 0; i < BranchData.length; i++)
            if (BranchData[i]
                    .branch
                    .toString()
                    .toUpperCase()
                    .contains(SearchText.toUpperCase()) ||
                SearchText == "")
              BranchWiseSales(
                color: ColorList[i % 4],
                BranchData: BranchData[i],
                sale: SalesData[i],
                isSale: true,
              ),
        if (branchWiseController == 1)
          for (int i = 0; i < BranchData.length; i++)
            if (BranchData[i]
                    .branch
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
        height(2.3.h),
      ],
    );
  }
}
