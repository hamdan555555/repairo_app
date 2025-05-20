import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/VerifyCubit/verification_cubit.dart';
import 'package:breaking_project/data/repository/categories_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/data/repository/technicians_repository.dart';
import 'package:breaking_project/data/repository/verification_repository.dart';
import 'package:breaking_project/data/web_services/categories_webservices.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/data/web_services/technicians_webservices.dart';
import 'package:breaking_project/data/web_services/verification_webservices.dart';
import 'package:breaking_project/presentation/screens/allcategories.dart';
import 'package:breaking_project/presentation/screens/edit_profile.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/login_screen.dart';
import 'package:breaking_project/presentation/screens/main_screen.dart';
import 'package:breaking_project/presentation/screens/map.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/providers.dart';
import 'package:breaking_project/presentation/screens/search.dart';
import 'package:breaking_project/presentation/screens/servicesProviders.dart';
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CategoriesRepository categoriesRepository;
  late AllcategoriesCubit allcategoriesCubit;

  AppRouter() {
    categoriesRepository =
        CategoriesRepository(categoriesWebservices: CategoriesWebservices());
    allcategoriesCubit = AllcategoriesCubit(categoriesRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'editprofile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      // case 'map':
      //   return MaterialPageRoute(builder: (_) => MapScreen());

      case 'providers':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AllcategoriesCubit>(
                create: (context) => allcategoriesCubit,
              ),
              BlocProvider<AlltechnisianCubit>(
                create: (context) => AlltechnisianCubit(TechniciansRepository(
                    techniciansWebservices: TechniciansWebservices())),
              ),
            ],
            // create: (_) => AlltechnisianCubit(TechniciansRepository(
            //     techniciansWebservices: TechniciansWebservices())),
            child: FilterScreen(),
          ),
        );

      case 'mainscreen':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AllcategoriesCubit>(
                create: (context) => allcategoriesCubit,
              ),
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                    HomeRepository(homeWebservices: HomeWebservices()))
                  ..getBannerImages(''),
              ),
            ],
            child: MainScreen(),
          ),
        );

      case 'search':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
            child: const SearchScreen(),
          ),
        );

      case 'login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginCubit(AuthRepository(AuthWebService())),
            child: const LoginScreen(),
          ),
        );

      // case 'servproviders':
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) =>
      //           HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
      //       child: const FilteredTechniciansScreen(),
      //     ),
      //   );

      case 'allcategories':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AllcategoriesCubit(CategoriesRepository(
                categoriesWebservices: CategoriesWebservices())),
            child: const Allcategories(),
          ),
        );

      case 'home':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AllcategoriesCubit>(
                create: (context) => allcategoriesCubit..getAllCategories(),
              ),
              BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                    HomeRepository(homeWebservices: HomeWebservices()))
                  ..getBannerImages(''),
              ),
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
    return null;
  }
}
