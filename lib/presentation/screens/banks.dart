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
import 'package:get/get_core/src/get_main.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Available Banks", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: buildBlocWidget()),
        ],
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllbanksCubit, AllbanksStates>(
      builder: (context, state) {
        if (state is AllbanksLoaded) {
          final allBanks = state.banks;
          // // فلترة حسب الاسم
          // final filteredbanks = allBanks.where((bank) {
          //   final name = bank.name?.toLowerCase() ?? '';
          //   return name.contains(searchKeyword);
          // }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: allBanks.length,
            itemBuilder: (ctx, index) => buildTechCard(allBanks[index]),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple));
        }
      },
    );
  }

  Widget buildTechCard(RBankData bank) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BlocProvider(
              create: (context) => BankDataCubit(BankDataRepository(
                  bankDataWebservices: BankDataWebservices())),
              child: BankDataScreen(id: bank.id!),
            ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.name!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("اسم الحساب: ${bank.accountName}"),
                    Text("رقم الحساب: ${bank.accountNumber}"),
                    Text("IBAN: ${bank.iban}"),
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
