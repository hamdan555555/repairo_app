import 'package:breaking_project/business_logic/ItemsCubit/items_cubit.dart';
import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/data/repository/items_repository.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/data/web_services/Items_webservices.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/login_screen.dart';
import 'package:breaking_project/presentation/screens/profile.dart';
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BlocProvider(
      create: (context) =>
          ItemsCubit(ItemsRepository(itemsWebservices: ItemsWebservices()))
            ..getAllItems(),
      child: BannerSlider(),
    ),
    BlocProvider(
        create: (context) => LoginCubit(AuthRepository(AuthWebService())),
        child: LoginScreen()),
    ProfileScreen(),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
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
