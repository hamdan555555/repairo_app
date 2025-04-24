import 'dart:convert';

import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_states.dart';
import 'package:breaking_project/presentation/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileLoading) {
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

        if (state is ProfileError) {
          Get.snackbar("Error", state.message,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed('editprofile');
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Color(0xFF6F4EC9),
          elevation: 0,
          leading: Icon(Icons.arrow_back_ios, color: Colors.white),
          title: Text('Profile', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //color: Color(0xFF6F4EC9),
                padding: EdgeInsets.only(top: 20, bottom: 40),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/jpg/hamdan.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit,
                                size: 18, color: Color(0xFF6F4EC9)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Mohamed Yousef",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text("Damascus_Mazzeh",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text("0962269365",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
              sectionTitle("GENERAL"),
              settingsTile(Icons.dark_mode, "Dark Mode",
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (val) {
                      setState(() {
                        isDarkMode = val;
                      });
                    },
                  )),
              settingsTile(Icons.lock, "Change Password"),
              settingsTile(Icons.language, "App Language"),
              settingsTile(Icons.favorite_border, "Favourite Service"),
              settingsTile(Icons.star_border, "Rate Us"),
              sectionTitle("ABOUT APP"),
              settingsTile(Icons.privacy_tip_outlined, "Privacy Policy"),
              settingsTile(Icons.article_outlined, "Terms & Conditions"),
              settingsTile(Icons.help_outline, "Help Support"),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    final url = Uri.parse(
                        'http://172.20.10.5:8000/api/user/authentication/logout');
                    // const token =
                    //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL3VzZXIvYXV0aGVudGljYXRpb24vY2hlY2stY29kZSIsImlhdCI6MTc0NTQ5NDg2MywiZXhwIjoxNzQ1NDk4NDYzLCJuYmYiOjE3NDU0OTQ4NjMsImp0aSI6IkI2MzlXUmFCNWtkM0M0bE4iLCJzdWIiOiI5ZWMwMTc1ZS0yMWJkLTQyYmUtODg1OS0xMDE3ODMzMjhiZjMiLCJwcnYiOiI0YWMwNWMwZjhhYzA4ZjM2NGNiNGQwM2ZiOGUxZjYzMWZlYzMyMmU4In0.a8XqHaj-CdnbXK8YHwQ0-r-xOtGzyz6ySnNDLwUUDCI';

                    var token = prefs.getString('auth_token');
                    final response = await http.post(
                      url,
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                      },
                    );

                    if (response.statusCode == 200) {
                      Get.toNamed('login');
                      final data = jsonDecode(response.body);
                      print(data.toString());
                      return data;
                    } else {
                      print('Failed to get user info: ${response.statusCode}');
                      throw Exception('logout failed');
                    }
                    //Get.to(EditProfileScreen());
                    print("dfdfdfdfdfdfdfdfdf");
                    // final prefs = await SharedPreferences.getInstance();
                    // var token = prefs.getString('auth_token');

                    // context.read<ProfileCubit>().getUserData(token!);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6F4EC9),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title,
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget settingsTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
