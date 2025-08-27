import 'package:breaking_project/data/models/chatting_model.dart';
import 'package:breaking_project/data/web_services/show_chat_webservice.dart';

class ShowChatRepository {
  final ShowChatWebservice showChatWebservice;

  ShowChatRepository(this.showChatWebservice);

  Future<RChatData> showChat(String requestid) async {
    final data = await showChatWebservice.showChat(requestid);
    return RChatData.fromJson(data);
  }
}
