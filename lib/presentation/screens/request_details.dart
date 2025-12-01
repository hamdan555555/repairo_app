import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_cubit.dart';
import 'package:breaking_project/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:breaking_project/business_logic/PayInvoiceCubit/pay_invoice_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:breaking_project/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:breaking_project/business_logic/ChatCubit/chat_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/repository/cancel_order_repository.dart';
import 'package:breaking_project/data/repository/invoice_repository.dart';
import 'package:breaking_project/data/repository/pay_invoice_repository.dart';
import 'package:breaking_project/data/repository/chat_repository.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/cancel_order_webservice.dart';
import 'package:breaking_project/data/web_services/invoice_web_services.dart';
import 'package:breaking_project/data/web_services/pay_invoice_webservices.dart';
import 'package:breaking_project/data/web_services/chat_webservice.dart';
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

  // يستقبل الـ bookingHistory كـ Map<String, dynamic> (أو Map<String, String>)
  Widget _buildBookingHistoryList(Map<String, dynamic>? bookingHistory) {
    if (bookingHistory == null || bookingHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "لا يوجد سجل للحجوزات",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // نجهز لستة من العناصر مع محاولة تحويل التاريخ إلى DateTime
    final entries = bookingHistory.entries.map((e) {
      final key = e.key.toString();
      final raw = e.value?.toString() ?? '';

      DateTime? dt;
      try {
        // بعض APIs يرجّع "2025-08-30 00:57:25" -> نحول المسافة لـ T حتى يقبل DateTime.parse
        final iso = raw.replaceFirst(' ', 'T');
        dt = DateTime.parse(iso);
      } catch (_) {
        dt = null;
      }

      return {'status': key, 'raw': raw, 'dt': dt};
    }).toList();

    // نرتب حسب التاريخ إذا متوفر (من الأقدم للأحدث)
    entries.sort((a, b) {
      final da = a['dt'] as DateTime?;
      final db = b['dt'] as DateTime?;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });

    // نعرض داخل ListView مقيد الارتفاع حتى الـ BottomSheet يظل قابلاً للتمرير
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = entries[index];
          final status = (item['status'] as String);
          final raw = (item['raw'] as String);
          final dt = item['dt'] as DateTime?;

          // عرض تاريخ ووقت بصيغة بسيطة (fallback إلى النص الخام إن لم نستطع التحويل)
          final displayDate = dt != null
              ? "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}"
              : (raw.split(' ').isNotEmpty ? raw.split(' ').first : raw);
          final displayTime = dt != null
              ? "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}"
              : (raw.split(' ').length > 1
                  ? raw.split(' ').sublist(1).join(' ')
                  : '');

          final color = _statusColor(status);
          final title = _statusTitle(status);
          final desc = _statusDescription(status, raw);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العمود الصغير: الوقت - التاريخ - خط عمودي
              Column(
                children: [
                  Text(
                    displayTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(displayDate),
                  const SizedBox(height: 6),
                  // خط عمودي يصل للأحداث التالية (لا نطوّله عند آخر عنصر)
                  if (index != entries.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: color.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    )
                  else
                    const SizedBox(height: 4),
                ],
              ),

              const SizedBox(width: 12),

              // الدائرة الملونة
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

              const SizedBox(width: 12),

              // العنوان والوصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(desc),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ترجمة اسم الحالة إلى عنوان عرضي (تقدر تضيف حالات أخرى هنا)
  String _statusTitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'مُعلّق';
      case 'accepted':
        return 'مقبول';
      case 'assigned':
        return 'تم التعيين';
      case 'ongoing':
        return 'جاري التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'canceled':
        return 'ملغي';
      default:
        // إذا الحالة غير معروفة نعرضها كما هي (بدون تعديل)
        return status;
    }
  }

  // لون لكل حالة (تقدر تغيّر الألوان هنا)
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.teal;
      case 'assigned':
        return Colors.blue;
      case 'ongoing':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'canceled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // وصف مبسّط لكل حالة؛ إذا كنت عندك وصفات مفصّلة في الـ API استبدل raw بها
  String _statusDescription(String status, String rawDate) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'تم إنشاء الطلب';
      case 'accepted':
        return 'تم قبول الطلب';
      case 'assigned':
        return 'تم تعيين الفني للطلب';
      case 'ongoing':
        return 'تم بدء التنفيذ';
      case 'completed':
        return 'انتهى التنفيذ';
      case 'rejected':
        return 'تم رفض الطلب';
      case 'canceled':
        return 'تم إلغاء الطلب';
      default:
        return rawDate; // fallback: نعرض التاريخ/البيانات الخام لو ما في وصف
    }
  }

  Color _getColorFromString(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
                      backgroundImage: NetworkImage(imageUrl.replaceFirst(
                          "127.0.0.1", AppConstants.baseaddress)),
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
                                  create: (context) => ChatCubit(
                                      ChatRepository(ChatWebservice())),
                                  child: ChattingScreen(
                                    techname:
                                        requestdetails.technicianAccount!.name!,
                                    techimage: requestdetails
                                        .technicianAccount!.image!,
                                    user_id: requestdetails.user!.id!,
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

                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // لتوفير مساحة أكبر إذا كان المحتوى طويلاً
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // رأس الـ BottomSheet
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "سجل عملية طلب الخدمة",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        // Text(
                                        //   "ID : ${request.id}",
                                        //   style: TextStyle(
                                        //     fontFamily: 'Cairo',
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 18,
                                        //     color: Colors.deepPurple,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // هنا تضاف قائمة تاريخ الطلبات
                                    // استخدمنا List of Maps لتسهيل عرض البيانات
                                    _buildBookingHistoryList(
                                      requestdetails.bookingHistory,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.history, color: Colors.teal),
                          title: Text(
                            "تاريخ الطلب",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "رؤية حالات طلب الخدمة",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ), // هون الإضافة
                        ),
                      ),
                    ),
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
