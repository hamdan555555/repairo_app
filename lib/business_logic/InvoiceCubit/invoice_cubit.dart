import 'package:breaking_project/business_logic/InvoiceCubit/invoice_states.dart';
import 'package:breaking_project/data/repository/invoice_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceCubit extends Cubit<InvoiceStates> {
  final InvoiceRepository invoiceRepository;

  InvoiceCubit(this.invoiceRepository) : super(InvoiceInitial());

  void getinvoice(String id) async {
    emit(InvoiceLoading());
    try {
      final invoicedetails = await invoiceRepository.getinvoice(id);
      emit(InvoiceSuccess(invoicedetails));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
