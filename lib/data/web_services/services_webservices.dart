import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceWebservices {
  Future<List<Map<String, dynamic>>> getServices(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/services/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('sub info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      print(data.toString());
      return data;
    } else {
      print('Failed to get services info: ${response.statusCode}');
      throw Exception('services failed');
    }
  }
}
