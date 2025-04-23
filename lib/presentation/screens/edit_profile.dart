import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
                  backgroundImage: AssetImage('assets/images/jpg/hamdan.jpg'),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF6B52AE),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                )
              ],
            ),
            SizedBox(height: 30),
            buildTextField(Icons.person_outline, 'Full Name'),
            SizedBox(height: 16),
            buildTextField(
              Icons.mail_outline,
              'Email',
            ),
            SizedBox(height: 16),
            buildTextField(Icons.phone_outlined, 'Contact Number'),
            SizedBox(height: 16),
            buildDropdownField('Select Country'),
            SizedBox(height: 16),
            buildTextField(
              Icons.location_on_outlined,
              'Address',
            ),
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
                onPressed: () {},
                child: Text('Save',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hint, {String? initialValue}) {
    return TextFormField(
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
