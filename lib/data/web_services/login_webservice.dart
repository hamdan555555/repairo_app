import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthWebService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }
}
