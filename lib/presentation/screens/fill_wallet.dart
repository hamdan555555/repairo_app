import 'dart:io';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_cubit.dart';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_states.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FillWallet extends StatefulWidget {
  const FillWallet({super.key});

  @override
  State<FillWallet> createState() => _FillWalletState();
}

class _FillWalletState extends State<FillWallet> {
  final TextEditingController amountController = TextEditingController();
  RBankData? selectedBank;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImages() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    BlocProvider.of<AllbanksCubit>(context).getAllbanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL
      child: MultiBlocListener(
        listeners: [
          BlocListener<AllbanksCubit, AllbanksStates>(
            listener: (context, state) {
              if (state is AllbanksLoading) {
                _showLoadingDialog("...جاري تحميل البنوك");
              } else {
                if (Get.isDialogOpen!) Get.back();
              }
              if (state is AllbanksFailed) {
                Get.snackbar("خطأ", state.message,
                    backgroundColor: Colors.redAccent, colorText: Colors.white);
              }
            },
          ),
          BlocListener<WalletTopupCubit, WalletTopupStates>(
            listener: (context, state) {
              if (state is WalletTopupLoading) {
                _showLoadingDialog("...جاري إرسال الطلب");
              } else if (state is WalletTopupSuccess) {
                if (Get.isDialogOpen!) Get.back();
                _showSuccessDialog();
              } else {
                if (Get.isDialogOpen!) Get.back();
              }
              if (state is WalletTopupError) {
                Get.snackbar("فشل شحن المحفظة", state.message,
                    backgroundColor: Colors.redAccent, colorText: Colors.white);
              }
            },
          ),
        ],
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "معلومات الشحن",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // شعار البنوك
                  Row(
                    children: [
                      Image.asset('assets/images/png/baraka.png',
                          width: 50, height: 32),
                      const SizedBox(width: 16),
                      Image.asset('assets/images/png/Bemo.png',
                          width: 50, height: 32),
                      const SizedBox(width: 16),
                      Image.asset('assets/images/png/islamicsyrian.png',
                          width: 50, height: 32),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // اختيار البنك
                  const Text(
                    "اختر البنك",
                    style: TextStyle(
                        fontFamily: "Cairo", fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<AllbanksCubit, AllbanksStates>(
                    builder: (context, state) {
                      if (state is AllbanksLoaded) {
                        return DropdownButtonFormField<RBankData>(
                          value: selectedBank,
                          items: state.banks
                              .map((bank) => DropdownMenuItem<RBankData>(
                                    value: bank,
                                    child: Text(bank.name ?? 'اختر البنك',
                                        style: const TextStyle(
                                            fontFamily: "Cairo")),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedBank = value),
                          decoration: _inputDecoration("اختر البنك"),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        hint: const Text("اختر البنك",
                            style: TextStyle(fontFamily: "Cairo")),
                        items: const [
                          DropdownMenuItem(
                            value: 'اختر البنك',
                            child: Text('اختر البنك'),
                          ),
                        ],
                        onChanged: (_) {},
                        decoration: _inputDecoration("اختر البنك"),
                      );
                    },
                  ),
                  const SizedBox(height: 25),

                  // المبلغ
                  const Text(
                    "المبلغ",
                    style: TextStyle(
                        fontFamily: "Cairo", fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("ادخل المبلغ"),
                  ),
                  const SizedBox(height: 25),

                  // صورة الفاتورة
                  const Text(
                    "رفع صورة الوصل",
                    style: TextStyle(
                        fontFamily: "Cairo", fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.add_a_photo, color: Colors.teal),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // if (selectedImage != null)
                      //   ClipRRect(
                      //     borderRadius: BorderRadius.circular(8),
                      //     child: Image.file(
                      //       selectedImage!,
                      //       width: 100,
                      //       height: 100,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (selectedImage != null)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.file(
                          selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20.h,
                  ),

                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        final now = DateTime.now();
                        final formattedDate =
                            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                        if (selectedBank != null &&
                            selectedImage != null &&
                            amountController.text.isNotEmpty) {
                          context.read<WalletTopupCubit>().topuprequest(
                              bankid: selectedBank!.id!,
                              amount: amountController.text,
                              images: selectedImage!,
                              date: formattedDate);
                        } else {
                          Get.snackbar("خطأ", "يرجى إدخال جميع الحقول",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white);
                        }
                      },
                      child: const Text(
                        "شحن",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: "Cairo", fontSize: 14),
      filled: true,
      fillColor: const Color.fromRGBO(243, 243, 243, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.teal),
      ),
    );
  }

  void _showLoadingDialog(String msg) {
    Get.defaultDialog(
      title: msg,
      titleStyle: const TextStyle(fontFamily: "Cairo"),
      content: const Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(color: Colors.teal),
      ),
      barrierDismissible: false,
    );
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: '',
      content: Column(
        children: [
          SvgPicture.asset("assets/images/svg/checkc.svg", width: 40),
          const SizedBox(height: 10),
          const Text(
            "تم إرسال طلبك بنجاح",
            style: TextStyle(
                fontFamily: "Cairo", fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      confirm: CustomElevatedButton(
        text: "موافق",
        onpressed: () => Get.toNamed("mainscreen"),
      ),
      barrierDismissible: false,
    );
  }
}
