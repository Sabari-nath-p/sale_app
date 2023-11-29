import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seematti/MVC/Controller.dart';
import 'package:seematti/MVC/SaleDataModel.dart';
import 'package:seematti/components/salesdetailscard.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:sizer/sizer.dart';

import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';

class SaleDataView extends StatefulWidget {
  SaleDataView({super.key});

  @override
  State<SaleDataView> createState() => _SaleDataViewState();
}

class _SaleDataViewState extends State<SaleDataView> {
  int total = 0;
  String searchText = "";

  Calculatetotal() {
    setState(() {
      for (var data in ctrl.SalesData!.data!.salesDetails!) {
        total = total + int.parse(data.netSaleAmount.toString());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tempList = ctrl.SalesData!.data!.salesDetails!;
    super.initState();

    Calculatetotal();
    loadNotifier();
    //sortAlphabetial();
  }

  List<SalesDetails> tempList = [];
  bool IsSorted = false;
  sortAlphabetial() {
    ctrl.sortSales();
    // if (!IsSorted)
    //   tempList.sort((a, b) => a.item!.compareTo(b.item!));
    // else {
    //   tempList = ctrl.SalesData!.data!.salesDetails!;
    // }
    // IsSorted = !IsSorted;
    // setState(() {});
  }

  loadNotifier() async {
    ctrl.SortNotifier.addListener(() {
      sortAlphabetial();
    });
  }

  Controller ctrl = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 5.29.h,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 0),
          margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 1.1.h),
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
                      searchText = value;
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
                  ),
                ),
              ),
            ],
          ),
        ),
        if (searchText == "") height(2.5.h),
        if (searchText == "")
          tx700("${ToFixed(total)}", size: 24, color: Colors.black),
        height(4),
        if (searchText == "")
          tx500(
              ctrl.SelectedBranch.isNotEmpty
                  ? "Sales Details - ${StringtoFormate(ctrl.SelectedBranch!.first!.branch!)}"
                  : "Sales Details -  All Branch",
              size: 13,
              color: Colors.black),
        height(10),
        for (var data in tempList)
          if (data.item!
                  .toString()
                  .toUpperCase()
                  .contains(searchText.toUpperCase()) ||
              searchText == "")
            SalesDetialCard(
              color: ColorList[
                  ctrl.SalesData!.data!.salesDetails!.indexOf(data) % 4],
              data: data,
            ),
        height(2.35.h),
      ],
    );
  }
}
