import 'package:breaking_project/data/models/chatting_model.dart';
import 'package:breaking_project/presentation/widgets/reciever_message_item_widget.dart';
import 'package:breaking_project/presentation/widgets/send_message_widget.dart';
import 'package:breaking_project/presentation/widgets/sender_message_item_widget.dart';
import 'package:flutter/widgets.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({
    super.key,
    required this.scrollController,
    required this.chatDetailsModel,
    required this.currentUser,
  });

  final ScrollController scrollController;
  final RChatData? chatDetailsModel;
  final int currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            itemCount: chatDetailsModel!.messages!.length,
            itemBuilder: (context, i) {
              Messages message = chatDetailsModel!.messages![i];
              if (currentUser != message.sender) {
                return ReceiverMsgItemWidget(
                  message: message,
                );
              } else {
                return SenderMsgItemWidget(
                  message: message,
                );
              }
            }),
      ),
      SendMessageWidget(
        userId: currentUser,
        roomId: int.parse(chatDetailsModel!.chatId!),
      ),
    ]);
  }
}
