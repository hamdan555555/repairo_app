import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {required this.onpressed, required this.text, this.active = true});

  void Function()? onpressed;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              active ? const Color.fromRGBO(95, 96, 185, 1) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onpressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
