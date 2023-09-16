import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:seematti/utiles/sizer.dart';
import 'package:seematti/utiles/textstyles.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ForgotPasswordScreen extends StatefulWidget {
  String userid;
  ForgotPasswordScreen({super.key, required this.userid});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isResendReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sentOtp();
  }

  sentOtp() async {
    final Response = await post(Uri.parse("$baseurl/v1/account/generateotp"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "email": widget.userid,
        }));
    print(Response.body);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);

      if (js["success"] == true && js["success"] != null) {
        Fluttertoast.showToast(
            msg: "Otp has been sent to your registered mail id");
      } else {
        Fluttertoast.showToast(msg: "Invalid email id ");
        Navigator.of(context).pop();
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  int PageController = 0;
  bool isconfirm = false;
  bool isnew = false;
  bool isloading = false;
  bool resendController = true;
  TextEditingController otpController = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 60,
              alignment: Alignment.center,
              color: Color(0xffF3F1EE),
              child: Row(
                children: [
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back)),
                  width(10),
                  tx600(
                      (PageController == 1) ? "Create Password" : "Verify OTP",
                      size: 18),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              color: Color(0xffF8F8F8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (PageController == 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height(60),
                          SizedBox(
                            height: 150,
                            width: 135,
                            child: Image.asset(
                              "assets/images/otpimage.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          height(50),
                          tx400(
                              "Enter the 4 digit OTP sent to your email address",
                              size: 14,
                              color: Colors.black),
                          height(11),
                          tx400(
                              "(${widget.userid.substring(0, 4)}*****${widget.userid.substring(widget.userid.length - 9, widget.userid.length)})",
                              size: 14,
                              color: Colors.black),
                          height(44),
                          tx700("One Time Password"),
                          height(22),
                          Pinput(
                            separatorBuilder: (index) {
                              return width(15);
                            },
                            length: 4,
                          ),
                          if (resendController) height(22),
                          if (resendController)
                            Countdown(
                              seconds: 30,
                              build: (BuildContext context, double time) =>
                                  tx700(formatDuration(
                                      Duration(seconds: time.round()))),
                              interval: Duration(milliseconds: 100),
                              onFinished: () {
                                // //noprint('Timer is done!');
                                setState(() {
                                  isResendReady = true;
                                });
                              },
                            ),
                          if (resendController) height(22),
                          if (resendController)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                tx400("Did not receive? ",
                                    size: 14, color: Colors.black),
                                InkWell(
                                  onTap: () {
                                    if (isResendReady) {
                                      print("working");
                                      sentOtp();
                                      setState(() {
                                        resendController = false;
                                      });
                                    }
                                  },
                                  child: tx400("Resend",
                                      color: (isResendReady)
                                          ? primaryColor
                                          : Colors.black54,
                                      size: 14),
                                )
                              ],
                            ),
                        ],
                      ),
                    if (PageController == 1)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height(60),
                          Container(
                            alignment: Alignment.center,
                            child: Container(
                              height: 150,
                              width: 135,
                              child: Image.asset(
                                "assets/images/submitpass.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          height(50),
                          tx500("Create new password"),
                          height(20),
                          tx400(
                              "Your new password must be different from previous used password",
                              size: 14),
                          height(41),
                          tx400("New Password", size: 14),
                          height(11),
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                          tx400("Confirm New Password", size: 14),
                          height(11),
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                      )
                  ],
                ),
              ),
            )),
            if (PageController == 0)
              Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    //   ScreenChanger(context, LoginScreen());
                    if (otpController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter otp");
                    } else if (isloading) {
                      Fluttertoast.showToast(msg: "please wait");
                    } else {
                      checkOtp(otpController.text.trim());
                    }
                  },
                  child: ButtonContainer(
                      tx600("Verify OTP", color: Colors.white),
                      color: primaryColor,
                      height: 50,
                      radius: 10),
                ),
              ),
            if (PageController == 1)
              Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    //   ScreenChanger(context, LoginScreen());
                    if (newPass.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please fill new password");
                    } else if (confirmPass.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please fill confirm password");
                    } else if (isloading) {
                      Fluttertoast.showToast(msg: "please wait");
                    } else if (newPass.text != confirmPass.text) {
                      Fluttertoast.showToast(
                          msg:
                              'new password and confrim passwords are mismatch');
                    } else {
                      ResetPassword();
                    }
                  },
                  child: ButtonContainer(
                      tx600("Reset Password", color: Colors.white),
                      color: primaryColor,
                      height: 50,
                      radius: 10),
                ),
              ),
            height(20)
          ],
        ),
      ),
    );
  }

  checkOtp(String otp) async {
    setState(() {
      isloading = true;
    });
    final Response = await post(Uri.parse("$baseurl/v1/account/verifyotp"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"email": widget.userid, "otp": "$otp"}));

    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      if (js["success"] == true && js["success"] != null) {
        resetPasswordCode = js["data"]["resetPasswordCode"];
        setState(() {
          PageController = 1;
          isloading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Invalid otp");
        setState(() {
          isloading = false;
        });
      }
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  ResetPassword() async {
    setState(() {
      isloading = true;
    });
    final Response = await post(Uri.parse("$baseurl/v1/account/resetpassword"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          {
            "resetPasswordCode": resetPasswordCode,
            "newPassword": newPass.text.trim()
          }
        }));

    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      if (js["success"] == true && js["success"] != null) {
        Fluttertoast.showToast(msg: "Password  Successfully updated");
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: "password reset failed");
        setState(() {
          isloading = false;
        });
      }
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  String resetPasswordCode = "";
  String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
