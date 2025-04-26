import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoriesWebservice {
  Future<List<Map<String, dynamic>>> getSubCategories(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('http://172.20.10.5:8000/api/sub-category/$id');

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
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('Login failed');
    }
  }
}
