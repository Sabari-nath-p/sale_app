import 'package:flutter/material.dart';
import 'package:seematti/components/salesdetailscard.dart';
import 'package:seematti/utiles/colors.dart';

import '../utiles/functionSupporter.dart';
import '../utiles/sizer.dart';
import '../utiles/textstyles.dart';

class SaleDataView extends StatefulWidget {
  var salesDetails;
  SaleDataView({super.key, required this.salesDetails});

  @override
  State<SaleDataView> createState() => _SaleDataViewState();
}

class _SaleDataViewState extends State<SaleDataView> {
  int total = 0;
  String searchText = "";

  Calculatetotal() {
    setState(() {
      for (var data in widget.salesDetails) {
        total = total + int.parse(data["netSaleAmount"].toString());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Calculatetotal();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 0),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff767680).withOpacity(.12)),
          child: Row(
            children: [
              width(8),
              Icon(
                Icons.search,
                size: 22,
                color: Color(0xff3C3C43),
              ),
              width(6),
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "Search",
                    isCollapsed: true,
                    hintStyle: TextStyle(
                        fontFamily: "lato",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff3C3C43)),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (searchText == "") height(22),
        if (searchText == "")
          tx700("${ToFixed(total)}", size: 24, color: Colors.black),
        height(4),
        if (searchText == "")
          tx500("Today’s Sales Details - All Branch",
              size: 13, color: Colors.black),
        height(10),
        for (var data in widget.salesDetails)
          if (data["item"]
                  .toString()
                  .toUpperCase()
                  .contains(searchText.toUpperCase()) ||
              searchText == "")
            SalesDetialCard(
              color: ColorList[widget.salesDetails.indexOf(data) % 4],
              data: data,
            ),
      ],
    );
  }
}
