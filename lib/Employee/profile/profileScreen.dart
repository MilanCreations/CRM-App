// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Home%20Page/chatHomeScreen.dart';
import 'package:crm_milan_creations/Employee/Apply%20Leave/applyLeaveScreen.dart';
import 'package:crm_milan_creations/Employee/Attendance%20History/allendanceHistoryScreen.dart';
import 'package:crm_milan_creations/Employee/Leave%20History/leaveHistoryScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Leave%20Request/empLeaveRequestScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListScreen.dart';
import 'package:crm_milan_creations/HR%20App/Salary/SalaryScreen.dart';
import 'package:crm_milan_creations/HR%20App/view%20personal%20employees%20details/viewEmployeePersonalDetailsScreen.dart';
import 'package:crm_milan_creations/Inventory%20Management/Issue%20Inventory%20History/issueInventoryScreen.dart';
import 'package:crm_milan_creations/Inventory%20Management/Issue%20Inventory/IssueInventoryScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Lead%20list/allLeadsScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Create%20Leads/createLeadsScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/My%20Leads%20List/myLeadListScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String name = "";
  String useremail = "";
  String userRole = "";
  String token = "";
  String employeeID = "";
  String visitTime = "";
  String profilePicPath = ""; // Could be local path or base64
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // String permissions =  "";
  // File? _profileImage;
  // final ImagePicker _picker = ImagePicker();
  List chartData = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    loadDataFromLocal();
       _checkInitialConnection();
   _setupConnectivityListener();
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
    _connectivitySubscription = _connectivityService.listenToConnectivityChanges(
      onConnected: () {
        // Optional: You can automatically go back if connection is restored
        // Get.back();
      },
      onDisconnected: () {
        _connectivityService.showNoInternetScreen();
      },
    );
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("fullname") ?? "";
      useremail = prefs.getString("email") ?? "";
      userRole = prefs.getString("role_code") ?? ""; 
      token = prefs.getString('token') ?? "";
      employeeID = prefs.getString('employee_id') ?? "";
      // companyId = prefs.getString('company_id') ?? "";
      String? localName = prefs.getString('name');
      // name = prefs.getString('name') ?? "";
      name =
          (localName == null || localName.trim().isEmpty)
              ? (prefs.getString('fullname') ?? "")
              : localName;

      profilePicPath = prefs.getString('profile_pic') ?? "";
      print("profile pic in profile screen:- $profilePicPath");
    });
  }

  // ✅ Load chart data from SharedPreferences
  Future<void> loadDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? permissions = prefs.getString('permissions');
    print("Chart data:- $permissions");
    if (permissions != null) {
      try {
        List<dynamic> jsonData = json.decode(permissions);

        chartData = jsonData.map((e) => e).toList();
        print("Chart data:- $chartData");
      } catch (e) {
        print("Error parsing chart data: $e");
      }
    }
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Logout?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  const Text(
                    "Are you sure you want to logout?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Logout Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: CRMColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            Get.back(); // Close dialog first
                            Get.snackbar(
                              "Success",
                              "Logout Successfully",
                              backgroundColor: CRMColors.error,
                              colorText: CRMColors.textWhite,
                            );
                            Get.offAll(() => const LoginScreen());
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? CRMColors.crmMainCOlor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CRMColors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: iconColor ?? CRMColors.crmMainCOlor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showFullScreenImage,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CRMColors.crmMainCOlor, width: 2),
        ),
        child: _getProfileImageWidget(),
      ),
    );
  }

  void _showFullScreenImage() {
    if (profilePicPath.isEmpty) return;

    try {
      Widget imageWidget;

      // Check if it's a file path
      final file = File(profilePicPath);
      if (file.existsSync()) {
        imageWidget = Image.file(file);
      }
      // Check if it's a network URL
      else if (profilePicPath.startsWith('http')) {
        imageWidget = Image.network(profilePicPath);
      }
      // Assume it's base64 if neither
      else {
        final imageBytes = base64Decode(profilePicPath);
        imageWidget = Image.memory(imageBytes);
      }

      Get.dialog(
        Dialog(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: imageWidget,
          ),
        ),
      );
    } catch (e) {
      print('Error showing full screen image: $e');
      Get.snackbar(
        "Error",
        "Could not display image",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }

  Widget _getProfileImageWidget() {
    if (profilePicPath.isEmpty) {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 50, color: Colors.white),
      );
    }

    try {
      // Check if it's a file path
      final file = File(profilePicPath);
      if (file.existsSync()) {
        return CircleAvatar(radius: 50, backgroundImage: FileImage(file));
      }
      // Check if it's a network URL
      else if (profilePicPath.startsWith('http')) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(profilePicPath),
        );
      }
      // Assume it's base64 if neither
      else {
        final imageBytes = base64Decode(profilePicPath);
        return CircleAvatar(
          radius: 50,
          backgroundImage: MemoryImage(imageBytes),
        );
      }
    } catch (e) {
      print('Error loading profile image: $e');
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 50, color: Colors.white),
      );
    }
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
          text: 'Profile',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile image with edit button
            _buildProfileImage(),
            const SizedBox(height: 16),
            CustomText(
              text: username,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              gradient: const LinearGradient(
                colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                useremail,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  buildMenuItem(
                    icon: Icons.person_outline,
                    text: "Profile Details",
                    onTap:
                        () => Get.to(
                          ViewEmployeePersonalDetailsScreen(employeeId: employeeID),
                        ),
                  ),
                  userRole != "EMPLOYEE"
                      ? buildMenuItem(
                        icon: Icons.person_outline,
                        text: 'Employee List',
                        onTap: () {
                          Get.to(EmployeeListScreen());
                        }, // Navigate to profile detail screen if needed
                      )
                      : const SizedBox(),
                  userRole != "COMPANY_ADMIN"
                      ? buildMenuItem(
                        icon: Icons.calendar_month_outlined,
                        text: 'Apply Leave',
                        onTap: () => Get.to(() => LeaveRequestScreen()),
                      )
                      : const SizedBox(),
                  buildMenuItem(
                    icon: Icons.calendar_month_outlined,
                    text: 'Leave History',
                    onTap: () => Get.to(() => LeavehistoryScreen()),
                  ),
                  userRole != "EMPLOYEE" && userRole != "COMPANY_ADMIN"
                      ? buildMenuItem(
                        icon: Icons.schedule,
                        text: 'Leave Requests',
                        onTap: () => Get.to(() => EmpLeaveRequestScreen()),
                      )
                      : const SizedBox(),
                  userRole != "COMPANY_ADMIN"
                      ? buildMenuItem( 
                        icon: Icons.history,
                        text: 'Attendance History',
                        onTap: () => Get.to(() => const HistoryScreen()),
                      )
                      : const SizedBox(),
                  buildMenuItem(
                    icon: Icons.currency_rupee_sharp,
                    text: 'Salary',
                    onTap: () => Get.to(() => Salaryscreen()),
                  ),
                  buildMenuItem(
                    icon: Icons.chat,
                    text: 'Chat',
                    onTap: () => Get.to(() => ChatHomeScreen()),
                  ),
                  widgetshowpermissionswise(),
                  userRole == "COMPANY_ADMIN"
                      ? buildMenuItem(
                        icon: Icons.leaderboard,
                        text: 'Create Lead',
                        onTap:
                            () => Get.to(
                              () => CreateLeadsScreen(
                                token: token,
                                name: name,
                                visitTime: visitTime,
                                employeeid: employeeID,
                              ),
                            ),
                      )
                      : const SizedBox(),

                  userRole != "EMPLOYEE"
                      ? buildMenuItem(
                        icon: Icons.inventory,
                        text: 'Inventory Management',
                        onTap: () => Get.to(() => IssueInventoryScreen()),
                      )
                      : SizedBox(),

                  buildMenuItem(
                    icon: Icons.inventory_sharp,
                    text: 'Inventory History',
                    onTap: () => Get.to(() => IssueInventoryHistoryScreen()),
                  ),
                  userRole != "HR_MANAGER"
                  ?buildMenuItem(
                    icon: Icons.leak_add_sharp,
                    text: 'All Leads',
                    onTap: () => Get.to(() => AllLeadsScreen()),
                  ): SizedBox(),
                  buildMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    iconColor: CRMColors.error,
                    onTap: showLogoutDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget widgetshowpermissionswise() {
    return Column(
      children:
          chartData.map<Widget>((element) {
            if (element == "create-leads") {
              return buildMenuItem(
                icon: Icons.leaderboard,
                text: 'Create Lead',
                onTap:
                    () => Get.to(
                      () => CreateLeadsScreen(
                        token: token,
                        name: name,
                        visitTime: visitTime,
                        employeeid: employeeID,
                      ),
                    ),
              );
            } else if (element == "view-leads" || userRole == "HR_MANAGER" ) {
              return buildMenuItem(
                icon: Icons.lan_outlined,
                text: 'My Leads',
                onTap: () => Get.to(() => LeadListScreen()),
              );
            } else if (element == "manage-others-leads") {
              return buildMenuItem(
                icon: Icons.manage_accounts_outlined,
                text: 'Manage Leads',
                onTap: () => Get.to(() => Salaryscreen()),
              );
            } else {
              return Text("No Permission");
            }
          }).toList(),
    );
  }


}
