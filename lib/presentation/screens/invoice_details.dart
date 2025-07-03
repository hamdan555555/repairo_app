import 'package:breaking_project/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:breaking_project/business_logic/InvoiceCubit/invoice_states.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_cubit.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_states.dart';
import 'package:breaking_project/data/models/invoice_model.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return BlocListener<PayInvoiceCubit, PayInvoiceStates>(
      listener: (context, state) {
        if (state is PayInvoiceLoading) {
          Get.defaultDialog(
            title: "Loading...",
            content: const Column(
              children: [
                CircularProgressIndicator(color: Colors.blueAccent),
                SizedBox(height: 10),
                Text("Please wait..."),
              ],
            ),
            barrierDismissible: false,
          );
        } else if (state is PayInvoiceSuccess) {
          Get.back();
          Get.defaultDialog(
            title: '',
            titlePadding:
                EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
            content: Column(
              children: [
                Container(
                    width: 32,
                    height: 32,
                    child: SvgPicture.asset("assets/images/svg/checkc.svg")),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Your invoice payment done",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(71, 71, 71, 1)),
                ),
              ],
            ),
            middleText: "Error Happened!",
            backgroundColor: Colors.white,
            middleTextStyle: TextStyle(color: Colors.black),
            confirm: Padding(
              padding: const EdgeInsets.only(left: 63, right: 63, bottom: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomElevatedButton(
                    text: 'ok',
                    onpressed: () {
                      Get.toNamed("mainscreen");
                    }),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          if (Get.isDialogOpen!) {
            Get.back();
          }
        }

        if (state is PayInvoiceError) {
          Get.snackbar("Error", state.message,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
      child: Scaffold(
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
                    if ((invoicedetails.customServices?.isNotEmpty ??
                        false)) ...[
                      const SizedBox(height: 20),
                      _buildSectionTitle("خدمات مخصصة"),
                      ...invoicedetails.customServices!
                          .map(_buildCustomServiceCard),
                    ],
                    BlocBuilder<InvoiceCubit, InvoiceStates>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                              visible: invoicedetails.status != "paid",
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                        onpressed: () {
                                          context
                                              .read<PayInvoiceCubit>()
                                              .payinvoice(
                                                  id: invoicedetails
                                                      .serviceRequestId!,
                                                  paymenttype: "cash");
                                        },
                                        text: "pay cash"),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: CustomElevatedButton(
                                        onpressed: () {},
                                        text: "pay by wallet"),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is InvoiceLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(child: Text("Error Happenep"));
          },
        ),
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
        title: Text(service.name ?? "خدمة مخصصة"),
        subtitle: Text("الكلفة: ${service.price} ل.س"),
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
