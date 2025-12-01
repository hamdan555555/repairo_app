import 'package:breaking_project/data/models/coponus_model.dart';

abstract class CopounsStates {}

class CopounsInitial extends CopounsStates {}

class CopounsLoading extends CopounsStates {}

class CopounsSuccess extends CopounsStates {
  final List<RCoponusData> copuns;
  CopounsSuccess({required this.copuns});
}

class CopounsEmpty extends CopounsStates {}

class CopounsError extends CopounsStates {
  final String message;
  CopounsError(this.message);
}
