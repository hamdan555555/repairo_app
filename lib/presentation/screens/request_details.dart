import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_cubit.dart';
import 'package:breaking_project/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:breaking_project/business_logic/ShowChatCubit/show_chat_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/repository/cancel_order_repository.dart';
import 'package:breaking_project/data/repository/invoice_repository.dart';
import 'package:breaking_project/data/repository/pay_invoice_repository.dart';
import 'package:breaking_project/data/repository/show_chat_repository.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/cancel_order_webservice.dart';
import 'package:breaking_project/data/web_services/invoice_web_services.dart';
import 'package:breaking_project/data/web_services/pay_invoice_webservices.dart';
import 'package:breaking_project/data/web_services/show_chat_webservice.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';
import 'package:breaking_project/presentation/screens/cancellation_reasons.dart';
import 'package:breaking_project/presentation/screens/chatting_screen.dart';
import 'package:breaking_project/presentation/screens/invoice_details.dart';
import 'package:breaking_project/presentation/screens/report_screen.dart';
import 'package:breaking_project/presentation/screens/service_rating_screen.dart';
import 'package:breaking_project/presentation/screens/tech_data.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String id;
  const RequestDetailsScreen({Key? key, required this.id}) : super(key: key);

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
    return Directionality(
      // لتطبيق RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       Get.to(() => BlocProvider(
          //                       create: (context) => ShowChatCubit(
          //                           ShowChatRepository(
          //                               ShowChatWebservice())),
          //                       child: ChattingScreen(
          //                         requestId: widget.r,
          //                           ),
          //                     ));
          //     },

          //   child: Icon(Icons.chat))],
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        body: BlocBuilder<RequestDetailsCubit, RequestDetailsStates>(
          builder: (context, state) {
            if (state is RequestDetailsSuccess) {
              final requestdetails = state.requestdata;

              Widget _buildUserAvatar(
                  String imageUrl, String name, String role) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        imageUrl.replaceFirst(
                            "127.0.0.1", AppConstants.baseaddress),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        )),
                    Text(role,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey[600],
                          fontSize: 12,
                        )),
                  ],
                );
              }

              Widget _buildUserSection() {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUserAvatar(requestdetails.user!.image!,
                            requestdetails.user!.name!, 'العميل'),
                        Icon(Icons.swap_horiz,
                            size: 36, color: Colors.teal[300]),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => BlocProvider(
                                  create: (context) => TechDataCubit(
                                      TechnicianDataRepository(
                                          technicianDataWebservices:
                                              TechnicianDataWebservices())),
                                  child: TechDataScreen(
                                      id: requestdetails
                                          .technicianAccount!.id!),
                                ));
                          },
                          child: _buildUserAvatar(
                              requestdetails.technicianAccount!.image!,
                              requestdetails.technicianAccount!.name!,
                              'المهني'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              Widget _buildInfoCard(String title, String value,
                  {IconData? icon}) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(icon ?? Icons.info, color: Colors.teal),
                    title: Text(title,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    subtitle: Text(value,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                        )),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildUserSection(),
                    Visibility(
                      visible: requestdetails.status == "accepted",
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => BlocProvider(
                                  create: (context) => ShowChatCubit(
                                      ShowChatRepository(ShowChatWebservice())),
                                  child: ChattingScreen(
                                    requestId: requestdetails.id!,
                                    currentUser: "user",
                                  ),
                                ));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 1.5,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Icon(Icons.chat, color: Colors.teal),
                              title: Text(
                                "الذهاب إلى المحادثة",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                "إبدأ محادثتك مع المهني",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey), // هون الإضافة
                            ),
                          )),
                    ),
                    _buildInfoCard('موقع التنفيذ', requestdetails.location!,
                        icon: Icons.location_on),
                    _buildInfoCard(
                        'التاريخ المحدد', requestdetails.scheduledDate!,
                        icon: Icons.date_range),
                    _buildInfoCard(
                        'الوقت المحدد', requestdetails.scheduledTime!,
                        icon: Icons.access_time),
                    _buildInfoCard(
                        'حالة الطلب',
                        requestdetails.status == "accepted"
                            ? "مقبول"
                            : requestdetails.status == "ended"
                                ? "منهي"
                                : requestdetails.status == "rejected"
                                    ? "مرفوض"
                                    : requestdetails.status == "ongoing"
                                        ? "جاري"
                                        : requestdetails.status == "pending"
                                            ? "معلّق"
                                            : requestdetails.status ==
                                                    "canceled"
                                                ? "ملغي"
                                                : "${requestdetails.status}",
                        icon: Icons.flag),
                    _buildInfoCard('تفاصيل إضافية', requestdetails.details!,
                        icon: Icons.notes),
                    const SizedBox(height: 20),

                    // زر عرض الفاتورة
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
                                  ),
                                  BlocProvider<PayInvoiceCubit>(
                                    create: (_) => PayInvoiceCubit(
                                        PayInvoiceRepository(
                                            PayInvoiceWebservices())),
                                  ),
                                ],
                                child:
                                    InvoiceDetailsPage(id: requestdetails.id!),
                              ),
                            ),
                          );
                        },
                        text: "عرض الفاتورة",
                      ),
                    ),
                    Visibility(
                      visible: requestdetails.status == "ended" &&
                          requestdetails.review == null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: CustomElevatedButton(
                          color: Colors.deepOrangeAccent,
                          onpressed: () {
                            Get.to(ServiceRatingScreen(
                              id: requestdetails.id!,
                            ));
                          },
                          text: "تقييم الخدمة",
                        ),
                      ),
                    ),

                    Visibility(
                      visible: requestdetails.status != "ended" &&
                          requestdetails.status != "ongoing" &&
                          requestdetails.status != "canceled",
                      child: CustomElevatedButton(
                        onpressed: () {
                          Get.to(() => BlocProvider(
                                create: (context) => CancelOrderCubit(
                                    CancelOrderRepository(
                                        CancelOrderWebservice())),
                                child: CancelOrderScreen(
                                    id: requestdetails.id!,
                                    request_status: requestdetails.status),
                              ));
                        },
                        text: "إلغاء الطلب ",
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Visibility(
                        visible: requestdetails.status != "ended" &&
                            requestdetails.status != "ongoing" &&
                            requestdetails.status != "accepted",
                        child: CustomElevatedButton(
                          color: Colors.redAccent,
                          onpressed: () async {
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
                                '${AppConstants.baseUrl}/user/service-request/${requestdetails.id}');
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
                          text: "حذف الطلب",
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "هل واجهت مشكلة ما ؟ يمكنك إبلاغنا",
                          style: TextStyle(fontFamily: "Cairo"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ReportScreen(
                                    id: requestdetails.id!,
                                  ));
                            },
                            child: Text(
                              "من هنا",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Colors.teal,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else if (state is RequestDetailsLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.teal));
            }
            return const Center(
                child: Text(
              "حدث خطأ أثناء جلب البيانات",
              style: TextStyle(fontFamily: 'Cairo'),
            ));
          },
        ),
      ),
    );
  }
}
