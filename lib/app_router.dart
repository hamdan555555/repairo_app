// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/SignupCubit/signup_cubit.dart';
import 'package:breaking_project/business_logic/VerifyCubit/verification_cubit.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/repository/signup_repository.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/data/repository/verification_repository.dart';
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/data/web_services/signup_webservices.dart';
import 'package:breaking_project/data/web_services/verification_webservices.dart';
import 'package:breaking_project/presentation/screens/edit_profile.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/login_screen.dart';
import 'package:breaking_project/presentation/screens/main_screen.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/signup_screen.dart';
import 'package:breaking_project/presentation/screens/test.dart';
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:breaking_project/presentation/widgets/service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:breaking_project/business_logic/ItemsCubit/items_cubit.dart';
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
      // case charecters_screen:
      //   return MaterialPageRoute(
      //       builder: (_) => BlocProvider(
      //             create: (context) => itemsCubit,
      //             child: ItemsScreen(),
      //           ));

      case charecters_details_screen:
        return MaterialPageRoute(builder: (_) => ItemsDetailsScreen());

      // case '/':
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: LoginCubit(AuthRepository(AuthWebService())),
      //       child: LoginScreen(),
      //     ),
      //   );

      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: SignupCubit(SignupRepository(SignupWebservices())),
            child: SignupScreen(),
          ),
        );

      case 'verification':
        return MaterialPageRoute(builder: (_) => Verification());

      case 'banner':
        return MaterialPageRoute(builder: (_) => BannerSlider());

      case 'service':
        return MaterialPageRoute(builder: (_) => ServiceWidget());

      case 'editprofile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case 'homepage':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: SignupCubit(SignupRepository(SignupWebservices())),
                  child: HomePage(),
                ));

      case 'login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: LoginCubit(AuthRepository(AuthWebService())),
                  child: LoginScreen(),
                ));

      // case 'mainscreen':
      //   return MaterialPageRoute(builder: (_) => MainScreen());

      case 'home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => itemsCubit..getAllItems(),
                  child: BannerSlider(),
                ));

      case 'profile':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      ProfileCubit(ProfileRepository(ProfileWebservices()))
                        ..getUserData('anytoken'),
                  child: ProfileScreen(),
                ));

      case 'verify':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => VerificationCubit(
                      VerificationRepository(VerificationWebservices())),
                  child: Verification(),
                ));
    }
  }
}
