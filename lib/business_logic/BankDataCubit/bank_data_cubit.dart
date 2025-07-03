import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/BankDataCubit/bank_data_states.dart';
import 'package:breaking_project/data/models/bank_data_model.dart';
import 'package:breaking_project/data/repository/bank_data_repository.dart';

class BankDataCubit extends Cubit<BankDataStates> {
  BankDataCubit(this.bankDataRepository) : super(BankDataInitial());

  final BankDataRepository bankDataRepository;
  late BankDRData bankdata;

  Future<BankDRData?> getBankData(String id) async {
    emit(BankDataLoading());
    try {
      final bankinfo = await bankDataRepository.getBankData(id);
      print("insideee Bankd cubitttt");
      print(bankinfo);
      emit(BankDataLoaded(BankDdata: bankinfo));
      return bankinfo;
    } catch (e) {
      print("error in cubit: $e");
      emit(BankDataFailed(e.toString()));
      return null;
    }
  }
}
