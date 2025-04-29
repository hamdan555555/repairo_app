import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/business_logic/LoginCubit/login_states.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
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

        if (state is LoginError) {
          Get.snackbar("Error", state.message,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 97),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/User.svg',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Hello User !",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Welcome Back, you have been ",
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    "missed for long Time ",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  CustomTextFormField(
                    isPass: false,
                    controller: context.read<LoginCubit>().phoneController,
                    hinttext: 'Phone Number',
                    suffixicon: const Icon(Icons.phone_android_rounded),
                    keybordtype: TextInputType.phone,
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: context.read<LoginCubit>().rememberMe,
                          onChanged: (bool? newValue) {
                            context
                                .read<LoginCubit>()
                                .toggleRememberMe(newValue ?? false);
                          },
                          activeColor: const Color.fromRGBO(95, 96, 185, 1),
                          checkColor: Colors.white,
                        ),
                        const Text("Remember Me"),
                        const SizedBox(
                          width: 80,
                        ),
                        GestureDetector(
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: const Color.fromRGBO(95, 96, 185, 1)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: CustomElevatedButton(
                        text: 'Login',
                        onpressed: () async {
                          context.read<LoginCubit>().login(
                              context.read<LoginCubit>().phoneController.text);
                        }),
                  ),
                  if (state is LoginError)
                    Text(state.message,
                        style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
