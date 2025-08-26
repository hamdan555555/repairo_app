import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/tech_data_model.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/map.dart';
import 'package:breaking_project/presentation/screens/provided_services.dart';
import 'package:breaking_project/presentation/screens/tech_prevwork_details.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TechDataScreen extends StatefulWidget {
  final String id;
  TechDataScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<TechDataScreen> createState() => _TechDataScreenState();
}

class _TechDataScreenState extends State<TechDataScreen> {
  late RTecPData tech;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TechDataCubit>(context).getTechData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Text(
            "الملف الشخصي للمهني",
            style: TextStyle(
                fontFamily: "Cairo", color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: BlocBuilder<TechDataCubit, TechDataStates>(
          builder: (context, state) {
            if (state is TechDataLoaded) {
              tech = state.techdata;
              return buildProfileContent();
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileContent() {
    final displayImage =
        tech.image?.replaceFirst("127.0.0.1", AppConstants.baseaddress) ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Card معلومات المهني
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        tech.image != null && tech.image!.isNotEmpty
                            ? NetworkImage(displayImage)
                            : const AssetImage('assets/images/jpg/hamdan.jpg')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tech.name ?? '',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo"),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.teal,
                        size: 16,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("العنوان :  ${tech.place ?? "غير معروف"}",
                          style: const TextStyle(fontFamily: "Cairo")),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.teal,
                        size: 16,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("التقييم :  ${tech.rating ?? "0.0"}",
                          style: const TextStyle(fontFamily: "Cairo")),
                      // const SizedBox(width: 4),
                      // const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.teal,
                        size: 16,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("التخصص :  ${tech.category?.displayName ?? ''}",
                          style: const TextStyle(fontFamily: "Cairo")),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // الأعمال السابقة (بورتفوليو)
          if ((tech.previousWorks?.isNotEmpty ?? false)) ...[
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "الأعمال السابقة",
                style: const TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tech.previousWorks!.map((work) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(work.title!,
                            style: const TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          work.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: "Cairo"),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: work.image!.map((imgUrl) {
                              final fixedUrl = imgUrl.replaceFirst(
                                  "127.0.0.1", AppConstants.baseaddress);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(fixedUrl,
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.cover),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => WorkDetailsPage(work: work));
                            },
                            child: const Text("عرض التفاصيل",
                                style: TextStyle(
                                    fontFamily: "Cairo", color: Colors.teal)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            const Text("لا يوجد أعمال سابقة",
                style: TextStyle(fontFamily: "Cairo")),
          ],

          const SizedBox(height: 24),

          // الأزرار
          CustomElevatedButton(
              onpressed: () {
                Get.to(() => BlocProvider(
                      create: (_) => ProvidedServicesCubit(
                          ProvidedServicesRepository(
                              ProvidedServicesWebservices())),
                      child: ProvidedServicesScreen(
                          techId: tech.id!, techname: tech.name!),
                    ));
              },
              text: 'عرض الخدمات'),
          // const SizedBox(height: 12),
          // CustomElevatedButton(
          //     onpressed: () {
          //       Get.to(MapScreen());
          //     },
          //     text: 'عرض على الخريطة'),
        ],
      ),
    );
  }
}
