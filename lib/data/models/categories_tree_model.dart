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
  String? image;
  String? type;
  List<Subcategories>? subcategories;

  RCategoryTreeData({
    this.id,
    this.displayName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
    this.type,
    this.subcategories,
  });

  RCategoryTreeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    image = json['image'];
    type = json['type'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['display_name'] = displayName;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['image'] = image;
    map['type'] = type;
    if (subcategories != null) {
      map['subcategories'] = subcategories!.map((v) => v.toJson()).toList();
    }
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
  String? image;
  String? type;
  List<Subcategories>? subcategories;
  List<Service>? services;

  Subcategories({
    this.id,
    this.displayName,
    this.categoryId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
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
    image = json['image'];
    type = json['type'];

    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }

    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(Service.fromJson(v));
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
    map['image'] = image;
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

class Service {
  String? id;
  String? subCategoryId;
  String? displayName;
  double? minPrice;
  double? maxPrice;
  int? expectedTime;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? image;

  Service({
    this.id,
    this.subCategoryId,
    this.displayName,
    this.minPrice,
    this.maxPrice,
    this.expectedTime,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString(),
      subCategoryId: json['sub_category_id']?.toString(),
      displayName: json['display_name']?.toString(),
      minPrice: double.tryParse(json['min_price']?.toString() ?? '0'),
      maxPrice: double.tryParse(json['max_price']?.toString() ?? '0'),
      expectedTime: json['expected_time'] is int
          ? json['expected_time']
          : int.tryParse(json['expected_time']?.toString() ?? '0'),
      description: json['description']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_category_id': subCategoryId,
      'display_name': displayName,
      'min_price': minPrice,
      'max_price': maxPrice,
      'expected_time': expectedTime,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'image': image,
    };
  }
}
