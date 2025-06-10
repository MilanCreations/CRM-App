// ignore_for_file: deprecated_member_use, prefer_null_aware_operators

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/HR%20Leads/hrLeadsController.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Details/leadDetailsScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusController.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusModel.dart';
import 'package:crm_milan_creations/Lead%20Management/My%20Leads%20List/myLeadListController.dart';
import 'package:crm_milan_creations/Lead%20Management/Update%20Lead%20Status/UpdateLeadStatusController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HrleadsScreen extends StatefulWidget {
  const HrleadsScreen({super.key});

  @override
  State<HrleadsScreen> createState() => _HrleadsScreenState();
}

class _HrleadsScreenState extends State<HrleadsScreen> {
  final Hrleadscontroller hrLeadcontroller = Get.put(Hrleadscontroller());
  final LeadListcontroller leadController = Get.put(LeadListcontroller());
  UpdateLeadcontroller updateLeadcontroller = Get.put(UpdateLeadcontroller());
  final TextEditingController searchController = TextEditingController();
  final LeadStatuscontroller leadStatuscontroller = Get.put(LeadStatuscontroller());
  final ScrollController _scrollController = ScrollController();
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Status? statusAssign;
  DateTime? followUpDate;
  String? statusAssignName;
  bool checkfollowup = false;
  DateTime? startDate;
  DateTime? endDate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    leadStatuscontroller.leadStatusFunction();
    leadController.leadListFunction(isRefresh: true);
    _scrollController.addListener(_onScroll);
    hrLeadcontroller.hrleadsFunction(isRefresh: true);
       _checkInitialConnection();
   _setupConnectivityListener();
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
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      hrLeadcontroller.hrleadsFunction(
        isRefresh: true,
        searchQuery: searchController.text.trim(),
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !hrLeadcontroller.isLoading.value &&
        hrLeadcontroller.hasMoreData.value) {
      hrLeadcontroller.hrleadsFunction(
        isRefresh: false,
        searchQuery: searchController.text.trim(),
        startDate: startDate != null ? startDate!.toIso8601String() : null,
        endDate: endDate != null ? endDate!.toIso8601String() : null,
      );
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      // Positive/Active statuses - Cool colors
      case 'assigned':
        return const Color(0xFF3498DB); // Friendly blue
      case 'valid':
        return const Color(0xFF2ECC71); // Fresh green
      case 'hot':
        return const Color(0xFFE74C3C); // Urgent red

      // Neutral/Progress statuses - Warm colors
      case 'followup':
        return const Color(0xFFF39C12); // Attention orange
      case 'new':
        return const Color(0xFF9B59B6); // Creative purple
      case 'mature':
        return const Color(0xFF1ABC9C); // Balanced teal

      // Negative/Inactive statuses - Muted colors
      case 'rejected':
        return const Color(0xFF95A5A6); // Neutral gray
      case 'cold':
        return const Color(0xFF5D6D7E); // Cool gray-blue
      case 'invalid':
        return const Color(0xFF7F8C8D); // Dark gray
      case 'not interested':
        return const Color(0xFFC0392B); // Dark red (strong rejection)

      // Default
      default:
        return const Color(0xFF95A5A6); // Neutral gray
    }
  }

  Color _getStatusBackgroundColor(String? status) {
    return _getStatusColor(status).withOpacity(0.15); // Lighter background
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CRMColors.black1.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
                color: isStatus ? _getStatusColor(value) : CRMColors.black1,
                fontSize: 14,
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
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: const CustomText(
          text: "HR Leads",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: searchController,
                onChanged: (_) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search by name, phone or email...',
                  prefixIcon: const Icon(Icons.search, color: CRMColors.grey),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: CRMColors.grey),
                          onPressed: () {
                            searchController.clear();
                            _onSearchChanged();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          
          // Date Filter Row
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: InkWell(
          //           onTap: () async {
          //             final DateTime? picked = await showDatePicker(
          //               context: context,
          //               initialDate: startDate ?? DateTime.now(),
          //               firstDate: DateTime(2000),
          //               lastDate: DateTime(2100),
          //             );
          //             if (picked != null && picked != startDate) {
          //               setState(() {
          //                 startDate = picked;
          //                 hrLeadcontroller.hrleadsFunction(
          //                   isRefresh: true,
          //                   searchQuery: searchController.text.trim(),
          //                   startDate: startDate!.toIso8601String(),
          //                   endDate: endDate?.toIso8601String(),
          //                 );
          //               });
          //             }
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(8),
          //               border: Border.all(color: CRMColors.grey),
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   startDate != null
          //                       ? DateFormat('dd MMM yyyy').format(startDate!)
          //                       : 'Start Date',
          //                   style: TextStyle(
          //                     color: startDate != null ? Colors.black : CRMColors.grey,
          //                   ),
          //                 ),
          //                 Icon(Icons.calendar_today, size: 20, color: CRMColors.grey),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       Expanded(
          //         child: InkWell(
          //           onTap: () async {
          //             final DateTime? picked = await showDatePicker(
          //               context: context,
          //               initialDate: endDate ?? DateTime.now(),
          //               firstDate: startDate ?? DateTime(2000),
          //               lastDate: DateTime(2100),
          //             );
          //             if (picked != null && picked != endDate) {
          //               setState(() {
          //                 endDate = picked;
          //                 hrLeadcontroller.hrleadsFunction(
          //                   isRefresh: true,
          //                   searchQuery: searchController.text.trim(),
          //                   startDate: startDate?.toIso8601String(),
          //                   endDate: endDate!.toIso8601String(),
          //                 );
          //               });
          //             }
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(8),
          //               border: Border.all(color: CRMColors.grey),
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   endDate != null
          //                       ? DateFormat('dd MMM yyyy').format(endDate!)
          //                       : 'End Date',
          //                   style: TextStyle(
          //                     color: endDate != null ? Colors.black : CRMColors.grey,
          //                   ),
          //                 ),
          //                 Icon(Icons.calendar_today, size: 20, color: CRMColors.grey),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             startDate = null;
          //             endDate = null;
          //             hrLeadcontroller.hrleadsFunction(
          //               isRefresh: true,
          //               searchQuery: searchController.text.trim(),
          //             );
          //           });
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.all(12),
          //           decoration: BoxDecoration(
          //             color: CRMColors.grey.withOpacity(0.2),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: const Icon(Icons.refresh, color: CRMColors.grey),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          
          const SizedBox(height: 8),
          
          // Leads List
          Expanded(
            child: Obx(() {
              if (hrLeadcontroller.isLoading.value && hrLeadcontroller.hrLeadList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (hrLeadcontroller.hrLeadList.isEmpty) {
                return const Center(
                  child: Text(
                    "No HR Leads Found",
                    style: TextStyle(fontSize: 18, color: CRMColors.black1),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await hrLeadcontroller.hrleadsFunction(
                    isRefresh: true,
                    searchQuery: searchController.text.trim(),
                    startDate: startDate?.toIso8601String(),
                    endDate: endDate?.toIso8601String(),
                  );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: hrLeadcontroller.hrLeadList.length +
                      (hrLeadcontroller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == hrLeadcontroller.hrLeadList.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final lead = hrLeadcontroller.hrLeadList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with name and status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lead.name ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CRMColors.black1,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusBackgroundColor(lead.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    lead.status ?? 'No Status',
                                    style: TextStyle(
                                      color: _getStatusColor(lead.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Contact Info Section
                            const Text(
                              'Contact Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CRMColors.black1,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            _buildInfoRow('Phone', lead.phone ?? 'Not provided'),
                            _buildInfoRow('Email', lead.email ?? 'Not provided'),
                            _buildInfoRow('Address', lead.address ?? 'Not provided'),

                            // Lead Details Section
                            const SizedBox(height: 12),
                            const Text(
                              'Lead Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CRMColors.black1,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            _buildInfoRow('Company', lead.companyName ?? 'Not provided'),
                            _buildInfoRow('Source', lead.source ?? 'Not provided'),
                            _buildInfoRow('Query Type', lead.queryType ?? 'Not provided'),
                            _buildInfoRow(
                              'Visit Time',
                              lead.visitTime != null
                                  ? _formatDateTime(lead.visitTime!.toString())
                                  : 'Not scheduled',
                            ),
                            _buildInfoRow('Remark', lead.remark ?? 'No remarks'),

                            // Assignment Info Section
                            const SizedBox(height: 12),
                            const Text(
                              'Assignment Info',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CRMColors.black1,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            _buildInfoRow('Created By', lead.leadCreator ?? 'Unknown'),
                            _buildInfoRow('Assigned To', lead.employeeName ?? 'Unassigned'),
                            _buildInfoRow(
                              'Created At',
                              lead.createdAt != null
                                  ? _formatDateTime(lead.createdAt!.toString())
                                  : 'Unknown',
                            ),

                            // Action Buttons
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: Get.height * 0.08,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showAssignLeadDialog(
                                          lead.id.toString(),
                                          lead.status ?? '',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFEC32B1),
                                              Color(0xFF0C46CC),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Update Status',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: Get.height * 0.08,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(
                                          () => LeadDetailsScreen(
                                            assignID: '${lead.assignId}',
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF0C46CC),
                                              Color(0xFFEC32B1),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'View Details',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void showAssignLeadDialog(String leadid, String leadstatus) {
    DateTime? dialogFollowUpDate = followUpDate;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.assignment_ind_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Update Lead",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Update Lead Status",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Feedback Field
                    CustomTextFormField(
                      label: 'Enter feedback',
                      controller: updateLeadcontroller.feedBack,
                      backgroundColor: CRMColors.white,
                      labelStyle: const TextStyle(color: Colors.grey),
                      borderColor: CRMColors.black1,
                    ),

                    // Status Dropdown
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Obx(() {
                        return DropdownButtonHideUnderline(
                          child: Container(
                            height: Get.height * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CRMColors.black1),
                            ),
                            child: DropdownButton2<Status?>(
                              isExpanded: true,
                              buttonStyleData: const ButtonStyleData(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              hint: const Text(
                                'Select Status',
                                style: TextStyle(color: Colors.grey),
                              ),
                              items: leadStatuscontroller.leadstatus
                                  .map<DropdownMenuItem<Status?>>(
                                    (status) => DropdownMenuItem<Status?>(
                                      value: status,
                                      child: Text(status.name ?? ''),
                                    ),
                                  )
                                  .toList(),
                              value: statusAssign,
                              onChanged: (Status? value) {
                                setState(() {
                                  statusAssign = value;
                                  statusAssignName = value?.name;
                                  checkfollowup = statusAssignName == "followup";
                                });
                              },
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Follow-up Date Picker
                    Visibility(
                      visible: checkfollowup,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Follow-up Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: dialogFollowUpDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && picked != dialogFollowUpDate) {
                                setState(() {
                                  dialogFollowUpDate = picked;
                                  followUpDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    dialogFollowUpDate != null
                                        ? DateFormat('yyyy-MM-dd').format(dialogFollowUpDate!)
                                        : 'Select Follow-up Date',
                                    style: TextStyle(
                                      color: dialogFollowUpDate != null
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              updateLeadcontroller.feedBack.clear();
                              statusAssign = null;
                              statusAssignName = null;
                              checkfollowup = false;
                              followUpDate = null;
                              Get.back();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Obx(() {
                            if (updateLeadcontroller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              onPressed: () async {
                                if (statusAssignName == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please select a status',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                Get.dialog(
                                  const Center(child: CircularProgressIndicator()),
                                  barrierDismissible: false,
                                );

                                try {
                                  await updateLeadcontroller.updateLeadCOntrollerFunction(
                                    leadid,
                                    followUpDate,
                                    statusAssignName!,
                                    leadstatus == "mature" ? "client" : "",
                                  );

                                  // Refresh data
                                  await hrLeadcontroller.hrleadsFunction(isRefresh: true);

                                  Get.back(); // Close loading
                                  Get.back(); // Close dialog

                                  Get.snackbar(
                                    'Success',
                                    'Lead status updated',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  // Reset fields
                                  updateLeadcontroller.feedBack.clear();
                                  statusAssign = null;
                                  statusAssignName = null;
                                  checkfollowup = false;
                                  followUpDate = null;
                                } catch (e) {
                                  Get.back(); // Close loading
                                  Get.snackbar(
                                    'Error',
                                    'Failed to update status: ${e.toString()}',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEC32B1),
                                      Color(0xFF0C46CC),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 88.0,
                                    minHeight: 48.0,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Save Changes",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}