import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seematti/screen/loginScreen.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:seematti/utiles/sizer.dart';

import '../utiles/textstyles.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                top: 0,
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Center(
                      child: Image.asset(
                        "assets/images/client-logoWhite.png",
                        width: 200,
                        height: 70,
                      ),
                    )),
                    Container(
                        width: 309,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            tx700("Welcome",
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
                        )),
                    height(20),
                    Container(
                      width: 309,
                      height: 1,
                      color: Colors.white.withOpacity(.6),
                    ),
                    height(30),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 309,
                        //  padding: const EdgeInsets.only(left: 36, right: 100),
                        child: tx500("Just one step away to view your",
                            color: Colors.white, size: 16),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 309,
                        child:
                            tx700("business.", color: Colors.white, size: 16),
                      ),
                    ),
                    height(70),
                    InkWell(
                      onTap: () {
                        ScreenChanger(context, LoginScreen());
                      },
                      child: ButtonContainer(
                          tx600("Sign in", color: primaryColor),
                          color: Colors.white,
                          width: 309,
                          height: 45,
                          radius: 10),
                    ),
                    height(20),
                    tx500("Ver. - 1.0.0", color: Colors.white),
                    height(70),
                    //tx600("Service ver : 1.0.0", color: Colors.white),
                    height(4),
                    SizedBox(
                        width: 90,
                        height: 50,
                        child: Image.asset("assets/images/mretail_white.png")),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
