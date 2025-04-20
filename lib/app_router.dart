// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:breaking_project/business_logic/cubit/items_cubit.dart';
import 'package:breaking_project/constants/strings.dart';
import 'package:breaking_project/data/repository/items_repository.dart';
import 'package:breaking_project/presentation/screens/items_details_screen.dart';
import 'package:breaking_project/presentation/screens/items_screen.dart';

class AppRouter {
  late ItemsRepository itemsRepository;
  late ItemsCubit itemsCubit;

  AppRouter() {
    itemsRepository = ItemsRepository(itemsWebservices: ItemsWebservices());
    itemsCubit = ItemsCubit(itemsRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charecters_screen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => itemsCubit,
                  child: ItemsScreen(),
                ));

      case charecters_details_screen:
        return MaterialPageRoute(builder: (_) => ItemsDetailsScreen());
    }
  }
}
