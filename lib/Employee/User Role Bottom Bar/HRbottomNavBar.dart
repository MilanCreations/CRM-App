// ignore_for_file: file_names
import 'package:crm_milan_creations/Employee/Dashboard/dashboardScreen.dart';
import 'package:crm_milan_creations/Employee/Attendance%20History/historyScreen.dart';
import 'package:crm_milan_creations/Employee/Notifications/notificationsScreen.dart';
import 'package:crm_milan_creations/Employee/profile/profileScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/material.dart';

class HRBottomNavBar extends StatefulWidget {
  final String checkpagestatuss;
  const HRBottomNavBar({super.key, required this.checkpagestatuss});

  @override
  State<HRBottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<HRBottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Dashboardscreen(checkpagestatus: widget.checkpagestatuss),
      ProfileScreen(),
      NotificationsScreen(),
      HistoryScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 5,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: CRMColors.crmMainCOlor, // Just a fallback color
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem(Icons.dashboard, "Dashboard", 0),
          _buildNavItem(Icons.person, "Profile", 1),
          _buildNavItem(Icons.notifications, "Notifications", 2),
          _buildNavItem(Icons.wallet, "Historyhr", 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return isSelected
              ? LinearGradient(
                colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds)
              : LinearGradient(
                colors: [Colors.grey, Colors.grey], // Keep grey for unselected
              ).createShader(bounds);
        },
        child: Icon(
          icon,
          color: Colors.white,
        ), // Keep white, shader applies color
      ),
      label: label,
    );
  }
}
