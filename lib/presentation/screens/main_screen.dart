import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/UserRequestsCubit/user_requests_cubit.dart';
import 'package:breaking_project/data/repository/categories_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/repository/technicians_repository.dart';
import 'package:breaking_project/data/repository/user_requests_repository.dart';
import 'package:breaking_project/data/web_services/categories_webservices.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/data/web_services/technicians_webservices.dart';
import 'package:breaking_project/data/web_services/user_requests_webservices.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/map.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/providers.dart';
import 'package:breaking_project/presentation/screens/search.dart';
import 'package:breaking_project/presentation/screens/user_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
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
      FilterScreen(),

      // const SearchScreen(),
      UserRequests(),
      MapScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AllcategoriesCubit(CategoriesRepository(
              categoriesWebservices: CategoriesWebservices())),
        ),
        BlocProvider(
          create: (_) => AlltechnisianCubit(TechniciansRepository(
              techniciansWebservices: TechniciansWebservices())),
        ),
        BlocProvider(
          create: (_) =>
              HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
        ),
        BlocProvider(
          create: (_) => UserRequestsCubit(UserRequestsRepository(
              userRequestsWebservices: UserRequestsWebservices())),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0), // زاوية علوية يسار
              topRight: Radius.circular(16.0), // زاوية علوية يمين
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GNav(
                style: GnavStyle.google,
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.teal,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    hoverColor: Colors.tealAccent,
                    icon: LineIcons.home,
                    text: 'الرئيسية',
                    textStyle:
                        TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  ),
                  GButton(
                    hoverColor: Colors.tealAccent,
                    icon: LineIcons.businessTime,
                    text: 'المهنيون',
                    textStyle:
                        TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  ),
                  // GButton(
                  //   icon: LineIcons.search,
                  //   text: 'البحث',
                  //   textStyle:
                  //       TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  // ),
                  GButton(
                    icon: LineIcons.book,
                    text: 'الحجوزات',
                    textStyle:
                        TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  ),
                  GButton(
                    icon: LineIcons.mapAlt,
                    text: 'الخريطة',
                    textStyle:
                        TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'حسابي',
                    textStyle:
                        TextStyle(fontFamily: "Cairo", color: Colors.teal),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}
