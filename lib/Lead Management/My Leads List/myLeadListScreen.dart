import 'dart:async';

import 'package:crm_milan_creations/Lead%20Management/Lead%20Details/leadDetailsScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusController.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusModel.dart';
import 'package:crm_milan_creations/Lead%20Management/My%20Leads%20List/myLeadListController.dart';
import 'package:crm_milan_creations/Lead%20Management/Update%20Lead%20Status/UpdateLeadStatusController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final LeadListcontroller leadController = Get.put(LeadListcontroller());
  final TextEditingController searchController = TextEditingController();
  final LeadStatuscontroller leadStatuscontroller = Get.put(
    LeadStatuscontroller(),
  );

  UpdateLeadcontroller updateLeadcontroller = Get.put(UpdateLeadcontroller());

  DateTime? startDate;
  DateTime? endDate;
  DateTime? followUpDate;
  Status? statusAssign;
  String? selectedCompany;
  String? statusAssignName;
  bool checkfollowup = false;
  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // getallCompanieslistcontroller.getAllCompaniesListFunction();
    leadStatuscontroller.leadStatusFunction();
    leadController.leadListFunction(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !leadController.isLoading.value &&
        leadController.hasMoreData.value) {
      leadController.leadListFunction(
        search: searchController.text.trim(),
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      leadController.leadListFunction(
        isRefresh: true,
        search: searchController.text.trim(),
      );
    });
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: CustomText(
          text: 'My Leads',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),

        elevation: 1,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => _onSearchChanged(),
                    decoration: InputDecoration(
                      hintText: 'Search leads...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  leadController.leadListFunction(
                                    isRefresh: true,
                                  );
                                },
                              )
                              : null,
                      // contentPadding: const EdgeInsets.symmetric(
                      //   horizontal: 16,
                      // ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter button
                // SizedBox(
                //   width: double.infinity,
                //   child: CustomButton(
                //     text: 'Search',
                //     gradient: const LinearGradient(
                //       colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     onPressed: () {
                //       FocusScope.of(context).unfocus();
                //       _onSearchChanged();
                //     },
                //     // style: ElevatedButton.styleFrom(
                //     //   padding: const EdgeInsets.symmetric(vertical: 14),
                //     //   shape: RoundedRectangleBorder(
                //     //     borderRadius: BorderRadius.circular(10),
                //     //   ),
                //     //   backgroundColor: theme.primaryColor,
                //     //   foregroundColor: Colors.white,
                //     // ),

                //     // icon: const Icon(Icons.filter_list),
                //     // label: const CustomText(text:"Search",color: CRMColors.whiteColor,),
                //   ),
                // ),
              ],
            ),
          ),
          // const Divider(height: 1),

          // List view
          Expanded(
            child: Obx(() {
              if (leadController.isLoading.value &&
                  leadController.leadList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (leadController.leadList.isEmpty) {
                return const Center(child: Text('No leads found.'));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    leadController.leadList.length +
                    (leadController.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < leadController.leadList.length) {
                    final lead = leadController.leadList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header with name and date
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    lead.name ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  lead.createdAt != null
                                      ? DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(lead.createdAt!)
                                      : '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lead details
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  Icons.email,
                                  'Email:',
                                  lead.email ?? 'N/A',
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.phone,
                                  'Contact:',
                                  lead.phone ?? 'N/A',
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.source,
                                  'Source:',
                                  lead.source ?? 'N/A',
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.note,
                                  'Purpose:',
                                  lead.remark ?? 'N/A',
                                ),
                                const SizedBox(height: 8),
                                _buildStatusChip(lead.status ?? ''),
                                const SizedBox(height: 16),

                                // Update Status Button
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: Get.height * 0.08,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showAssignLeadDialog(
                                              lead.id.toString(),
                                              lead.status,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                    const SizedBox(
                                      width: 12,
                                    ), // Space between buttons
                                    Expanded(
                                      child: SizedBox(
                                        height: Get.height * 0.08,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print("Navigating with lead ID: ${lead.id}");
                                            Get.to(
                                              () => LeadDetailsScreen(
                                               assignID: '${lead.assignId}',
                                                // leadId: '${lead.id}',
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                        ],
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for status chip
  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'hot':
        backgroundColor = CRMColors.hot;
        textColor = CRMColors.white;
        break;
      case 'followup':
        backgroundColor = CRMColors.followup;
        textColor = CRMColors.white;
        break;
      case 'mature':
        backgroundColor = CRMColors.mature;
        textColor = CRMColors.white;
        break;
      case 'cold':
        backgroundColor = CRMColors.cold;
        textColor = CRMColors.white;
        break;

        case 'not interested':
        backgroundColor = CRMColors.notInterested;
        textColor = CRMColors.white;
        break;

        case 'valid':
        backgroundColor = CRMColors.valid;
        textColor = CRMColors.white;
        break;

        case 'invalid':
        backgroundColor = CRMColors.invalid;
        textColor = CRMColors.white;
        break;

        case 'assigned':
        backgroundColor = CRMColors.dividerCOlor;
        textColor = CRMColors.white;
        break;


      default:
        backgroundColor = Colors.grey.shade200;
        textColor = CRMColors.white;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void showAssignLeadDialog(String leadid, String leadstatus) {
    DateTime? dialogFollowUpDate = followUpDate;

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
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
                        // header
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

                        CustomTextFormField(
                          label: 'Enter feedback',
                          controller: updateLeadcontroller.feedBack,
                          backgroundColor: CRMColors.white,
                          labelStyle: TextStyle(color: Colors.grey),
                          borderColor: CRMColors.black1,
                        ),

                        // Select Status Dropdown
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Obx(() {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton2<Status?>(
                                isExpanded: true,
                                buttonStyleData: ButtonStyleData(
                                  height: 60,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: CRMColors.black1),
                                  ),
                                ),
                                hint: const Text(
                                  'Select Status',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                items:
                                    leadStatuscontroller.leadstatus
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
                                    if (statusAssignName == "followup") {
                                      checkfollowup = true;
                                    } else {
                                      checkfollowup = false;
                                    }
                                    // Track status name
                                  });
                                },
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 16),

                        // Date Picker Visibility
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
                                    initialDate:
                                        dialogFollowUpDate ?? DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null &&
                                      picked != dialogFollowUpDate) {
                                    setState(() {
                                      dialogFollowUpDate = picked;
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
                                            ? DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(dialogFollowUpDate!)
                                            : 'Select Follow-up Date',
                                        style: TextStyle(
                                          color:
                                              dialogFollowUpDate != null
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

                        // const SizedBox(height: 25),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // RESET all fields
                                  updateLeadcontroller.feedBack.clear();
                                  statusAssign = null;
                                  statusAssignName = null;
                                  checkfollowup = false;
                                  followUpDate = null;

                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
                              child: ElevatedButton(
                                onPressed: () async {
                                  updateLeadcontroller
                                      .updateLeadCOntrollerFunction(
                                        leadid,
                                        followUpDate != null
                                            ? followUpDate
                                            : null,
                                        statusAssignName!,
                                        leadstatus == "mature" ? "client" : "",
                                      );
                                  // RESET all fields
                                  updateLeadcontroller.feedBack.clear();
                                  statusAssign = null;
                                  statusAssignName = null;
                                  checkfollowup = false;
                                  followUpDate = null;

                                  await leadController.leadListFunction(
                                    isRefresh: true,
                                  );
                                  Get.back();

                                  setState(() {
                                    statusAssign = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  backgroundColor:
                                      Colors
                                          .transparent, // Important for gradient to show
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
          ),
    );
  }

}
