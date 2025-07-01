import 'package:breaking_project/data/models/invoice_model.dart';
import 'package:breaking_project/data/web_services/invoice_web_services.dart';

class InvoiceRepository {
  final InvoiceWebServices invoiceWebServices;

  InvoiceRepository(this.invoiceWebServices);

  Future<InvoiceRData> getinvoice(String id) async {
    final data = await invoiceWebServices.getinvoice(id);
    return InvoiceRData.fromJson(data);
  }
}
