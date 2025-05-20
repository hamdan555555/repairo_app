import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationWebservices {
  Future<Map<String, dynamic>> verifyNumber(String phone, String code) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/user/authentication/check-code'),
      body: {'phone': phone, 'code': code},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error happened");
      throw Exception('Login failed');
    }
  }
}
