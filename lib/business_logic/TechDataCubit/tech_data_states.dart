import 'package:breaking_project/data/models/tech_data_model.dart';

abstract class TechDataStates {}

class TechDataInitial extends TechDataStates {}

class TechDataFailed extends TechDataStates {
  final String message;
  TechDataFailed(this.message);
}

class TechDataLoading extends TechDataStates {}

class TechDataLoaded extends TechDataStates {
  final RTecPData techdata;
  TechDataLoaded({required this.techdata});
}
