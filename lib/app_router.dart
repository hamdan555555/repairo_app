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
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:breaking_project/business_logic/ServicesCubit/services_cubit.dart';
import 'package:breaking_project/data/repository/items_repository.dart';

class AppRouter {
  late ServicesRepository servicesRepository;
  late ServicesCubit servicesCubit;

  AppRouter() {
    servicesRepository =
        ServicesRepository(servicesWebservices: ServicesWebservices());
    servicesCubit = ServicesCubit(servicesRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: SignupCubit(SignupRepository(SignupWebservices())),
            child: SignupScreen(),
          ),
        );

      case 'editprofile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case 'mainscreen':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: SignupCubit(SignupRepository(SignupWebservices())),
                  child: MainScreen(),
                ));

      case 'login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: LoginCubit(AuthRepository(AuthWebService())),
                  child: LoginScreen(),
                ));

      case 'home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => servicesCubit..getAllItems(),
                  child: const HomeScreen(),
                ));

      case 'profile':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      ProfileCubit(ProfileRepository(ProfileWebservices()))
                        ..getUserData('anytoken'),
                  child: ProfileScreen(),
                ));

      case 'verification':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => VerificationCubit(
                      VerificationRepository(VerificationWebservices())),
                  child: Verification(),
                ));
    }
  }
}
