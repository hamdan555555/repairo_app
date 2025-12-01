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
    return Directionality(
      textDirection: TextDirection.rtl, // من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل طلب التعبئة',
            style: TextStyle(
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // رأس البطاقة
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (request.bank?.image?.isNotEmpty ?? false)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            request.bank!.image!,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.account_balance,
                                    size: 55, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.bank?.name ?? 'بنك غير معروف',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(request.status ?? ''),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(request.status ?? ''),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Cairo",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => AllbanksCubit(
                                    BanksRepository(
                                        bankWebservices: BankWebservices())),
                              ),
                              BlocProvider(
                                create: (context) => WalletRequestEditCubit(
                                    WalletRequestEditRepository(
                                        WalletRequestEditWebservice())),
                              ),
                            ],
                            child: EditWalletRequestScreen(request: request),
                          ));
                        },
                        icon: const Icon(Icons.edit, color: Colors.grey),
                      )
                    ],
                  ),

                  const Divider(height: 30, thickness: 1),

                  // مبلغ التعبئة
                  _buildDetailsRow(
                    'مبلغ التعبئة',
                    '${request.amount} ل.س',
                    Icons.monetization_on,
                    Colors.green,
                  ),

                  const SizedBox(height: 15),
                  const Text(
                    'تفاصيل الحساب البنكي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsRow(
                    'اسم الحساب',
                    request.bank?.accountName ?? 'غير متوفر',
                    Icons.account_circle,
                    Colors.teal,
                  ),
                  _buildDetailsRow(
                    'رقم الحساب',
                    request.bank?.accountNumber ?? 'غير متوفر',
                    Icons.credit_card,
                    Colors.indigo,
                  ),
                  _buildDetailsRow(
                    'رقم IBAN',
                    request.bank?.iban ?? 'غير متوفر',
                    Icons.account_balance_wallet,
                    Colors.orange,
                  ),

                  // صورة الإيصال
                  if (request.image != null && request.image!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Icon(Icons.receipt, size: 22, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'صورة الإيصال',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Cairo",
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          request.image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('تعذّر تحميل الصورة'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // عنصر صف التفاصيل
  Widget _buildDetailsRow(
      String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Cairo",
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cairo",
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // لون حالة الطلب
  static Color _getStatusColor(String status) {
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

  // ترجمة حالة الطلب
  static String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'مقبول';
      case 'pending':
        return 'قيد المراجعة';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }
}
