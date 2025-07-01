import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class PayInvoiceWebservices {
  Future<Map<String, dynamic>> payinvoice(
      {
        required String id,
      required String paymenttype,}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/user/invoice/$id');
    print("111111111111");

    final request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['payment_type'] = paymenttype;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("تم الإرسال بنجاح: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("فشل الدفع: ${response.statusCode} - ${response.body}");
        return {
          'success': false,
          'message': 'فشل الدفع',
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
