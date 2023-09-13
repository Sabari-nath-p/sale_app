import 'package:flutter/material.dart';
import 'package:seematti/utiles/sizer.dart';
import 'package:seematti/utiles/textstyles.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class SalesDetialCard extends StatefulWidget {
  Color color;
  var data;
  SalesDetialCard({super.key, required this.color, required this.data});

  @override
  State<SalesDetialCard> createState() => _SalesDetialCardState();
}

class _SalesDetialCardState extends State<SalesDetialCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double precentage = 0;
    precentage = (widget.data["netSalePerc"] * 3.24);
    return AnimatedContainer(
      height: (isExpanded) ? 220 : 120,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 200),
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
          border: (isExpanded) ? Border.all(color: Color(0xffB32033)) : null),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: tx500("${widget.data["item"]}",
                    color: Colors.black, size: 14),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Container(
                    width: 25,
                    height: 25,
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
              tx700("${widget.data["netSaleAmount"]}",
                  color: Colors.black, size: 18),
              Expanded(child: Container()),
              tx700("${widget.data["netSalePerc"]}%",
                  size: 18, color: widget.color)
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
                width: precentage.toDouble(),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.color),
              )),
          Expanded(
              child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                  left: 0,
                  top: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tx600("${widget.data["discountAmount"]}",
                          size: 16, color: Colors.black),
                      tx400("Discount Amount", size: 10, color: Colors.black)
                    ],
                  )),
              Positioned(
                  right: 0,
                  top: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      tx600("${widget.data["taxAmount"]}",
                          size: 16, color: Colors.black),
                      tx400("Tax Amount", size: 10, color: Colors.black)
                    ],
                  )),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tx600("${widget.data["returnAmount"]}",
                          size: 16, color: Colors.black),
                      tx400("Return Amount", size: 10, color: Colors.black)
                    ],
                  )),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      tx600("${widget.data["totalPieces"]}",
                          size: 16, color: Colors.black),
                      tx400("Total Pieces", size: 10, color: Colors.black)
                    ],
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
