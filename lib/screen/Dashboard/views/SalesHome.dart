import 'dart:convert';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
//import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pinput/pinput.dart';
import 'package:seematti/MVC/BranchModel.dart';
import 'package:seematti/MVC/CompanyModel.dart';
import 'package:seematti/MVC/Controller.dart';
import 'package:seematti/screen/Dashboard/components/SalesWiseData.dart';

import 'package:seematti/screen/Dashboard/components/branchwiseView.dart';
import 'package:seematti/screen/Dashboard/components/salesGraph.dart';

import 'package:seematti/utiles/colors.dart';
import 'package:seematti/utiles/dateConverter.dart';
import 'package:sizer/sizer.dart';

import '../../../utiles/functionSupporter.dart';
import '../../../utiles/sizer.dart';
import '../../../utiles/textstyles.dart';
import 'package:http/http.dart' as http;

final List myList = const [
  {'id': 'dog', 'label': 'Dog'},
  {'id': 'cat', 'label': 'Cat'},
  {'id': 'mouse', 'label': 'Mouse'},
  {'id': 'rabbit', 'label': 'Rabbit'},
];

class ScalesHome extends StatefulWidget {
  ScalesHome({
    super.key,
  });

  @override
  State<ScalesHome> createState() => _ScalesHomeState();
}

class _ScalesHomeState extends State<ScalesHome> {
  int backController = 0;
  int branchWiseController = 0;

  @override
  void initState() {
    // TODO: implement initState
    //  / loadCompany();
    BackButtonInterceptor.add(myInterceptor, zIndex: 2, name: "SomeName");

    super.initState();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (backController != 0)
      setState(() {
        backController = 0;
      });
    else {
      //print("workig");
      exit(0);
    } // Do some stuff.
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("SomeName");
    super.dispose();
  }

  Controller ctrl = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    // //////print(fromDate);
    // //////print(ToDate);

