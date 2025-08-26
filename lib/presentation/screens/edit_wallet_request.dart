import 'dart:io';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/WalletRequestEditCubit/wallet_request_edit_cubit.dart';
import 'package:breaking_project/business_logic/WalletRequestEditCubit/wallet_request_edit_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditWalletRequestScreen extends StatefulWidget {
  final RWalletRequestsData request;

  const EditWalletRequestScreen({super.key, required this.request});

  @override
  State<EditWalletRequestScreen> createState() =>
      _EditWalletRequestScreenState();
}

class _EditWalletRequestScreenState extends State<EditWalletRequestScreen> {
  late TextEditingController _amountController;
  RBankData? selelectedbank;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImages() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AllbanksCubit>(context).getAllbanks();
    _amountController = TextEditingController(text: widget.request.amount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تعديل طلب التعبئة',
            style: TextStyle(fontFamily: "Cairo"),
          ),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AllbanksCubit, AllbanksStates>(
              listener: (context, state) {
                if (state is AllbanksLoading) {
                  Get.defaultDialog(
                    title: "جاري التحميل...",
                    titleStyle: const TextStyle(fontFamily: "Cairo"),
                    content: const Column(
                      children: [
                        CircularProgressIndicator(color: Colors.teal),
                        SizedBox(height: 10),
                        Text("الرجاء الانتظار.",
                            style: TextStyle(fontFamily: "Cairo")),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                } else {
                  if (Get.isDialogOpen!) Get.back();
                }
              },
            ),
            BlocListener<WalletRequestEditCubit, WalletTopupEditStates>(
              listener: (context, state) {
                if (state is WalletTopupEditLoading) {
                  Get.defaultDialog(
                    title: "جاري حفظ التعديلات...",
                    titleStyle: const TextStyle(fontFamily: "Cairo"),
                    content: const Column(
                      children: [
                        CircularProgressIndicator(color: Colors.teal),
                        SizedBox(height: 10),
                        Text("الرجاء الانتظار.",
                            style: TextStyle(fontFamily: "Cairo")),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                } else if (state is WalletTopupEditSuccess) {
                  if (Get.isDialogOpen!) Get.back();
                  Get.snackbar(
                    "تم بنجاح",
                    "تم تعديل الطلب بنجاح",
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                  );
                  Get.offAllNamed("mainscreen");
                } else if (state is WalletTopupEditError) {
                  if (Get.isDialogOpen!) Get.back();
                  Get.snackbar(
                    "خطأ",
                    state.message,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اختيار البنك
                BlocBuilder<AllbanksCubit, AllbanksStates>(
                  builder: (context, state) {
                    if (state is AllbanksLoaded) {
                      return DropdownButtonFormField<RBankData>(
                        value: selelectedbank,
                        items: context.read<AllbanksCubit>().banks.map(
                          (bank) {
                            return DropdownMenuItem<RBankData>(
                              value: bank,
                              child: Text(bank.name ?? '',
                                  style: const TextStyle(fontFamily: "Cairo")),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selelectedbank = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color:
                                  Colors.teal, // اللون لما يكون الحقل مش فوكس
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.teal, // اللون لما يصير فوكس
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),

                          labelText: "${widget.request.bank!.name}",
                          labelStyle: const TextStyle(fontFamily: "Cairo"),
                          // border: OutlineInputBorder(

                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.teal));
                  },
                ),

                const SizedBox(height: 20),

                // حقل المبلغ
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal, // اللون لما يكون الحقل مش فوكس
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal, // اللون لما يصير فوكس
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                    ),
                    labelText: "مبلغ التعبئة",
                    labelStyle: const TextStyle(fontFamily: "Cairo"),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),

                const SizedBox(height: 20),

                // صورة الإيصال
                Text("تحديث صورة الإيصال",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo")),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, color: Colors.teal),
                        SizedBox(width: 8),
                        Text("اختر صورة",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (selectedImage != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover),
                    ),
                  )
                else if (widget.request.image != null &&
                    widget.request.image!.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.request.image!.replaceFirst(
                            '127.0.0.1', AppConstants.baseaddress),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // زر الحفظ
                Center(
                  child: CustomElevatedButton(
                    onpressed: () {
                      final now = DateTime.now();
                      final formattedDate =
                          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                      context.read<WalletRequestEditCubit>().topuprequestedit(
                            walletreqId: widget.request.id!,
                            bankid:
                                selelectedbank?.id ?? widget.request.bank!.id!,
                            amount: _amountController.text,
                            date: formattedDate,
                            images: selectedImage,
                          );
                    },
                    text: "حفظ التعديلات",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
