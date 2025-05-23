import 'package:breaking_project/data/models/user_requests_model.dart';

abstract class UserRequestsStates {}

class UserRequestsInitial extends UserRequestsStates {}

class UserRequestsFailed extends UserRequestsStates {
  final String message;
  UserRequestsFailed(this.message);
}

class UserRequestsLoading extends UserRequestsStates {}

class UserRequestsLoaded extends UserRequestsStates {
  final List<RUserRequestData> requests;
  UserRequestsLoaded({required this.requests});
}
