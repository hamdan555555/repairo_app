import 'dart:io';
import 'package:breaking_project/business_logic/WalletRequestEditCubit/wallet_request_edit_states.dart';
import 'package:breaking_project/data/repository/wallet_request_edit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletRequestEditCubit extends Cubit<WalletTopupEditStates> {
  final WalletRequestEditRepository walletRequestEditRepository;

  final amountController = TextEditingController();

  WalletRequestEditCubit(this.walletRequestEditRepository)
      : super(WalletTopupEditInitial());
  void topuprequestedit({
    required String walletreqId,
    String? bankid,
    String? date,
    File? images,
    String? amount,
  }) async {
    emit(WalletTopupEditLoading());
    try {
      await walletRequestEditRepository.topuprequestedit(
          walletreqId: walletreqId,
          bankid: bankid!,
          amount: amount!,
          date: date!,
          image: images!);
      emit(WalletTopupEditSuccess());
      print("Doneeeeeeeeeeeeeeeeeeee Editiiiiiiing");
    } catch (e) {
      emit(WalletTopupEditError(e.toString()));
    }
  }
}
