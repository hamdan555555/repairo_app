// import 'package:breaking_project/core/constants/app_constants.dart';
// import 'package:breaking_project/data/models/items_model.dart';
// import 'package:breaking_project/data/models/service_model.dart';
// import 'package:breaking_project/presentation/screens/services_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ServicesWidget extends StatefulWidget {
//   final RServiceData services;
//   final int indexx;
//   final void Function(String serviceId, bool selected) onToggle;

//   const ServicesWidget({
//     super.key,
//     required this.services,
//     required this.indexx,
//     required this.onToggle,
//   });

//   @override
//   State<ServicesWidget> createState() => _ServicesWidgetState();
// }

// class _ServicesWidgetState extends State<ServicesWidget> {
//   bool isSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           // Get.to(
//           //   () => BlocProvider(
//           //     create: (context) => ServiceCubit(
//           //         ServiceRepository(serviceWebservices: ServiceWebservices())),
//           //     child: ServicesScreen(
//           //       id: subcategory.id.toString(),
//           //       subname: subcategory.displayName.toString(),
//           //       videourl: "assets/videos/plumbing.mp4",
//           //     ),
//           //   ),
//           // );
//         },
//         child: Column(
//           children: [
//             // الصورة التي تملأ الجزء العلوي من البطاقة
//             Container(
//               width: 200.w,
//               height: 100.h,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 child: Image.network(
//                   widget.services.image!
//                       .  (widget.services.image!.toString(),
//                           "http://127.0.0.1:8000/storage/images/defaults/service.png")
//                       .  ('127.0.0.1', AppConstants.baseaddress),
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Icon(
//                     Icons.image_not_supported_outlined,
//                     size: 50,
//                     color: Colors.grey.shade400,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4),
//               child: Text(
//                 widget.services.displayName ?? '',
//                 // textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontFamily: "Cairo",
//                   fontSize: 16,
//                 ),
//               ),
//             )
//           ],
//         )
//         // child: Container(
//         //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         //   padding: const EdgeInsets.all(12),
//         //   decoration: BoxDecoration(
//         //     color: Colors.white,
//         //     borderRadius: BorderRadius.circular(16),
//         //     boxShadow: [
//         //       BoxShadow(
//         //         color: Colors.grey.withOpacity(0.15),
//         //         blurRadius: 8,
//         //         offset: const Offset(0, 3),
//         //       ),
//         //     ],
//         //   ),
//         //   child: Row(
//         //     children: [
//         //       // الصورة
//         //       ClipRRect(
//         //         borderRadius: BorderRadius.circular(12),
//         //         child: subcategory.image != null && subcategory.image!.isNotEmpty
//         //             ? Image.network(
//         //                 subcategory.image!
//         //                     .  ('127.0.0.1', AppConstants.baseaddress),
//         //                 width: 70,
//         //                 height: 70,
//         //                 fit: BoxFit.cover,
//         //                 errorBuilder: (context, error, stackTrace) => Icon(
//         //                   Icons.image_not_supported_outlined,
//         //                   size: 50,
//         //                   color: Colors.grey.shade400,
//         //                 ),
//         //               )
//         //             : SvgPicture.asset(
//         //                 'assets/images/svg/home.svg',
//         //                 width: 60,
//         //                 height: 60,
//         //                 color: Colors.grey.shade400,
//         //               ),
//         //       ),
//         //       const SizedBox(width: 16),
//         //       // النص
//         //       Expanded(
//         //         child: Text(
//         //           subcategory.displayName ?? '',
//         //           style: const TextStyle(
//         //             fontSize: 16,
//         //             fontWeight: FontWeight.w600,
//         //           ),
//         //           maxLines: 2,
//         //           overflow: TextOverflow.ellipsis,
//         //         ),
//         //       ),
//         //       const Icon(Icons.arrow_forward_ios_rounded,
//         //           size: 18, color: Colors.grey),
//         //     ],
//         //   ),
//         // ),
//         );
//     //  Card(
//     //   margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//     //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     //   child: Row(
//     //     children: [
//     //       // صورة الخدمة
//     //       Stack(
//     //         children: [
//     //           ClipRRect(
//     //             borderRadius: const BorderRadius.only(
//     //               topLeft: Radius.circular(20),
//     //               bottomLeft: Radius.circular(20),
//     //             ),
//     //             child: Image.network(
//     //               widget.services.image!
//     //                   .  ('127.0.0.1', AppConstants.baseaddress),
//     //               width: 100,
//     //               height: 100,
//     //               fit: BoxFit.cover,
//     //               errorBuilder: (context, error, stackTrace) => Icon(
//     //                 Icons.image_not_supported_outlined,
//     //                 size: 50,
//     //                 color: Colors.grey.shade400,
//     //               ),
//     //             ),

//     //             // Image.asset(
//     //             //   'assets/images/png/worker1.png',
//     //             //   height: 100,
//     //             //   width: 100,
//     //             //   fit: BoxFit.cover,
//     //             // ),
//     //           ),
//     //           Positioned(
//     //             top: 8,
//     //             left: 8,
//     //             child: Container(
//     //               padding:
//     //                   const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     //               decoration: BoxDecoration(
//     //                 color: Colors.deepPurple,
//     //                 borderRadius: BorderRadius.circular(20),
//     //               ),
//     //               child: Text(
//     //                 widget.services.maxPrice!,
//     //                 style: const TextStyle(color: Colors.white),
//     //               ),
//     //             ),
//     //           ),
//     //         ],
//     //       ),

//     //       const SizedBox(width: 16),

//     //       // معلومات الخدمة
//     //       Expanded(
//     //         flex: 3,
//     //         child: Column(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             Row(
//     //               children: List.generate(
//     //                 5,
//     //                 (index) =>
//     //                     const Icon(Icons.star, size: 16, color: Colors.amber),
//     //               ),
//     //             ),
//     //             const SizedBox(height: 4),
//     //             Text(
//     //               widget.services.displayName!,
//     //               style: const TextStyle(
//     //                   fontSize: 16, fontWeight: FontWeight.bold),
//     //             ),
//     //             const SizedBox(height: 4),
//     //             Row(
//     //               children: const [
//     //                 CircleAvatar(
//     //                   radius: 12,
//     //                   backgroundImage:
//     //                       AssetImage("assets/images/png/worker1.png"),
//     //                 ),
//     //                 SizedBox(width: 8),
//     //                 Text("provider"),
//     //               ],
//     //             )
//     //           ],
//     //         ),
//     //       ),

//     //       Padding(
//     //         padding: const EdgeInsets.only(right: 12),
//     //         child: Checkbox(
//     //           value: isSelected,
//     //           shape: const CircleBorder(),
//     //           activeColor: Colors.deepPurple,
//     //           onChanged: (val) {
//     //             setState(() {
//     //               isSelected = val!;
//     //               widget.onToggle(widget.services.id!, isSelected);
//     //             });
//     //           },
//     //         ),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }
// }

import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceItemCard extends StatelessWidget {
  final RServiceData service;
  final int quantity; // الكمية الموجودة بالـ cart
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ServiceItemCard({
    Key? key,
    required this.service,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              service.image!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),

          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.displayName!,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  "العنصر هو مادة كيميائية نقية لا يمكن تجزئتها إلى ما هو أبسط منها كيميائيًا، ويتكون من نوع واحد من الذرات، لكل منها عدد محدد من البروتونات يميزه عن العناصر الأخرى. تُعدّ العناصر الأساس الذي تُبنى عليه جميع المواد في الكون، وتُصنف إلى فلزات وأشباه فلزات ولا فلزات، وتُنظم في الجدول الدوري حسب أعدادها الذرية.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  "${service.maxPrice} ليرة",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // زر أو عداد
          quantity == 0
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: onAdd,
                  child: Text("أضف"),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                    ),
                    Text(
                      "$quantity",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: onIncrement,
                      icon: Icon(Icons.add_circle, color: Colors.green),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
