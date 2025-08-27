abstract class SendChatMessageStates {}

class SendChatMessageInitial extends SendChatMessageStates {}

class SendChatMessageLoading extends SendChatMessageStates {}

class SendChatMessageSuccess extends SendChatMessageStates {}

class SendChatMessageError extends SendChatMessageStates {
  final String message;
  SendChatMessageError(this.message);
}
