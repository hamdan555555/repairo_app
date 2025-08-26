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
    return Directionality(
      // خلي كل الصفحة RTL
      textDirection: TextDirection.rtl,
      child: BlocListener<PayInvoiceCubit, PayInvoiceStates>(
        listener: (context, state) {
          if (state is PayInvoiceLoading) {
            Get.defaultDialog(
              title: "...جاري التحميل ",
              titleStyle: const TextStyle(fontFamily: "Cairo"),
              content: const Column(
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 10),
                  Text(
                    "الرجاء الانتظار.",
                    style: TextStyle(fontFamily: "Cairo"),
                  ),
                ],
              ),
              barrierDismissible: false,
            );
          } else if (state is PayInvoiceSuccess) {
            Get.back();
            Get.defaultDialog(
              title: '',
              titlePadding: const EdgeInsets.all(0),
              content: Column(
                children: [
                  SizedBox(
                      width: 48,
                      height: 48,
                      child: SvgPicture.asset((state).message == "فشل الدفع"
                          ? "assets/images/png/warning.png"
                          : "assets/images/svg/checkc.svg")),
                  const SizedBox(height: 10),
                  Text(
                    (state).message,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ],
              ),
              confirm: Padding(
                padding: const EdgeInsets.only(left: 63, right: 63, bottom: 12),
                child: CustomElevatedButton(
                    text: 'رجوع للرئيسية',
                    onpressed: () {
                      Get.toNamed("mainscreen");
                    }),
              ),
              barrierDismissible: false,
            );
          } else {
            if (Get.isDialogOpen!) {
              Get.back();
            }
          }

          if (state is PayInvoiceError) {
            Get.snackbar(
              "خطأ",
              state.message,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              titleText: const Text(
                "خطأ",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo"),
              ),
              messageText: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: "Cairo",
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("تفاصيل الفاتورة",
                style: TextStyle(fontFamily: "Cairo")),
            centerTitle: true,
            backgroundColor: Colors.teal,
            elevation: 2,
          ),
          body: BlocBuilder<InvoiceCubit, InvoiceStates>(
            builder: (context, state) {
              if (state is InvoiceSuccess) {
                final invoicedetails = state.invoiceData;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildInvoiceHeader(invoicedetails),
                    const SizedBox(height: 20),
                    _buildSectionTitle("الخدمات"),
                    const SizedBox(height: 8),
                    ...?invoicedetails.services?.map(_buildServiceCard),
                    if ((invoicedetails.customServices?.isNotEmpty ??
                        false)) ...[
                      const SizedBox(height: 20),
                      _buildSectionTitle("خدمات مخصصة"),
                      const SizedBox(height: 8),
                      ...invoicedetails.customServices!
                          .map(_buildCustomServiceCard),
                    ],
                    const SizedBox(height: 30),
                    if (invoicedetails.status != "paid") ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onpressed: () {
                                context.read<PayInvoiceCubit>().payinvoice(
                                    id: invoicedetails.serviceRequestId!,
                                    paymenttype: "cash");
                              },
                              text: "ادفع كاش",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomElevatedButton(
                              onpressed: () {
                                context.read<PayInvoiceCubit>().payinvoice(
                                    id: invoicedetails.serviceRequestId!,
                                    paymenttype: "wallet");
                              },
                              text: "ادفع من المحفظة",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              } else if (state is InvoiceLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              }
              return const Center(
                  child: Text("حدث خطأ أثناء جلب بيانات الفاتورة",
                      style: TextStyle(fontFamily: "Cairo")));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader(InvoiceRData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.teal.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("رقم الطلب:", data.serviceRequestId ?? "غير معروف"),
            _infoRow("تاريخ الإنشاء:", data.createdDate ?? "-"),
            _infoRow("تاريخ الدفع:", data.paymentDate ?? "-"),
            _infoRow(
                "طريقة الدفع:",
                data.paymentType == "cash"
                    ? "نقداً"
                    : data.paymentType == "wallet"
                        ? "محفظة"
                        : "_"),
            _infoRow(
                "الحالة:",
                data.status == "paid"
                    ? "مدفوعة"
                    : data.status == "pending"
                        ? "غير مدفوعة"
                        : "_"),
            _infoRow("المجموع:", "${data.totalAmount ?? 0} ل.س"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14, fontFamily: "Cairo"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Services service) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.build, color: Colors.teal),
        title: Text(service.name ?? "خدمة غير معروفة",
            style: const TextStyle(
                fontFamily: "Cairo", fontWeight: FontWeight.w500)),
        subtitle: Text(
            "الكمية: ${service.quantity}, السعر: ${service.price} ل.س",
            style: const TextStyle(fontFamily: "Cairo")),
      ),
    );
  }

  Widget _buildCustomServiceCard(CustomService service) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.design_services, color: Colors.teal),
        title: Text(service.name ?? "خدمة مخصصة",
            style: const TextStyle(
                fontFamily: "Cairo", fontWeight: FontWeight.w500)),
        subtitle: Text("الكلفة: ${service.price} ل.س",
            style: const TextStyle(fontFamily: "Cairo")),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: "Cairo",
        color: Colors.teal,
      ),
    );
  }
}
