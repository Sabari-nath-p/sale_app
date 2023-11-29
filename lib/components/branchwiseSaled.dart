import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seematti/MVC/SaleDataModel.dart';
import 'package:sizer/sizer.dart';

import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';

class BranchWiseSales extends StatelessWidget {
  Color color;
  Branches BranchData;
  Profit? Amountdata;
  Sales? sale;

  bool isSale = false;
  BranchWiseSales(
      {super.key,
      required this.color,
      this.Amountdata,
      this.sale,
      required this.BranchData,
      required this.isSale});

  @override
  Widget build(BuildContext context) {
    double precentage = 0;
    precentage = (isSale)
        ? (sale!.salesPercentage! * 3.24)
        : (Amountdata!.profitPercentage! * 3.24);
    return Container(
      height: 14.11.h,
      margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: .5.h),
      padding: EdgeInsets.all(4.2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: Offset(0, 0),
              blurRadius: 14)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: tx500(StringtoFormate(BranchData.branch!),
                    color: Colors.black),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1,
            margin: EdgeInsets.only(top: 1.8.w, bottom: 1.2.h),
            color: Color(0xffE2E2E2),
          ),
          Row(
            children: [
              tx700(
                  (isSale)
                      ? "${ToFixed(sale!.totalSales)}"
                      : "${ToFixed(Amountdata!.totalProfit)}",
                  color: Colors.black,
                  size: 18),
              Expanded(child: Container()),
              tx700(
                  (isSale)
                      ? "${sale!.salesPercentage}%"
                      : "${Amountdata!.profitPercentage}%",
                  size: 18,
                  color: color)
            ],
          ),
          height(1.5.h),
          Container(
              height: .9.h,
              width: 86.31.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffD7D7D7)),
              child: Container(
                height: .9.h,
                width: precentage,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
              )),
        ],
      ),
    );
  }
}
