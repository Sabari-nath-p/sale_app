import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:seematti/components/SalesWiseData.dart';
import 'package:seematti/components/branchwiseSaled.dart';
import 'package:seematti/components/branchwiseView.dart';
import 'package:seematti/components/salesGraph.dart';
import 'package:seematti/components/salesdetailscard.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/main.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:seematti/utiles/dateConverter.dart';

import '../../../utiles/functionSupporter.dart';
import '../../../utiles/sizer.dart';
import '../../../utiles/textstyles.dart';
import 'package:http/http.dart' as http;

class ScalesHome extends StatefulWidget {
  List clist;
  var SalesData;
  List blist;
  ScalesHome(
      {super.key,
      required this.blist,
      required this.clist,
      required this.SalesData});

  @override
  State<ScalesHome> createState() => _ScalesHomeState();
}

class _ScalesHomeState extends State<ScalesHome> {
  int backController = 0;
  int branchWiseController = 0;
  DateTime ToDate = DateTime.now();
  DateTime fromDate = DateTime.parse("2023-07-31 07:38:57.854003");

  @override
  void initState() {
    // TODO: implement initState
    //  / loadCompany();
    BackButtonInterceptor.add(myInterceptor, zIndex: 2, name: "SomeName");
    CompanyList = widget.clist;
    //BranchList = widget.blist;
    if (CompanyList.isNotEmpty) selectedCompany = CompanyList[0]["company"];
    selectedBranch = "All Branches";
    SalesData = widget.SalesData;
    super.initState();
    loadCompany();
    loadTotal();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (backController != 0)
      setState(() {
        backController = 0;
      }); // Do some stuff.
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("SomeName");
    super.dispose();
  }

  var SalesData;

  List CompanyList = [];
  String selectedCompany = "";
  List BranchList = [];
  String selectedBranch = "";

