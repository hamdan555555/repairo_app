import 'dart:io';

import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WalletTopupRequestWebservice {
  Future<Map<String, dynamic>> topuprequest(
      {required String bankid,
      required String amount,
      required String date,
      required File image}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/user/wallet-top-up-request');

    print("111111111111");

    final request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['bank_id'] = bankid;
    request.fields['amount'] = amount;
    request.fields['date'] = date;
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
    ));
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
