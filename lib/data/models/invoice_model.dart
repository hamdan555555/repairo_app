class InvoiceDetails {
  bool? success;
  String? message;
  InvoiceRData? data;

  InvoiceDetails({this.success, this.message, this.data});

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? InvoiceRData.fromJson(json['data']) : null;
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

class InvoiceRData {
  String? id;
  String? serviceRequestId;
  String? createdDate;
  String? paymentDate;
  String? paymentType;
  String? status;
  int? totalAmount;
  List<Services>? services;
  List<CustomService>? customServices;

  InvoiceRData({
    this.id,
    this.serviceRequestId,
    this.createdDate,
    this.paymentDate,
    this.paymentType,
    this.status,
    this.totalAmount,
    this.services,
    this.customServices,
  });

  InvoiceRData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceRequestId = json['service_request_id'];
    createdDate = json['created_date'];
    paymentDate = json['payment_date'];
    paymentType = json['payment_type'];
    status = json['status'];
    totalAmount = json['total_amount'];

    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }

    if (json['custom_services'] != null) {
      customServices = <CustomService>[];
      json['custom_services'].forEach((v) {
        customServices!.add(CustomService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['service_request_id'] = serviceRequestId;
    data['created_date'] = createdDate;
    data['payment_date'] = paymentDate;
    data['payment_type'] = paymentType;
    data['status'] = status;
    data['total_amount'] = totalAmount;

    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (customServices != null) {
      data['custom_services'] = customServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? name;
  int? quantity;
  int? price;

  Services({this.name, this.quantity, this.price});

  Services.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class CustomService {
  String? name;
  int? price;

  CustomService({this.name, this.price});

  CustomService.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
