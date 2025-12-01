import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/repository/creating_order_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/web_services/creating_order_webservice.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/presentation/screens/creating_order.dart';
import 'package:breaking_project/presentation/screens/servicesProviders.dart';
import 'package:breaking_project/presentation/screens/suggested_services_screen.dart';
import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart' as intl;

class SchedulePage extends StatefulWidget {
  final Cart cart;

  const SchedulePage({super.key, required this.cart});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int? selectedIndex; // <-- لتخزين العنصر المختار
  double _hourValue = 12; // القيمة الافتراضية للساعة
  DateTime _time = DateTime.now();
  String? formattedDate;
  String? formattedTime;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 50, right: 8, left: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "الخطوة 2 من 4 ",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
                const Text("أي مهني ترغب ؟",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                /// البطاقات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProCard("مهني معيّن", null, true, index: 0),
                    _buildProCard("تعيين آلي", null, false,
                        auto: true, index: 1),
                  ],
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text("اختر اليوم",
                      style: TextStyle(fontSize: 18, fontFamily: "Cairo")),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.single,
                    showNavigationArrow: true, // الأسهم للتنقل بين الأشهر
                    view: DateRangePickerView.month,
                    selectionColor: Colors.teal,
                    todayHighlightColor: Colors.teal,
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek:
                          6, // يخلي السبت أول يوم (حسب العادة المحلية)
                    ),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      final DateTime selectedDate = args.value;
                      formattedDate =
                          intl.DateFormat('yyyy-MM-dd').format(selectedDate);

                      debugPrint("اليوم المختار: $formattedDate");
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                  child: Text("الوقت المفضل لبدء الخدمة",
                      style: TextStyle(fontSize: 18, fontFamily: "Cairo")),
                ),
                TimePickerSpinner(
                  is24HourMode: true,
                  normalTextStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  highlightedTextStyle:
                      TextStyle(fontSize: 22, color: Colors.teal),
                  spacing: 30,
                  itemHeight: 40,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      _time = time;
                      formattedTime = intl.DateFormat('HH:mm').format(time);
                      debugPrint("الوقت المختار: $formattedTime");
                    });
                  },
                ),

                //const Spacer(),

                /// الكارت مع المجموع
                // Container(
                //   color: Colors.teal,
                //   padding: const EdgeInsets.all(16),
                //   child: Column(
                //     children: [
                //       Text("المجموع: ${widget.cart.total} ليرة",
                //           style: const TextStyle(
                //               fontSize: 18, fontWeight: FontWeight.bold)),
                //       const SizedBox(height: 10),
                //       ElevatedButton(
                //         onPressed: () {
                //           if (selectedIndex == null) {
                //             Get.snackbar("تنبيه", "يرجى اختيار محترف أولاً");
                //           } else {
                //             // الانتقال للخطوة التالية
                //           }
                //         },
                //         style: ElevatedButton.styleFrom(
                //           minimumSize: const Size(double.infinity, 50),
                //           backgroundColor: Colors.amber,
                //         ),
                //         child: const Text("التالي",
                //             style: TextStyle(fontSize: 18)),
                //       ),
                //     ],
                //   ),
                // )
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // showCartBottomSheet(context, widget.cart);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "المجموع: 1200 ليرة",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            Row(
                              children: [
                                Text(
                                  "المجموع: ${widget.cart.total.toStringAsFixed(2)} ليرة",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo"),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(Icons.keyboard_arrow_up_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (selectedIndex == null) {
                            Get.snackbar("تنبيه", "يرجى اختيار نوع المهني");
                            return;
                          }

                          if (formattedDate == null) {
                            Get.snackbar("تنبيه", "يرجى اختيار اليوم");
                            return;
                          }

                          if (formattedTime == null) {
                            Get.snackbar("تنبيه", "يرجى اختيار الوقت");
                            return;
                          }

                          /// إذا كل الشروط تمام
                          if (selectedIndex == 0) {
                            Get.to(
                              () => BlocProvider(
                                create: (_) => HomeCubit(
                                  HomeRepository(
                                      homeWebservices: HomeWebservices()),
                                ),
                                child: FilteredTechniciansScreen(
                                  date: formattedDate,
                                  time: formattedTime,
                                  cart: widget.cart,
                                  selectedservices: widget.cart.items
                                      .map((item) => item.service.id)
                                      .whereType<String>()
                                      .toList(),
                                ),
                              ),
                            );
                          } else {
                            Get.to(() => BlocProvider(
                                  create: (context) => CreatingOrderCubit(
                                      CreatingOrderRepository(
                                          CreatingOrderWebservice())),
                                  child: CreateRequestScreen(
                                    date: formattedDate,
                                    time: formattedTime,
                                    id: '',
                                    servicesids: widget.cart.items
                                        .map((item) => item.service.id!)
                                        .toList(),
                                    servicesquantities: widget.cart.items
                                        .map((item) => item.quantity.toString())
                                        .toList(),
                                  ),
                                ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24),
                            child: Text(
                              "التالي",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ويدجت الكارد
  Widget _buildProCard(String name, String? rating, bool recommended,
      {bool auto = false, required int index}) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 140,
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.teal.shade50 : Colors.white,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              radius: 35,
              child: CircleAvatar(
                backgroundImage:
                    auto ? null : const AssetImage("assets/images/jpg/pro.jpg"),
                backgroundColor: Colors.teal.shade100,
                radius: 30,
                child: auto
                    ? const Text("Repairo",
                        style: TextStyle(color: Colors.teal))
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Cairo"),
                  overflow: TextOverflow.ellipsis),
            ),
            if (recommended && !auto)
              const Text("موصى بها في منطقتك",
                  style: TextStyle(fontSize: 12, fontFamily: "Cairo")),
            if (auto)
              const Text(
                "سنقوم بتعيين أفضل محترف متوفر",
                style: TextStyle(fontSize: 12, fontFamily: "Cairo"),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
