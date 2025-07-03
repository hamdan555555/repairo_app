import 'dart:io';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_states.dart';
import 'package:breaking_project/data/repository/wallet_topup_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTopupCubit extends Cubit<WalletTopupStates> {
  final WalletTopupRequestRepository WalletTopupRepository;

  final amountController = TextEditingController();

  WalletTopupCubit(this.WalletTopupRepository) : super(WalletTopupInitial());

  void topuprequest({
    required String bankid,
    required String date,
    required File images,
    required String amount,
  }) async {
    emit(WalletTopupLoading());
    try {
      await WalletTopupRepository.topuprequest(
          bankid: bankid, amount: amount, date: date, image: images);
      emit(WalletTopupSuccess());
      print("Doneeeeeeeeeeeeeeeeeeee");
    } catch (e) {
      emit(WalletTopupError(e.toString()));
    }
  }
}
