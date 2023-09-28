import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/main.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';
import 'package:seematti/screen/forgotPassword.dart';
import 'package:seematti/screen/splashScreen.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:seematti/utiles/sizer.dart';
import 'package:seematti/utiles/textstyles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassVisible = false;
  bool isRemember = true;
  bool isReady = false;
  bool isLoading = false;
  FocusNode emailFocuse = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStartup();
  }

  loadStartup() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      size = MediaQuery.of(context).size.height - 135;
      isAnimated = true;
    });
    await Future.delayed(Duration(milliseconds: 680));
    setState(() {
      isAnimationCompleted = true;
    });
  }

  double size = 0;
  bool isAnimated = false;
  bool isAnimationCompleted = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
              top: 50,
              left: 40,
              child: AnimatedContainer(
                  curve: Curves.decelerate,
                  duration: Duration(seconds: 3),
                  width: (!isAnimated) ? 0 : 309,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        tx700("Sign In",
                            color: Colors.white,
                            size: 25,
                            textAlign: TextAlign.center),
                        Container(
                          width: 100,
                          height: 30,
                          margin: EdgeInsets.only(top: 4),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.white54.withOpacity(.2),
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Positioned(
                // top: size,
                top: (!isAnimationCompleted) ? null : 135,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  height: (!isAnimated) ? 0 : density(size),
                  duration: Duration(milliseconds: 800),
                  curve: Curves.decelerate,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(40),
                                tx700("Welcome", size: 22, color: Colors.black),
                                height(11),
                                Wrap(
                                  children: [
                                    tx400("Login to your account to view your ",
                                        size: 14, color: Colors.black),
                                    tx600("business.",
                                        color: Colors.black, size: 14),
                                  ],
                                ),
                                height(50),
                                tx400("Mobile / Email",
                                    size: 14, color: Color(0xff323030)),
                                height(11),
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller: emailController,
                                    focusNode: emailFocuse,
                                    onChanged: (value) {
                                      if (emailController.text.length > 2 &&
                                          passwordController.text.length > 2)
                                        setState(() {
                                          isReady = true;
                                        });
                                      else {
                                        setState(() {
                                          isReady = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        isDense: true),
                                  ),
                                ),
                                height(17),
                                tx400("Password",
                                    size: 14, color: Color(0xff323030)),
                                height(11),
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    obscureText: !isPassVisible,
                                    controller: passwordController,
                                    onChanged: (value) {
                                      if (emailController.text.length > 2 &&
                                          passwordController.text.length > 2)
                                        setState(() {
                                          isReady = true;
                                        });
                                      else {
                                        setState(() {
                                          isReady = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        // isCollapsed: true,
                                        suffixIcon: (isPassVisible)
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPassVisible =
                                                        !isPassVisible;
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
                                                    isPassVisible =
                                                        !isPassVisible;
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
                              ],
                            ),
                          ),
                        ),
                        height(5),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Switch(
                                  activeColor: primaryColor,
                                  value: isRemember,
                                  onChanged: (value) {
                                    setState(() {
                                      isRemember = value;
                                    });
                                  }),
                              tx500("Remember me",
                                  size: 12, color: Color(0xff323030)),
                              Expanded(child: Container()),
                              InkWell(
                                  onTap: () {
                                    if (emailController.text.isNotEmpty) {
                                      ScreenChanger(
                                          context,
                                          ForgotPasswordScreen(
                                              userid:
                                                  emailController.text.trim()));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please enter email id for reset password and click forgot option");
                                      // FocusScope.of(context)
                                      //     .requestFocus(emailFocuse);
                                      // emailController.
                                    }
                                  },
                                  child: tx500("Forgot Password ?",
                                      size: 12, color: Color(0xff323030))),
                              width(10)
                            ],
                          ),
                        ),
                        height(5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              //   ScreenChanger(context, HomeMain());
                              if (!isReady) {
                                Fluttertoast.showToast(
                                    msg: "Please fill login credentials",
                                    gravity: ToastGravity.TOP);
                                return;
                              }
                              if (isLoading) {
                                Fluttertoast.showToast(
                                    msg: "Please wait",
                                    gravity: ToastGravity.TOP);
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              try {
                                final Response =
                                    await http.post(Uri.parse("$baseurl/login"),
                                        body: json.encode({
                                          "username":
                                              emailController.text.trim(),
                                          "password":
                                              passwordController.text.trim()
                                        }),
                                        headers: {
                                      'Content-Type': 'application/json',
                                      "AppID": "S01",
                                    });

                                //noprint(Response.body);
                                //noprint(Response.statusCode);
                                print("working");

                                print(Response.body);
                                if (Response.statusCode == 200) {
                                  var res = json.decode(Response.body);

                                  if (res["success"] &&
                                      res["success"] != null) {
                                    //noprint(res);
                                    print(Response.body);
                                    print(Response.body);
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString("USER", Response.body);
                                    pref.setString(
                                        "TOKEN", res["data"]["authToken"]);
                                    pref.setString(
                                        "USERID", res["data"]["userID"]);
                                    userid = res["data"]["userID"];
                                    token = res["data"]["authToken"];
                                    final pp = await http.post(
                                        Uri.parse(
                                            "$baseurl/v1/profile/getuserprofile"),
                                        body: json.encode({"userID": "$userid"}),
                                        headers: {
                                          'Content-Type': 'application/json',
                                          'Authorization': 'Bearer $token'
                                        });
                                    print(pp.body);
                                    if (pp.statusCode == 200) {
                                      var js = json.decode(pp.body);
                                      UserData = js["data"][0];
                                    }
                                    if (isRemember)
                                      pref.setString("LOGIN", "IN");
                                    else
                                      pref.setString("LOGIN", "SKIP");

                                    while (Navigator.canPop(context))
                                      Navigator.pop(context);
                                    Navigator.pop(context);
                                    ScreenChanger(context, SplashScreen());
                                  } else {
                                    //noprint("working");
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Incorrect credentials",
                                        gravity: ToastGravity.TOP);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Bad request",
                                      gravity: ToastGravity.TOP);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              } on SocketException catch (_) {
                                Fluttertoast.showToast(
                                    msg: "Please connect to internet and retry",
                                    gravity: ToastGravity.TOP);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: ButtonContainer(
                                (isLoading)
                                    ? LoadingIndicator(
                                        indicatorType:
                                            Indicator.ballClipRotatePulse,
                                        colors: [Colors.white],
                                      )
                                    : tx600("Sign in",
                                        color: (isReady)
                                            ? Colors.white
                                            : Colors.black),
                                color: (isReady)
                                    ? primaryColor
                                    : Color(0xffD9D9D9),
                                // width: 309,
                                height: 45,
                                radius: 10),
                          ),
                        ),
                        height(15),
                        Center(
                            child: tx400("Ver. - 1.00.1.00",
                                size: 14,
                                textAlign: TextAlign.center,
                                color: Colors.black)),
                        height(140),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 30),
                          child: SizedBox(
                            width: 90,
                            height: 50,
                            child: Image.asset("assets/images/mretail1.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  double density(
    double d,
  ) {
    double height = MediaQuery.of(context).size.width;
    double value = d * (height / 390);
    return value;
  }
}
