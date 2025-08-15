import 'dart:io';
import 'package:breaking_project/data/web_services/wallet_request_edit_webservice.dart';

class WalletRequestEditRepository {
  final WalletRequestEditWebservice walletRequestEditWebservice;
  WalletRequestEditRepository(this.walletRequestEditWebservice);

  Future<void> topuprequestedit({
    required String walletreqId,
    String? bankid,
    String? amount,
    String? date,
    File? image,
  }) async {
    final data = await walletRequestEditWebservice.topuprequestedit(
        walletreqId: walletreqId,
        bankid: bankid!,
        amount: amount!,
        date: date!,
        image: image!);
    print(data);
  }
}
