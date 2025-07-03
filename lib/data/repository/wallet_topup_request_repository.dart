import 'dart:io';
import 'package:breaking_project/data/web_services/wallet_topup_request_webservice.dart';

class WalletTopupRequestRepository {
  final WalletTopupRequestWebservice walletTopupRequestWebservice;
  WalletTopupRequestRepository(this.walletTopupRequestWebservice);

  Future<void> topuprequest({
    required String bankid,
    required String amount,
    required String date,
    required File image,
  }) async {
    final data = await walletTopupRequestWebservice.topuprequest(
        bankid: bankid, amount: amount, date: date, image: image);
    print(data);
  }
}
