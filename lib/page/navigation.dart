import 'package:smart_parking_customer/page/reservations/parking.search.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_customer/page/user/profile.dart';
import 'home.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.qr_code_2_rounded),
            selectedIcon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_online_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Đặt chỗ',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_outlined),
            icon: Icon(Icons.account_circle),
            label: 'Hồ sơ',
          ),
        ],
      ),
      body: <Widget>[
        const MyHomePage(title: 'Home Page'),
        const ParkingSearchPage(),
        const ProfilePage()
      ][currentPageIndex],
    );
  }
}
