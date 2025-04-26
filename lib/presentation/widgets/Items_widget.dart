import 'package:breaking_project/data/models/items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemWidget extends StatelessWidget {
  final Services item;
  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 98,
            height: 75,
            child: Transform.scale(
              scale: 0.6,
              child: SvgPicture.asset(
                'assets/images/svg/home.svg',

                // fit: BoxFit.cover,
              ),
            ),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 226, 222, 222),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
          ),
          Container(
            width: 98,
            height: 34,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: const Center(
                child: Text(
              "Smart Home",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          )
        ],
      ),
    );
  }
}
