abstract class PayInvoiceStates {}

class PayInvoiceInitial extends PayInvoiceStates {}

class PayInvoiceLoading extends PayInvoiceStates {}

class PayInvoiceSuccess extends PayInvoiceStates {}

class PayInvoiceError extends PayInvoiceStates {
  final String message;
  PayInvoiceError(this.message);
}
