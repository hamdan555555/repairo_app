import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/data/models/searched_services_model.dart';
import 'package:breaking_project/data/repository/services_repository.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';
import 'package:breaking_project/data/web_services/services_webservices.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';
import 'package:breaking_project/presentation/screens/searched_services.dart';
import 'package:breaking_project/presentation/screens/services_screen.dart';
import 'package:breaking_project/presentation/screens/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              child: Subcategories(id: widget.services.id!),
            ),
          );
        } else if (widget.services.type == 'sub_category') {
          onTap:
          () {
            Get.to(
              () => BlocProvider(
                create: (context) => ServiceCubit(ServiceRepository(
                    serviceWebservices: ServiceWebservices())),
                child: ServicesScreen(id: widget.services.id!),
              ),
            );
          };
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            // صورة الخدمة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/png/worker1.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.services.type!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // معلومات الخدمة
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.services.displayName!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            AssetImage("assets/images/png/worker1.png"),
                      ),
                      SizedBox(width: 8),
                      Text("provider"),
                    ],
                  )
                ],
              ),
            ),

            Visibility(
              visible: widget.services.type == 'service',
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Checkbox(
                  value: isSelected,
                  shape: const CircleBorder(), // خلي شكلها دائرة
                  activeColor: Colors.deepPurple,

                  onChanged: (val) {
                    setState(() {
                      isSelected = val!;
                      //final cubit = context.read<HomeCubit>();
                      widget.onToggle(widget.services.id!, isSelected);

                      // SearchedServ.toggleServiceSelection(
                      //     widget.services.id!, isSelected);
                      // cubit.toggleServiceSelection(
                      //     widget.services.id!, isSelected);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
