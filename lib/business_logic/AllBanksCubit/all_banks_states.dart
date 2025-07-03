import 'package:breaking_project/data/models/bank_model.dart';

abstract class AllbanksStates {}

class AllbanksInitial extends AllbanksStates {}

class AllbanksFailed extends AllbanksStates {
  final String message;
  AllbanksFailed(this.message);
}

class AllbanksLoading extends AllbanksStates {}

class AllbanksLoaded extends AllbanksStates {
  final List<RBankData> banks;
  AllbanksLoaded({required this.banks});
}
