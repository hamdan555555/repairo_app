import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_states.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/data/models/service_model.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text("Services"),
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

  Widget builditemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: context.read<ServiceCubit>().services.length,
        itemBuilder: (ctx, index) {
          return ServicesWidget(
            services: context.read<ServiceCubit>().services[index],
          );
        },
      ),
    );
  }
}
