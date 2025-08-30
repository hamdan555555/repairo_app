import 'package:breaking_project/business_logic/BankDataCubit/bank_data_cubit.dart';
import 'package:breaking_project/business_logic/BankDataCubit/bank_data_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/bank_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BankDataScreen extends StatefulWidget {
  final String id;
  BankDataScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<BankDataScreen> createState() => BankDataScreenStatee();
}

class BankDataScreenStatee extends State<BankDataScreen> {
  late BankDRData bank;

  @override
  void initState() {
    BlocProvider.of<BankDataCubit>(context).getBankData(widget.id);
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 RTL
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: const Text(
            "تفاصيل البنك",
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: buildBlocWidget(),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BankDataCubit, BankDataStates>(
      builder: (context, state) {
        if (state is BankDataLoaded) {
          bank = state.BankDdata;
          return buildBankCard();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget buildBankCard() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة البنك
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bank.image!
                      .replaceFirst("127.0.0.1", AppConstants.baseaddress),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_balance_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // تفاصيل البنك
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.name ?? "",
                      style: const TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                        Icons.person, "اسم الحساب:", bank.accountName ?? "-"),
                    _infoRow(Icons.confirmation_number, "رقم الحساب:",
                        bank.accountNumber ?? "-"),
                    _infoRow(Icons.credit_card, "IBAN:", bank.iban ?? "-"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 18),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Cairo",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.teal),
    );
  }
}
