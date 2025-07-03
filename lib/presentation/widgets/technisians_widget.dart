import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/searched_technicians_model.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';
import 'package:breaking_project/presentation/screens/tech_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TechnisiansWidget extends StatelessWidget {
  final RSearchedTechsData technisians;
  const TechnisiansWidget({super.key, required this.technisians});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("hereeeee is agaaaaaain ${technisians.id}");
        Get.to(() => BlocProvider(
              create: (context) => TechDataCubit(TechnicianDataRepository(
                  technicianDataWebservices: TechnicianDataWebservices())),
              child: TechDataScreen(id: technisians.account!.id!),
            ));
      },
      // onTap: () {
      //   Get.to(
      //     () => BlocProvider(
      //       create: (context) => TechDataCubit(TechnicianDataRepository(
      //           technicianDataWebservices: TechnicianDataWebservices())),
      //       child: TechDataScreen(id: technisians.id!),
      //     ),
      //   );
      // },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile image
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: technisians.account!.image!.isNotEmpty
                    ? Image.network(
                        technisians.account!.image!.replaceFirst(
                            '127.0.0.1', AppConstants.baseaddress),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 30),
                          );
                        },
                      )
                    : Image.network(
                        'https://via.placeholder.com/100x100.png?text=No+Image',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 30),
                          );
                        },
                      )),
            const SizedBox(width: 16),
            // Name and phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    technisians.account!.name ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    technisians.phone ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
