import 'package:breaking_project/business_logic/ShowChatCubit/show_chat_states.dart';
import 'package:breaking_project/data/repository/show_chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowChatCubit extends Cubit<ShowChatStates> {
  final ShowChatRepository showChatRepository;

  ShowChatCubit(this.showChatRepository) : super(ShowChatInitial());

  void showChat(String requestid) async {
    emit(ShowChatLoading());
    try {
      final chat = await showChatRepository.showChat(requestid);
      emit(ShowChatSuccess(chat));
    } catch (e) {
      emit(ShowChatError(e.toString()));
    }
  }
}
