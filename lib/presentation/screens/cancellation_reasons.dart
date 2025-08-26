import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_cubit.dart';
import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_states.dart';
import 'package:flutter/material.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CancelOrderScreen extends StatefulWidget {
  final String? id;
  final String? request_status;

  const CancelOrderScreen({Key? key, this.id, this.request_status})
      : super(key: key);

  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  final TextEditingController _customReasonController = TextEditingController();
  bool _showCustomReasonField = false;

  final List<String> _cancellationReasons = [
    'أجرب التطبيق فقط',
    'غيّرت رأيي',
    'لم يتم الاتفاق مع المهني',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  void _selectReason(String reason) {
    setState(() {
      _selectedReason = reason;
      _showCustomReasonField = reason == 'سبب آخر';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<CancelOrderCubit, CancelOrderStates>(
          listener: (context, state) {
            if (state is CancelOrderLoading) {
              Get.defaultDialog(
                title: "جاري المعالجة...",
                titleStyle: const TextStyle(fontFamily: "Cairo"),
                content: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text(
                      "الرجاء الانتظار",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            } else if (state is CancelOrderSuccess) {
              Get.back();
              Get.defaultDialog(
                title: '',
                titlePadding: EdgeInsets.zero,
                content: Column(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: widget.request_status == "pending"
                          ? SvgPicture.asset("assets/images/svg/checkc.svg")
                          : Image.asset("assets/images/png/warning.png"),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.request_status == "pending"
                          ? "تم إلغاء طلبك بنجاح ✅"
                          : "تم إرسال طلب الإلغاء\n سيتم التواصل معك قريبا",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                confirm: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  child: CustomElevatedButton(
                    text: 'موافق',
                    onpressed: () {
                      Get.toNamed("mainscreen");
                    },
                  ),
                ),
                barrierDismissible: false,
              );
            } else {
              if (Get.isDialogOpen!) Get.back();
            }

            if (state is CancelOrderError) {
              Get.snackbar("خطأ", state.message,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'اختر سبب الإلغاء',
                  style: TextStyle(
                    fontFamily: "Cairo",
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                ..._cancellationReasons.map((reason) => _buildReasonButton(
                      reason,
                      icon: Icons.info_outline,
                    )),
                _buildReasonButton('سبب آخر', icon: Icons.edit_note),
                if (_showCustomReasonField)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      style: TextStyle(fontFamily: "Cairo"),
                      controller: _customReasonController,
                      decoration: InputDecoration(
                        hintText: 'أدخل السبب هنا...',
                        hintStyle: const TextStyle(fontFamily: "Cairo"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (text) {
                        _selectedReason = _customReasonController.text;
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onpressed: _selectedReason != null
                      ? () {
                          String finalReason = _selectedReason!;
                          if (_selectedReason == 'سبب آخر') {
                            finalReason =
                                _customReasonController.text.trim().isEmpty
                                    ? 'سبب آخر (لم يتم إدخال نص)'
                                    : _customReasonController.text.trim();
                          }
                          context
                              .read<CancelOrderCubit>()
                              .cancelorder(id: widget.id!, reason: finalReason);
                        }
                      : null,
                  text: 'تأكيد الإلغاء',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonButton(String reason, {IconData? icon}) {
    bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () => _selectReason(reason),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon,
                  size: 20, color: isSelected ? Colors.teal : Colors.grey),
            const SizedBox(width: 8),
            Text(
              reason,
              style: TextStyle(
                fontFamily: "Cairo",
                color: isSelected ? Colors.teal : Colors.black87,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
