import 'package:breaking_project/business_logic/VerifyCubit/verification_states.dart';
import 'package:breaking_project/data/repository/verification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  final VerificationRepository verificationRepository;

  VerificationCubit(this.verificationRepository) : super(VerificationInitial());

  void onSubmit() {
    // hide = !hide;
    // emit(LoginPassHideChanged(hide));
  }
  void DidnotgetCode() {
    // hide = !hide;
    // emit(LoginPassHideChanged(hide));
  }

  void verify(String phone, String code) async {
    emit(VerificationLoading());
    try {
      var user = await verificationRepository.verifyNumber(phone, code);
      emit(VerificationSuccess(user));
      Get.back();
      //Get.toNamed('mainscreen');
      Get.offAllNamed('mainscreen');
    } catch (e) {
      emit(VerificationError(e.toString()));
    }
  }
}
