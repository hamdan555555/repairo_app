import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_states.dart';
import 'package:breaking_project/data/repository/cancel_order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelOrderCubit extends Cubit<CancelOrderStates> {
  final CancelOrderRepository cancelOrderRepository;

  CancelOrderCubit(this.cancelOrderRepository) : super(CancelOrderInitial());

  void cancelorder({
    required String id,
    required String reason,
  }) async {
    emit(CancelOrderLoading());
    try {
      final prefs = await SharedPreferences.getInstance();

      await cancelOrderRepository.cancelorder(id: id, reason: reason);
      emit(CancelOrderSuccess());
    } catch (e) {
      emit(CancelOrderError(e.toString()));
    }
  }
}
