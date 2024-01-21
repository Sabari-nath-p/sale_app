import 'package:flutter/material.dart';
import 'package:seematti/MVC/SaleDataModel.dart';
import 'package:seematti/utiles/functionSupporter.dart';
import 'package:seematti/utiles/sizer.dart';
import 'package:seematti/utiles/textstyles.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:sizer/sizer.dart';

class SalesDetialCard extends StatefulWidget {
  Color color;
  SalesDetails data;
  SalesDetialCard({super.key, required this.color, required this.data});

  @override
  State<SalesDetialCard> createState() => _SalesDetialCardState();
}

class _SalesDetialCardState extends State<SalesDetialCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double precentage = 0;
    precentage = (widget.data.netSalePerc! * .87.w);
    return AnimatedContainer(
      height: (isExpanded) ? 25.8.h : 16.29.h,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: .7.h),
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
          border: (isExpanded) ? Border.all(color: Color(0xffB32033)) : null),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: tx500(StringtoFormate("${widget.data.item}"),
                    color: Colors.black, size: 14),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                    width: 6.57.w,
                    height: 6.57.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: (isExpanded)
                            ? Color(0xffB32033)
                            : Color(0xffD9D9D9)),
                    child: AnimatedRotation(
                      turns: (isExpanded) ? 2 / 8 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: (isExpanded) ? Colors.white : Colors.black,
                      ),
                    )),
              )
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
              tx700("${ToFixed(widget.data.netSaleAmount)}",
                  color: Colors.black, size: 18),
              Expanded(child: Container()),
              tx700("${widget.data.netSalePerc}%",
                  size: 18, color: widget.color)
            ],
          ),
          height(1.5.h),
          Container(
              height: 7,
              width: 86.31.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffD7D7D7)),
              child: Container(
                height: 7,
                width: precentage.toDouble(),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.color),
              )),
          height(10),
          Expanded(
              child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tx600("${ToFixed(widget.data.discountAmount)}",
                              size: 16, color: Colors.black),
                          tx400("Discount Amount",
                              size: 10, color: Colors.black)
                        ],
                      ),
                    height(15),
                    if (isExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tx600("${ToFixed(widget.data.returnAmount)}",
                              size: 16, color: Colors.black),
                          tx400("Return Amount", size: 10, color: Colors.black)
                        ],
                      ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tx600("${ToFixed(widget.data.taxAmount)}",
                              size: 16, color: Colors.black),
                          tx400("Tax Amount", size: 10, color: Colors.black)
                        ],
                      ),
                    height(15),
                    if (isExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tx600("${widget.data.totalPieces}",
                              size: 16, color: Colors.black),
                          tx400("Total Pieces", size: 10, color: Colors.black)
                        ],
                      )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
