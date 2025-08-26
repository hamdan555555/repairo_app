import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/data/models/searched_services_model.dart';
import 'package:breaking_project/data/repository/services_repository.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';
import 'package:breaking_project/data/web_services/services_webservices.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';
import 'package:breaking_project/presentation/screens/services_screen.dart';
import 'package:breaking_project/presentation/screens/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchingServicesWidget extends StatefulWidget {
  final RSearchedServiceData services;
  final int indexx;
  final void Function(String serviceId, bool selected) onToggle;

  const SearchingServicesWidget(
      {super.key,
      required this.services,
      required this.indexx,
      required this.onToggle});

  @override
  State<SearchingServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<SearchingServicesWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.services.type == 'category') {
          Get.to(
            () => BlocProvider(
              create: (context) => SubcategoryCubit(SubcategoryRepository(
                  subcategoriesWebservice: SubcategoriesWebservice())),
              child: Subcategories(
                id: widget.services.id!,
                catname: widget.services.displayName!,
              ),
            ),
          );
        } else if (widget.services.type == 'sub_category') {
          Get.to(
            () => BlocProvider(
              create: (context) => ServiceCubit(
                  ServiceRepository(serviceWebservices: ServiceWebservices())),
              child: ServicesScreen(
                id: widget.services.id!,
                videourl: "assets/videos/plumbing.mp4",
                subname: widget.services.displayName!,
              ),
            ),
          );
        } else {
          // Get.to(
          //   () => BlocProvider(
          //     create: (context) => ServiceCubit(
          //         ServiceRepository(serviceWebservices: ServiceWebservices())),
          //     child: ServicesScreen(
          //       id: widget.,
          //       videourl: "assets/videos/plumbing.mp4",
          //       subname: widget.services.displayName!,
          //     ),
          //   ),
          // );
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 90.h,
            child: Card(
              // color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // صورة الخدمة
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Image.asset(
                        'assets/images/png/worker1.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // معلومات الخدمة
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.services.displayName!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            Text(
                              "تنظيف المكيفات",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  "50.000 ليرة",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo"),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "80.000 ليرة",
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo"),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Icon(
                                  Icons.timer_sharp,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                Text(
                                  "70 دقائق",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
