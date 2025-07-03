import 'package:breaking_project/data/models/bank_data_model.dart';
import 'package:breaking_project/data/web_services/bank_data_webservice.dart';

class BankDataRepository {
  final BankDataWebservices bankDataWebservices;

  BankDataRepository({required this.bankDataWebservices});

  Future<BankDRData> getBankData(String id) async {
    final item = await bankDataWebservices.getBankData(id);
    return BankDRData.fromJson(item);
  }
}
