import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_states.dart';
import 'package:breaking_project/core/constants/app_colors.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/servicesProviders.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ServicesScreen extends StatefulWidget {
  final String id;
  ServicesScreen({Key? key, required this.id}) : super(key: key);
  @override
  State<ServicesScreen> createState() => ServicesScreenStatee();
}

class ServicesScreenStatee extends State<ServicesScreen> {
  //static List<String> selectedServices = [];
  List<String> selectedServices = [];

  void toggleServiceSelection(String service, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(service);
      } else {
        selectedServices.remove(service);
      }
    });
  }

  late List<RServiceData> services;
  final searchTextController = TextEditingController();
  late String subcategoryname;

  late String id;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ServiceCubit>(context).getServices(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: Row(
          children: [
            Expanded(
                child: CustomElevatedButton(
                    active: selectedServices.isNotEmpty,
                    onpressed: selectedServices.isNotEmpty
                        ? () {
                            // print(selectedServices);
                            // Get.to(() => MultiBlocProvider(
                            //       providers: [
                            //         BlocProvider(
                            //           create: (context) => HomeCubit(
                            //             HomeRepository(
                            //                 homeWebservices: HomeWebservices()),
                            //           ),
                            //           // child: FilteredTechniciansScreen(
                            //           //   selectedservices: selectedServices,
                            //           // ),
                            //         ),
                            //         BlocProvider(
                            //           create: (context) => ProvidedServicesCubit(
                            //               ProvidedServicesRepository(
                            //                   ProvidedServicesWebservices())),
                            //         ),
                            //       ],
                            //       child: FilteredTechniciansScreen(
                            //         selectedservices: selectedServices,
                            //       ),
                            //     ));
                          }
                        : () {},
                    text: 'order')),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: CustomElevatedButton(
                    active: selectedServices.isNotEmpty,
                    onpressed: selectedServices.isNotEmpty
                        ? () {
                            print(selectedServices);
                            Get.to(() => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => HomeCubit(
                                        HomeRepository(
                                            homeWebservices: HomeWebservices()),
                                      ),
                                      // child: FilteredTechniciansScreen(
                                      //   selectedservices: selectedServices,
                                      // ),
                                    ),
                                    BlocProvider(
                                      create: (context) => ProvidedServicesCubit(
                                          ProvidedServicesRepository(
                                              ProvidedServicesWebservices())),
                                    ),
                                  ],
                                  child: FilteredTechniciansScreen(
                                    selectedservices: selectedServices,
                                  ),
                                ));
                          }
                        : () {},
                    text: 'Next')
                // : SizedBox(
                //     width: 335,
                //     height: 45,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.grey,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //       onPressed: () {},
                //       child: Text(
                //         'Next',
                //         style: const TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        title: Text(
          "Services",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(color: Colors.white10, child: buildBlocWidget()),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ServiceCubit, ServiceStates>(builder: (context, state) {
      if (state is ServiceLoaded) {
        services = (state).services;
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
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: GridView.builder(
  //       scrollDirection: Axis.vertical,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 1,
  //         childAspectRatio: 0.8,
  //         crossAxisSpacing: 16,
  //         mainAxisSpacing: 16,
  //       ),
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: context.read<ServiceCubit>().services.length,
  //       itemBuilder: (ctx, index) {
  //         return ServicesWidget(
  //           services: context.read<ServiceCubit>().services[index],
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget builditemsList() {
  //   final services = context.read<ServiceCubit>().services;

  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

  //     itemCount: services.length,
  //     shrinkWrap: true,

  //     //    physics:  NeverScrollableScrollPhysics(), // حتى ما تتعارض مع ScrollView خارجي
  //     itemBuilder: (ctx, index) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 12.0),
  //         child: ServicesWidget(
  //           indexx: index,
  //           services: services[index],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget builditemsList() {
    final services = context.read<ServiceCubit>().services;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ServicesWidget(
            indexx: index,
            services: services[index],
            onToggle: toggleServiceSelection, // ✅ مرّر الدالة هون
          ),
        );
      },
    );
  }
}
