class User {
  bool? success;
  String? message;
  Data? data;

  User({this.success, this.message, this.data});

  User.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    message = json['message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? phone;
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  Data({
    this.id,
    this.name,
    this.phone,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    phone = json['phone']?.toString();
    accessToken = json['access_token']?.toString();
    tokenType = json['token_type']?.toString();
    expiresIn = json['expires_in'] is int ? json['expires_in'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}
