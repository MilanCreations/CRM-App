import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Admin/Dashboard/CompAdminDashController.dart';
import 'package:crm_milan_creations/Employee/Notifications/notificationsScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Attendance/todayAttendanceScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Leave%20Request/todayLeaveScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final CompanyAdminDashboardController companyAdminDashboardController =
      Get.put(CompanyAdminDashboardController());

  String userRole = "";
  String companyname = "";
  List<String> chartData = [];

  @override
  void initState() {
    getUserData();
    _checkInitialConnection();
    _setupConnectivityListener();
    companyAdminDashboardController.companyAdminDashboardFunction();
    super.initState();
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userRole = sharedPreferences.getString("role_code") ?? "";
    companyname = sharedPreferences.getString("company_name") ?? "";
    String? permissionsJson = sharedPreferences.getString("permissions");
    if (permissionsJson != null) {
      chartData = List<String>.from(jsonDecode(permissionsJson));
    }
    print("User Role: $userRole");
    setState(() {});
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService
        .listenToConnectivityChanges(
          onConnected: () {},
          onDisconnected: () {
            _connectivityService.showNoInternetScreen();
          },
        );
  }

  Widget buildDashboardTile(
    String title,
    RxString value,
    IconData icon,
    List<Color> gradientColors, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.3),
              offset: const Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 36),
                  const SizedBox(height: 15),
                  Obx(
                    () => Text(
                      value.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Welcome $userRole',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        // backgroundColor: CRMColors.crmMainCOlor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed:
                () =>
                    Get.to(() => NotificationsScreen(message: RemoteMessage())),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E8F0)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
                  children: [
                    // if (chartData.contains("view-leads") ||
                    //     userRole == "HR_MANAGER")
                    // buildDashboardTile(
                    //   "My Leads",
                    //   // controller.myLeads,
                    //   RxString("0"),
                    //   Icons.assessment,
                    //   [Color(0xFFDA22FF), Color(0xFF9733EE)],
                    //   onTap: () {
                    //     Get.to(() => HrleadsScreen());
                    //   },
                    // ),
                    buildDashboardTile(
                      "Today Attendance",
                      // controller.todayAttendanceCount,
                      RxString("0"),
                      Icons.group,
                      [Color(0xFF1A2980), Color(0xFF26D0CE)],
                      onTap: () {
                        Get.to(() => const TodayAttendanceScreen());
                      },
                    ),
                    buildDashboardTile(
                      "Today Leaves",
                      // controller.todayLeaves,
                      RxString("0"),
                      Icons.today,
                      [Color(0xFFFF8008), Color(0xFFFE642E)],
                      onTap: () {
                        Get.to(() => const HrLeaveRequestScreen(isToday: true));
                      },
                    ),
                    buildDashboardTile(
                      "Pending Leaves",
                      // controller.pendingLeaves,
                      RxString("0"),
                      Icons.pending_actions,
                      [Color(0xFFED213A), Color(0xFF93291E)],
                      onTap: () {
                        Get.to(
                          () => const HrLeaveRequestScreen(
                            statusFilter: "pending",
                          ),
                        );
                      },
                    ),
                    buildDashboardTile(
                      "Approved Leaves",
                      // controller.approvedLeaves,
                      RxString("0"),
                      Icons.verified,
                      [Color(0xFF56AB2F), Color(0xFFA8E063)],
                      onTap: () {
                        Get.to(
                          () => const HrLeaveRequestScreen(
                            statusFilter: "approved",
                          ),
                        );
                      },
                    ),

                    buildDashboardTile(
                      "Total Employees",
                      companyAdminDashboardController.totalEmployees,
                      Icons.groups,
                      [Color(0xFF00B4DB), Color(0xFF0083B0)],
                      onTap: () => Get.to(() => const EmployeeListScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
