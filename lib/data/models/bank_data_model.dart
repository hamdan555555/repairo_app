class BankData {
  bool? success;
  String? message;
  BankDRData? data;

  BankData({this.success, this.message, this.data});

  BankData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new BankDRData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BankDRData {
  String? id;
  String? name;
  String? accountName;
  String? accountNumber;
  String? iban;
  String? image;

  BankDRData(
      {this.id,
      this.name,
      this.accountName,
      this.accountNumber,
      this.iban,
      this.image});

  BankDRData.fromJson(Map<String, dynamic> json) {
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
