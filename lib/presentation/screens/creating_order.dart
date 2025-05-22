import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_cubit.dart';
import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateRequestScreen extends StatefulWidget {
  final String id;
  final List<String> services;
  const CreateRequestScreen(
      {super.key, required this.id, required this.services});
  @override
  _CreateRequestScreenState createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController locationcontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDateTime;
  List<File> selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((x) => File(x.path)).toList();
      });
    }
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order'),
      ),
      body: BlocListener<CreatingOrderCubit, CreatingOrderStates>(
        listener: (context, state) {
          if (state is CreatingOrderLoading) {
            Get.defaultDialog(
              title: "Loading...",
              content: const Column(
                children: [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 10),
                  Text("Please wait..."),
                ],
              ),
              barrierDismissible: false,
            );
          } else {
            if (Get.isDialogOpen!) {
              Get.back();
            }
          }

          if (state is CreatingOrderError) {
            Get.snackbar("Error", state.message,
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        },
        child: BlocBuilder<CreatingOrderCubit, CreatingOrderStates>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      ":من فضلك قم بإضافة بعض الصور التوضيحية للمشكلة ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  SizedBox(height: 30),
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
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add_a_photo, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // العنوان
                  TextField(
                    controller: locationcontroller,
                    decoration: InputDecoration(
                      labelText: 'العنوان الحالي ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),

                  // الوقت
                  InkWell(
                    onTap: pickDateTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'الوقت المطلوب للخدمة',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        selectedDateTime != null
                            ? "${selectedDateTime!.toLocal()}".split('.')[0]
                            : 'اختر الوقت',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // الوصف
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'شرح تفصيلي للمشكلة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),

                  // زر الإرسال
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CreatingOrderCubit>().createOrder(
                            technicianId: widget.id,
                            selectedServiceIds: widget.services,
                            details: descriptionController.text,
                            images: selectedImages,
                            location: locationcontroller.text,
                            date:
                                '${selectedDateTime!.year}-${selectedDateTime!.month}-${selectedDateTime!.day}',
                            time: '09:00');
                      },
                      icon: Icon(Icons.send),
                      label: Text('send order'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
