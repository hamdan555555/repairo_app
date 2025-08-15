import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/AllWalletRequestsCubit/all_wallet_requests_states.dart';
import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/data/repository/all_wallet_requests_repository.dart';

class AllWalletRequestsCubit extends Cubit<AllWalletRequestsStates> {
  AllWalletRequestsCubit(this.allWalletRequestsRepository)
      : super(AllWalletRequestsInitial());
  final AllWalletRequestsRepository allWalletRequestsRepository;
  late List<RWalletRequestsData> walletrequests = [];

  Future<List<RWalletRequestsData>> getallwalletrequests({
    String? status,
    String? bankId,
  }) async {
    allWalletRequestsRepository
        .getAllWalletRequests(status: status, bankid: bankId)
        .then((therequests) {
      emit(AllWalletRequestsLoaded(walletrequests: therequests));
      walletrequests = therequests;
    });
    return walletrequests;
  }
}
