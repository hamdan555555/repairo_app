class TechData {
  bool? success;
  String? message;
  RTecPData? data;

  TechData({this.success, this.message, this.data});

  TechData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new RTecPData.fromJson(json['data']) : null;
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

class RTecPData {
  String? id;
  String? name;
  String? place;
  String? rating;
  String? jobCategoryId;
  Category? category;
  List<PreviousWorks>? previousWorks;
  String? image;

  RTecPData(
      {this.id,
      this.name,
      this.place,
      this.rating,
      this.jobCategoryId,
      this.category,
      this.previousWorks,
      this.image});

  RTecPData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    place = json['place'];
    rating = json['rating'];
    jobCategoryId = json['job_category_id'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['previous_works'] != null) {
      previousWorks = <PreviousWorks>[];
      json['previous_works'].forEach((v) {
        previousWorks!.add(new PreviousWorks.fromJson(v));
      });
    }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['place'] = this.place;
    data['rating'] = this.rating;
    data['job_category_id'] = this.jobCategoryId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.previousWorks != null) {
      data['previous_works'] =
          this.previousWorks!.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
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

class PreviousWorks {
  String? id;
  String? title;
  String? description;
  String? technicianAccountId;
  List<String>? image;

  PreviousWorks(
      {this.id,
      this.title,
      this.description,
      this.technicianAccountId,
      this.image});

  PreviousWorks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    technicianAccountId = json['technician_account_id'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['technician_account_id'] = this.technicianAccountId;
    if (this.image != null) {
      data['image'] = this.image;
    }

    return data;
  }
}
