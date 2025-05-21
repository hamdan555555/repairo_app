import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';

class ProvidedServicesRepository {
  final ProvidedServicesWebservices providedServicesWebservices;

  ProvidedServicesRepository(this.providedServicesWebservices);

  // Future<List<RProvidedServicesData>> getThisTechServices(String techid ,List<String> selectedServiceIds) async {
  //   final data = await providedServicesWebservices.getthisTechServices(technicianId: techid , selectedServiceIds: selectedServiceIds);

  //   return RProvidedServicesData.fromJson(data);
  // }

  // Future<List<RProvidedServicesData>> getThisTechServices(
  //   String techid,
  //   List<String> services,
  // ) async {
  //   print("provided services Searching Startedd");

  //   final providedser = await providedServicesWebservices.getthisTechServices(
  //     technicianId: techid,
  //     selectedServiceIds: services,
  //   );
  //   //print("this inside repo response ===> $response");

  //   // تأكد إنو البيانات موجودة
  //   //final List<dynamic> serviceList = response['data']['services'];
  //   final result =
  //       providedser.map((item) => RProvidedServicesData.fromJson(item).)

  //   print("result in repo of services providers ===> $result");
  //   return result;
  // }

  Future<List<RProvidedServices>> getThisTechServices(
    String techid,
    List<String> services,
  ) async {
    print("provided services Searching Started");

    final response = await providedServicesWebservices.getthisTechServices(
      technicianId: techid,
      selectedServiceIds: services,
    );

    print("this inside repo response ===> $response");

    if (response['success'] == true) {
      final List<dynamic> serviceList = response['data']['services'];
      print("this is this list $serviceList");

      final result =
          serviceList.map((item) => RProvidedServices.fromJson(item)).toList();

      print("result in repo of services providers ===> $result");
      return result;
    } else {
      print("getThisTechServices failed: ${response['message']}");
      throw Exception('فشل في جلب الخدمات: ${response['message']}');
    }
  }
}