    //////print(synctime);
    // if (ctrl.SalesData != null) SalesData = json.decode(ctrl.SalesData!.data!.toJson);
    return GetBuilder<Controller>(builder: (_) {
      String synctime = "";
      final f = DateFormat('dd/MM/yyyy');
      final timeFormated = new DateFormat('dd MMM hh:mm a');

      if (ctrl.SalesData!.data!.syncDateTime != null) {
        DateTime time = DateTime.parse(DateFormateCorrector(
            ctrl.SalesData!.data!.syncDateTime.toString()));

        synctime = timeFormated.format(time);
      }
      return (ctrl.SalesData == null)
          ? Container()
          : Container(
              //padding: MediaQuery.of(context).viewInsets,
              color: Color(0xffF8F8F8),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.2.w, vertical: 1.4.h),
                    height: 5.88.h,
                    alignment: Alignment.bottomLeft,
                    color: Color(0xffF3F1EE),
                    child: Row(
                      children: [
                        //   if (backController == 0)
                        //  InkWell(onTap: () {}, child: Icon(Icons.menu)),
                        if (backController != 0)
                          InkWell(
                              onTap: () {
                                setState(() {
                                  backController = 0;
                                });
                              },
                              child: Icon(Icons.arrow_back_rounded)),
                        width(10),
                        if (backController == 1)
                          tx600("Sales Details", size: 18, color: Colors.black),
                        if (backController == 0)
                          tx600("Sales Statistics",
                              size: 18, color: Colors.black),
                        if (backController == 2)
                          tx600("Branch-wise", size: 18, color: Colors.black),
                        Expanded(
                            child: Container(
                          height: 2.35.h,
                        )),
                        if (backController != 0)
                          InkWell(
                            onTap: () {
                              print(backController);
                              if (backController == 1) {
                                ctrl.sortSales();
                              } else {
                                ctrl.SortAlphabetically();
                              }
                            },
                            child: SizedBox(
                              height: 3.5.h,
                              width: 3.5.h,
                              child: Image.asset(
                                "assets/icons/atoz.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  if (backController == 1)
                    Container(
                        height: MediaQuery.of(context).size.height - 20.5.h,
                        child: SingleChildScrollView(child: SaleDataView())),
                  if (backController == 2)
                    Container(
                        height: MediaQuery.of(context).size.height - 20.58.h,
                        child: SingleChildScrollView(
                          child: BranchWiseView(),
                        )),
                  if (backController == 0)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            height(10),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (ctrl.SelectedCompany != null)
                                    Container(
                                        width: 38.1.w,
                                        height: 4.9.h,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff323030),
                                                width: .6),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                        child: (ctrl.companyModel!.company!
                                                    .length ==
                                                1)
                                            ? tx500(
                                                StringtoFormate(ctrl
                                                    .companyModel!
                                                    .company![0]
                                                    .company!),
                                                size: 14,
                                                color: Colors.black)
                                            : DropdownButton<Company>(
                                                isExpanded: true,
                                                value: ctrl.SelectedCompany,
                                                isDense: true,
                                                icon: RotatedBox(
                                                  quarterTurns: (3).toInt(),
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 14,
                                                  ),
                                                ),
                                                underline: Container(),
                                                onChanged: (value) {
                                                  ctrl.SelectedCompany = value;
                                                  ctrl.SelectedBranch = [];

                                                  ctrl.loadBranch(value!
                                                      .companyID
                                                      .toString());
                                                },
                                                items: ctrl
                                                    .companyModel!.company!
                                                    .map((var data) {
                                                  return new DropdownMenuItem<
                                                      Company>(
                                                    value: data,
                                                    child: tx500(
                                                        StringtoFormate(data
                                                            .company
                                                            .toString()),
                                                        size: 14,
                                                        color: Colors.black),
                                                  );
                                                }).toList())),
                                  width(2.6.w),
                                  if (ctrl.SelectedBranch != null)
                                    Expanded(
                                      child: Container(
                                          height: 4.9.h,
                                          color: Colors.white,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              56.5.w,
                                          child: MultiSelectDropdown.simpleList(
                                            includeSelectAll: true,
                                            numberOfItemsLabelToShow: 1,
                                            whenEmpty: "Select Branches",
                                            //   checkboxFillColor: Colors.white,
                                            //  splashColor: Colors.red,
                                            // checkboxFillColor:

                                            //     Colors.transparent,
                                            //isDense: true,
                                            // icon: Padding(
                                            //   padding:
                                            //       EdgeInsets.only(top: 1.2.h),
                                            //   child: RotatedBox(
                                            //     quarterTurns: (3).toInt(),
                                            //     child: Icon(
                                            //       Icons.arrow_back_ios_rounded,
                                            //       size: 14,
                                            //     ),
                                            //   ),
                                            // ),

                                            // decoration: InputDecoration(
                                            //     enabledBorder: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //             color:
                                            //                 Color(0xff323030),
                                            //             width: .6),
                                            //         gapPadding: 0,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10)),
                                            //     focusedBorder: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //             color:
                                            //                 Color(0xff323030),
                                            //             width: .6),
                                            //         gapPadding: 0,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10)),
                                            //     disabledBorder: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //             color:
                                            //                 Color(0xff323030),
                                            //             width: .6),
                                            //         gapPadding: 0,
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10)),
                                            //     border: OutlineInputBorder(
                                            //         borderSide: BorderSide(
                                            //             color: Color(0xff323030),
                                            //             width: .6),
                                            //         gapPadding: 0,
                                            //         borderRadius: BorderRadius.circular(10))),
                                            // childBuilder: (selectedValues) {
                                            //   if (selectedValues.length == 1) {
                                            //     return Padding(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 10),
                                            //       child: tx500(
                                            //           StringtoFormate(
                                            //               selectedValues.first
                                            //                   .toString()),
                                            //           size: 14,
                                            //           color: Colors.black),
                                            //     );
                                            //   } else if (selectedValues.length >
                                            //       1) {
                                            //     return Padding(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 10),
                                            //       child: tx500(
                                            //           StringtoFormate(
                                            //               selectedValues
                                            //                       .length
                                            //                       .toString() +
                                            //                   " Selected"
                                            //                       .toString()),
                                            //           size: 14,
                                            //           color: Colors.black),
                                            //     );
                                            //   } else {
                                            //     return Padding(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 10),
                                            //       child: tx500(
                                            //           StringtoFormate(
                                            //               "Select Branch"),
                                            //           size: 14,
                                            //           color: Colors.black),
                                            //     );
                                            //   }
                                            // },

                                            list: ctrl.BranchList,
                                            initiallySelected: ctrl.BS,
                                            listChanger: ctrl.listChanger,
                                            onChange: (value) {
                                              //   ctrl.SelectedBranch = value;

                                              ctrl.BS = value
                                                  .map((e) => e.toString())
                                                  .toList();
                                              ctrl.formBranchList();

                                              ctrl.update();

                                              ctrl.formBranchList();
                                              ctrl.update();
                                            },
                                          )),
                                    ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     //ctrl.controller.clearAllSelection();
                                  //     ctrl.SelectedBranch =
                                  //         ctrl.branchModel!.branch!;
                                  //     ctrl.update();
                                  //   },
                                  //   child: Container(
                                  //     width: 10.4.w,
                                  //     height: 10.4.w,
                                  //     decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(8),
                                  //         color: Color(0xff767680)
                                  //             .withOpacity(.12)),
                                  //     child: Icon(Icons.all_inbox),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            height(1.17.h),
                            Container(
                              height: 5.88.h,
                              margin: EdgeInsets.symmetric(horizontal: 5.2.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xff767680).withOpacity(.12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ctrl.startData = DateTime.now();
                                      ctrl.endDate = DateTime.now();
                                      ctrl.LoadSaleData();
                                    },
                                    child: Container(
                                      width: 26.3.w,
                                      alignment: Alignment.center,
                                      height: 3.88.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: tx600("Today",
                                          color: primaryColor, size: 14),
                                    ),
                                  ),
                                  tx500(
                                      "${f.format(ctrl.startData)} - ${f.format(ctrl.endDate)}",
                                      size: 14,
                                      color: Colors.black),
                                  InkWell(
                                    onTap: () async {
                                      //////print("worling");
                                      var result =
                                          await showCalendarDatePicker2Dialog(
                                        context: context,
                                        dialogSize: Size(78.9.w, 47.h),
                                        config:
                                            CalendarDatePicker2WithActionButtonsConfig(
                                                calendarType:
                                                    CalendarDatePicker2Type
                                                        .range,
                                                currentDate: DateTime.now()),
                                        value: [ctrl.startData, ctrl.endDate],
                                      );
                                      //////print(result);
                                      if (result != null) {
                                        if (result.length > 1) {
                                          setState(() {
                                            ctrl.startData = result[0]!;
                                            ctrl.endDate = result[1]!;
                                            ctrl.LoadSaleData();
                                          });
                                          //////print(CurrentBranchID);
                                        } else {
                                          setState(() {
                                            ctrl.startData = result[0]!;
                                            ctrl.endDate = result[0]!;
                                            ctrl.LoadSaleData();
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 8.4.w,
                                      height: 8.4.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xff767680)
                                              .withOpacity(.12)),
                                      child: Icon(Icons.calendar_month),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(2),
                              height: 23.5.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Image.asset(
                                        "assets/images/salescard.png",
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      left: 10.5.w,
                                      top: 10.5.w,
                                      child: tx500("Sales",
                                          size: 13, color: Colors.white)),
                                  Positioned(
                                      left: 10.5.w,
                                      top: 15.78.w,
                                      child: tx700(
                                          ToFixed(ctrl.totalSale.toString()),
                                          size: 22,
                                          color: Colors.white)),
                                  Positioned(
                                      left: 10.5.w,
                                      bottom: 18.02.w,
                                      child: tx500("Profits",
                                          size: 13, color: Colors.white)),
                                  Positioned(
                                      left: 10.5.w,
                                      bottom: 10.5.w,
                                      child: tx700(
                                          ToFixed(ctrl.totalProfits.toString()),
                                          size: 19,
                                          color: Colors.white)),
                                  Positioned(
                                    top: 7.8.w,
                                    bottom: 7.8.w,
                                    right: 10.5.w,
                                    width: 36.8.w,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          backController = 2;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (ctrl.SalesData!.data!.sales!
                                                  .isNotEmpty)
                                                tx700("Sales",
                                                    color: Colors.black,
                                                    size: 14),
                                              if (ctrl.SalesData!.data!.sales!
                                                  .isNotEmpty)
                                                tx500("Branch-wise",
                                                    color: Colors.black,
                                                    size: 8),
                                              if (ctrl.SalesData!.data!.sales!
                                                  .isEmpty)
                                                tx700("No Sales",
                                                    color: Colors.black,
                                                    size: 14),
                                              if (ctrl.SalesData!.data!.sales!
                                                  .isEmpty)
                                                tx500("Available",
                                                    color: Colors.black,
                                                    size: 8),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 7.8.w,
                                      bottom: 7.8.w,
                                      right: 5.2.w,
                                      width: 47.3.w,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (ctrl.SalesData!.data!.sales!
                                                .isNotEmpty)
                                              backController = 2;
                                            else
                                              Fluttertoast.showToast(
                                                  msg: "No data available");
                                          });
                                        },
                                        child: PieChart(
                                          PieChartData(
                                              sections: [
                                                if (ctrl.SalesData!.data!.sales!
                                                    .isNotEmpty)
                                                  for (int i = 0;
                                                      i <
                                                          ctrl.SalesData!.data!
                                                              .branches!.length;
                                                      i++)
                                                    PieChartSectionData(
                                                      value: double.parse(ctrl
                                                              .SalesData!
                                                              .data!
                                                              .sales![i]
                                                              .totalSales!
                                                              .toString())
                                                          .toDouble(),
                                                      radius: 30,
                                                      showTitle: false,
                                                      color: ColorList[i % 4],
                                                    ),
                                                // PieChartSectionData(
                                                //     value: ctrl.totalSale!
                                                //         .toDouble(),
                                                //     radius: 28,
                                                //     showTitle: false,
                                                //     color: Color(0xff4ADEC3)),
                                                // PieChartSectionData(
                                                //     value: ctrl.totalProfits!
                                                //         .toDouble(),
                                                //     radius: 28,
                                                //     showTitle: false,
                                                //     color: Color(0xffF6C61A))
                                              ],
                                              centerSpaceRadius: 32,
                                              sectionsSpace: 2,
                                              centerSpaceColor:
                                                  Colors.transparent),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 31.76.h,
                              width: 94.21.w,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.1),
                                        offset: Offset(0, 0),
                                        blurRadius: 4)
                                  ]),
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  if (ctrl.SalesData!.data!.salesDetails!
                                      .isNotEmpty)
                                    Positioned(
                                        top: 7.6.h,
                                        bottom: 4.1.h,
                                        right: 2.6.w,
                                        left: 2.6.w,
                                        child: SalesGraph()),
                                  Positioned(
                                      right: 3.4.w,
                                      top: 3.4.w,
                                      width: 10.3.w,
                                      height: 10.2.w,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              ctrl.sortSales();
                                            });
                                          },
                                          child: Image.asset(
                                              "assets/icons/atoz.png"))),
                                  Positioned(
                                      left: 3.4.w,
                                      top: 3.4.w,
                                      child: tx500("Sales Details",
                                          size: 17, color: Colors.black)),
                                  Positioned(
                                      left: 3.4.w,
                                      top: 4.5.h,
                                      child: tx500("Section-wise sales details",
                                          size: 13, color: Colors.black)),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (ctrl.SalesData!.data!
                                                .salesDetails!.isNotEmpty)
                                              backController = 1;
                                            else
                                              Fluttertoast.showToast(
                                                  msg: "No sales available");
                                          });
                                        },
                                        child: Container(
                                          height: 3.5.h,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.6.w),
                                          padding: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Color(0xffE2E2E2)))),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              tx500("View Details ",
                                                  textAlign: TextAlign.center,
                                                  size: 12,
                                                  color: Colors.black
                                                      .withOpacity(.9)),
                                              width(2),
                                              InkWell(
                                                onTap: () {},
                                                child: SizedBox(
                                                    height: 8,
                                                    width: 8,
                                                    child: Image.asset(
                                                        "assets/icons/doubleright.png")),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            height(2.3.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.1.w),
                              child: Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                children: [
                                  SalesCard(
                                      "assets/icons/discount.png",
                                      "${ToFixed(ctrl.SalesData!.data!.discountAmount!.toString())}",
                                      "Discount Amount"),
                                  SalesCard(
                                      "assets/icons/tax.png",
                                      "${ToFixed(ctrl.SalesData!.data!.taxAmount!.toString())}",
                                      "Tax Amount"),
                                  SalesCard(
                                      "assets/icons/return.png",
                                      "${ToFixed(ctrl.SalesData!.data!.returnAmount!.toString())}",
                                      "Return Amount"),
                                  SalesCard(
                                      "assets/icons/pieces.png",
                                      "${ctrl.SalesData!.data!.totalPieces!.toString()}",
                                      "Total Pieces"),
                                ],
                              ),
                            ),
                            height(10),
                          ],
                        ),
                      ),
                    ),
                  if (backController == 0 && synctime != "")
                    Container(
                      height: 2.9.h,
                      width: double.infinity,
                      color: Color(0xffF4DDE0),
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tx500("Last successful sync at ",
                              size: 12, color: Color(0xffB8293B)),
                          tx600("$synctime", size: 12, color: Color(0xffB8293B))
                        ],
                      ),
                    )
                ],
              ),
            );
    });
  }

  SalesCard(String image, String amount, String title) {
    return Container(
      height: 7.6.h,
      width: 44.7.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: Offset(0, 0),
                blurRadius: 4)
          ]),
      child: Row(
        children: [
          width(5),
          SizedBox(
            height: 4.7.h,
            width: 10.5.w,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tx600(amount, size: 16, color: Colors.black),
              tx400(title, size: 12, color: Colors.black)
            ],
          )
        ],
      ),
    );
  }
}
