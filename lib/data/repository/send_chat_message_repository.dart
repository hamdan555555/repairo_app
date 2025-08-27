import 'package:breaking_project/data/web_services/send_chat_message_webservice.dart';

class SendChatMessageRepository {
  final SendChatMessageWebservice sendChatMessageWebservice;
  SendChatMessageRepository(this.sendChatMessageWebservice);
  Future<void> sendmessage(String chatid, String message) async {
    final data = await sendChatMessageWebservice.sendmessage(chatid, message);
    print(data);
  }
}
