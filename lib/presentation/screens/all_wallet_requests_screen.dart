import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_states.dart';
import 'package:breaking_project/business_logic/AllWalletRequestsCubit/all_wallet_requests_cubit.dart';
import 'package:breaking_project/business_logic/AllWalletRequestsCubit/all_wallet_requests_states.dart';
import 'package:breaking_project/data/models/bank_model.dart';
import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/presentation/screens/walet_request_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Wallet Requests", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          buildFilterOptions(),
          Expanded(child: buildBlocWidget()),
        ],
      ),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<AllbanksCubit, AllbanksStates>(
                  builder: (context, state) {
                    if (state is AllbanksLoaded) {
                      return DropdownButton<RBankData?>(
                        hint: const Text("All"),
                        value: selelectedbank,
                        items: [
                          const DropdownMenuItem<RBankData?>(
                            value: null,
                            child: Text("All"),
                          ),
                          ...context
                              .read<AllbanksCubit>()
                              .banks
                              .map((bank) => DropdownMenuItem<RBankData>(
                                    value: bank,
                                    child: Text(bank.name ?? 'غير معروف'),
                                  ))
                              .toList(),
                        ],
                        onChanged: (RBankData? value) {
                          setState(() {
                            selelectedbank = value;
                          });

                          context
                              .read<AllWalletRequestsCubit>()
                              .getallwalletrequests(
                                bankId: selelectedbank?.id,
                                status: selectedstatus,
                              );
                        },
                      );
                    }
                    return DropdownButton<String>(
                      hint: Text("All"),
                      value: 'All',
                      items: [
                        DropdownMenuItem<String>(
                          value: 'All',
                          child: Text('All'),
                        )
                      ],
                      onChanged: (val) {},
                    );
                  },
                ),
                DropdownButton<String>(
                  hint: Text("Status"),
                  value: selectedstatus,
                  items:
                      [null, 'pending', 'accepted', 'rejected'].map((statuee) {
                    return DropdownMenuItem(
                      value: statuee,
                      child: Text(statuee == null ? "All" : statuee.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedstatus = value;
                    });
                    BlocProvider.of<AllWalletRequestsCubit>(context)
                        .getallwalletrequests(
                            bankId: selelectedbank!.id!,
                            status: selectedstatus);
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllWalletRequestsCubit, AllWalletRequestsStates>(
      builder: (context, state) {
        if (state is AllWalletRequestsLoaded) {
          final allrequests = state.walletrequests;

          // فلترة حسب الاسم
          final filteredrequests = allrequests.where((request) {
            final bankname = request.bank!.name?.toLowerCase() ?? '';
            return bankname.contains('');
          }).toList();

          if (filteredrequests.isEmpty) {
            return Center(child: Text("No requests found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredrequests.length,
            itemBuilder: (ctx, index) =>
                buildRequestCard(filteredrequests[index]),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple));
        }
      },
    );
  }

  Widget buildRequestCard(RWalletRequestsData request) {
    return GestureDetector(
      onTap: () {
        Get.to(WalletRequestDetailsScreen(
          request: request,
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (request.bank!.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        request.bank!.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.account_balance,
                              size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      request.bank!.name!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status!.replaceFirst(
                          request.status![0], request.status![0].toUpperCase()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              _buildInfoRow('cahrging amount :', '${request.amount} s.p',
                  Icons.monetization_on),
              _buildInfoRow(
                  'account name :', request.bank!.accountName!, Icons.person),
              _buildInfoRow('account number:', request.bank!.accountNumber!,
                  Icons.credit_card),
              _buildInfoRow(
                  'IBAN:', request.bank!.iban!, Icons.account_balance_wallet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
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
}
