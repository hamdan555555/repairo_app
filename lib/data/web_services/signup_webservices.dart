import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupWebservices {
  Future<Map<String, dynamic>> signup(
      String email, String phone, String name, String password) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('signup failed');
    }
  }
}
