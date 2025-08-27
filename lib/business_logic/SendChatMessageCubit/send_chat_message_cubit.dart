import 'package:breaking_project/business_logic/SendChatMessageCubit/send_chat_message_states.dart';
import 'package:breaking_project/data/repository/send_chat_message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendChatMessageCubit extends Cubit<SendChatMessageStates> {
  final SendChatMessageRepository sendChatMessageRepository;

  SendChatMessageCubit(this.sendChatMessageRepository)
      : super(SendChatMessageInitial());

  void sendmessage(String chatid, String message) async {
    emit(SendChatMessageLoading());
    try {
      await sendChatMessageRepository.sendmessage(chatid, message);
      emit(SendChatMessageSuccess());
    } catch (e) {
      emit(SendChatMessageError(e.toString()));
    }
  }
}
