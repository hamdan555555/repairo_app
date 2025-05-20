import 'dart:developer';

import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/subcategory_model.dart';
import 'package:breaking_project/data/repository/services_repository.dart';
import 'package:breaking_project/data/web_services/services_webservices.dart';
import 'package:breaking_project/presentation/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SubcateroriesWidget extends StatelessWidget {
  final RSubCategoryData subcategory;
  const SubcateroriesWidget({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BlocProvider(
            create: (context) => ServiceCubit(
                ServiceRepository(serviceWebservices: ServiceWebservices())),
            child: ServicesScreen(id: subcategory.id.toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // الصورة
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: subcategory.image != null && subcategory.image!.isNotEmpty
                  ? Image.network(
                      subcategory.image!
                          .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/svg/home.svg',
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade400,
                    ),
            ),
            const SizedBox(width: 16),
            // النص
            Expanded(
              child: Text(
                subcategory.displayName ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
