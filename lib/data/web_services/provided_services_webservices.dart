import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProvidedServicesWebservices {
  // Future<Map<String, dynamic>> getthisTechServices(String id,) async {
  //   final response = await http.post(
  //     Uri.parse('${AppConstants.baseUrl}/user/technician/$id/services'),

  //     body: {'phone': phone, 'type_message': 'sms'},
  //   );

  //   if (response.statusCode == 200) {
  //     print("successsssss");
  //     final data = jsonDecode(response.body);
  //     print(data.toString());
  //     return data;
  //   } else {
  //     print("Error happened");
  //     throw Exception('Login failed');
  //   }
  // }

//   Future<Map<String, dynamic>> getthisTechServices({
//   required String technicianId,
//   required List<String> selectedServiceIds,
// }) async {
//   final url = Uri.parse('${AppConstants.baseUrl}/user/technician/$technicianId/services');

//   final request = http.MultipartRequest('POST', url);

//   // إضافة كل خدمة مختارة كمفتاح selected_services[i]
//   for (int i = 0; i < selectedServiceIds.length; i++) {
//     request.fields['selected_services[$i]'] = selectedServiceIds[i];
//   }

//   try {
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       print("تم الإرسال بنجاح: ${response.body}");
//     } else {
//       print("فشل الطلب: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     print("خطأ بالطلب: $e");

//   }
// }

  Future<Map<String, dynamic>> getthisTechServices({
    required String technicianId,
    required List<String> selectedServiceIds,
  }) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/user/technician/$technicianId/services');

    final request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('auth_token');

    request.headers['Authorization'] = 'Bearer $token';

    for (int i = 0; i < selectedServiceIds.length; i++) {
      request.fields['selected_services[$i]'] = selectedServiceIds[i];
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("تم الإرسال بنجاح: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("فشل الطلب: ${response.statusCode} - ${response.body}");
        return {
          'success': false,
          'message': 'فشل الطلب',
          'status': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      print("خطأ بالطلب: $e");
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }
}
