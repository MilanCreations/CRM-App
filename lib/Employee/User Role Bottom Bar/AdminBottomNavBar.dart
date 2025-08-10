// ignore_for_file: file_names
import 'package:crm_milan_creations/Admin/Dashboard/AdminDashboardScreen.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Home%20Page/chatHomeScreen.dart';
import 'package:crm_milan_creations/Employee/profile/profileScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatefulWidget {
  final String checkpagestatuss;
  const AdminBottomNavBar({super.key, required this.checkpagestatuss});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AdminDashboardScreen(),
      ProfileScreen(),
      // NotificationsScreen(message: RemoteMessage()),
      ChatHomeScreen(),
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
          // _buildNavItem(Icons.notifications_active, "Notification", 2),
          _buildNavItem(Icons.chat, "Chat", 3),
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
