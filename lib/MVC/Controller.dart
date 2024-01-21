import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
//import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:seematti/MVC/BranchModel.dart';
import 'package:seematti/MVC/CompanyModel.dart';
import 'package:seematti/MVC/SaleDataModel.dart';
import 'package:seematti/constants/stringData.dart';
import 'package:http/http.dart' as http;
import 'package:seematti/main.dart';
import 'package:seematti/screen/Dashboard/HomeMain.dart';
import 'package:seematti/screen/Dashboard/views/SalesHome.dart';
import 'package:seematti/utiles/functionSupporter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  CompanyModel? companyModel;
  BranchModel? branchModel;
  Company? SelectedCompany;
  SaleDataModel? SalesData;
  int? totalSale = 0;
  int? totalProfits = 0;
  ValueNotifier SortNotifier = ValueNotifier(10);
  List<Branch> SelectedBranch = [];
  DateTime startData = DateTime.now().subtract(Duration(days: 10));
  DateTime endDate = DateTime.now();
  bool firstLaunch = false;
  bool sortSale = false;
  bool sortBranch = false;
  ValueNotifier<List> listChanger = ValueNotifier<List>([]);
  //MultiSelectController controller = MultiSelectController();

  var AuthHeader = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  LoadCompany() async {
    final Response =
        await http.post(Uri.parse(baseurl + "/v1/company/dropdown"),
            headers: AuthHeader,
            body: json.encode({
              "userID": userid,
            }));
    ////print(Response.body);
    ////print(Response.statusCode);

    if (Response.statusCode == 200) {
      companyModel = CompanyModel.fromJson(json.decode(Response.body));
      if (companyModel!.company!.length > 0) {
        SelectedCompany = (companyModel!.company!.first);
        loadBranch(SelectedCompany!.companyID.toString());
      }
    }
  }

  loadLastEntry() async {
    final Response =
        await http.post(Uri.parse(baseurl + "/v1/common/getlastentrydate"),
            body: jsonEncode({
              "branchID": BranchIDlist(),
              "userID": userid,
            }),
            headers: AuthHeader);
    // print(Response.body);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);

      if (js["data"] != null) {
        String dt = js["data"]["lastEntryDate"];
        List temp = dt.split("/");
        startData = DateTime.parse(temp[2] + "-" + temp[1] + "-" + temp[0]);
        endDate = startData;
        LoadSaleData();
      } else {
        LoadSaleData();
      }
    }
  }

  loadBranch(String companyID) async {
    print("working");
    BranchList.clear();
    BS.clear();
    final Response = await http.post(Uri.parse(baseurl + "/v1/branch/dropdown"),
        headers: AuthHeader,
        body: json.encode({"userID": userid, "companyID": companyID}));
    //print(Response.body);
    ////print(Response.statusCode);
    if (Response.statusCode == 200) {
      branchModel = BranchModel.fromJson(json.decode(Response.body));

      // Branch all = Branch(branch: "ALL", branchID: 0);
      // branchModel!.branch!.add(all);
      if (branchModel!.branch!.isNotEmpty) {
        // BranchList.add("ALL");
      }
      //  BranchList.add("ALL");

      for (var data in branchModel!.branch!) {
        BranchList.add(data.branch!.capitalizeFirst.toString());
        BS.add(data.branch!.capitalizeFirst.toString());

        SelectedBranch.add(data);
      }
      listChanger.value = [...BS];

      ///   update();

      print(BranchList);

      /// LoadSaleData();
      loadLastEntry();
    }

    //print(branchModel!.branch!);
  }

  List<String> BranchList = [];
  List<String> BS = [];

  Widget multi = Container();

  formBranchList() {
    SelectedBranch.clear();
    for (var data in branchModel!.branch!) {
      if (BS.indexOf(data.branch!.capitalizeFirst.toString()) != -1) {
        SelectedBranch.add(data);
      }
    }
    print(SelectedBranch);
    loadLastEntry();
    update();
  }

  LoadSaleData() async {
    ////print(token);
    ////print(startData.toString());
    ////print(endDate.toString());
    final Response = await http.post(Uri.parse("$baseurl/v1/mis/dashboard"),
        body: jsonEncode({
          "branchID": BranchIDlist(),
          "userID": "$userid",
          "endDate": f.format(endDate), //f.format(DateTime.now()),
          "startDate": f.format(startData),
        }),
        headers: AuthHeader);
    print(Response.body);
    print(BranchIDlist());
    print(Response.statusCode);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      if (js["success"]) {
        //print(Response.body);

        SalesData = SaleDataModel.fromJson(json.decode(Response.body));
        if (SalesData!.data!.sales!.isNotEmpty)
          totalSale = SalesData!.data!.sales!.last.totalSales;
        else
          totalSale = 0;
        if (SalesData!.data!.profit!.isNotEmpty)
          totalProfits = SalesData!.data!.profit!.last.totalProfit;
        else
          totalProfits = 0;
        update();

        if (!firstLaunch) {
          firstLaunch = true;
          Get.back();
          Get.to(() => HomeMain(), transition: Transition.downToUp);
        }
      } else {
        Data data = Data(
            branches: [],
            sales: [],
            profit: [],
            salesDetails: [],
            discountAmount: 0,
            returnAmount: 0,
            taxAmount: 0,
            totalPieces: 0);
        SalesData = SaleDataModel(data: data);
        totalSale = 0;
        totalProfits = 0;
        update();
      }
    }
  }

  sortSales() {
    if (!sortSale) {
      SalesData!.data!.salesDetails!.sort((a, b) => a.item!.compareTo(b.item!));
      sortSale = true;
    } else {
      SalesData!.data!.salesDetails!
          .sort((a, b) => b.netSaleAmount!.compareTo(a.netSaleAmount!));
      sortSale = false;
    }
    update();
  }

  SortAlphabetically() {
    if (!sortBranch) {
      for (int i = 0; i < SalesData!.data!.branches!.length - 1; i++) {
        if (SalesData!.data!.branches![i].branch!
                .compareTo(SalesData!.data!.branches![i + 1].branch!) >
            0) {
          var temp = SalesData!.data!.branches![i + 1];
          SalesData!.data!.branches![i + 1] = SalesData!.data!.branches![i];
          SalesData!.data!.branches![i] = temp;

          var tm = SalesData!.data!.sales![i + 1];
          SalesData!.data!.sales![i + 1] = SalesData!.data!.sales![i];
          SalesData!.data!.sales![i] = tm;

          var tm2 = SalesData!.data!.profit![i + 1];
          SalesData!.data!.profit![i + 1] = SalesData!.data!.profit![i];
          SalesData!.data!.profit![i] = tm2;
        }
      }
      sortBranch = true;
    } else {
      for (int i = 0; i < SalesData!.data!.branches!.length - 1; i++) {
        if (SalesData!.data!.sales![i].totalSales!
                .compareTo(SalesData!.data!.sales![i + 1].totalSales!) <
            0) {
          var temp = SalesData!.data!.branches![i + 1];
          SalesData!.data!.branches![i + 1] = SalesData!.data!.branches![i];
          SalesData!.data!.branches![i] = temp;

          var tm = SalesData!.data!.sales![i + 1];
          SalesData!.data!.sales![i + 1] = SalesData!.data!.sales![i];
          SalesData!.data!.sales![i] = tm;

          var tm2 = SalesData!.data!.profit![i + 1];
          SalesData!.data!.profit![i + 1] = SalesData!.data!.profit![i];
          SalesData!.data!.profit![i] = tm2;
        }
      }
      sortBranch = false;
    }

    update();
  }

  final f = DateFormat('dd/MM/yyyy');
  List BranchIDlist() {
    List temp = [];
    if (SelectedBranch.isNotEmpty && SelectedBranch.first.branch != "ALL") {
      for (var data in SelectedBranch) temp.add(data.branchID);
      return temp;
    } else {
      for (var data in branchModel!.branch!) temp.add(data.branchID);

      ////print(temp);
      return []; //temp;
    }
  }

  loadInfo2() async {
    final res = await get(Uri.parse("$baseurl/v1/common/getversion"), headers: {
      "Authorization": "Bearer $token",
    });
    //////print(res.body);
    if (res.statusCode == 200) {
      var js = json.decode(res.body);
      //////print(js);
      String Version =
          js["data"]["versionNo"].toString().replaceAll("-SNAPSHOT", "");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("SERVICE", Version);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //   LoadCompany();
  }
}
