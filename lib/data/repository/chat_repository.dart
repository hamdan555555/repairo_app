import 'dart:io';

import 'package:breaking_project/data/models/chatting_model.dart';
import 'package:breaking_project/data/web_services/chat_webservice.dart';

class ChatRepository {
  final ChatWebservice chatWebservice;

  ChatRepository(this.chatWebservice);

  Future<RChatData> showChat(String requestid) async {
    final data = await chatWebservice.showChat(requestid);
    return RChatData.fromJson(data);
  }

  Future<void> sendmessage(String chatid, String? message, File? image) async {
    final data = await chatWebservice.sendmessage(chatid, message, image);
    print("555555555555");
    print(data);
  }
}
