import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class VerificationWebservices {
  Future<Map<String, dynamic>> verifyNumber(String phone, String code) async {
    final response = await http.post(
      Uri.parse('http://172.20.10.5:8000/api/user/authentication/check-code'),
      body: {'phone': phone, 'code': code},
    );

    if (response.statusCode == 200) {
      print("successsssss");
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error happened");
      throw Exception('Login failed');
    }
  }
}
