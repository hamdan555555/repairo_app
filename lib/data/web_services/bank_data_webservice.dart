import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BankDataWebservices {
  Future<Map<String, dynamic>> getBankData(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/user/bank/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('bank d info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(dataa['data']);
      print(data.toString());
      return data;
    } else {
      print('Failed to get bank d info: ${response.statusCode}');
      throw Exception('getting bank info failed');
    }
  }
}
