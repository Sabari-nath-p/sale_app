import 'package:flutter/material.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';
import 'package:seematti/screen/Dashboard/views/notification.dart';
import 'package:seematti/screen/Dashboard/views/settingsView.dart';
import 'package:seematti/utiles/colors.dart';
import 'package:sizer/sizer.dart';
ValueNotifier notifier = ValueNotifier(10);
class HomeMain extends StatefulWidget {
  HomeMain({
    super.key,
  });

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int bottomIndex = 0;

  
  loadNotifier() async {
    notifier.addListener(() {
      setState(() {
        bottomIndex = 0; // notifier.value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                bottomIndex = value;
              });
            },
            selectedItemColor: primaryColor,
            currentIndex: bottomIndex,
            selectedLabelStyle:
                TextStyle(fontFamily: "lato", fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                TextStyle(fontFamily: "lato", fontWeight: FontWeight.w500),
            items: [
              BottomNavigationBarItem(
                  icon: SizedBox(
                      width: 10.5.w,
                      height: 10.5.w,
                      child: Image.asset(
                        "assets/icons/sales.png",
                        color:
                            (bottomIndex == 0) ? primaryColor : Colors.black87,
                      )),
                  label: "Sales"),
              BottomNavigationBarItem(
                icon: SizedBox(
                    width: 10.5.w,
                    height: 4.7.h,
                    child: Image.asset(
                      "assets/icons/setting.png",
                      color: (bottomIndex == 1) ? primaryColor : Colors.black87,
                    )),
                label: "Settings",
              ),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      width: 4.7.h,
                      height: 4.7.h,
                      child: Image.asset(
                        "assets/icons/notification.png",
                        color:
                            (bottomIndex == 2) ? primaryColor : Colors.black87,
                      )),
                  label: "Notifications")
            ],
          ),
          body: (bottomIndex == 0)
              ? ScalesHome()
              //  if (bottomIndex == 2)
              : (bottomIndex == 1)
                  ? settingView(
                      notifier: notifier,
                    )
                  : NotificationsScreen(
                      notifier: notifier,
                    )),
    );
  }
}
