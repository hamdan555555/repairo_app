class ServicesProvidersSearch {
  bool? success;
  String? message;
  List<RSearchesServiceProvidersData>? data;

  ServicesProvidersSearch({this.success, this.message, this.data});

  ServicesProvidersSearch.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RSearchesServiceProvidersData>[];
      json['data'].forEach((v) {
        data!.add(new RSearchesServiceProvidersData.fromJson(v));
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

class RSearchesServiceProvidersData {
  String? id;
  String? name;
  String? rating;
  String? image;

  RSearchesServiceProvidersData({this.id, this.name, this.rating, this.image});

  RSearchesServiceProvidersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['image'] = this.image;
    return data;
  }
}
