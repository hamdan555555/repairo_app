import 'package:breaking_project/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:breaking_project/business_logic/InvoiceCubit/invoice_states.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_cubit.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_states.dart';
import 'package:breaking_project/data/models/invoice_model.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDetailsPage extends StatefulWidget {
  final String id;

  const InvoiceDetailsPage({super.key, required this.id});

  @override
  State<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  @override
  void initState() {
    context.read<InvoiceCubit>().getinvoice(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الفاتورة"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:
          //const Center(child: Text("لا توجد بيانات لعرضها"))
          BlocBuilder<InvoiceCubit, InvoiceStates>(
        builder: (context, state) {
          if (state is InvoiceSuccess) {
            final invoicedetails = (state).invoiceData;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildInvoiceHeader(invoicedetails),
                  const SizedBox(height: 20),
                  _buildSectionTitle("الخدمات"),
                  ...?invoicedetails.services?.map(_buildServiceCard),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                        visible: invoicedetails.status != "paid",
                        child: Row(
                          children: [
                            Expanded(
                              child: BlocListener<PayInvoiceCubit,
                                  PayInvoiceStates>(
                                listener: (context, state) {
                                  if (state is PayInvoiceSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('تمت العملية بنجاح')),
                                    );
                                  } else if (state is PayInvoiceError) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("خطأ"),
                                        content: Text(state.message),
                                      ),
                                    );
                                  }
                                },
                                child: CustomElevatedButton(
                                    onpressed: () {
                                      context
                                          .read<PayInvoiceCubit>()
                                          .payinvoice(
                                              id: invoicedetails.id!,
                                              paymenttype: "cash");
                                    },
                                    text: "pay cash"),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomElevatedButton(
                                  onpressed: () {}, text: "pay by wallet"),
                            ),
                          ],
                        )),
                  ),
                  if ((invoicedetails.customServices?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle("خدمات مخصصة"),
                    ...invoicedetails.customServices!
                        .map(_buildCustomServiceCard),
                  ],
                ],
              ),
            );
          } else if (state is InvoiceLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(child: Text("Error Happenep"));
        },
      ),
    );
  }

  Widget _buildInvoiceHeader(InvoiceRData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("رقم الطلب:", data.serviceRequestId ?? "غير معروف"),
            _infoRow("تاريخ الإنشاء:", data.createdDate ?? "-"),
            _infoRow("تاريخ الدفع:", data.paymentDate ?? "-"),
            _infoRow("طريقة الدفع:", data.paymentType ?? "-"),
            _infoRow("الحالة:", data.status ?? "-"),
            _infoRow("المجموع:", "${data.totalAmount ?? 0} ل.س"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Services service) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.build),
        title: Text(service.name ?? "خدمة غير معروفة"),
        subtitle: Text("الكمية: ${service.quantity}, السعر: ${service.price}"),
      ),
    );
  }

  Widget _buildCustomServiceCard(CustomService service) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.design_services),
        title: Text(service.title ?? "خدمة مخصصة"),
        subtitle: Text("الكلفة: ${service.cost} ل.س"),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
