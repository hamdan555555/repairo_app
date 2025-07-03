import 'dart:io';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_cubit.dart';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_states.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class FillWallet extends StatefulWidget {
  const FillWallet({super.key});

  @override
  State<FillWallet> createState() => _FillWalletState();
}

class _FillWalletState extends State<FillWallet> {
  final TextEditingController amountController = TextEditingController();
  RBankData? selectedBank;
  DateTime? selectedDateTime;

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

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  void initState() {
    BlocProvider.of<AllbanksCubit>(context).getAllbanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AllbanksCubit, AllbanksStates>(
          listener: (context, state) {
            if (state is AllbanksLoading) {
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
        BlocListener<WalletTopupCubit, WalletTopupStates>(
          listener: (context, state) {
            if (state is WalletTopupLoading) {
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
            } else if (state is WalletTopupSuccess) {
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
                      "Your request has been sent",
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
            if (state is WalletTopupError) {
              Get.snackbar(
                "Error charging wallet",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 84, left: 16, right: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                width: 24,
                                height: 24,
                                child: Icon(Icons.arrow_back_ios_new_outlined)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Charging Information",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(71, 71, 71, 1)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  //color: Colors.orange,
                                  width: 48,
                                  height: 32,
                                  child: Image.asset(
                                      'assets/images/png/baraka.png')),
                              SizedBox(
                                width: 16,
                              ),
                              Container(
                                  //color: Colors.amber,
                                  width: 48,
                                  height: 32,
                                  child: Image.asset(
                                      'assets/images/png/Bemo.png')),
                              SizedBox(
                                width: 16,
                              ),
                              Container(
                                  //color: Colors.amber,
                                  width: 48,
                                  height: 32,
                                  child: Image.asset(
                                      'assets/images/png/islamicsyrian.png')),
                            ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Bank Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(71, 71, 71, 1)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<AllbanksCubit, AllbanksStates>(
                        builder: (context, state) {
                          if (state is AllbanksLoaded) {
                            return DropdownButtonFormField<RBankData>(
                              value: selectedBank,
                              items: context
                                  .read<AllbanksCubit>()
                                  .banks
                                  .map(
                                    (bank) => DropdownMenuItem<RBankData>(
                                      value: bank,
                                      child: Text(
                                        bank.name ?? 'choose bank',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBank = value!;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'choose bank',
                                hintStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
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
                              hintStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
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

                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Amount",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(71, 71, 71, 1)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        cursorColor: Colors.blue,
                        keyboardAppearance: Brightness.light,
                        decoration: InputDecoration(
                          hintText: 'enter amount',
                          hintStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),

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
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Upload Bill Image",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(71, 71, 71, 1)),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: pickImages,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.add_a_photo,
                                  color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if (selectedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(selectedImage!,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           child: Text(
                      //         "Empiry date",
                      //         style: TextStyle(fontSize: 16),
                      //       )),
                      //       SizedBox(
                      //         width: 16,
                      //       ),
                      //       Expanded(
                      //           child: Text(
                      //         "security date",
                      //         style: TextStyle(fontSize: 16),
                      //       )),
                      //     ],
                      //   ),
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextFormField(
                      //         // validator: (val){
                      //         //   return validInput(
                      //         //       val!, 5, 50, 'date');
                      //         // },
                      //         // controller: controller.empirydate,
                      //         showCursor: false,

                      //         textAlign: TextAlign.center,

                      //         cursorColor: Colors.blue,
                      //         //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      //         keyboardAppearance: Brightness.light,
                      //         decoration: InputDecoration(
                      //           hintText: 'MM/YY',
                      //           hintStyle: TextStyle(
                      //               fontSize: 12, fontWeight: FontWeight.w400),

                      //           //suffixText: '°C',
                      //           focusedBorder: OutlineInputBorder(
                      //             borderSide: const BorderSide(color: Colors.blue),
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           filled: true,
                      //           fillColor: Color.fromRGBO(243, 243, 243, 1),
                      //         ),
                      //         onChanged: (value) {},
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Expanded(
                      //       child: TextFormField(
                      //         // validator: (val){
                      //         //   return validInput(
                      //         //       val!, 5, 50, 'date');
                      //         // },
                      //         // controller: controller.securitydate,
                      //         showCursor: false,
                      //         textAlign: TextAlign.center,

                      //         cursorColor: Colors.blue,
                      //         //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      //         keyboardAppearance: Brightness.light,
                      //         decoration: InputDecoration(
                      //           hintText: 'cvv',
                      //           hintStyle: TextStyle(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w400,
                      //           ),

                      //           //suffixText: '°C',
                      //           focusedBorder: OutlineInputBorder(
                      //             borderSide: const BorderSide(color: Colors.blue),
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(16),
                      //           ),
                      //           filled: true,
                      //           fillColor: Color.fromRGBO(243, 243, 243, 1),
                      //         ),
                      //         onChanged: (value) {},
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Text(
                      //   "Zip/Postal Code",
                      //   style: TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w400,
                      //       color: Color.fromRGBO(71, 71, 71, 1)),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // TextFormField(
                      //   keyboardType: TextInputType.number,
                      //   // validator: (val){
                      //   //   return validInput(
                      //   //       val!, 4, 4, 'zip');
                      //   // },
                      //   // controller: controller.zipcode,
                      //   cursorColor: Colors.blue,
                      //   //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      //   keyboardAppearance: Brightness.light,
                      //   decoration: InputDecoration(
                      //     hintText: 'xxxx',
                      //     hintStyle:
                      //         TextStyle(fontSize: 20, fontWeight: FontWeight.w400),

                      //     //suffixText: '°C',
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: const BorderSide(color: Colors.blue),
                      //       borderRadius: BorderRadius.circular(16),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(16),
                      //     ),
                      //     filled: true,
                      //     fillColor: Color.fromRGBO(243, 243, 243, 1),
                      //   ),
                      //   onChanged: (value) {},
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () async {
                            final now = DateTime.now();
                            final formattedDate =
                                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                            context.read<WalletTopupCubit>().topuprequest(
                                bankid: selectedBank!.id!,
                                amount: amountController.text,
                                images: selectedImage!,
                                date: formattedDate);
                            // if (formData!.validate()) {
                            //  if(ccontroller.lastprice<=sccontroller.bbalance){
                            //    sccontroller.bbalance=sccontroller.bbalance-ccontroller.lastprice;
                            //    controller.createnow(context);
                            //  }
                            //  else{

                            //    Get.defaultDialog(
                            //      title: "Payment Failed",
                            //      middleText: "Balance is not enough",
                            //      backgroundColor: Colors.white,
                            //      titleStyle: const TextStyle(
                            //          color: Colors.redAccent, fontWeight: FontWeight.bold),
                            //      middleTextStyle: TextStyle(color: Colors.black),
                            //      confirm:

                            //      Padding(
                            //        padding: const EdgeInsets.only(left:  63,right: 63,bottom: 12),
                            //        child: MainButton(text: 'ok', onPressed:(){

                            //          Get.back();
                            //        }),
                            //      ),

                            //      barrierDismissible: false,
                            //    );
                            //  }
                            // }else{

                            //   Get.defaultDialog(
                            //     title: "Payment Failed",
                            //     middleText: "Enter Correct Informations",
                            //     backgroundColor: Colors.white,
                            //     titleStyle: const TextStyle(
                            //         color: Colors.redAccent, fontWeight: FontWeight.bold),
                            //     middleTextStyle: TextStyle(color: Colors.black),
                            //     confirm:

                            //     Padding(
                            //       padding: const EdgeInsets.only(left:  63,right: 63,bottom: 12),
                            //       child: MainButton(text: 'ok', onPressed:(){

                            //         Get.back();
                            //       }),
                            //     ),

                            //     barrierDismissible: false,
                            //   );

                            // }
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
