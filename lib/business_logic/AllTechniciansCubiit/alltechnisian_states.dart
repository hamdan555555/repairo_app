import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/data/models/technisians_model.dart';

abstract class AlltechnisiansStates {}

class AlltechnisiansInitial extends AlltechnisiansStates {}

class AlltechnisiansFailed extends AlltechnisiansStates {
  final String message;
  AlltechnisiansFailed(this.message);
}

class AllAlltechnisiansLoading extends AlltechnisiansStates {}

class AllAlltechnisiansLoaded extends AlltechnisiansStates {
  final List<RTechData> technicians;
  AllAlltechnisiansLoaded({required this.technicians});
}
