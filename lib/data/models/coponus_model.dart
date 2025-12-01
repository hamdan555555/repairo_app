class Copouns {
  bool? success;
  String? message;
  List<RCoponusData>? data;

  Copouns({this.success, this.message, this.data});

  Copouns.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RCoponusData>[];
      json['data'].forEach((v) {
        data!.add(new RCoponusData.fromJson(v));
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

class RCoponusData {
  String? id;
  String? userId;
  String? coupon;
  String? type;
  String? value;
  int? active;

  RCoponusData({this.id, this.userId, this.coupon, this.type, this.value, this.active});

  RCoponusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    coupon = json['coupon'];
    type = json['type'];
    value = json['value'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coupon'] = this.coupon;
    data['type'] = this.type;
    data['value'] = this.value;
    data['active'] = this.active;
    return data;
  }
}
