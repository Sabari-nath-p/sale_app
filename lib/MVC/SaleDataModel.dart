class SaleDataModel {
  Data? data;
  bool? success;

  SaleDataModel({this.data, this.success});

  SaleDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  List<Branches>? branches;
  List<Sales>? sales;
  List<Profit>? profit;
  List<SalesDetails>? salesDetails;
  int? discountAmount;
  int? taxAmount;
  int? returnAmount;
  int? totalPieces;
  String? syncDateTime;

  Data(
      {this.branches,
      this.sales,
      this.profit,
      this.salesDetails,
      this.discountAmount,
      this.taxAmount,
      this.returnAmount,
      this.totalPieces,
      this.syncDateTime});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((v) {
        sales!.add(new Sales.fromJson(v));
      });
    }
    if (json['profit'] != null) {
      profit = <Profit>[];
      json['profit'].forEach((v) {
        profit!.add(new Profit.fromJson(v));
      });
    }
    if (json['salesDetails'] != null) {
      salesDetails = <SalesDetails>[];
      json['salesDetails'].forEach((v) {
        salesDetails!.add(new SalesDetails.fromJson(v));
      });
    }
    discountAmount = json['discountAmount'];
    taxAmount = json['taxAmount'];
    returnAmount = json['returnAmount'];
    totalPieces = json['totalPieces'];
    syncDateTime = json['syncDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    if (this.sales != null) {
      data['sales'] = this.sales!.map((v) => v.toJson()).toList();
    }
    if (this.profit != null) {
      data['profit'] = this.profit!.map((v) => v.toJson()).toList();
    }
    if (this.salesDetails != null) {
      data['salesDetails'] = this.salesDetails!.map((v) => v.toJson()).toList();
    }
    data['discountAmount'] = this.discountAmount;
    data['taxAmount'] = this.taxAmount;
    data['returnAmount'] = this.returnAmount;
    data['totalPieces'] = this.totalPieces;
    data['syncDateTime'] = this.syncDateTime;
    return data;
  }
}

class Branches {
  int? branchID;
  String? branch;

  Branches({this.branchID, this.branch});

  Branches.fromJson(Map<String, dynamic> json) {
    branchID = json['branchID'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchID'] = this.branchID;
    data['branch'] = this.branch;
    return data;
  }
}

class Sales {
  int? branchID;
  int? totalSales;
  int? salesPercentage;

  Sales({this.branchID, this.totalSales, this.salesPercentage});

  Sales.fromJson(Map<String, dynamic> json) {
    branchID = json['branchID'];
    totalSales = json['totalSales'];
    salesPercentage = json['salesPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchID'] = this.branchID;
    data['totalSales'] = this.totalSales;
    data['salesPercentage'] = this.salesPercentage;
    return data;
  }
}

class Profit {
  int? branchID;
  int? totalProfit;
  int? profitPercentage;

  Profit({this.branchID, this.totalProfit, this.profitPercentage});

  Profit.fromJson(Map<String, dynamic> json) {
    branchID = json['branchID'];
    totalProfit = json['totalProfit'];
    profitPercentage = json['profitPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchID'] = this.branchID;
    data['totalProfit'] = this.totalProfit;
    data['profitPercentage'] = this.profitPercentage;
    return data;
  }
}

class SalesDetails {
  String? item;
  int? netSaleAmount;
  int? discountAmount;
  int? taxAmount;
  int? returnAmount;
  int? totalPieces;
  int? netSalePerc;

  SalesDetails(
      {this.item,
      this.netSaleAmount,
      this.discountAmount,
      this.taxAmount,
      this.returnAmount,
      this.totalPieces,
      this.netSalePerc});

  SalesDetails.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    netSaleAmount = json['netSaleAmount'];
    discountAmount = json['discountAmount'];
    taxAmount = json['taxAmount'];
    returnAmount = json['returnAmount'];
    totalPieces = json['totalPieces'];
    netSalePerc = json['netSalePerc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['netSaleAmount'] = this.netSaleAmount;
    data['discountAmount'] = this.discountAmount;
    data['taxAmount'] = this.taxAmount;
    data['returnAmount'] = this.returnAmount;
    data['totalPieces'] = this.totalPieces;
    data['netSalePerc'] = this.netSalePerc;
    return data;
  }
}
