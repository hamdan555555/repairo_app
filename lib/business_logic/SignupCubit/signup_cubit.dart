import 'package:breaking_project/business_logic/LoginCubit/login_states.dart';
import 'package:breaking_project/business_logic/SignupCubit/signup_states.dart';
import 'package:breaking_project/data/repository/signup_repository.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository signupRepository;

  final phonecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  bool hide = false;

  SignupCubit(this.signupRepository) : super(SignupInitial());

  void signup(String email, String password, String phone, String name) async {
    print("ggggggggggggggggg");
    emit(SignupLoading());
    print("sssssssssssss");
    try {
      await Future.delayed(const Duration(seconds: 2));

      // final user = await signupRepository.signup(email, password, phone, name);
      // emit(SignupSuccess(user));
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }

  void togglePassHide() {
    hide = !hide;
    emit(SignupPassHideChanged(hide));
  }
}
