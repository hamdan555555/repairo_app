class Technicians {
  bool? success;
  String? message;
  List<RTechData>? data;

  Technicians({this.success, this.message, this.data});

  Technicians.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RTechData>[];
      json['data'].forEach((v) {
        data!.add(new RTechData.fromJson(v));
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

class RTechData {
  String? id;
  String? name;
  String? rating;
  String? image;
  String? jobCategoryId;
  String? status;
  Category? category;

  RTechData({
    this.id,
    this.name,
    this.rating,
    this.image,
    this.jobCategoryId,
    this.status,
    this.category,
  });

  RTechData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    image = json['image'];
    jobCategoryId = json['job_category_id'];
    status = json['status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['image'] = this.image;
    data['job_category_id'] = this.jobCategoryId;
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? id;
  String? displayName;

  Category({this.id, this.displayName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    return data;
  }
}
