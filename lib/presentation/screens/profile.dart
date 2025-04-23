import 'package:breaking_project/presentation/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                onPressed: () {
                  Get.to(EditProfileScreen());
                },
                child: Text(
                  "Edit Profile",
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Color(0xFF6F4EC9),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
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
