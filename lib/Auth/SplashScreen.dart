import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/CompanyAdminBottomBar.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/EmployeeBottomNavBar.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusController.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/HRbottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final CheckClockInController objCheckClockInController =
      Get.put(CheckClockInController(checkpagestatus: "splash"));

  @override
  void initState() {
    super.initState();
    _startSplashDelay();
  }

  void _startSplashDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role_code');
    final fullName = prefs.getString('fullname');
    print("Full Name in splash: $fullName");

    if (token != null && token.isNotEmpty) {
      await objCheckClockInController.checkClockInController();
      _navigateToHomeBasedOnRole(role);
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  void _navigateToHomeBasedOnRole(String? roleName) {
    print("Role Name: $roleName");
    switch (roleName) {
      case "HR_MANAGER":
        Get.off(() => HRBottomNavBar(checkpagestatuss: "splash"));
        break;
      case "SUPER_ADMIN":
        Get.off(() => SuperAdminBottomNavBar(checkpagestatuss: "splash"));
        break;
      case "Manager":
        // Get.off(() => ManagerBottomNavBar(checkpagestatuss: "splash"));
        break;
      case "TeamLead":
        // Get.off(() => TeamLeadBottomNavBar(checkpagestatuss: "splash"));
        break;
      case "EMPLOYEE":
        Get.off(() => EmployeeBottomNavBar(checkpagestatuss: "login"));
        break;
      default:
        Get.off(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/mainlogo.png', // 🔁 Replace with your actual image path
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}