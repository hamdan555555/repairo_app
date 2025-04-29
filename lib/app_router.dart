import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/SignupCubit/signup_cubit.dart';
import 'package:breaking_project/business_logic/VerifyCubit/verification_cubit.dart';
import 'package:breaking_project/data/repository/categories_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/repository/signup_repository.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/data/repository/verification_repository.dart';
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:breaking_project/data/web_services/categories_webservices.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/data/web_services/signup_webservices.dart';
import 'package:breaking_project/data/web_services/verification_webservices.dart';
import 'package:breaking_project/presentation/screens/allcategories.dart';
import 'package:breaking_project/presentation/screens/edit_profile.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/login_screen.dart';
import 'package:breaking_project/presentation/screens/main_screen.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/search.dart';
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

      // case 'search':
      //   return MaterialPageRoute(builder: (_) => SearchScreen());

      case 'mainscreen':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: HomeCubit(
                      HomeRepository(homeWebservices: HomeWebservices())),
                  child: MainScreen(),
                ));

      case 'search':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: HomeCubit(
                      HomeRepository(homeWebservices: HomeWebservices())),
                  child: SearchScreen(),
                ));

      case 'login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: LoginCubit(AuthRepository(AuthWebService())),
                  child: LoginScreen(),
                ));

      case 'allcategories':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: AllcategoriesCubit(CategoriesRepository(
                      categoriesWebservices: CategoriesWebservices())),
                  child: const Allcategories(),
                ));

      case 'home':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ServicesCubit>(
                create: (context) => servicesCubit..getAllItems(),
              ),
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                    HomeRepository(homeWebservices: HomeWebservices()))
                  ..getBannerImages(''),
              ),
              // ضيف قد ما بدك BlocProviders تانيين
            ],
            child: const HomeScreen(),
          ),
        );

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
