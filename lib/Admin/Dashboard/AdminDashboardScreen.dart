import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/Employee/Notifications/notificationsScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Attendance/todayAttendanceScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Leave%20Request/todayLeaveScreen.dart';
import 'package:crm_milan_creations/Admin/Dashboard/CompAdminDashController.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final CompanyAdminDashboardController controller = Get.put(
    CompanyAdminDashboardController(),
  );

  String userRole = "";
  String companyname = "";
  List<String> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkInitialConnection();
    _setupConnectivityListener();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
      companyname = prefs.getString("company_name") ?? "";
      String? permissionsJson = prefs.getString("permissions");
      if (permissionsJson != null)
        chartData = List<String>.from(jsonDecode(permissionsJson));
    });
  }

  Future<void> _checkInitialConnection() async {
    if (!await _connectivityService.isConnected())
      _connectivityService.showNoInternetScreen();
  }

  late StreamSubscription _connectivitySubscription;
  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService
        .listenToConnectivityChanges(
          onConnected: () {},
          onDisconnected: () => _connectivityService.showNoInternetScreen(),
        );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget buildTile({
    required String title,
    required RxString value,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.3),
              offset: Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 36),
                  SizedBox(height: 15),
                  Obx(
                    () => Text(
                      value.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
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

  Future<void> _navigateToEmployeeList() async {
    await Get.to(() => const EmployeeListScreen());
    controller.fetchDashboardData(); // refresh upon return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        gradient: LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Welcome $companyname',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed:
                () =>
                    Get.to(() => NotificationsScreen(message: RemoteMessage())),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E8F0)],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.9,
                children: [
                  buildTile(
                    title: "Total Employees",
                    value: controller.totalEmployees,
                    icon: Icons.group,
                    gradient: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    onTap: _navigateToEmployeeList,
                  ),
                  buildTile(
                    title: "Today Leaves",
                    value: controller.todayLeaves,
                    icon: Icons.today,
                    gradient: [Color(0xFFFF8008), Color(0xFFFE642E)],
                    onTap: () async {
                      await Get.to(
                        () => const HrLeaveRequestScreen(isToday: true),
                      );
                      controller.fetchDashboardData();
                    },
                  ),
                  buildTile(
                    title: "Today Attendance",
                    value: controller.todayAttendanceCount,
                    icon: Icons.group,
                    gradient: [Color(0xFF1A2980), Color(0xFF26D0CE)],
                    onTap: () async {
                      await Get.to(() => const TodayAttendanceScreen());
                      controller.fetchDashboardData();
                    },
                  ),
                  buildTile(
                    title: "Pending Leaves",
                    value: controller.pendingLeaves,
                    icon: Icons.pending_actions,
                    gradient: [Color(0xFFED213A), Color(0xFF93291E)],
                    onTap: () async {
                      await Get.to(
                        () =>
                            const HrLeaveRequestScreen(statusFilter: "pending"),
                      );
                      controller.fetchDashboardData();
                    },
                  ),
                  buildTile(
                    title: "Approved Leaves",
                    value: controller.approvedLeaves,
                    icon: Icons.verified,
                    gradient: [Color(0xFF56AB2F), Color(0xFFA8E063)],
                    onTap: () async {
                      await Get.to(
                        () => const HrLeaveRequestScreen(
                          statusFilter: "approved",
                        ),
                      );
                      controller.fetchDashboardData();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
