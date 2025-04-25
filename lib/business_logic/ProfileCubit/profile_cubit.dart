import 'package:breaking_project/business_logic/ProfileCubit/profile_states.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  void getUserData(String token) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      var tokenn = prefs.getString('auth_token');

      final user = await profileRepository.getUserData(tokenn!);
      emit(ProfileSuccess(user));
      //Get.back();
      //Get.toNamed('verify');
      //await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
