import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_cubit.dart';
import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_states.dart';
import 'package:breaking_project/core/services/firebase_api.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateRequestScreen extends StatefulWidget {
  final String? id;
  final List<String> servicesids;
  final List<String> servicesquantities;
  final String? date;
  final String? time;

  const CreateRequestScreen({
    super.key,
    this.id,
    required this.servicesids,
    required this.servicesquantities,
    this.date,
    this.time,
  });

  @override
  _CreateRequestScreenState createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController locationcontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  //DateTime? selectedDateTime;
  List<File> selectedImages = [];

  final ImagePicker _picker = ImagePicker();
  double _hourValue = 12; // القيمة الافتراضية للساعة
  DateTime _time = DateTime.now();
  String? formattedDate;
  String? formattedTime;
  bool _isSearchingTechnician = false;

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((x) => File(x.path)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseApi.onTechnicianAccepted = () {
      if (_isSearchingTechnician) {
        _isSearchingTechnician = false;
        if (Get.isDialogOpen!) Get.back();
        Get.snackbar("مبروك 🎉", "تم العثور على مهني وافق على طلبك",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<CreatingOrderCubit, CreatingOrderStates>(
          listener: (context, state) {
            if (state is CreatingOrderLoading) {
              Get.defaultDialog(
                title: "...جاري التحميل ",
                titleStyle: TextStyle(fontFamily: "Cairo"),
                content: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text("الرجاء الانتظار.",
                        style: TextStyle(fontFamily: "Cairo")),
                  ],
                ),
                barrierDismissible: false,
              );
            } else if (state is CreatingOrderSuccess) {
              if (widget.id != "") {
                Get.back();
                Get.defaultDialog(
                  title: '',
                  content: Column(
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          child: Image.asset("assets/images/png/check.png")),
                      SizedBox(height: 10),
                      Text(
                        "تم إنشاء الطلب بنجاح",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: Colors.black),
                      ),
                    ],
                  ),
                  confirm: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 12),
                    child: CustomElevatedButton(
                      text: 'حسناً',
                      onpressed: () => Get.toNamed("mainscreen"),
                    ),
                  ),
                  barrierDismissible: false,
                );
              } else {
                Get.back();
                // إذا الطلب عن طريق النظام (بحث عن مهني)
                setState(() => _isSearchingTechnician = true);
                // عرض شاشة البحث
                Get.defaultDialog(
                  title: "جاري البحث...",
                  content: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 12),
                      Text("نبحث عن مهني مناسب لطلبك",
                          style: TextStyle(fontFamily: "Cairo")),
                    ],
                  ),
                  barrierDismissible: false,
                );

                // بدء العداد (لو ما اجا رد خلال دقيقة)
                Future.delayed(Duration(minutes: 2), () {
                  if (_isSearchingTechnician) {
                    _isSearchingTechnician = false;
                    if (Get.isDialogOpen!) Get.back();
                    Get.snackbar(
                      "عذراً",
                      "لم يتم العثور على مهني متاح الآن",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                });
                // Get.offAllNamed("mainscreen")
              }
            } else if (state is CreatingOrderError) {
              if (Get.isDialogOpen!) Get.back();
              Get.snackbar("خطأ", state.message,
                  backgroundColor: Colors.redAccent, colorText: Colors.white);
            }
          },
          child: BlocBuilder<CreatingOrderCubit, CreatingOrderStates>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(top: 60, right: 8, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey.shade500,
                              child: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("عملية إرسال الطلب",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Cairo",
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    // خطوة
                    Text(
                      "الخطوة 4 من 4",
                      style: TextStyle(color: Colors.grey, fontFamily: "Cairo"),
                    ),
                    SizedBox(height: 20),

                    Visibility(
                      visible: widget.date == null,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text("اختر اليوم",
                            style:
                                TextStyle(fontSize: 18, fontFamily: "Cairo")),
                      ),
                    ),

                    Visibility(
                      visible: widget.date == null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.single,
                          showNavigationArrow: true, // الأسهم للتنقل بين الأشهر
                          view: DateRangePickerView.month,
                          selectionColor: Colors.teal,
                          todayHighlightColor: Colors.teal,
                          monthViewSettings:
                              const DateRangePickerMonthViewSettings(
                            firstDayOfWeek:
                                6, // يخلي السبت أول يوم (حسب العادة المحلية)
                          ),
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            final DateTime selectedDate = args.value;
                            formattedDate = intl.DateFormat('yyyy-MM-dd')
                                .format(selectedDate);

                            debugPrint("اليوم المختار: $formattedDate");
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: widget.time == null,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                        child: Text("الوقت المفضل لبدء الخدمة",
                            style:
                                TextStyle(fontSize: 18, fontFamily: "Cairo")),
                      ),
                    ),
                    Visibility(
                      visible: widget.time == null,
                      child: TimePickerSpinner(
                        is24HourMode: true,
                        normalTextStyle:
                            TextStyle(fontSize: 18, color: Colors.grey),
                        highlightedTextStyle:
                            TextStyle(fontSize: 22, color: Colors.teal),
                        spacing: 30,
                        itemHeight: 40,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            _time = time;
                            formattedTime =
                                intl.DateFormat('HH:mm').format(time);
                            debugPrint("الوقت المختار: $formattedTime");
                          });
                        },
                      ),
                    ),

                    /////////////////////////

                    // اختيار الصور
                    Text("من فضلك قم بإضافة بعض الصور التوضيحية",
                        style: _titleStyle),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...selectedImages.map((file) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(file,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            )),
                        GestureDetector(
                          onTap: pickImages,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              border: Border.all(color: Colors.teal),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add_a_photo, color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // العنوان
                    Text("العنوان التفصيلي", style: _titleStyle),
                    SizedBox(height: 16),
                    TextField(
                      style: TextStyle(fontFamily: "Cairo"),
                      controller: locationcontroller,
                      decoration: _inputDecoration("أدخل العنوان الحالي"),
                    ),
                    SizedBox(height: 20),

                    Text("وصف المشكلة", style: _titleStyle),
                    SizedBox(height: 16),
                    TextField(
                      style: TextStyle(fontFamily: "Cairo"),
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: _inputDecoration("صف المشكلة بشكل تفصيلي"),
                    ),
                    SizedBox(height: 30),

                    // زر الإرسال
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // إذا كان الطلب موجّه لمهني معيّن
                            if (widget.id != "") {
                              context.read<CreatingOrderCubit>().createOrder(
                                    technicianId: widget.id,
                                    selectedServiceIds: widget.servicesids,
                                    details: descriptionController.text,
                                    images: selectedImages,
                                    location: locationcontroller.text,
                                    date: widget.date ?? formattedDate!,
                                    time: widget.time ?? formattedTime!,
                                  );
                            } else {
                              context.read<CreatingOrderCubit>().createOrder(
                                    technicianId: null,
                                    selectedServiceIds: widget.servicesids,
                                    details: descriptionController.text,
                                    images: selectedImages,
                                    location: locationcontroller.text,
                                    date: widget.date ?? formattedDate!,
                                    time: widget.time ?? formattedTime!,
                                  );
                            }
                          },
                          label: Text('إرسال الطلب',
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TextStyle get _titleStyle => TextStyle(
        fontSize: 16,
        fontFamily: "Cairo",
      );

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: "Cairo", fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal)),
    );
  }
}
