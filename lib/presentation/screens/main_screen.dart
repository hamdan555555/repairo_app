import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/data/repository/user_repository.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/presentation/screens/home_screen.dart';
import 'package:breaking_project/presentation/screens/login_screen.dart';
import 'package:breaking_project/presentation/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // الصفحات اللي رح يتبدل بينهم
  final List<Widget> _pages = [
    BannerSlider(),
    BlocProvider(
        create: (context) => LoginCubit(AuthRepository(AuthWebService())),
        child: LoginScreen()),
    Verification(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Navigation Example')),
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
