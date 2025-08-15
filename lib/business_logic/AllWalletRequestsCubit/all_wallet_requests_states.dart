import 'package:breaking_project/data/models/wallet_requests_model.dart';

abstract class AllWalletRequestsStates {}

class AllWalletRequestsInitial extends AllWalletRequestsStates {}

class AllWalletRequestsFailed extends AllWalletRequestsStates {
  final String message;
  AllWalletRequestsFailed(this.message);
}

class AllWalletRequestsLoading extends AllWalletRequestsStates {}

class AllWalletRequestsLoaded extends AllWalletRequestsStates {
  final List<RWalletRequestsData> walletrequests;
  AllWalletRequestsLoaded({required this.walletrequests});
}
