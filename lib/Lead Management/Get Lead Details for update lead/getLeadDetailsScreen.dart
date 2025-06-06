import 'package:crm_milan_creations/Lead%20Management/Edit%20Lead/editLeadScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20Lead%20Details%20for%20update%20lead/getLeadDetailsController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
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

  @override
  void initState() {
    super.initState();
    getLeadDetailsController.fetchLeadDetails(widget.leadId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit, color: Colors.white),
        //     onPressed: () {
        //       // Add edit functionality
        //       Get.to(EditleadScreen(
        //         leadId: widget.leadId,
        //       ));
        //     },
        //   ),
        // ],
      ),
      body: Obx(() {
        if (getLeadDetailsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 24),
              _buildInfoCard(),
              SizedBox(height: 16),
              // _buildVerificationBadge(),
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
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
        ),
        SizedBox(height: 12),
        Text(
          getLeadDetailsController.name.value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        // SizedBox(height: 4),
        // Text(
        //   getLeadDetailsController.queryType.value,
        //   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        // ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, 'Phone', getLeadDetailsController.phone.value),
            Divider(height: 24, thickness: 0.5),
            if (getLeadDetailsController.email.value.isNotEmpty)
              _buildInfoRow(Icons.email, 'Email', getLeadDetailsController.email.value),
            if (getLeadDetailsController.email.value.isNotEmpty)
              Divider(height: 24, thickness: 0.5),
            _buildInfoRow(Icons.location_on, 'Address', getLeadDetailsController.address.value),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: (getLeadDetailsController.phoneVerified.value == true)
            ? Colors.green.shade50 
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            (getLeadDetailsController.phoneVerified.value == true)
                ? Icons.verified 
                : Icons.warning_amber,
            color: (getLeadDetailsController.phoneVerified.value == true)
                ? Colors.green 
                : Colors.orange,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'Phone ${(getLeadDetailsController.phoneVerified.value == true) ? "Verified" : "Not Verified"}',
            style: TextStyle(
              color: (getLeadDetailsController.phoneVerified.value == true)
                  ? Colors.green 
                  : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 16),
        _buildDetailItem('Visit Time', formatDate(getLeadDetailsController.visitTime.value)),
        _buildDetailItem('Source', getLeadDetailsController.source.value),
        _buildDetailItem('Branch', getLeadDetailsController.branchName.value),
        _buildDetailItem('Purpose', getLeadDetailsController.remark.value),
        _buildDetailItem('Query type', getLeadDetailsController.queryType.value,),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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