import 'dart:convert';

import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceRatingScreen extends StatefulWidget {
  final String id;
  ServiceRatingScreen({Key? key, required this.id}) : super(key: key);

  @override
  ServiceRatingScreenState createState() => ServiceRatingScreenState();
}

class ServiceRatingScreenState extends State<ServiceRatingScreen> {
  double rating = 0.0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void submitRating() async {
    Get.defaultDialog(
      title: "...جاري التقييم ",
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
    final url = Uri.parse('${AppConstants.baseUrl}/user/review');
    var token = prefs.getString('auth_token');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_request_id': widget.id,
        'rating': rating,
        'comment': commentController.text,
      }),
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
              child: Image.asset("assets/images/png/rating.png"),
            ),
            const SizedBox(height: 8),
            Text(
              "تم تسجيل تقييمك  ",
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
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          child: CustomElevatedButton(
            text: 'موافق',
            onpressed: () => Get.offAllNamed("mainscreen"),
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
              child: Image.asset("assets/images/png/rating2.png"),
            ),
            const SizedBox(height: 8),
            Text(
              "عذراً, لم يتم تسجيل التقييم \n  حصلت مشكلة",
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
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          child: CustomElevatedButton(
            text: 'موافق',
            onpressed: () {
              Get.back();
            },
          ),
        ),
        barrierDismissible: false,
      );

      print('Failed to get user info: ${response.statusCode}');
      throw Exception('logout failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام Directionality لتأكيد أن اتجاه التطبيق من اليمين لليسار
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'تقييم الخدمة',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عنوان التقييم
              const Text(
                'كم تقيم خدمتنا؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Widget التقييم بالنجوم
              Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      this.rating = newRating; // الحل هو استخدام this.rating
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // حقل إدخال التعليق
              const Text(
                'أخبرنا عن رأيك بالخدمة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'هل كانت جودة الخدمة كما توقّعت ؟',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'اكتب تعليقك هنا...',
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
              ElevatedButton(
                onPressed: rating > 0 ? submitRating : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'إرسال التقييم',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
