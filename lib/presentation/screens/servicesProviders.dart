import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/searched_services_providers_model.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/provided_services.dart';
import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredTechniciansScreen extends StatefulWidget {
  final List<String> selectedservices;
  final Cart? cart;
  final String? date;
  final String? time;
  const FilteredTechniciansScreen(
      {super.key,
      required this.selectedservices,
      required this.cart,
      required this.time,
      required this.date});

  @override
  State<FilteredTechniciansScreen> createState() =>
      _FilteredTechniciansScreenState();
}

class _FilteredTechniciansScreenState extends State<FilteredTechniciansScreen> {
  late List<RSearchesServiceProvidersData> techs;
  @override
  void initState() {
    context.read<HomeCubit>().getServicesProviders(widget.selectedservices);
    print(
        "hereeeeebb ${context.read<HomeCubit>().getServicesProviders(widget.selectedservices)}");
    print("we'll start nowwww");
    // context.read<ProvidedServicesCubit>().fetchProvidedServices(
    //     'f06cc4dd-6c00-4801-94c9-5433fbfb9c3a',
    //     ['9ef4d40e-9802-428c-b5af-9c7e171693d6']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is SearchServicesProvidersSuccess) {
            techs = state.servicesproviders;
            return Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade500,
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: techs.length,
                        itemBuilder: (context, index) {
                          final techh = techs[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // selectedIndex = index;
                                Get.to(() => BlocProvider(
                                      create: (_) => ProvidedServicesCubit(
                                          ProvidedServicesRepository(
                                              ProvidedServicesWebservices())),
                                      child: ProvidedServicesScreen(
                                          time: widget.time!,
                                          date: widget.date!,
                                          cart: widget.cart!,
                                          techId: techh.id!,
                                          selectedServices:
                                              widget.selectedservices,
                                          techname: techh.name!),
                                    ));
                              });
                            },
                            child: Container(
                              width: 140,
                              height: 160,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.teal, width: 2),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.teal.shade100,
                                    radius: 35,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(techh.image!
                                          .replaceFirst("127.0.0.1",
                                              AppConstants.baseaddress)),
                                      // const AssetImage(
                                      //     "assets/images/jpg/pro.jpg"),
                                      backgroundColor: Colors.teal.shade100,
                                      radius: 30,
                                      child: null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text("${techh.name}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Cairo"),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  // if (recommended && !auto)

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(techh.rating!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Cairo")),
                                          Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amber,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // if (auto)
                                  //   const Text(
                                  //     "سنقوم بتعيين أفضل محترف متوفر",
                                  //     style: TextStyle(fontSize: 12, fontFamily: "Cairo"),
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                ],
                              ),
                            ),
                          );

                          //buildTechCard(techh);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is SearchServicesProvidersLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          } else if (state is SearchServicesProvidersFailed) {
            return Center(child: Text("Error Happened"));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: techs.length,
            itemBuilder: (context, index) {
              final techh = techs[index];
              return buildTechCard(techh);
            },
          );
        },
      )),
    );
  }

  Widget buildTechCard(RSearchesServiceProvidersData tech) {
    return Card(
      //elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        onTap: () {
          // Get.to(() => BlocProvider(
          //       create: (_) => TechDataCubit(TechnicianDataRepository(
          //           technicianDataWebservices: TechnicianDataWebservices())),
          //       child: TechDataScreen(id: tech.id!),
          //     ));

          Get.to(() => BlocProvider(
                create: (_) => ProvidedServicesCubit(
                    ProvidedServicesRepository(ProvidedServicesWebservices())),
                child: ProvidedServicesScreen(
                    date: widget.date!,
                    time: widget.time!,
                    cart: widget.cart!,
                    techId: tech.id!,
                    selectedServices: widget.selectedservices,
                    techname: tech.name!),
              ));
        },
        leading: CircleAvatar(
          backgroundImage: tech.image!.isNotEmpty
              ? NetworkImage(
                  tech.image!
                      .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                )
              : const AssetImage('assets/images/jpg/hamdan.jpg'),

          // Image.network(tech.image!.replaceFirst("127.0", to)) as ImageProvider,
        ),
        title: Text(tech.name ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text("Category: ${tech.name ?? "Unknown"}"),
            if (tech.rating != null) Text("Rating: ${tech.rating!.toString()}"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
