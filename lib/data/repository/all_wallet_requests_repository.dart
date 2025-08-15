import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/data/web_services/all_wallet_requests_webservice.dart';

class AllWalletRequestsRepository {
  final AllWalletRequestsWebservice allWalletRequestsWebservice;

  AllWalletRequestsRepository({required this.allWalletRequestsWebservice});

  Future<List<RWalletRequestsData>> getAllWalletRequests(
      {String? status, String? bankid}) async {
    final items = await allWalletRequestsWebservice.getAllWalletRequests(
        status: status, bank_id: bankid);
    return items.map((item) => RWalletRequestsData.fromJson(item)).toList();
  }
}
