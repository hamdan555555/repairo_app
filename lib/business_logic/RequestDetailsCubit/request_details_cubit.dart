import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:breaking_project/data/repository/requset_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsStates> {
  final RequsetDetailsRepository requsetDetailsRepository;

  RequestDetailsCubit(this.requsetDetailsRepository)
      : super(RequestDetailsInitial());

  void getRequestDetails(String id) async {
    emit(RequestDetailsLoading());
    try {
      final requestdetails =
          await requsetDetailsRepository.getRequestDetails(id);
      emit(RequestDetailsSuccess(requestdetails));
    } catch (e) {
      emit(RequestDetailsError(e.toString()));
    }
  }
}
