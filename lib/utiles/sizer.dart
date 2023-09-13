import 'package:flutter/material.dart';

height(double h) => SizedBox(
      height: h,
    );
width(double w) => SizedBox(
      width: w,
    );

Widget ButtonContainer(Widget child,
    {double radius = 20,
    double width = 0,
    double height = 0,
    Color color = const Color(0xffBB2828)}) {
  return Container(
    width: (width > 0) ? width : null,
    height: (height > 0) ? height : null,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), color: color),
    child: child,
  );
}

ScreenChanger(BuildContext context, var screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}
