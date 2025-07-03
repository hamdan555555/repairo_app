import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/WalletTopupCubit/wallet_topup_cubit.dart';
import 'package:breaking_project/data/repository/bank_repository.dart';
import 'package:breaking_project/data/repository/wallet_topup_request_repository.dart';
import 'package:breaking_project/data/web_services/banks_webservices.dart';
import 'package:breaking_project/data/web_services/wallet_topup_request_webservice.dart';
import 'package:breaking_project/presentation/screens/fill_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 65, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 24, height: 24, child: Icon(Icons.arrow_back)
                      // SvgPicture.asset(AppImages.arrowback)

                      ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Wallet",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(71, 71, 71, 1)),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(Scanner());
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 130),
                        child: Container(
                            width: 24,
                            height: 24,
                            child: Icon(Icons.qr_code_scanner_outlined)
                            // SvgPicture.asset(AppImages.scanner)
                            ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Scan & Charge",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 21,
            ),
            // Wallet Balance Card
            Container(
              height: 239,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Balance",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("0\$",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 100),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => AllbanksCubit(
                                    BanksRepository(
                                        bankWebservices: BankWebservices())),
                              ),
                              BlocProvider(
                                create: (context) => WalletTopupCubit(
                                    WalletTopupRequestRepository(
                                        WalletTopupRequestWebservice())),
                              ),
                            ],
                            child: FillWallet(),
                          ));
                    },
                    child: Column(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Top Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Payment Methods Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildListItem(Icons.credit_card, "Payment Methods"),
                  _buildListItem(Icons.access_time, "Transactions"),
                  _buildListItem(Icons.savings, "Default Tips",
                      trailingText: "No Tip"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, {String? trailingText}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: trailingText != null
          ? Text(trailingText,
              style: TextStyle(color: Colors.grey, fontSize: 14))
          : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        print("kdfkjdfkjdkfjdkfjkdjfkdjfkjdfjkdjf");
      },
    );
  }
}
