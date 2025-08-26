abstract class PayInvoiceStates {}

class PayInvoiceInitial extends PayInvoiceStates {}

class PayInvoiceLoading extends PayInvoiceStates {}

class PayInvoiceSuccess extends PayInvoiceStates {
  final String message;
  PayInvoiceSuccess(this.message);
}

class PayInvoiceError extends PayInvoiceStates {
  final String message;
  PayInvoiceError(this.message);
}

class PayInvoiceInsufficientBalance extends PayInvoiceStates {}
