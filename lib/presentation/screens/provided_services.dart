import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_states.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/presentation/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvidedServicesScreen extends StatefulWidget {
  final List<String> selectedServices;
  final String techId;

  const ProvidedServicesScreen(
      {super.key, required this.selectedServices, required this.techId});

  @override
  State<ProvidedServicesScreen> createState() => _ProvidedServicesScreenState();
}

class _ProvidedServicesScreenState extends State<ProvidedServicesScreen> {
  List<RProvidedServices> services = [];

  @override
  void initState() {
    context
        .read<ProvidedServicesCubit>()
        .fetchProvidedServices(widget.techId, widget.selectedServices);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خدماتي', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6F4EC9),
        centerTitle: true,
      ),
      body: BlocBuilder<ProvidedServicesCubit, ProvidedServicesStates>(
        builder: (context, state) {
          if (state is ProvidedServicesSuccess) {
            services = (state).providedservices;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceCard(service: service);
              },
            );
          } else if (state is ProvidedServicesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProvidedServicesError) {
            return Center(child: Text("Error Happened"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ServiceCard(service: service);
            },
          );
        },
      ),
    );
  }
}
