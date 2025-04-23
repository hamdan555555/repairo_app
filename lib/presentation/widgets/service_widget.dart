import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: 280,
      height: 311,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              'assets/images/jpg/worker2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              children: [
                RatingStars(
                  starSize: 14,
                  starSpacing: 6,
                  starCount: 5,
                  starColor: Colors.amber,
                  starOffColor: Colors.amber,
                  valueLabelVisibility: false,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '4.3',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              "Fixing Anroid Smart Devices Around",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Interior And Wiring",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Mohamed Yousef",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );

    // Container(
    //   decoration: const BoxDecoration(
    //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
    //   width: 335,
    //   height: 160,
    //   child: Image.asset(
    //     'assets/images/jpg/worker2.jpg',
    //     fit: BoxFit.fill,
    //   ),
    // ),
    // Container(
    //   width: 335,
    //   height: 120,
    //   decoration: const BoxDecoration(
    //       color: Color.fromARGB(255, 236, 233, 233),
    //       borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(10),
    //           bottomRight: Radius.circular(10))),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: const Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             children: [
    //               RatingStars(
    //                 starSize: 16,
    //                 starSpacing: 6,
    //                 starCount: 5,
    //                 starColor: Colors.amber,
    //                 starOffColor: Colors.amber,
    //                 valueLabelVisibility: false,
    //               ),
    //               SizedBox(
    //                 width: 10,
    //               ),
    //               Text(
    //                 '4.3',
    //                 style: TextStyle(
    //                     fontSize: 16, fontWeight: FontWeight.bold),
    //               )
    //             ],
    //           ),
    //           Text(
    //             "Fixing Anroid Smart Devices Around",
    //             style: TextStyle(fontSize: 20),
    //           ),
    //           Text(
    //             "Interior And Wiring",
    //             textAlign: TextAlign.start,
    //             style: TextStyle(fontSize: 20),
    //           ),
    //           SizedBox(
    //             height: 5,
    //           ),
    //           Row(
    //             children: [
    //               CircleAvatar(
    //                 radius: 14,
    //                 backgroundColor: Colors.black,
    //               ),
    //               SizedBox(
    //                 width: 12,
    //               ),
    //               Text(
    //                 "Mohamed Yousef",
    //                 style: TextStyle(fontSize: 14, color: Colors.grey),
    //               )
    //             ],
    //           ),
    //         ]),
    //   ),
    // ),
  }
}
