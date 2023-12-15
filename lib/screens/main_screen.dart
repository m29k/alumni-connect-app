import 'package:flutter/material.dart';

import '../widgets/customBottomNavBar.dart';
import '../screens/home_page_screen.dart';
import '../screens/members_page_screen.dart';
import '../screens/messages_page_screen.dart';
import '../screens/notifications_page_screen.dart';
import '../screens/more_page_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      const HomePageScreen(),
      const MembersPageScreen(),
      const MessagesPageScreen(),
      const NotificationsPageScreen(),
      const MorePageScreen(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBody: true,
          body: _pages[_selectedIndex],
          bottomNavigationBar: const CustomBottomNavBar()),
    );
  }
}
