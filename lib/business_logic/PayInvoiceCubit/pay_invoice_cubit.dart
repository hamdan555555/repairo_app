import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_states.dart';
import 'package:breaking_project/data/repository/pay_invoice_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayInvoiceCubit extends Cubit<PayInvoiceStates> {
  final PayInvoiceRepository payInvoiceRepository;

  PayInvoiceCubit(this.payInvoiceRepository) : super(PayInvoiceInitial());

  void payinvoice({
    required String id,
    required String paymenttype,
  }) async {
    emit(PayInvoiceLoading());
    try {
      final prefs = await SharedPreferences.getInstance();

      await payInvoiceRepository.payinvoice(id: id, paymenttype: paymenttype);
      emit(PayInvoiceSuccess());
      print("Doneeeeeeeeeeeeeeeeeeee");
      //Get.back();
      //Get.toNamed('verification');
    } catch (e) {
      emit(PayInvoiceError(e.toString()));
    }
  }
}
