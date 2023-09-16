import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';
import 'package:seematti/screen/WelcomeScreen.dart';
import 'package:seematti/screen/loginScreen.dart';
import 'package:seematti/screen/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var UserData;
String login = "";
int isok = 0;
String userid = "";
String token = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  login = preferences.getString("LOGIN").toString();

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
      print(UserData);
      isok = 1;
    } else if (Response.statusCode == 401) {
      isok = 2;
      Fluttertoast.showToast(msg: "Reauthenticate please");
    }
  } else if (login == "SKIP") {
    isok = 2;
  }
  runApp(seematti());
}

class seematti extends StatelessWidget {
  const seematti({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: WelcomeScreen(),
      home: (isok == 1)
          ? SplashScreen()
          : (isok == 2)
              ? LoginScreen()
              : WelcomeScreen(),
    );
  }
}
