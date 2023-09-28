import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/screen/forgotPassword.dart';
import 'package:seematti/screen/loginScreen.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../utiles/sizer.dart';
import '../../../utiles/textstyles.dart';
import 'package:http/http.dart';

class settingView extends StatefulWidget {
  ValueNotifier notifier;
  settingView({super.key, required this.notifier});

  @override
  State<settingView> createState() => _settingViewState();
}

class _settingViewState extends State<settingView> {
  int backController = 0;
  String currentTitle = "Settings";
  bool isPassVisible = false;
  bool isconfirm = false;
  bool isnew = false;
  bool isloading = false;
  TextEditingController currectPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor, zIndex: 1, name: "Setting");
    loadinfo();
    loadInfo2();
  }

  String appversion = "";
  String Version = "";
  loadinfo() async {
    final response = await get(
        Uri.parse(
          "$baseurl/v1/common/getsupportedversion",
        ),
        headers: {
          "Authorization": "Bearer $token",
        });
    // print(response.body);

    if (response.statusCode == 200) {
      var js = json.decode(response.body);

      if (js["success"]) {
        setState(() {
          appversion = js["data"]["android"];
        });
      }
    }
  }

  loadInfo2() async {
    final res = await get(Uri.parse("$baseurl/v1/common/getversion"), headers: {
      "Authorization": "Bearer $token",
    });
    print(res.body);
    if (res.statusCode == 200) {
      var js = json.decode(res.body);
      print(js);
      setState(() {
        Version =
            js["data"]["versionNo"].toString().replaceAll("-SNAPSHOT", "");
      });
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (backController > 0) {
      setState(() {
        backController = 0;
        currentTitle = "Settings";
      });
    }
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("Setting");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String letter = UserData["name"][0];
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        //height: MediaQuery.of(context).size.height - 71,
        color: Color(0xffF3F1EE),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              height: 50,
              alignment: Alignment.bottomLeft,
              color: Color(0xffF3F1EE),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        if (backController > 0) {
                          setState(() {
                            backController = 0;
                            currentTitle = "Settings";
                          });
                        } else {
                          print("print working");
                          widget.notifier.value++;
                          widget.notifier.notifyListeners();
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                      )),
                  width(10),
                  tx600(currentTitle, size: 18, color: Colors.black),
                ],
              ),
            ),
            if (backController == 0)
              Expanded(
                  child: Container(
                color: Color(0xffF8F8F8),
                child: Column(
                  children: [
                    settingItem("Profile", "assets/icons/profile2.png", 1),
                    settingItem(
                        "Change Password", "assets/icons/password.png", 2),
                    settingItem("App info", "assets/icons/info.png", 3),
                    InkWell(
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString("LOGIN", "SKIP");
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => LoginScreen()));
                      },
                      child: Container(
                        height: 55,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Color(0xffE2E2E2)))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset("assets/icons/logout.png"),
                            ),
                            tx600("Logout", size: 14, color: primaryColor),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
            if (backController == 2)
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(20),
                color: Color(0xffF8F8F8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tx400("Old password", size: 14, color: Colors.black),
                      height(11),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: currectPass,
                          obscureText: !isPassVisible,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // isCollapsed: true,
                              suffixIcon: (isPassVisible)
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPassVisible = !isPassVisible;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPassVisible = !isPassVisible;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility_off,
                                        color: Colors.black54,
                                      ),
                                    ),
                              isDense: true),
                        ),
                      ),
                      height(17),
                      tx400("New password", size: 14, color: Colors.black),
                      height(11),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: newPass,
                          obscureText: !isnew,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // isCollapsed: true,
                              suffixIcon: (isnew)
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          isnew = !isnew;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          isnew = !isnew;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility_off,
                                        color: Colors.black54,
                                      ),
                                    ),
                              isDense: true),
                        ),
                      ),
                      height(17),
                      tx400("Confirm new password",
                          size: 14, color: Colors.black),
                      height(11),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: confirmPass,
                          obscureText: !isconfirm,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // isCollapsed: true,
                              hintStyle: TextStyle(
                                  fontFamily: "lato",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              suffixIcon: (isconfirm)
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          isconfirm = !isconfirm;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          isconfirm = !isconfirm;
                                        });
                                      },
                                      child: Icon(
                                        Icons.visibility_off,
                                        color: Colors.black54,
                                      ),
                                    ),
                              isDense: true),
                        ),
                      ),
                      height(17),
                    ],
                  ),
                ),
              )),
            if (backController == 2)
              Container(
                color: Color(0xffF8F8F8),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: Image.asset("assets/icons/lock.png"),
                    ),
                    width(6),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(
                                userid: UserData["emailAddress"])));
                      },
                      child: tx500("Forgot Password?",
                          size: 13, color: Color(0xff323030)),
                    ),
                  ],
                ),
              ),
            if (backController == 2)
              Container(
                color: Color(0xffF8F8F8),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: InkWell(
                  onTap: () async {
                    if (currectPass.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please fill old password");
                    } else if (newPass.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please fill new password");
                    } else if (confirmPass.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please fill confirm new password");
                    } else if (isloading) {
                      Fluttertoast.showToast(msg: "Please wait");
                    } else if (newPass.text != confirmPass.text) {
                      Fluttertoast.showToast(
                          msg:
                              'Given new password and confirm new password are not same');
                    } else if (newPass.text == currectPass.text) {
                      Fluttertoast.showToast(
                          msg: 'New password and old password can\'t be same');
                    } else {
                      setState(() {
                        isloading = true;
                      });
                      final response = await post(
                          Uri.parse(
                            "$baseurl/v1/profile/changepassword",
                          ),
                          headers: {
                            "Authorization": "Bearer $token",
                            'Content-Type': 'application/json',
                          },
                          body: json.encode({
                            "userID": userid,
                            "oldPassword": currectPass.text.trim(),
                            "newPassword": newPass.text.trim()
                          }));

                      if (response.statusCode == 200) {
                        var js = json.decode(response.body);
                        print(response.body);
                        if (js["success"] != null && js["success"] == true) {
                          setState(() {
                            isloading = false;
                            backController = 0;
                          });
                          Fluttertoast.showToast(
                              msg: "Password successfully updated");
                        } else {
                          setState(() {
                            isloading = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Change password failed'");
                        }
                      } else {
                        setState(() {
                          isloading = false;
                        });
                        Fluttertoast.showToast(msg: "Something went wrong");
                      }
                    }
                  },
                  child: ButtonContainer(
                      (isloading)
                          ? LoadingIndicator(
                              indicatorType: Indicator.ballClipRotatePulse,
                              colors: [Colors.white])
                          : tx600("Proceed", color: Colors.white),
                      color: primaryColor,
                      height: 50,
                      radius: 10),
                ),
              ),
            if (backController == 1)
              Expanded(
                  child: Container(
                color: Color(0xffF8F8F8),
                child: Column(
                  children: [
                    Container(
                      height: 122,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
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
                              left: 0,
                              right: 0,
                              bottom: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: tx700(letter.toUpperCase(),
                                    size: 60, color: primaryColor),
                              ))
                        ],
                      ),
                    ),
                    height(20),
                    profileItem("Name", "${UserData["name"]}",
                        "assets/icons/profile.png"),
                    profileItem("Designation", "${UserData["designation"]}",
                        "assets/icons/position.png"),
                    profileItem("Phone No.", "+91 ${UserData["phoneNo"]}",
                        "assets/icons/phone.png"),
                    profileItem("Email Address", "${UserData["emailAddress"]}",
                        "assets/icons/mail.png"),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 6.5),
                      //  height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "assets/icons/branch.png",
                            ),
                          ),
                          width(18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tx400("Locations", size: 13, color: Colors.black),
                              height(10),
                              for (var data in UserData["location"])
                                branchCard("${data["company"]}",
                                    "${data["locations"]}"),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            if (backController == 3)
              Expanded(
                  child: Container(
                width: double.infinity,
                color: Color(0xffF8F8F8),
                child: Column(
                  children: [
                    height(40),
                    SizedBox(
                      height: 85,
                      child: Image.asset("assets/images/mretail1.png"),
                    ),
                    height(40),
                    infoItem("App Version", "App Ver. - $appversion"),
                    infoItem("Updated On", "29th May 2023 \t \t 06:00:00 PM"),
                    infoItem("Released On", "29th May 2023"),
                    height(10),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: ButtonContainer(
                            tx500("Service Ver. $Version", color: Colors.black),
                            radius: 10,
                            height: 50,
                            color: Color(0xffF3F1EE)))
                  ],
                ),
              )),
            if (backController == 3)
              Container(
                width: double.infinity,
                color: Color(0xffF8F8F8),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    tx500("Muziris Softech (P) Ltd.",
                        size: 14, color: Colors.black),
                    height(3),
                    tx500("2023  |  All rights reserved", size: 10)
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  infoItem(String field, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(.4)))),
      child: Row(
        children: [
          tx400(field, size: 14, color: Colors.black),
          Expanded(child: Container()),
          tx400(value, size: 14, color: Colors.black)
        ],
      ),
    );
  }

  settingItem(String title, String imgurl, int i) {
    return InkWell(
      onTap: () {
        setState(() {
          backController = i;
          currentTitle = title;
        });
      },
      child: Container(
        height: 55,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffE2E2E2)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(imgurl),
            ),
            tx500(title, size: 14, color: Colors.black),
            Expanded(child: Container()),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 14,
            )
          ],
        ),
      ),
    );
  }

  branchCard(String title, String body) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(8),
          tx500(title, size: 16, color: Colors.black),
          height(1),
          tx400(body, size: 13, color: Colors.black),
        ],
      ),
    );
  }

  profileItem(String field, String value, String imgurl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6.5),
      height: 55,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(imgurl),
          ),
          width(18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tx400(field, size: 13, color: Colors.black),
              height(5),
              tx500(value, size: 15, color: Colors.black)
            ],
          )
        ],
      ),
    );
  }
}
