class CategoriesData {
  bool? success;
  String? message;
  List<RCategoryTreeData>? data;

  CategoriesData({this.success, this.message, this.data});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RCategoryTreeData>[];
      json['data'].forEach((v) {
        data!.add(RCategoryTreeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RCategoryTreeData {
  String? id;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<Subcategories>? subcategories;
  String? type;

  RCategoryTreeData({
    this.id,
    this.displayName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subcategories,
    this.type,
  });

  RCategoryTreeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['display_name'] = displayName;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    if (subcategories != null) {
      map['subcategories'] = subcategories!.map((v) => v.toJson()).toList();
    }
    map['type'] = type;
    return map;
  }
}

class Subcategories {
  String? id;
  String? displayName;
  String? categoryId;
  dynamic parentId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? type;
  List<Subcategories>? subcategories; // Nested subcategories
  List<Services>? services;

  Subcategories({
    this.id,
    this.displayName,
    this.categoryId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.type,
    this.subcategories,
    this.services,
  });

  Subcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    categoryId = json['category_id'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    type = json['type'];

    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }

    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['display_name'] = displayName;
    map['category_id'] = categoryId;
    map['parent_id'] = parentId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['type'] = type;
    if (subcategories != null) {
      map['subcategories'] = subcategories!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      map['services'] = services!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Services {
  String? id;
  String? subCategoryId;
  String? displayName;
  String? minPrice;
  String? maxPrice;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Services({
    this.id,
    this.subCategoryId,
    this.displayName,
    this.minPrice,
    this.maxPrice,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    displayName = json['display_name'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['sub_category_id'] = subCategoryId;
    map['display_name'] = displayName;
    map['min_price'] = minPrice;
    map['max_price'] = maxPrice;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    return map;
  }
}
