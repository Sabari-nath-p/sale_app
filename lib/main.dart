import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/firebase_options.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';
import 'package:seematti/screen/WelcomeScreen.dart';
import 'package:seematti/screen/loginScreen.dart';
import 'package:seematti/screen/splashScreen.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

var UserData;
String login = "";
int isok = 0;
String userid = "";
String token = "";
String Serviceversion = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  login = preferences.getString("LOGIN").toString();
  Serviceversion =
      preferences.getString("SERVICE").toString().replaceAll("null", "1.0.0.0");
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  try {
    if (login == "IN") {
      token = preferences.getString("TOKEN").toString();
      userid = preferences.getString("USERID").toString();
      final Response = await http.post(
          Uri.parse("$baseurl/v1/profile/getuserprofile"),
          body: json.encode({"userID": "$userid"}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (Response.statusCode == 200) {
        var js = json.decode(Response.body);
        UserData = js["data"][0];
        //////print(UserData);
        isok = 1;
      } else if (Response.statusCode == 401) {
        isok = 2;
        Fluttertoast.showToast(msg: "Reauthenticate please");
      }
    } else if (login == "SKIP") {
      isok = 2;
    }
  } catch (e) {}
  runApp(seematti());
}

class seematti extends StatelessWidget {
  const seematti({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, Orientation, DeviceType) {
      return GetMaterialApp(
        // home: HomeMain(
        theme: ThemeData(primaryColor: primaryColor),
        //   branchList: [],
        //   Salesdata: "data",
        //   companyList: [],
        // ),
        home: (isok == 1)
            ? SplashScreen()
            : (isok == 2)
                ? LoginScreen()
                : WelcomeScreen(),
      );
    });
  }
}
