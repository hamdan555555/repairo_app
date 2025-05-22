import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/data/repository/categories_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/web_services/categories_webservices.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/map.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late PermissionStatus _permissionGranted;
  // LocationData? currentLocation;
  // final Location location = Location();

  // Future<void> getLocation() async {
  //   bool _serviceEnabled;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) return;
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) return;
  //   }

  //   final loc = await location.getLocation();
  //   setState(()  {
  //     currentLocation = loc;
  //     // final prefs = await SharedPreferences.getInstance();
  //     // await prefs.setString('lat', currentLocation!.latitude.toString());
  //     // await prefs.setString('lng', currentLocation!.longitude.toString());
  //   });
  // }

  int _selectedIndex = 0;

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // getLocation();

    super.initState();

    _pages = [
      const HomeScreen(),
      const SearchScreen(),
      MapScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AllcategoriesCubit(CategoriesRepository(
              categoriesWebservices: CategoriesWebservices())),
        ),
        BlocProvider(
          create: (_) =>
              HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromRGBO(95, 96, 185, 1),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
