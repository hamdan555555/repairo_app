class RequestDetails {
  bool? success;
  String? message;
  RRequestDetailsData? data;

  RequestDetails({this.success, this.message, this.data});

  RequestDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? RRequestDetailsData.fromJson(json['data'])
        : null;
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

class RRequestDetailsData {
  String? id;
  String? scheduledDate;
  String? scheduledTime;
  String? lat;
  String? lng;
  String? location;
  String? details;
  String? status;
  Map<String, String>? bookingHistory; // 👈 مفتاح - قيمة
  String? createdAt;
  String? statusCancellation;
  User? user;
  User? technicianAccount;
  List<Services>? services;
  List<Services>? customServices;
  dynamic review;
  dynamic report;
  List<String>? image;

  RRequestDetailsData({
    this.id,
    this.scheduledDate,
    this.scheduledTime,
    this.lat,
    this.lng,
    this.location,
    this.details,
    this.status,
    this.bookingHistory,
    this.createdAt,
    this.statusCancellation,
    this.user,
    this.technicianAccount,
    this.services,
    this.customServices,
    this.review,
    this.report,
    this.image,
  });

  RRequestDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduledDate = json['scheduled_date'];
    scheduledTime = json['scheduled_time'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    details = json['details'];
    status = json['status'];
    if (json['booking_history'] != null) {
      bookingHistory = Map<String, String>.from(json['booking_history']);
    }
    createdAt = json['created_at'];
    statusCancellation = json['status_cancellation'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    technicianAccount = json['technician_account'] != null
        ? User.fromJson(json['technician_account'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['custom_services'] != null) {
      customServices = <Services>[];
      json['custom_services'].forEach((v) {
        customServices!.add(Services.fromJson(v));
      });
    }
    review = json['review'];
    report = json['report'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['scheduled_date'] = scheduledDate;
    data['scheduled_time'] = scheduledTime;
    data['lat'] = lat;
    data['lng'] = lng;
    data['location'] = location;
    data['details'] = details;
    data['status'] = status;
    if (bookingHistory != null) {
      data['booking_history'] = bookingHistory;
    }
    data['created_at'] = createdAt;
    data['status_cancellation'] = statusCancellation;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (technicianAccount != null) {
      data['technician_account'] = technicianAccount!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (customServices != null) {
      data['custom_services'] = customServices!.map((v) => v.toJson()).toList();
    }
    data['review'] = review;
    data['report'] = report;
    if (image != null) {
      data['image'] = image;
    }
    return data;
  }
}

class BookingHistory {
  String? pending;
  String? accepted;
  String? ongoing;
  String? ended;

  BookingHistory({this.pending, this.accepted, this.ongoing, this.ended});

  BookingHistory.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    accepted = json['accepted'];
    ongoing = json['ongoing'];
    ended = json['ended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pending'] = pending;
    data['accepted'] = accepted;
    data['ongoing'] = ongoing;
    data['ended'] = ended;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? image;

  User({this.id, this.name, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Services {
  String? id;
  String? displayName;
  String? price;
  int? quantity;
  String? image;

  Services({this.id, this.displayName, this.price, this.quantity, this.image});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['display_name'] = displayName;
    data['price'] = price;
    data['quantity'] = quantity;
    data['image'] = image;
    return data;
  }
}
