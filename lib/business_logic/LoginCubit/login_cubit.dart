import 'package:breaking_project/business_logic/LoginCubit/login_states.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  bool rememberMe = false;
  bool hide = false;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit(this.authRepository) : super(LoginInitial());

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(LoginRememberMeChanged(rememberMe));
  }

  void togglePassHide() {
    hide = !hide;
    emit(LoginPassHideChanged(hide));
  }

  void login(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneController.text);
    emit(LoginLoading());
    try {
      final userlog = await authRepository.login(phone);
      emit(LoginSuccess(userlog));
      Get.back();
      Get.toNamed('verify');
      //await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
