import 'package:breaking_project/business_logic/SignupCubit/signup_cubit.dart';
import 'package:breaking_project/business_logic/SignupCubit/signup_states.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          print("oooooooooooooooooooooooohhhhhhhh");
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

        if (state is SignupError) {
          Get.snackbar("Error", state.message,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/svg/User.svg'),
                  SizedBox(
                    height: 15,
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
                    height: 35,
                  ),
                  CustomTextFormField(
                    isPass: false,
                    controller: context.read<SignupCubit>().firstnamecontroller,
                    hinttext: 'First Name',
                    suffixicon: const Icon(Icons.person),
                    keybordtype: TextInputType.name,
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    isPass: false,
                    controller: context.read<SignupCubit>().lastnamecontroller,
                    hinttext: 'Last Name',
                    suffixicon: const Icon(Icons.person),
                    keybordtype: TextInputType.name,
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    isPass: false,
                    controller: context.read<SignupCubit>().phonecontroller,
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
                    height: 20,
                  ),
                  CustomTextFormField(
                    isPass: false,
                    controller: context.read<SignupCubit>().emailcontroller,
                    hinttext: 'Email Address',
                    suffixicon: const Icon(Icons.email),
                    keybordtype: TextInputType.emailAddress,
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    isPass: context.read<SignupCubit>().hide,
                    controller: context.read<SignupCubit>().passwordcontroller,
                    hinttext: "Password",
                    suffixicon: IconButton(
                      onPressed: () {
                        context.read<SignupCubit>().togglePassHide();
                      },
                      icon: !context.read<SignupCubit>().hide
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    ),
                    keybordtype: TextInputType.visiblePassword,
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: CustomElevatedButton(
                        text: 'Signup',
                        onpressed: () {
                          print("ddfdfdfdf");
                          context.read<SignupCubit>().signup(
                              context.read<SignupCubit>().phonecontroller.text,
                              context
                                  .read<SignupCubit>()
                                  .passwordcontroller
                                  .text,
                              'any',
                              'thing');
                        }),
                  ),
                  if (state is SignupError)
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
