import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/tech_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkDetailsPage extends StatelessWidget {
  final PreviousWorks work;
  const WorkDetailsPage({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(work.title!,
              style: const TextStyle(
                  fontFamily: "Cairo", fontWeight: FontWeight.bold)),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(work.description ?? '',
                  style: const TextStyle(fontFamily: "Cairo", fontSize: 16)),
              const SizedBox(height: 16),
              ...work.image!.map((imgUrl) {
                final fixedUrl =
                    imgUrl.replaceFirst("127.0.0.1", AppConstants.baseaddress);
                return SizedBox(
                  width: double.infinity, // يجعل العنصر يملأ عرض الشاشة
                  height: 250.h,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Image.network(
                        fixedUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
