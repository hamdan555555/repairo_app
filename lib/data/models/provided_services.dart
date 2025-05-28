class ProvidedServices {
  bool? success;
  String? message;
  RProvidedServicesData? data;

  ProvidedServices({this.success, this.message, this.data});

  ProvidedServices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? new RProvidedServicesData.fromJson(json['data'])
        : null;
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

class RProvidedServicesData {
  List<RProvidedServices>? services;
  int? selectedCount;
  int? selectedTotalPrice;

  RProvidedServicesData(
      {this.services, this.selectedCount, this.selectedTotalPrice});

  RProvidedServicesData.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = <RProvidedServices>[];
      json['services'].forEach((v) {
        services!.add(new RProvidedServices.fromJson(v));
      });
    }
    selectedCount = json['selected_count'];
    selectedTotalPrice = json['selected_total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['selected_count'] = this.selectedCount;
    data['selected_total_price'] = this.selectedTotalPrice;
    return data;
  }
}

class RProvidedServices {
  String? id;
  String? name;
  String? minPrice;
  String? maxPrice;
  bool? selected;
  int? price;
  String? image;

  RProvidedServices(
      {this.id,
      this.name,
      this.minPrice,
      this.maxPrice,
      this.selected,
      this.price,
      this.image});

  RProvidedServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['display_name'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    selected = json['selected'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.name;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['selected'] = this.selected;
    data['price'] = this.price;
    data['image'] = this.image;
    return data;
  }
}
