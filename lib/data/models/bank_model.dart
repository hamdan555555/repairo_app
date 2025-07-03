class Banks {
  bool? success;
  String? message;
  List<RBankData>? data;

  Banks({this.success, this.message, this.data});

  Banks.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RBankData>[];
      json['data'].forEach((v) {
        data!.add(new RBankData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RBankData {
  String? id;
  String? name;
  String? accountName;
  String? accountNumber;
  String? iban;
  String? image;

  RBankData(
      {this.id,
      this.name,
      this.accountName,
      this.accountNumber,
      this.iban,
      this.image});

  RBankData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    iban = json['iban'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['iban'] = this.iban;
    data['image'] = this.image;
    return data;
  }
}
