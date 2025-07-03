import 'package:breaking_project/data/models/bank_data_model.dart';

abstract class BankDataStates {}

class BankDataInitial extends BankDataStates {}

class BankDataFailed extends BankDataStates {
  final String message;
  BankDataFailed(this.message);
}

class BankDataLoading extends BankDataStates {}

class BankDataLoaded extends BankDataStates {
  final BankDRData BankDdata;
  BankDataLoaded({required this.BankDdata});
}
