import 'package:breaking_project/business_logic/VerifyCubit/verification_states.dart';
import 'package:breaking_project/data/repository/verification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  final VerificationRepository verificationRepository;

  VerificationCubit(this.verificationRepository) : super(VerificationInitial());

  void onSubmit() {}
  void didnotgetCode() {}

  void verify(String phone, String code) async {
    emit(VerificationLoading());
    try {
      var user = await verificationRepository.verifyNumber(phone, code);
      emit(VerificationSuccess(user));
      Get.back();
      Get.offAllNamed('mainscreen');
      //await LocalStorageService.saveLastVisitedScreen('mainscreen');

    } catch (e) {
      emit(VerificationError(e.toString()));
    }

//هاد مثال عن استخدام كلاس الايرور هاندلير 
//   try {
//   await api.login();
// } catch (e) {
//   final errorMessage = ErrorHandler.handleError(e);
//   emit(LoginErrorState(errorMessage));
// }


//هاد مثال عن استخدام كلاس النيتوورك تشيكينغ
// bool online = await NetworkChecker.isConnected();
// if (!online) {
//   // أعرض alert أو snackBar
//   print("لا يوجد اتصال بالإنترنت");
// }



//هاد مثال عن استخدام كلاس النوتفيكيشن
// await NotificationService.init();

// NotificationService.showNotification(
//   id: 1,
//   title: "أهلاً محمد 👋",
//   body: "تم تسجيل الدخول بنجاح!",
// );






  }
}
