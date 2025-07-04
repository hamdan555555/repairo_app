import 'dart:io';

import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CreatingOrderWebservice {
  Future<Map<String, dynamic>> creteOrder(
      {required String technicianId,
      required List<String> selectedServiceIds,
      required String latitude,
      required String longtude,
      required String location,
      required List<File> images,
      required String date,
      required String time,
      required String details}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/user/service-request');

    print("111111111111");

    final request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['technician_account_id'] = technicianId;
    request.fields['location'] = location;
    request.fields['lat'] = latitude;
    request.fields['lng'] = longtude;
    request.fields['scheduled_date'] = date;
    request.fields['scheduled_time'] = time;
    request.fields['details'] = details;

    if (selectedServiceIds.isNotEmpty) {
      for (int i = 0; i < selectedServiceIds.length; i++) {
        request.fields['services[$i][id]'] = selectedServiceIds[i];
      }
    }

    if (selectedServiceIds.isNotEmpty) {
      for (int i = 0; i < selectedServiceIds.length; i++) {
        request.fields['services[$i][quantity]'] = '1';
      }
    }

    for (int i = 0; i < images.length; i++) {
      File imageFile = images[i];
      request.files.add(await http.MultipartFile.fromPath(
        'image[$i]',
        imageFile.path,
      ));
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
