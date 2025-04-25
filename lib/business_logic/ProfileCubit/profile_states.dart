import 'package:breaking_project/data/models/userprofile.dart';

import '../../data/models/userlog_model.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileSuccess extends ProfileStates {
  //final UserProfile userProfile;
  final PData userdata;
  ProfileSuccess(this.userdata);
}

class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}
