import 'dart:ffi';

class UserProfile {
  bool? success;
  String? message;
  PData? data;

  UserProfile({this.success, this.message, this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new PData.fromJson(json['data']) : null;
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

class PData {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? image;
  int? wallet;

  PData(
      {this.id, this.name, this.phone, this.address, this.image, this.wallet});

  PData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
    wallet =
        json['wallet'] != null ? int.tryParse(json['wallet'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['image'] = image;
    if (wallet != null) data['wallet'] = wallet.toString();
    return data;
  }
}
