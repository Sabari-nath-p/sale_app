class CompanyModel {
  List<Company>? company;
  Null? message;
  bool? success;

  CompanyModel({this.company, this.message, this.success});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      company = <Company>[];
      json['data'].forEach((v) {
        company!.add(new Company.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['data'] = this.company!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class Company {
  int? companyID;
  String? company;

  Company({this.companyID, this.company});

  Company.fromJson(Map<String, dynamic> json) {
    companyID = json['companyID'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyID'] = this.companyID;
    data['company'] = this.company;
    return data;
  }
}
