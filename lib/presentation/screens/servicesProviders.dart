import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/data/models/searched_services_providers_model.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/provided_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredTechniciansScreen extends StatefulWidget {
  final List<String> selectedservices;
  const FilteredTechniciansScreen({
    super.key,
    required this.selectedservices,
  });

  @override
  State<FilteredTechniciansScreen> createState() =>
      _FilteredTechniciansScreenState();
}

class _FilteredTechniciansScreenState extends State<FilteredTechniciansScreen> {
  late var techs;
  @override
  void initState() {
    context.read<HomeCubit>().getServicesProviders(widget.selectedservices);
    print(
        "hereeeeebb ${context.read<HomeCubit>().getServicesProviders(widget.selectedservices)}");
    print("we'll start nowwww");
    context.read<ProvidedServicesCubit>().fetchProvidedServices(
        'f06cc4dd-6c00-4801-94c9-5433fbfb9c3a',
        ['9ef4d40e-9802-428c-b5af-9c7e171693d6']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("selected services providers"),
          backgroundColor: Colors.deepPurple,
        ),
        body: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            if (state is SearchServicesProvidersSuccess) {
              techs = state.servicesproviders;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: techs.length,
                itemBuilder: (context, index) {
                  final techh = techs[index];
                  return buildTechCard(techh);
                },
              );
            } else if (state is SearchServicesProvidersLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
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
        ));
  }

  Widget buildTechCard(RSearchesServiceProvidersData tech) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  techId: tech.id!,
                  selectedServices: widget.selectedservices,
                ),
              ));
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/images/jpg/hamdan.jpg"),
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
