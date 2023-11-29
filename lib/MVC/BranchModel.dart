class BranchModel {
  List<Branch>? branch;
  bool? success;

  BranchModel({this.branch, this.success});

  BranchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      branch = <Branch>[];
      json['data'].forEach((v) {
        branch!.add(new Branch.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.branch != null) {
      data['data'] = this.branch!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Branch {
  int? branchID;
  String? branch;

  Branch({this.branchID, this.branch});

  Branch.fromJson(Map<String, dynamic> json) {
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
