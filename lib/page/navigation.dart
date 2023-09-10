import 'package:smart_parking_customer/page/history.dart';
import 'package:smart_parking_customer/page/reservations/parking.search.dart';
import 'package:flutter/material.dart';
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
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Đặt chỗ',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history),
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
        ],
      ),
      body: <Widget>[
        const MyHomePage(title: 'Home Page'),
        const ParkingSearchPage(),
        const History()
      ][currentPageIndex],
    );
  }
}
