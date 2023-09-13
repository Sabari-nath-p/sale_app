import 'package:flutter/material.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';
import 'package:seematti/screen/Dashboard/views/notification.dart';
import 'package:seematti/screen/Dashboard/views/settingsView.dart';
import 'package:seematti/utiles/colors.dart';

class HomeMain extends StatefulWidget {
  List companyList;
  List branchList;
  var Salesdata;
  HomeMain(
      {super.key,
      required this.Salesdata,
      required this.branchList,
      required this.companyList});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int bottomIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    "assets/icons/sales.png",
                    color: (bottomIndex == 0) ? primaryColor : Colors.black45,
                  )),
              label: "Sales"),
          BottomNavigationBarItem(
            icon: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  "assets/icons/setting.png",
                  color: (bottomIndex == 1) ? primaryColor : Colors.black45,
                )),
            label: "Setting",
          ),
          BottomNavigationBarItem(
              icon: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    "assets/icons/notification.png",
                    color: (bottomIndex == 2) ? primaryColor : Colors.black45,
                  )),
              label: "Notifications")
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (bottomIndex == 0)
              SizedBox(
                  //   padding: MediaQuery.of(context).viewInsets,
                  height: MediaQuery.of(context).size.height - 74,
                  child: ScalesHome(
                      clist: widget.companyList,
                      blist: widget.branchList,
                      SalesData: widget.Salesdata)),
            //  if (bottomIndex == 2)
            if (bottomIndex == 1)
              SizedBox(
                  //   padding: MediaQuery.of(context).viewInsets,
                  height: MediaQuery.of(context).size.height - 74,
                  child: settingView()),
            if (bottomIndex == 2)
              SizedBox(
                  //   padding: MediaQuery.of(context).viewInsets,
                  height: MediaQuery.of(context).size.height - 74,
                  child: NotificationsScreen())
          ],
        ),
      ),
    );
  }
}
