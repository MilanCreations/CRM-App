import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'myProfileController.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final Myprofilecontroller controller = Get.put(Myprofilecontroller());
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
     _checkInitialConnection();
   _setupConnectivityListener();
    controller.myProfileFunction();
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

  Widget buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: CRMColors.button),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: CRMColors.button,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: const CustomText(
          text: "My Profile",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Personal Information
              buildSectionTitle(Icons.person, "Personal Information"),
              buildInfoRow("Email", controller.email.value),
              buildInfoRow("Phone", controller.phone.value),
              buildInfoRow(
                "Emergency Contact",
                controller.emergencycontact.value,
              ),
              buildInfoRow("Address", controller.address.value),

              const Divider(height: 32),

              // Employment Details
              buildSectionTitle(Icons.work, "Employment Details"),
              buildInfoRow("Department", controller.departmentName.value),
              buildInfoRow("Designation", controller.designation.value),
              buildInfoRow("Role", controller.rolename.value),
              // buildInfoRow("Joining Date", controller.joindate.value),
              buildInfoRow("Salary", controller.salary.value),

              // buildInfoRow("Shift Time", controller.shiftTime.value),
              const Divider(height: 32),

              // Banking Information
              buildSectionTitle(
                Icons.account_balance_wallet,
                "Banking Information",
              ),
              buildInfoRow("Bank Name", controller.bankname.value),
              buildInfoRow("Account Number", controller.bankaccount.value),
              buildInfoRow("IFSC Code", controller.ifsCode.value),
            ],
          ),
        );
      }),
    );
  }
}
