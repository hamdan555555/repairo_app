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
        data!.add(RSearchedServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class RSearchedServiceData {
  String? id;
  String? displayName;
  String? type;
  String? image;
  String? subCategoryId; // جديد

  RSearchedServiceData({
    this.id,
    this.displayName,
    this.type,
    this.image,
    this.subCategoryId,
  });

  RSearchedServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    type = json['type'];
    image = json['image'];
    subCategoryId = json['sub_category_id']; // جديد
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['display_name'] = displayName;
    result['type'] = type;
    result['image'] = image;
    result['sub_category_id'] = subCategoryId; // جديد
    return result;
  }

  @override
  String toString() {
    return 'RSearchedServiceData(id: $id, name: $displayName, type: $type, image: $image, subCategoryId: $subCategoryId)';
  }
}
