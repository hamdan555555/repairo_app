import 'package:breaking_project/presentation/widgets/login_form.dart';
import 'package:breaking_project/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupForm(),
    );
  }
}
