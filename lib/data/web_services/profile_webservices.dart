import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileWebservices {
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final prefs = await SharedPreferences.getInstance();

    final url = Uri.parse('http://172.20.10.5:8000/api/user/profile');
    // const token =
    //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL3VzZXIvYXV0aGVudGljYXRpb24vY2hlY2stY29kZSIsImlhdCI6MTc0NTQ5NDg2MywiZXhwIjoxNzQ1NDk4NDYzLCJuYmYiOjE3NDU0OTQ4NjMsImp0aSI6IkI2MzlXUmFCNWtkM0M0bE4iLCJzdWIiOiI5ZWMwMTc1ZS0yMWJkLTQyYmUtODg1OS0xMDE3ODMzMjhiZjMiLCJwcnYiOiI0YWMwNWMwZjhhYzA4ZjM2NGNiNGQwM2ZiOGUxZjYzMWZlYzMyMmU4In0.a8XqHaj-CdnbXK8YHwQ0-r-xOtGzyz6ySnNDLwUUDCI';

    var token = prefs.getString('auth_token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('User info: ${response.body}');
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('Login failed');
    }
  }
}
