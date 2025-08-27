import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendChatMessageWebservice {
  Future<Map<String, dynamic>> sendmessage(
    String chatid,
    String message,
  ) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/user/chat/message'),
      body: {
        'chat_id': chatid,
        'message': message,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error happened");
      throw Exception('Login failed');
    }
  }
}
