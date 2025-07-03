import 'package:breaking_project/app_router.dart';
import 'package:breaking_project/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/repository/invoice_repository.dart';
import 'package:breaking_project/data/repository/pay_invoice_repository.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/invoice_web_services.dart';
import 'package:breaking_project/data/web_services/pay_invoice_webservices.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';
import 'package:breaking_project/presentation/screens/invoice_details.dart';
import 'package:breaking_project/presentation/screens/tech_data.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String id;
  const RequestDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    context.read<RequestDetailsCubit>().getRequestDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<RequestDetailsCubit, RequestDetailsStates>(
        builder: (context, state) {
          if (state is RequestDetailsSuccess) {
            final requestdetails = (state).requestdata;

            Widget _buildUserAvatar(String imageUrl, String name, String role) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(imageUrl.replaceFirst(
                          "127.0.0.1", AppConstants.baseaddress)),
                    ),
                    SizedBox(height: 8),
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(role,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              );
            }

            Widget _buildUserSection() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserAvatar(requestdetails.user!.image!,
                      requestdetails.user!.name!, 'العميل'),
                  Icon(Icons.swap_horiz, size: 36, color: Colors.grey),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => BlocProvider(
                            create: (context) => TechDataCubit(
                                TechnicianDataRepository(
                                    technicianDataWebservices:
                                        TechnicianDataWebservices())),
                            child: TechDataScreen(
                                id: requestdetails.technicianAccount!.id!),
                          ));
                    },
                    child: _buildUserAvatar(
                        requestdetails.technicianAccount!.image!,
                        requestdetails.technicianAccount!.name!,
                        'المهني'),
                  ),
                ],
              );
            }

            Widget _buildInfoCard(String title, String value) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(value, style: TextStyle(fontSize: 16)),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildUserSection(),
                  SizedBox(height: 20),
                  _buildInfoCard('📍 موقع التنفيذ', requestdetails.location!),
                  _buildInfoCard(
                      '🗓️ التاريخ المحدد', requestdetails.scheduledDate!),
                  _buildInfoCard(
                      '⏰ الوقت المحدد', requestdetails.scheduledTime!),
                  _buildInfoCard('📌 حالة الطلب', requestdetails.status!),
                  _buildInfoCard('📋 التفاصيل', requestdetails.details!),
                  Visibility(
                      visible: requestdetails.status == "ended",
                      child: CustomElevatedButton(
                          onpressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider<InvoiceCubit>(
                                              create: (_) => InvoiceCubit(
                                                  InvoiceRepository(
                                                      InvoiceWebServices())),

                                              // أو مرر نسخة جاهزة إذا موجودة
                                            ),
                                            BlocProvider<PayInvoiceCubit>(
                                              create: (_) => PayInvoiceCubit(
                                                  PayInvoiceRepository(
                                                      PayInvoiceWebservices())),

                                              // أو مرر نسخة جاهزة إذا موجودة
                                            ),
                                          ],
                                          child: InvoiceDetailsPage(
                                              id: requestdetails.id!))),
                            );
                          },
                          text: "Show Invoice")),
                  Visibility(
                      visible: requestdetails.status != "ended" &&
                          requestdetails.status != "ongoing",
                      child: CustomElevatedButton(
                          onpressed: () {}, text: "Cancel Order"))
                ],
              ),
            );
          } else if (state is RequestDetailsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(child: Text("Error Happenep"));
        },
      ),
    );
  }
}
