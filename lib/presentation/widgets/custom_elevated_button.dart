import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {required this.onpressed,
      required this.text,
      this.active = true,
      this.color});

  void Function()? onpressed;
  final String text;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: active && color == null
              ? Colors.teal
              : active == false
                  ? Colors.grey
                  : color ?? Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onpressed,
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
