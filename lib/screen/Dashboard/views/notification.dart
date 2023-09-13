import 'package:flutter/material.dart';

import '../../../utiles/sizer.dart';
import '../../../utiles/textstyles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: (true)
            ? Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 90,
                  alignment: Alignment.bottomLeft,
                  color: Color(0xffF3F1EE),
                  child: Row(
                    children: [
                      //InkWell(onTap: () {}, child: Icon(Icons.arrow_back)),
                      width(10),
                      tx600("Notifications", size: 18, color: Colors.black),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  alignment: Alignment.center,
                  child: Image.asset("assets/icons/noNotification.png"),
                ))
              ])
            : Center(
                child: Image.asset("assets/images/nonotification.png"),
              ));
  }
}
