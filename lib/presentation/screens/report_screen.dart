import 'dart:convert';

import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  final String id;
  const ReportScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // للتحكم بنص حقل الإبلاغ
  final TextEditingController _descriptionController = TextEditingController();

  // لتعطيل الزر مؤقتاً أثناء الإرسال
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // دالة إرسال الإبلاغ
  void _submitReport() async {
    // التأكد من أن الحقل ليس فارغاً
    if (_descriptionController.text.isEmpty) {
      Get.snackbar(
        "خطأ",
        "الرجاء كتابة وصف الإبلاغ.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        titleText: const Text(
          "خطأ",
          style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),
        ),
        messageText: const Text(
          "الرجاء كتابة وصف الإبلاغ.",
          style: TextStyle(fontFamily: "Cairo", fontSize: 16.0),
        ),
      );
      return;
    }

    // إظهار مؤشر التحميل
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${AppConstants.baseUrl}/user/report');
      var token = prefs.getString('auth_token');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_request_id': widget.id,
          'description': _descriptionController.text,
        }),
      );

      // إخفاء مؤشر التحميل
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // إذا كان الإبلاغ ناجحاً
        Get.defaultDialog(
          title: "تم الإرسال بنجاح ✅",
          titleStyle: const TextStyle(
              fontFamily: "Cairo", fontWeight: FontWeight.bold, fontSize: 18),
          content: const Text(
            "تم استلام إبلاغك بنجاح. سنقوم بمراجعته.",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Cairo"),
          ),
          confirm: CustomElevatedButton(
            text: 'موافق',
            onpressed: () => Get.offAllNamed("mainscreen"),
          ),
        );
      } else {
        // إذا فشل الإبلاغ
        Get.defaultDialog(
          title: "فشل الإرسال ❌",
          titleStyle: const TextStyle(
              fontFamily: "Cairo", fontWeight: FontWeight.bold, fontSize: 18),
          content: const Text(
            "عذراً، حدث خطأ أثناء إرسال الإبلاغ. الرجاء المحاولة لاحقاً.",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Cairo"),
          ),
          confirm: CustomElevatedButton(
            text: 'موافق',
            onpressed: () => Get.back(),
          ),
        );
      }
    } catch (e) {
      // في حالة وجود خطأ في الاتصال
      setState(() {
        _isLoading = false;
      });
      Get.defaultDialog(
        title: "خطأ في الاتصال",
        titleStyle: const TextStyle(
            fontFamily: "Cairo", fontWeight: FontWeight.bold, fontSize: 18),
        content: Text(
          "الرجاء التحقق من اتصالك بالإنترنت والمحاولة مجدداً.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: "Cairo"),
        ),
        confirm: CustomElevatedButton(
          text: 'موافق',
          onpressed: () => Get.back(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'الإبلاغ عن مشكلة',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان الصفحة
              const Text(
                'أخبرنا عن المشكلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // حقل إدخال الوصف
              TextField(
                controller: _descriptionController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'اكتب وصف الإبلاغ هنا...',
                  hintStyle: TextStyle(fontFamily: 'Cairo'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 32),

              // زر الإرسال
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.teal))
                  : CustomElevatedButton(
                      text: 'إرسال الإبلاغ',
                      onpressed: _submitReport,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
