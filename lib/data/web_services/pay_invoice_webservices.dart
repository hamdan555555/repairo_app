import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PayInvoiceWebservices {
  Future<Map<String, dynamic>> payinvoice({
    required String id,
    required String paymenttype,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/user/invoice/$id'),
      );

      request.fields.addAll({
        '_method': 'put',
        'payment_type': paymenttype,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Payment successful: $responseBody");
        final decoded = jsonDecode(responseBody);
        return decoded;
      } else {
        print("❌ Payment failed: $responseBody");
        return {
          'success': false,
          'message': 'فشل الدفع',
          'status': response.statusCode,
          'body': responseBody,
        };
      }
    } catch (e) {
      print("⚠️ Exception occurred: $e");
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }
}
