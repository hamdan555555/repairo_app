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
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Request Edit'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AllbanksCubit, AllbanksStates>(
            listener: (context, state) {
              if (state is AllbanksLoading) {
                Get.defaultDialog(
                  title: "...جاري التحميل ",
                  titleStyle: TextStyle(fontFamily: "Cairo"),
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
              } else {
                if (Get.isDialogOpen!) {
                  Get.back();
                }
              }
              if (state is AllbanksFailed) {
                Get.snackbar(
                  "Error",
                  state.message,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
          ),
          BlocListener<WalletRequestEditCubit, WalletTopupEditStates>(
            listener: (context, state) {
              if (state is WalletTopupEditLoading) {
                Get.defaultDialog(
                  title: "...جاري التحميل ",
                  titleStyle: TextStyle(fontFamily: "Cairo"),
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
              } else if (state is WalletTopupEditSuccess) {
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
                          child:
                              SvgPicture.asset("assets/images/svg/checkc.svg")),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Request has been updated",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(71, 71, 71, 1)),
                      ),
                    ],
                  ),
                  middleText: "Enter Correct Informations",
                  backgroundColor: Colors.white,
                  middleTextStyle: TextStyle(color: Colors.black),
                  confirm: Padding(
                    padding:
                        const EdgeInsets.only(left: 63, right: 63, bottom: 12),
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
              if (state is WalletTopupEditError) {
                Get.snackbar(
                  "Error has happened",
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
              BlocBuilder<AllbanksCubit, AllbanksStates>(
                builder: (context, state) {
                  if (state is AllbanksLoaded) {
                    return DropdownButtonFormField<RBankData>(
                      value: selelectedbank,
                      items: context
                          .read<AllbanksCubit>()
                          .banks
                          .map(
                            (bank) => DropdownMenuItem<RBankData>(
                              value: bank,
                              child: Text(
                                bank.name ?? widget.request.bank!.name!,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selelectedbank = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.request.bank!.name!,
                        hintStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(243, 243, 243, 1),
                      ),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    hint: Text("choose bank"),
                    value: 'choose bank',
                    items: [
                      DropdownMenuItem<String>(
                        value: 'choose bank',
                        child: Text('choose bank'),
                      ),
                    ],
                    onChanged: (val) {},
                    decoration: InputDecoration(
                      hintText: 'choose bank',
                      hintStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(243, 243, 243, 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                cursorColor: Colors.blue,
                keyboardAppearance: Brightness.light,
                decoration: InputDecoration(
                  hintText: 'enter amount',
                  hintStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

                  //suffixText: '°C',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(243, 243, 243, 1),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              Text(
                "update image ..",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add_a_photo, color: Colors.black54),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //if (selectedImage != null)
              selectedImage != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(selectedImage!,
                            width: 100, height: 100, fit: BoxFit.cover),
                      ),
                    )
                  : Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            widget.request.image!.replaceFirst(
                                '127.0.0.1', AppConstants.baseaddress),
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          )),
                    ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CustomElevatedButton(
                    onpressed: () {
                      // if (selectedImage != null) {
                      //   imagetopass = selectedImage!;
                      // }
                      final now = DateTime.now();
                      final formattedDate =
                          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                      selectedImage != null
                          ? context
                              .read<WalletRequestEditCubit>()
                              .topuprequestedit(
                                  walletreqId: widget.request.id!,
                                  bankid: selelectedbank != null
                                      ? selelectedbank!.id!
                                      : widget.request.bank!.id!,
                                  amount: _amountController.text,
                                  images: selectedImage!,
                                  date: formattedDate)
                          : context
                              .read<WalletRequestEditCubit>()
                              .topuprequestedit(
                                  walletreqId: widget.request.id!,
                                  bankid: selelectedbank != null
                                      ? selelectedbank!.id!
                                      : widget.request.bank!.id!,
                                  amount: _amountController.text,
                                  date: formattedDate);
                    },
                    text: "save changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
