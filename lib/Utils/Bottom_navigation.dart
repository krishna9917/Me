import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_app/Resources/ImagePaths.dart';

import '../Screen/PortfolioScreen.dart';
import '../Screen/SettingScreen.dart';
import '../Screen/TradesScreen.dart';
import '../Screen/WatchlistScreen.dart';

class Bottom_Navigation extends StatefulWidget {
  const Bottom_Navigation({super.key});

  @override
  State<Bottom_Navigation> createState() => _Bottom_NavigationState();
}

class _Bottom_NavigationState extends State<Bottom_Navigation> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = [
    WatchlistScreen(),
    TradesScreen(),
    PortfolioScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePaths.wishlist,
              width: 20,
              height: 20,
            ),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePaths.trade,
              width: 20,
              height: 20,
            ),
            label: 'Trades',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePaths.portfolio,
              width: 20,
              height: 20,
            ),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePaths.profile,
              width: 20,
              height: 20,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
