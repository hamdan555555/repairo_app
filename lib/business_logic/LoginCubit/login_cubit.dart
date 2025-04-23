import 'package:breaking_project/business_logic/LoginCubit/login_states.dart';
import 'package:breaking_project/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void login(String email, String password) async {
    emit(LoginLoading());
    try {
      // final user = await authRepository.login(email, password);
      // emit(LoginSuccess(user));
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
