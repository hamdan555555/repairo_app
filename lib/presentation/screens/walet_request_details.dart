import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/WalletRequestEditCubit/wallet_request_edit_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/wallet_requests_model.dart';
import 'package:breaking_project/data/repository/bank_repository.dart';
import 'package:breaking_project/data/repository/wallet_request_edit_repository.dart';
import 'package:breaking_project/data/web_services/banks_webservices.dart';
import 'package:breaking_project/data/web_services/wallet_request_edit_webservice.dart';
import 'package:breaking_project/presentation/screens/edit_wallet_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class WalletRequestDetailsScreen extends StatelessWidget {
  final RWalletRequestsData request;
  const WalletRequestDetailsScreen({super.key, required this.request});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopUp Request Details'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (request.bank!.image!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          request.bank!.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.account_balance,
                                size: 80, color: Colors.grey);
                          },
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                request.bank!.name!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => AllbanksCubit(
                                              BanksRepository(
                                                  bankWebservices:
                                                      BankWebservices())),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              WalletRequestEditCubit(
                                                  WalletRequestEditRepository(
                                                      WalletRequestEditWebservice())),
                                        ),
                                      ],
                                      child: EditWalletRequestScreen(
                                        request: request,
                                      ),
                                    ));
                                  },
                                  icon: Icon(Icons.edit))
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request.status!),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              _getStatusText(request.status!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1.5, color: Colors.grey),
                _buildDetailsRow(
                  ' charging amount',
                  '${request.amount} s.p',
                  Icons.monetization_on,
                  Colors.green,
                ),

                const SizedBox(height: 15),
                const Text(
                  'Bank Account Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailsRow(
                  ' Account Name',
                  request.bank!.accountName!,
                  Icons.account_circle,
                  Colors.teal,
                ),
                _buildDetailsRow(
                  'Account Number',
                  request.bank!.accountNumber!,
                  Icons.credit_card,
                  Colors.indigo,
                ),
                _buildDetailsRow(
                  'IBAN Number',
                  request.bank!.iban!,
                  Icons.account_balance_wallet,
                  Colors.orange,
                ),
                // لو فيه صورة إيصال
                if (request.image != null && request.image!.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.receipt,
                        size: 28,
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        'receipt image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        request.image!.replaceFirst(
                            '127.0.0.1', AppConstants.baseaddress),
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('image could not be loaded');
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء صفوف التفاصيل
  Widget _buildDetailsRow(
      String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لتحديد لون الحالة
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade700;
      case 'pending':
        return Colors.orange.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  // دالة لتحويل نص الحالة للعربية
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'مقبول';
      case 'pending':
        return 'معلّق';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }
}
