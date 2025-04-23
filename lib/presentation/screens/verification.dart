import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Verification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 4, right: 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  const Text(
                    "Verification code",
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 95),
                child: Column(
                  children: [
                    Text(
                      "we texted you a code",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("please enter it below :",
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              OtpTextField(
                cursorColor: const Color.fromRGBO(95, 96, 185, 1),
                borderRadius: BorderRadius.circular(10),
                numberOfFields: 5,
                borderColor: const Color.fromRGBO(95, 96, 185, 1),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
              const SizedBox(
                height: 40,
              ),
              const Text("this helps us verify every user in the"),
              const Text("system"),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Didn't get a code ?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              const SizedBox(
                height: 70,
              ),
              CustomElevatedButton(onpressed: () {}, text: 'Confirm')
            ],
          ),
        ),
      ),
    );
  }
}
