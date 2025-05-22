import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/data/models/searched_services_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/servicesProviders.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/searching_services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchedServ extends StatefulWidget {
  SearchedServ({super.key});
  @override
  State<SearchedServ> createState() => _SearchedServState();
}

class _SearchedServState extends State<SearchedServ> {
  List<RSearchedServiceData> searchresult = [];

  List<String> selectedServices = [];

  void toggleServiceSelection(String service, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(service);
      } else {
        selectedServices.removeWhere((element) => element == service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white10, child: buildBlocWidget());
  }

  Widget buildBlocWidget() {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      if (state is SearchServicesHomeSuccess) {
        searchresult = (state).servicessearchresult;
        return buildLoadedListWidget();
      } else if (state is SearchServicesHomeLoading) {
        return showloadingindicator();
      } else if (state is SearchTechsHomeFailed) {
        return Center(
          child: Text("NO Result !"),
        );
      } else {
        return buildLoadedListWidget();
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

  Widget builditemsList() {
    return SingleChildScrollView(
      child: Column(children: [
        ListView.builder(
          // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: searchresult.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: SearchingServicesWidget(
                onToggle: toggleServiceSelection,
                indexx: index,
                services: searchresult[index],
              ),
            );
          },
        ),
        Visibility(
          visible: searchresult.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: CustomElevatedButton(
                        active: selectedServices.isNotEmpty,
                        onpressed: selectedServices.isNotEmpty ? () {} : () {},
                        text: 'order now')),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlocConsumer<HomeCubit, HomeStates>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return CustomElevatedButton(
                          active: selectedServices.isNotEmpty,
                          onpressed: selectedServices.isNotEmpty
                              ? () {
                                  print(selectedServices);
                                  Get.to(() => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => HomeCubit(
                                              HomeRepository(
                                                  homeWebservices:
                                                      HomeWebservices()),
                                            ),
                                          ),
                                          BlocProvider(
                                            create: (context) =>
                                                ProvidedServicesCubit(
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
                          text: 'Next');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: searchresult.isNotEmpty,
          child: SizedBox(
            height: 15,
          ),
        ),
      ]),
    );
  }
}
