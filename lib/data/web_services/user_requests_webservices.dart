import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRequestsWebservices {
  Future<List<Map<String, dynamic>>> getAllRequests({
    String? status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    print("herreeee $status");
    final url =
        Uri.parse('${AppConstants.baseUrl}/user/service-request').replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status_request': status,
      },
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('UserRequests info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      return data;
    } else {
      print('Failed to get userRequests info: ${response.statusCode}');
      throw Exception(' userRequests get failed');
    }
  }
}
