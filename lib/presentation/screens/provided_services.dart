import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_states.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/data/repository/creating_order_repository.dart';
import 'package:breaking_project/data/web_services/creating_order_webservice.dart';
import 'package:breaking_project/presentation/screens/creating_order.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProvidedServicesScreen extends StatefulWidget {
  final List<String> selectedServices;
  final String techId;
  final String techname;

  const ProvidedServicesScreen(
      {super.key,
      required this.selectedServices,
      required this.techId,
      required this.techname});

  @override
  State<ProvidedServicesScreen> createState() => _ProvidedServicesScreenState();
}

class _ProvidedServicesScreenState extends State<ProvidedServicesScreen> {
  List<RProvidedServices> services = [];
  List<String> selectedServices = [];

  @override
  void initState() {
    context
        .read<ProvidedServicesCubit>()
        .fetchProvidedServices(widget.techId, widget.selectedServices);
    super.initState();
  }

  void toggleServiceSelection(String serviceId, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(serviceId);
        print(selectedServices);
      } else {
        selectedServices.remove(serviceId);
        print(selectedServices);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.techname}'s services ",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6F4EC9),
        centerTitle: true,
      ),
      body: BlocBuilder<ProvidedServicesCubit, ProvidedServicesStates>(
        builder: (context, state) {
          if (state is ProvidedServicesSuccess) {
            services = (state).providedservices;
            selectedServices = widget.selectedServices;
            print(selectedServices);
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = selectedServices.contains(service.id);
                    //final isSelected = service.selected;
                    print(isSelected);

                    return ServiceCard(
                        service: service,
                        isSelected: isSelected!,
                        onToggle: toggleServiceSelection);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomElevatedButton(
                  onpressed: () {
                    Get.to(() => BlocProvider(
                          create: (context) => CreatingOrderCubit(
                              CreatingOrderRepository(
                                  CreatingOrderWebservice())),
                          child: CreateRequestScreen(
                            id: widget.techId,
                            services: widget.selectedServices,
                          ),
                        ));
                  },
                  text: "Next",
                  active: selectedServices.isNotEmpty,
                ),
              )
            ]);
          } else if (state is ProvidedServicesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProvidedServicesError) {
            return Center(child: Text("Error Happened"));
          }
          return Center(child: Text("No Data"));

          //  ListView.builder(
          //   padding: const EdgeInsets.all(16),
          //   itemCount: services.length,
          //   itemBuilder: (context, index) {
          //     final service = services[index];
          //     return Center(child: Text("NO Data"))
          //   },
          // );
        },
      ),
    );
  }
}
