import 'package:breaking_project/data/models/chatting_model.dart';

abstract class ShowChatStates {}

class ShowChatInitial extends ShowChatStates {}

class ShowChatLoading extends ShowChatStates {}

class ShowChatSuccess extends ShowChatStates {
  final RChatData chat;
  ShowChatSuccess(this.chat);
}

class ShowChatError extends ShowChatStates {
  final String message;
  ShowChatError(this.message);
}
