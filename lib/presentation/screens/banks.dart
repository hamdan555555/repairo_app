import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/BankDataCubit/bank_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/data/repository/bank_data_repository.dart';
import 'package:breaking_project/data/web_services/bank_data_webservice.dart';
import 'package:breaking_project/presentation/screens/bank_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BanksScreen extends StatefulWidget {
  @override
  BanksScreenState createState() => BanksScreenState();
}

class BanksScreenState extends State<BanksScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AllbanksCubit>(context).getAllbanks();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // 🔥 RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Text(
            "البنوك المتاحة",
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: buildBlocWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllbanksCubit, AllbanksStates>(
      builder: (context, state) {
        if (state is AllbanksLoaded) {
          final allBanks = state.banks;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemCount: allBanks.length,
            itemBuilder: (ctx, index) => buildBankCard(allBanks[index]),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }
      },
    );
  }

  Widget buildBankCard(RBankData bank) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BlocProvider(
              create: (context) => BankDataCubit(
                BankDataRepository(bankDataWebservices: BankDataWebservices()),
              ),
              child: BankDataScreen(id: bank.id!),
            ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bank.image!
                      .replaceFirst("127.0.0.1", AppConstants.baseaddress),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_balance_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.name ?? "",
                      style: const TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "اسم الحساب: ${bank.accountName ?? "-"}",
                      style: const TextStyle(fontFamily: "Cairo", fontSize: 14),
                    ),
                    Text(
                      "رقم الحساب: ${bank.accountNumber ?? "-"}",
                      style: const TextStyle(fontFamily: "Cairo", fontSize: 14),
                    ),
                    Text(
                      "IBAN: ${bank.iban ?? "-"}",
                      style: const TextStyle(fontFamily: "Cairo", fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
