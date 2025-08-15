class AllWAlletRequests {
  bool? success;
  String? message;
  List<RWalletRequestsData>? data;

  AllWAlletRequests({this.success, this.message, this.data});

  AllWAlletRequests.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RWalletRequestsData>[];
      json['data'].forEach((v) {
        data!.add(new RWalletRequestsData.fromJson(v));
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

class RWalletRequestsData {
  String? id;
  String? userId;
  String? bankId;
  String? amount;
  String? status;
  Bank? bank;
  String? image;

  RWalletRequestsData(
      {this.id,
      this.userId,
      this.bankId,
      this.amount,
      this.status,
      this.bank,
      this.image});

  RWalletRequestsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankId = json['bank_id'];
    amount = json['amount'];
    status = json['status'];
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bank_id'] = this.bankId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    data['image'] = this.image;
    return data;
  }
}

class Bank {
  String? id;
  String? name;
  String? accountName;
  String? accountNumber;
  String? iban;
  String? image;

  Bank(
      {this.id,
      this.name,
      this.accountName,
      this.accountNumber,
      this.iban,
      this.image});

  Bank.fromJson(Map<String, dynamic> json) {
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