  loadCompany() async {
    final Respones = await http.post(Uri.parse("$baseurl/v1/company/dropdown"),
        body: json.encode({"userID": "$userid"}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("Company");
    print(Respones.body);
    if (Respones.statusCode == 200) {
      var js = json.decode(Respones.body);
      if (js["success"]) {
        // //noprint(Respones.body);
        setState(() {
          CompanyList = js["data"];
          //  //noprint(js['data']);
          if (CompanyList.isNotEmpty) {
            //noprint(Respones.body);
            selectedCompany = js["data"][0]["company"];
            loadBranch(js["data"][0]["companyID"]);
          }
        });
      }
    }
  }

  loadBranch(
    int id,
  ) async {
    final Respones = await http.post(Uri.parse("$baseurl/v1/branch/dropdown"),
        body: json.encode({"userID": "$userid", "companyID": id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (Respones.statusCode == 200) {
      //noprint(Respones.body);
      var js = json.decode(Respones.body);
      if (js["success"] && js["success"] != null) {
        setState(() {
          BranchList.add(
              {"branch": "All Branches", "branchID": "All Branches"});
          for (var data in js["data"]) BranchList.add(data);
          print(BranchList);
          //   if (BranchList.isNotEmpty) selectedBranch = js["data"][0]["branch"];
          loadSalesData(BranchIDlist());
        });
      }
    }
  }

  List BranchIDlist() {
    List temp = [];
    for (var data in BranchList)
      if (data["branch"] != "All Branches") temp.add(data["branchID"]);
    return temp;
  }

  List CurrentBranchID = [];
  final f = new DateFormat('dd/MM/yyyy');
  loadSalesData(List id) async {
    print(DateTime.now());
    CurrentBranchID = id;
    final Response = await http.post(Uri.parse("$baseurl/v1/mis/dashboard"),
        body: json.encode({
          "branchID": id,
          "userID": "$userid",
          "startDate": f.format(fromDate),
          "endDate": f.format(ToDate)
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print(Response.body);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      if (js["success"]) {
        setState(() {
          SalesData = js["data"];
          loadTotal();
        });
      }
    }
  }

  int totalSale = 0;
  int totalProfites = 0;

  loadTotal() {
    List saleList = SalesData["sales"];
    List profitList = SalesData["profit"];

    setState(() {
      totalSale = (saleList.isNotEmpty)
          ? saleList[saleList.length - 1]["totalSales"]
          : 0;
      ;
      totalProfites = (profitList.isNotEmpty)
          ? profitList[profitList.length - 1]["totalProfit"]
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(fromDate);
    // print(ToDate);

    final timeFormated = new DateFormat('dd MMM hh:mm a');
    DateTime time = DateTime.parse(
        DateFormateCorrector(SalesData["syncDateTime"].toString()));
    String synctime = timeFormated.format(time);
    print(synctime);

    return Container(
      //padding: MediaQuery.of(context).viewInsets,
      color: Color(0xffF8F8F8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            height: 50,
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
                  tx600("Sales Statistics", size: 18, color: Colors.black),
                if (backController == 2)
                  tx600("Branch-wise", size: 18, color: Colors.black),
                Expanded(
                    child: Container(
                  height: 20,
                )),
                if (backController != 0)
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/icons/atoz.png",
                      fit: BoxFit.fill,
                    ),
                  )
              ],
            ),
          ),
          if (backController == 1)
            Container(
                height: MediaQuery.of(context).size.height - 175,
                child: SingleChildScrollView(
                    child: SaleDataView(
                  salesDetails: SalesData["salesDetails"],
                ))),
          if (backController == 2)
            Container(
                height: MediaQuery.of(context).size.height - 175,
                child: SingleChildScrollView(
                  child: BranchWiseView(
                    saleData: SalesData["sales"],
                    profitData: SalesData["profit"],
                    branchData: SalesData["branches"],
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (selectedCompany != "")
                            Container(
                                width: 165,
                                height: 42,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff323030), width: .6),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: (CompanyList.length == 1)
                                    ? tx500(
                                        StringtoFormate(
                                            CompanyList[0]["company"]),
                                        size: 14,
                                        color: Colors.black)
                                    : DropdownButton(
                                        isExpanded: true,
                                        value: selectedCompany,
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
                                          setState(() {
                                            selectedCompany = value!;

                                            ///data[""]
                                          });
                                          for (var data in CompanyList) {
                                            setState(() {
                                              BranchList.clear();
                                              selectedBranch = "All Branches";
                                            });
                                            if (data["company"] == value) {
                                              loadBranch(data["companyID"]);
                                            }
                                          }
                                        },
                                        items: CompanyList.map((var data) {
                                          return new DropdownMenuItem<String>(
                                            value: data["company"].toString(),
                                            child: tx500(
                                                StringtoFormate(
                                                    data["company"].toString()),
                                                size: 14,
                                                color: Colors.black),
                                          );
                                        }).toList())),
                          width(10),
                          if (selectedBranch != "")
                            Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width -
                                    40 -
                                    10 -
                                    165,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff323030), width: .6),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: (BranchList.length == 1)
                                    ? tx500(
                                        StringtoFormate(
                                            BranchList[0]["branch"]),
                                        size: 14,
                                        color: Colors.black)
                                    : DropdownButton(
                                        isExpanded: true,
                                        value: selectedBranch,
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
                                          setState(() {
                                            selectedBranch = value!;
                                          });
                                          if (value != "All")
                                            for (var data in BranchList) {
                                              if (data["branch"] == value) {
                                                loadSalesData(
                                                    [data["branchID"]]);
                                              }
                                            }
                                          else {
                                            loadSalesData(BranchIDlist());
                                          }
                                        },
                                        items: BranchList.map((var data) {
                                          return new DropdownMenuItem<String>(
                                            value: data["branch"],
                                            child: tx500(data["branch"],
                                                size: 14, color: Colors.black),
                                          );
                                        }).toList())),
                        ],
                      ),
                    ),
                    height(10),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff767680).withOpacity(.12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child:
                                tx600("Today", color: primaryColor, size: 14),
                          ),
                          tx500("${f.format(fromDate)} - ${f.format(ToDate)}",
                              size: 14, color: Colors.black),
                          InkWell(
                            onTap: () async {
                              print("worling");
                              var result = await showCalendarDatePicker2Dialog(
                                context: context,
                                dialogSize: Size(300, 400),
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        calendarType:
                                            CalendarDatePicker2Type.range,
                                        currentDate: DateTime.now()),
                                value: [fromDate, ToDate],
                              );
                              print(result);
                              if (result != null) {
                                if (result.length > 1) {
                                  setState(() {
                                    fromDate = result[0]!;
                                    ToDate = result[1]!;
                                  });
                                  print(CurrentBranchID);
                                  loadSalesData(CurrentBranchID);
                                } else {
                                  setState(() {
                                    fromDate = result[0]!;
                                    ToDate = result[0]!;
                                  });

                                  loadSalesData(CurrentBranchID);
                                }
                              }
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff767680).withOpacity(.12)),
                              child: Icon(Icons.calendar_month),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(2),
                      height: 200,
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
                              left: 40,
                              top: 40,
                              child: tx500("Sales",
                                  size: 13, color: Colors.white)),
                          Positioned(
                              left: 40,
                              top: 60,
                              child: tx700(ToFixed(totalSale),
                                  size: 22, color: Colors.white)),
                          Positioned(
                              left: 40,
                              bottom: 70,
                              child: tx500("Profits",
                                  size: 13, color: Colors.white)),
                          Positioned(
                              left: 40,
                              bottom: 40,
                              child: tx700(ToFixed(totalProfites),
                                  size: 19, color: Colors.white)),
                          Positioned(
                            top: 30,
                            bottom: 30,
                            right: 40,
                            width: 140,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  backController = 2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (SalesData["sales"].isNotEmpty)
                                        tx700("Sales",
                                            color: Colors.black, size: 14),
                                      if (SalesData["sales"].isNotEmpty)
                                        tx500("Branch-wise",
                                            color: Colors.black, size: 8),
                                      if (SalesData["sales"].isEmpty)
                                        tx700("No Sales",
                                            color: Colors.black, size: 14),
                                      if (SalesData["sales"].isEmpty)
                                        tx500("Available",
                                            color: Colors.black, size: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 30,
                              bottom: 30,
                              right: 20,
                              width: 180,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (SalesData["sales"].isNotEmpty)
                                      backController = 2;
                                    else
                                      Fluttertoast.showToast(
                                          msg: "No data available");
                                  });
                                },
                                child: PieChart(
                                  PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                            value: totalSale.toDouble(),
                                            radius: 28,
                                            showTitle: false,
                                            color: Color(0xff4ADEC3)),
                                        PieChartSectionData(
                                            value: totalProfites.toDouble(),
                                            radius: 28,
                                            showTitle: false,
                                            color: Color(0xffF6C61A))
                                      ],
                                      centerSpaceRadius: 32,
                                      sectionsSpace: 2,
                                      centerSpaceColor: Colors.transparent),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 270,
                      width: 358,
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
                          Positioned(
                              top: 20,
                              bottom: 35,
                              right: 10,
                              left: 10,
                              child: SalesGraph(
                                salesGraphData: SalesData["salesDetails"],
                              )),
                          Positioned(
                              right: 13,
                              top: 13,
                              width: 40,
                              height: 40,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (SalesData["salesDetails"].isNotEmpty)
                                        backController = 1;
                                      else
                                        Fluttertoast.showToast(
                                            msg: "No sales available");
                                    });
                                  },
                                  child: Image.asset("assets/icons/atoz.png"))),
                          Positioned(
                              left: 13,
                              top: 13,
                              child: tx500("Sales Details",
                                  size: 17, color: Colors.black)),
                          Positioned(
                              left: 13,
                              top: 39,
                              child: tx500("Today’s section-wise sales details",
                                  size: 13, color: Colors.black)),
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (SalesData["salesDetails"].isNotEmpty)
                                      backController = 1;
                                    else
                                      Fluttertoast.showToast(
                                          msg: "No sales available");
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Color(0xffE2E2E2)))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tx500("View Details ",
                                          textAlign: TextAlign.center,
                                          size: 12,
                                          color: Colors.black.withOpacity(.9)),
                                      width(2),
                                      SizedBox(
                                          height: 8,
                                          width: 8,
                                          child: Image.asset(
                                              "assets/icons/doubleright.png"))
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    height(20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: [
                          SalesCard(
                              "assets/icons/discount.png",
                              "${ToFixed(SalesData["discountAmount"].toString())}",
                              "Discount Amount"),
                          SalesCard(
                              "assets/icons/tax.png",
                              "${ToFixed(SalesData["taxAmount"].toString())}",
                              "Tax Amount"),
                          SalesCard(
                              "assets/icons/return.png",
                              "${ToFixed(SalesData["returnAmount"].toString())}",
                              "Return Amount"),
                          SalesCard(
                              "assets/icons/pieces.png",
                              "${SalesData["totalPieces"].toString()}",
                              "Total Pieces"),
                        ],
                      ),
                    ),
                    height(10),
                  ],
                ),
              ),
            ),
          if (backController == 0)
            Container(
              height: 25,
              width: double.infinity,
              color: Color(0xffF4DDE0),
              padding: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tx500("Last successful sync at  ",
                      size: 12, color: Color(0xffB8293B)),
                  tx600("$synctime", size: 12, color: Color(0xffB8293B))
                ],
              ),
            )
        ],
      ),
    );
  }

  SalesCard(String image, String amount, String title) {
    return Container(
      height: 65,
      width: 170,
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
            height: 40,
            width: 40,
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
