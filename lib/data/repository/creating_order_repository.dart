import 'dart:io';
import 'package:breaking_project/data/web_services/creating_order_webservice.dart';
class CreatingOrderRepository {
  final CreatingOrderWebservice creatingOrderWebservice;

  CreatingOrderRepository(this.creatingOrderWebservice);

  Future<void> createOrder(
      {required String technicianId,
      required List<String> selectedServiceIds,
      required String latitude,
      required String longtude,
      required String location,
      required List<File> images,
      required String date,
      required String time,
      required String details}) async {
    final data = await creatingOrderWebservice.creteOrder(
        date: date,
        details: details,
        images: images,
        latitude: latitude,
        location: location,
        longtude: longtude,
        selectedServiceIds: selectedServiceIds,
        technicianId: technicianId,
        time: time);
    print(data);
  }
}
