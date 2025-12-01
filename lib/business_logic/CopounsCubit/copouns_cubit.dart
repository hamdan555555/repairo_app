import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/CopounsCubit/copouns_states.dart';
import 'package:breaking_project/data/models/coponus_model.dart';
import 'package:breaking_project/data/repository/copouns_repository.dart';

class CopounsCubit extends Cubit<CopounsStates> {
  CopounsCubit(this.copounsRepository) : super(CopounsInitial());

  final CopounsRepository copounsRepository;

  Future<void> getAllCopouns() async {
    try {
      emit(CopounsLoading()); // حالة تحميل

      final copouns = await copounsRepository.getAllCopuns();

      if (copouns.isEmpty) {
        emit(CopounsEmpty()); // لو ما في كوبونات
      } else {
        emit(CopounsSuccess(copuns: copouns)); // لو في كوبونات
      }
    } catch (e) {
      emit(CopounsError(e.toString())); // حالة خطأ
    }
  }
}
