import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteServicerequestWebservice {
  Future<List<Map<String, dynamic>>> deleteServiceRequest(
      {required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/user/service-request/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('request deleted succesfully: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      return data;
    } else {
      print('Failed to delete requst: ${response.statusCode}');
      throw Exception('deleting request failed');
    }
  }
}
