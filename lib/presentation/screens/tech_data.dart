import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/tech_data_model.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/map.dart';
import 'package:breaking_project/presentation/screens/provided_services.dart';
import 'package:breaking_project/presentation/widgets/Provided_service_card.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TechDataScreen extends StatefulWidget {
  final String id;
  TechDataScreen({Key? key, required this.id}) : super(key: key);
  @override
  State<TechDataScreen> createState() => SubcategoriesStatee();
}

class SubcategoriesStatee extends State<TechDataScreen> {
  late RTecPData tech;
  @override
  void initState() {
    print('this is idddd');
    // print(widget.id);
    BlocProvider.of<TechDataCubit>(context).getTechData(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text("technician profile"),
      ),
      body: Container(color: Colors.white10, child: buildBlocWidget()),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<TechDataCubit, TechDataStates>(
        builder: (context, state) {
      if (state is TechDataLoaded) {
        tech = (state).techdata;
        return buildLoadedListWidget();
      } else {
        return showloadingindicator();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return builditemsList();
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: const Color.fromRGBO(95, 96, 185, 1),
    ));
  }

  // Widget builditemsList() {
  //   return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: ListView.builder(
  //         itemCount: context.read<SubcategoryCubit>().subcategories.length,
  //         itemBuilder: (ctx, index) {
  //           return SubcateroriesWidget(
  //             subcategory:
  //                 context.read<SubcategoryCubit>().subcategories[index],
  //           );
  //         },
  //       )
  //       );
  // }

  Widget builditemsList() {
    final displayImage =
        tech.image?.replaceFirst("127.0.0.1", AppConstants.baseaddress) ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الفني
          // Center(
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: tech.image != null
          //         ? NetworkImage(
          //             tech.image!
          //                 .replaceFirst("127.0.0.1", AppConstants.baseaddress),
          //           )
          //         : const AssetImage('assets/images/jpg/hamdan.jpg')
          //             as ImageProvider,
          //     // tech.image != null
          //     //     ? NetworkImage(tech.image!
          //     //         .replaceFirst("127.0.0.1", AppConstants.baseaddress))
          //     //     : AssetImage('assets/images/jpg/hamdan.jpg')
          //   ),
          // ),

          Center(
            child: GestureDetector(
              onTap: () {
                print(tech.image!
                    .replaceFirst('127.0.0.1', AppConstants.baseaddress));

                print(tech.previousWorks![0].image);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: tech.image!.isNotEmpty
                    ? NetworkImage(
                        tech.image!.replaceFirst(
                            '127.0.0.1', AppConstants.baseaddress),
                      )
                    : const AssetImage('assets/images/jpg/hamdan.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // الاسم والتقييم والموقع
          Center(
            child: Column(
              children: [
                Text(
                  tech.name ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("📍 ${tech.place ?? 'غير معروف'}"),
                const SizedBox(height: 8),
                Text("⭐ ${tech.rating ?? '0.0'}"),
                const SizedBox(height: 8),
                Text("التخصص: ${tech.category?.displayName ?? ''}"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // عنوان الأعمال السابقة
          if ((tech.previousWorks?.isNotEmpty ?? false)) ...[
            Text(
              "الأعمال السابقة",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...tech.previousWorks!.map((work) {
              return ProvidedServiceCard(
                title: work.title,
                description: work.description,
                images: work.image,
              );
              // Card(
              //   elevation: 2,
              //   margin: const EdgeInsets.symmetric(vertical: 8),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           work.title ?? '',
              //           style: const TextStyle(
              //               fontSize: 16, fontWeight: FontWeight.w600),
              //         ),
              //         const SizedBox(height: 6),
              //         Text(work.description ?? '',
              //             style: const TextStyle(
              //                 fontSize: 14, color: Colors.grey)),
              //       ],
              //     ),
              //   ),
              // );
            }).toList()
          ] else ...[
            const Text("لا يوجد أعمال سابقة"),
          ],
          CustomElevatedButton(
              onpressed: () {
                // Get.to(MapScreen(
                //     // latitude: 35.5308,
                //     // longitude: 35.7906,
                //     // professionalName: tech.name ?? '',
                //     ));

                Get.to(() => BlocProvider(
                      create: (_) => ProvidedServicesCubit(
                          ProvidedServicesRepository(
                              ProvidedServicesWebservices())),
                      child: ProvidedServicesScreen(
                        techId: tech.id!,
                        selectedServices: [],
                      ),
                    ));
              },
              text: 'view services'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: CustomElevatedButton(
                onpressed: () {
                  Get.to(MapScreen(
                      // latitude: 35.5308,
                      // longitude: 35.7906,
                      // professionalName: tech.name ?? '',
                      ));
                },
                text: 'view on map'),
          )
        ],
      ),
    );
  }
}
