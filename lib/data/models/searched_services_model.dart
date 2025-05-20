class SearchedServices {
  bool? success;
  String? message;
  List<RSearchedServiceData>? data;

  SearchedServices({this.success, this.message, this.data});

  SearchedServices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RSearchedServiceData>[];
      json['data'].forEach((v) {
        data!.add(new RSearchedServiceData.fromJson(v));
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

class RSearchedServiceData {
  String? id;
  String? displayName;
  String? type;
  String? image;

  RSearchedServiceData({this.id, this.displayName, this.type, this.image});

  RSearchedServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    type = json['type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['type'] = this.type;
    data['image'] = this.image;
    return data;
  }

  @override
  String toString() {
    return 'RSearchedTechsData(id: $id, name: $displayName, type: $type, image: $image)';
  }
}
