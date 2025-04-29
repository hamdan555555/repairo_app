import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final addresscontroller = TextEditingController();

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        print('لم يتم اختيار صورة');
      }
    } catch (e) {
      print('حدث خطأ أثناء اختيار الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6B52AE),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!) as ImageProvider
                      : AssetImage('assets/images/jpg/hamdan.jpg'),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF6B52AE),
                  child: IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt,
                          color: Colors.white, size: 16)),
                )
              ],
            ),
            SizedBox(height: 30),
            buildTextField(Icons.person_outline, 'Full Name',
                controller: namecontroller),
            SizedBox(height: 16),
            buildTextField(
              Icons.mail_outline,
              'Email',
            ),
            SizedBox(height: 16),
            buildTextField(Icons.phone_outlined, 'Contact Number',
                controller: phonecontroller),
            SizedBox(height: 16),
            buildDropdownField('Select Country'),
            SizedBox(height: 16),
            buildTextField(Icons.location_on_outlined, 'Address',
                controller: addresscontroller),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B52AE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  var token = prefs.getString('auth_token');

                  var request = http.MultipartRequest('POST',
                      Uri.parse('http://192.168.1.100:8000/api/user/profile'));
                  request.headers['Authorization'] = 'Bearer $token';

                  request.fields['_method'] = 'put';
                  request.fields['name'] = namecontroller.text;
                  request.fields['address'] = addresscontroller.text;

                  if (imageFile != null) {
                    request.files.add(await http.MultipartFile.fromPath(
                      'image',
                      imageFile!.path,
                    ));
                  }

                  try {
                    var response = await request.send();
                    var body = await response.stream.bytesToString();

                    if (response.statusCode == 200) {
                      print(' تم التحديث بنجاح');
                      print(' الرد: $body');
                      Get.offAllNamed('profile');
                    } else {
                      print(' فشل التحديث: ${response.statusCode}');
                      print(' الرد: $body');
                    }
                  } catch (e) {
                    print(' خطأ أثناء الإرسال: $e');
                  }
                },
                child: Text('Save',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hint,
      {String? initialValue, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDropdownField(String hint) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.arrow_drop_down),
        filled: true,
        fillColor: Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Syria', 'USA', 'Germany', 'UAE']
          .map((e) => DropdownMenuItem(child: Text(e), value: e))
          .toList(),
      onChanged: (val) {},
    );
  }
}
