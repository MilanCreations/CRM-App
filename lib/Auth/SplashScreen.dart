import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/EmployeeBottomNavBar.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/superadmin.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusController.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/HRbottomNavBar.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final CheckClockInController objCheckClockInController =
      Get.put(CheckClockInController(checkpagestatus: "splash"));

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });

    _videoController.setLooping(false);

    _videoController.addListener(() {
      if (_videoController.value.position == _videoController.value.duration) {
        _checkLoginStatus();
      }
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
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _videoController.value.isInitialized
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                 
                ],
              ),
            )
          : const Center(child: CustomText(text: "Loading...")),
    );
  }
}
