import 'package:breaking_project/business_logic/ServicesCubit/services_cubit.dart';
import 'package:breaking_project/data/repository/items_repository.dart';
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServicesCubit(
          ServicesRepository(servicesWebservices: ServicesWebservices()))
        ..getAllItems(),
      child: Scaffold(
        appBar: AppBar(title: Text("Items")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) =>
                    context.read<ServicesCubit>().searchProducts(query),
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ServicesCubit, ServicesStates>(
                builder: (context, state) {
                  if (state is ServicesInitial)
                    return Center(child: CircularProgressIndicator());
                  if (state is ServicesLoaded) {
                    return ListView.builder(
                      itemCount: state.services.length,
                      itemBuilder: (_, index) => ListTile(
                        title: Text(state.services[index].description),
                      ),
                    );
                  }
                  if (state is ServicesFailed)
                    return Center(child: Text("error happened"));
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
