import 'package:breaking_project/data/web_services/pay_invoice_webservices.dart';

class PayInvoiceRepository {
  final PayInvoiceWebservices payInvoiceWebservices;

  PayInvoiceRepository(this.payInvoiceWebservices);

  Future<Map<String, dynamic>> payinvoice({
    required String id,
    required String paymenttype,
  }) async {
    final data = await payInvoiceWebservices.payinvoice(
      id: id,
      paymenttype: paymenttype,
    );
    print(data);
    return data; // ✅ رجّع الريسبونس للـ Cubit
  }
}
