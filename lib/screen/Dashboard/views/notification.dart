import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';

import '../../../utiles/sizer.dart';
import '../../../utiles/textstyles.dart';

class NotificationsScreen extends StatefulWidget {
  ValueNotifier notifier;
  NotificationsScreen({super.key, required this.notifier});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor, zIndex: 1, name: "Notifications");
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    notifier.value++;

    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("Notifications");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: (true)
            ? Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  color: Color(0xffF3F1EE),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            widget.notifier.value++;
                          },
                          child: Icon(Icons.arrow_back)),
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
