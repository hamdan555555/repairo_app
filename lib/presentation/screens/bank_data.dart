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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
          title: Text("Bank Data"),
        ),
        body: Expanded(child: buildBlocWidget()));
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BankDataCubit, BankDataStates>(
        builder: (context, state) {
      if (state is BankDataLoaded) {
        bank = (state).BankDdata;
        return buildLoadedListWidget();
      } else {
        return showloadingindicator();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return builditemsList();
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: const Color.fromRGBO(95, 96, 185, 1),
    ));
  }

  Widget builditemsList() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
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
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.account_balance_outlined,
                      size: 60,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),

              // معلومات البنك
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.name!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow("اسم الحساب:", bank.accountName!),
                    _infoRow("رقم الحساب:", bank.accountNumber!),
                    _infoRow("IBAN:", bank.iban!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
