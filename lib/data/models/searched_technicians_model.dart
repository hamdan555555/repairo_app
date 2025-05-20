// class Search {
//   bool? success;
//   String? message;
//   List<RSearchedTechsData>? data;

//   Search({this.success, this.message, this.data});

//   Search.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <RSearchedTechsData>[];
//       json['data'].forEach((v) {
//         data!.add(new RSearchedTechsData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class RSearchedTechsData {
//   String? id;
//   String? name;
//   String? phone;
//   String? image;

//   RSearchedTechsData({this.id, this.name, this.phone, this.image});

//   RSearchedTechsData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     phone = json['phone'];
//     name = json['account'] != null ? json['account']['name'] : null;
//     image = json['account'] != null ? json['account']['image'] : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['phone'] = this.phone;
//     data['image'] = this.image;
//     return data;
//   }
// }

class SearchedTechs {
  bool? success;
  String? message;
  List<RSearchedTechsData>? data;

  SearchedTechs({this.success, this.message, this.data});

  SearchedTechs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RSearchedTechsData>[];
      json['data'].forEach((v) {
        data!.add(new RSearchedTechsData.fromJson(v));
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

class RSearchedTechsData {
  String? id;
  String? phone;
  String? accountId;
  Account? account;

  RSearchedTechsData({this.id, this.phone, this.accountId, this.account});

  RSearchedTechsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    accountId = json['account_id'];
    account =
        json['account'] != null ? new Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['account_id'] = this.accountId;
    if (this.account != null) {
      data['account'] = this.account!.toJson();
    }

    return data;
  }

  @override
  String toString() {
    return 'RSearchedTechsData(id: $id, name: ${account!.name}, phone: $phone, image: ${account!.image})';
  }
}

class Account {
  String? id;
  String? name;
  String? image;

  Account({this.id, this.name, this.image});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
