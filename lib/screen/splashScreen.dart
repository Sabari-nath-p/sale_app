import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';
import 'package:seematti/screen/WelcomeScreen.dart';
import 'package:seematti/utiles/sizer.dart';
import 'package:seematti/utiles/textstyles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/stringData.dart';
import '../main.dart';
import 'Dashboard/HomeMain.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  loadLoginCheck(BuildContext context) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // String log = pref.getString("LOGIN").toString();
    Future.delayed(Duration(seconds: 2));
    // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HomeMain()));
    // //noprint(log);
    // if (log == "null") {
    //   ScreenChanger(context, WelcomeScreen());
    // } else {}
  }

  List CompanyList = [];
  String selectedCompany = "";
  List BranchList = [];
  String selectedBranch = "";

  loadCompany() async {
    print(userid);
    final Respones = await http.post(Uri.parse("$baseurl/v1/company/dropdown"),
        body: json.encode({"userID": "$userid"}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("Working");
    print(Respones.body);
    print("Working 1");
    if (Respones.statusCode == 200) {
      var js = json.decode(Respones.body);
      if (js["success"]) {
        setState(() {
          CompanyList = js["data"];
          if (CompanyList.isNotEmpty) {
            selectedCompany = js["data"][0]["company"];
            loadBranch(js["data"][0]["companyID"]);
          }
        });
      }
    }
  }

  loadBranch(int id) async {
    print(id);
    final Respones = await http.post(Uri.parse("$baseurl/v1/branch/dropdown"),
        body: json.encode({"userID": "$userid", "companyID": id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print(Respones.body);
    if (Respones.statusCode == 200) {
      var js = json.decode(Respones.body);
      if (js["success"] && js["success"] != null) {
        setState(() {
          BranchList = js["data"];
          if (BranchList.isNotEmpty) {
            selectedBranch = js["data"][0]["branch"];
            loadSalesData();
          }
        });
      }
    }
  }

  List BranchIDlist() {
    List temp = [];
    for (var data in BranchList) temp.add(data["branchID"]);
    return temp;
  }

  final f = new DateFormat('dd/MM/yyyy');
  loadSalesData() async {
    final Response = await http.post(Uri.parse("$baseurl/v1/mis/dashboard"),
        body: json.encode({
          "branchID": BranchIDlist(),
          "userID": "$userid",
          "startDate": "31/07/2023", //f.format(DateTime.now()),
          "endDate": f.format(DateTime.now()),
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print(Response.body);
    //noprint(Response.statusCode);
    //noprint(Response.body);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      if (js["success"]) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => HomeMain(
                Salesdata: js["data"],
                branchList: BranchList,
                companyList: CompanyList)));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned(
                top: 0, bottom: 0, left: 0, right: 0, child: Container()),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 167, 19, 39),
                    Color(0xffB32033)
                  ])),
                  child: Opacity(
                    opacity: .3,
                    child: Image.asset(
                      "assets/images/splashBG.png",
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.colorBurn,
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/client-logoWhite.png",
                        width: 200,
                        height: 70,
                      ),
                      height(10),
                      SizedBox(
                        width: 30,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOutRapid,
                          colors: [Colors.white],
                          strokeWidth: 10,
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
                //top: 0,
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    tx400("App ver : 1.0.0", color: Colors.white, size: 13),
                    height(4),
                    tx400("Service ver : 1.0.0", color: Colors.white, size: 13),
                    height(20),
                    SizedBox(
                        width: 100,
                        child: Image.asset("assets/images/mretail_white.png"))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
