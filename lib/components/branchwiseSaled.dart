import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';

class BranchWiseSales extends StatelessWidget {
  Color color;
  var BranchData;
  var Amountdata;
  bool isSale = false;
  BranchWiseSales(
      {super.key,
      required this.color,
      required this.Amountdata,
      required this.BranchData,
      required this.isSale});

  @override
  Widget build(BuildContext context) {
    double precentage = 0;
    precentage = (isSale)
        ? (Amountdata["salesPercentage"] * 3.24)
        : (Amountdata["profitPercentage"] * 3.24);
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: EdgeInsets.all(16),
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
                child: tx500(StringtoFormate(BranchData["branch"]),
                    color: Colors.black),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1,
            margin: EdgeInsets.only(top: 7, bottom: 11),
            color: Color(0xffE2E2E2),
          ),
          Row(
            children: [
              tx700(
                  (isSale)
                      ? "${ToFixed(Amountdata["totalSales"])}"
                      : "${ToFixed(Amountdata["totalProfit"])}",
                  color: Colors.black,
                  size: 18),
              Expanded(child: Container()),
              tx700(
                  (isSale)
                      ? "${ToFixed(Amountdata["salesPercentage"])}"
                      : "${ToFixed(Amountdata["profitPercentage"])}",
                  size: 18,
                  color: color)
            ],
          ),
          height(13),
          Container(
              height: 7,
              width: 328,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffD7D7D7)),
              child: Container(
                height: 7,
                width: precentage,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
              )),
        ],
      ),
    );
  }
}
