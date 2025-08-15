import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllWalletRequestsWebservice {
  Future<List<Map<String, dynamic>>> getAllWalletRequests({
    String? status,
    String? bank_id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url =
        Uri.parse('${AppConstants.baseUrl}/user/wallet-top-up-request').replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
        if (bank_id != null && bank_id.isNotEmpty) 'bank_id': bank_id,
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
      print('wallet requests info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      return data;
    } else {
      print('Failed to get wallet requests info: ${response.statusCode}');
      throw Exception('wallet requests got failed');
    }
  }
}
