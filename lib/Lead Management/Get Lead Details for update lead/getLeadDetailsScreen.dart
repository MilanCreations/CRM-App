import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20Lead%20Details%20for%20update%20lead/getLeadDetailsController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GetAndEditleadDetailsScreen extends StatefulWidget {
  final String? leadId;
  const GetAndEditleadDetailsScreen({super.key, required this.leadId});

  @override
  State<GetAndEditleadDetailsScreen> createState() => _GetAndEditleadDetailsScreenState();
}

class _GetAndEditleadDetailsScreenState extends State<GetAndEditleadDetailsScreen> {
  final GetLeadDetails getLeadDetailsController = Get.put(GetLeadDetails());
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
       _checkInitialConnection();
   _setupConnectivityListener();
    getLeadDetailsController.fetchLeadDetails(widget.leadId!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Lead Details',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Obx(() {
        if (getLeadDetailsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(CRMColors.crmMainCOlor),
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 24),
              _buildInfoCard(),
              SizedBox(height: 24),
              _buildDetailsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.person, size: 50, color: CRMColors.crmMainCOlor),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          getLeadDetailsController.name.value.isNotEmpty
              ? getLeadDetailsController.name.value
              : "No Name",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4),
        if (getLeadDetailsController.phoneVerified.value == true)
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, 'Phone', getLeadDetailsController.phone.value),
            Divider(height: 24, thickness: 0.5, color: Colors.grey[200]),
            if (getLeadDetailsController.email.value.isNotEmpty)
              _buildInfoRow(Icons.email, 'Email', getLeadDetailsController.email.value),
            if (getLeadDetailsController.email.value.isNotEmpty)
              Divider(height: 24, thickness: 0.5, color: Colors.grey[200]),
            _buildInfoRow(Icons.location_on, 'Address', getLeadDetailsController.address.value),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'LEAD INFORMATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailItem('Lead Creator', formatDate(getLeadDetailsController.leadCreator.value)),
                SizedBox(height: 16),
                _buildDetailItem('Visit Time', formatDate(getLeadDetailsController.visitTime.value)),
                SizedBox(height: 16),
                _buildDetailItem('Source', getLeadDetailsController.source.value),
                SizedBox(height: 16),
                _buildDetailItem('Branch', getLeadDetailsController.branchName.value),
                SizedBox(height: 16),
                _buildDetailItem('Purpose', getLeadDetailsController.remark.value),
                SizedBox(height: 16),
                _buildDetailItem('Query type', getLeadDetailsController.queryType.value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CRMColors.crmMainCOlor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: CRMColors.crmMainCOlor),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : 'Not provided',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value.isNotEmpty ? value : 'Not provided',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }
}