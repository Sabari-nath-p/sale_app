import 'package:flutter/material.dart';

Text tx500(String text,
        {double size = 16,
        Color color = Colors.black54,
        TextAlign textAlign = TextAlign.start,
        String family = "lato"}) =>
    Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: size,
            color: color,
            fontFamily: family,
            fontWeight: FontWeight.w500));
Text tx400(String text,
        {double size = 16,
        Color color = Colors.black54,
        TextAlign textAlign = TextAlign.start,
        String family = "lato"}) =>
    Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: size,
            color: color,
            fontFamily: family,
            fontWeight: FontWeight.w400));
Text tx600(String text,
        {double size = 16,
        Color color = Colors.black54,
        TextAlign textAlign = TextAlign.start,
        String family = "lato"}) =>
    Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: size,
            color: color,
            fontFamily: family,
            fontWeight: FontWeight.w600));
Text tx700(String text,
        {double size = 16,
        Color color = Colors.black54,
        TextAlign textAlign = TextAlign.start,
        String family = "lato"}) =>
    Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: size,
            color: color,
            fontFamily: family,
            fontWeight: FontWeight.w700));
