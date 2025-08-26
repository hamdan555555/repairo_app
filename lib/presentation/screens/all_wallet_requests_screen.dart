import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/AllWalletRequestsCubit/all_wallet_requests_cubit.dart';
import 'package:breaking_project/business_logic/AllWalletRequestsCubit/all_wallet_requests_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/presentation/screens/walet_request_details.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllWalletRequestsScreen extends StatefulWidget {
  @override
  AllwalletRequestsScreenState createState() => AllwalletRequestsScreenState();
}

class AllwalletRequestsScreenState extends State<AllWalletRequestsScreen> {
  RBankData? selelectedbank;
  String? selectedstatus;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AllbanksCubit>(context).getAllbanks();
    BlocProvider.of<AllWalletRequestsCubit>(context).getallwalletrequests();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Text(
            "طلبات المحفظة",
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            buildFilterOptions(),
            Expanded(child: buildBlocWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BlocBuilder<AllbanksCubit, AllbanksStates>(
                  builder: (context, state) {
                    if (state is AllbanksLoaded) {
                      return DropdownButton<RBankData?>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: selelectedbank,
                        hint: const Text("كل البنوك",
                            style: TextStyle(fontFamily: "Cairo")),
                        items: [
                          const DropdownMenuItem<RBankData?>(
                            value: null,
                            child: Text("كل البنوك",
                                style: TextStyle(fontFamily: "Cairo")),
                          ),
                          ...state.banks.map((bank) => DropdownMenuItem(
                                value: bank,
                                child: Text(bank.name ?? 'غير معروف',
                                    style:
                                        const TextStyle(fontFamily: "Cairo")),
                              )),
                        ],
                        onChanged: (RBankData? value) {
                          setState(() => selelectedbank = value);
                          context
                              .read<AllWalletRequestsCubit>()
                              .getallwalletrequests(
                                bankId: selelectedbank?.id,
                                status: selectedstatus,
                              );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text("الحالة",
                      style: TextStyle(fontFamily: "Cairo")),
                  value: selectedstatus,
                  items: [null, 'pending', 'accepted', 'rejected']
                      .map((statuee) => DropdownMenuItem(
                            value: statuee,
                            child: Text(
                              statuee == null
                                  ? "كل الطلبات"
                                  : _getStatusArabic(statuee),
                              style: const TextStyle(fontFamily: "Cairo"),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedstatus = value);
                    BlocProvider.of<AllWalletRequestsCubit>(context)
                        .getallwalletrequests(
                      bankId: selelectedbank?.id,
                      status: selectedstatus,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllWalletRequestsCubit, AllWalletRequestsStates>(
      builder: (context, state) {
        if (state is AllWalletRequestsLoaded) {
          final allrequests = state.walletrequests;

          if (allrequests.isEmpty) {
            return const Center(
              child: Text("لا توجد طلبات.",
                  style: TextStyle(fontFamily: "Cairo", fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: allrequests.length,
            itemBuilder: (ctx, index) => buildRequestCard(allrequests[index]),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.teal));
        }
      },
    );
  }

  Widget buildRequestCard(RWalletRequestsData request) {
    return GestureDetector(
      onTap: () => Get.to(WalletRequestDetailsScreen(request: request)),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (request.bank?.image?.isNotEmpty == true)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        request.bank!.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance,
                            size: 50,
                            color: Colors.grey),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      request.bank?.name ?? "بنك غير معروف",
                      style: const TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      _getStatusArabic(request.status ?? ""),
                      style: const TextStyle(
                        fontFamily: "Cairo",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(request.status ?? ""),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildInfoRow("المبلغ:", "${request.amount} ل.س",
                        Icons.monetization_on),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: request.status == "pending",
                      child: GestureDetector(
                        onTap: () async {
                          Get.defaultDialog(
                            title: "...جاري الحذف ",
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
                          final prefs = await SharedPreferences.getInstance();
                          final url = Uri.parse(
                              '${AppConstants.baseUrl}/user/wallet-top-up-request/${request.id}');
                          var token = prefs.getString('auth_token');
                          final response = await http.delete(
                            url,
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                          );

                          if (response.statusCode == 200) {
                            Get.back();
                            Get.defaultDialog(
                              title: '',
                              titlePadding: EdgeInsets.zero,
                              content: Column(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Image.asset(
                                        "assets/images/png/delete.png"),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "تم حذف الطلب بنجاح",
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 12),
                                child: CustomElevatedButton(
                                  text: 'موافق',
                                  onpressed: () =>
                                      Get.offAllNamed("mainscreen"),
                                ),
                              ),
                              barrierDismissible: false,
                            );
                          } else {
                            Get.back();
                            Get.defaultDialog(
                              title: '',
                              titlePadding: EdgeInsets.zero,
                              content: Column(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Image.asset(
                                        "assets/images/png/deleteerror.png"),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "عذراً, لم يتم حذف الطلب \n  حصلت مشكلة",
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 12),
                                child: CustomElevatedButton(
                                  text: 'موافق',
                                  onpressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            print(
                                'Failed to get user info: ${response.statusCode}');
                            throw Exception('logout failed');
                          }
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.teal,
                          child:
                              Icon(Icons.delete_forever, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _buildInfoRow(
                  "اسم الحساب:", request.bank?.accountName ?? "", Icons.person),
              _buildInfoRow("رقم الحساب:", request.bank?.accountNumber ?? "",
                  Icons.credit_card),
              _buildInfoRow("IBAN:", request.bank?.iban ?? "",
                  Icons.account_balance_wallet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Cairo",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: 15,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusArabic(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return "مقبول";
      case 'pending':
        return "قيد الانتظار";
      case 'rejected':
        return "مرفوض";
      default:
        return "غير معروف";
    }
  }
}
