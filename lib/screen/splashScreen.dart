import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:seematti/MVC/Controller.dart';
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
    // //no////print(log);
    // if (log == "null") {
    //   ScreenChanger(context, WelcomeScreen());
    // } else {}
  }

  List CompanyList = [];
  String selectedCompany = "";
  List BranchList = [];
  String selectedBranch = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Controller ctrl = Get.put(Controller());

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
