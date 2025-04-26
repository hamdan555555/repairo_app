import 'package:breaking_project/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:breaking_project/business_logic/ServicesCubit/services_cubit.dart';
import 'package:breaking_project/data/repository/items_repository.dart';
import 'package:breaking_project/data/repository/profile_repository.dart';
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    BlocProvider(
      create: (context) => ServicesCubit(
          ServicesRepository(servicesWebservices: ServicesWebservices()))
        ..getAllItems(),
      child: HomeScreen(),
    ),
    BlocProvider(
        create: (context) =>
            ProfileCubit(ProfileRepository(ProfileWebservices())),
        child: ProfileScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
