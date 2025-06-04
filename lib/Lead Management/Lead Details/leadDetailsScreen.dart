import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:crm_milan_creations/Lead%20Management/Lead%20Details/leadDetailsController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';

class LeadDetailsScreen extends StatefulWidget {
  final String assignID;
  const LeadDetailsScreen({super.key, required this.assignID});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  Timer? _debounce;
  final Leaddetailscontroller leadDetailsController = Get.put(
    Leaddetailscontroller(),
  );
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leadDetailsController.leadDetailsFunction(
        assignId: widget.assignID,
        isRefresh: true,
      );
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      leadDetailsController.leadDetailsFunction(
        isRefresh: true,
        search: searchController.text.trim(),
        assignId: widget.assignID,
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: CustomText(
          text: 'Lead Details',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search leads...',
                    prefixIcon: const Icon(Icons.search, color: CRMColors.grey),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: CRMColors.grey,
                              ),
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
              const SizedBox(height: 16),

              // Lead List
              Expanded(
                child: Obx(() {
                  if (leadDetailsController.isLoading.value &&
                      leadDetailsController.leadDetailsList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (leadDetailsController.leadDetailsList.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 60,
                          color: CRMColors.darkGrey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Lead Details Found',
                          style: TextStyle(
                            fontSize: 18,
                            color: CRMColors.black1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    itemCount: leadDetailsController.leadDetailsList.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lead = leadDetailsController.leadDetailsList[index];

                      String formattedVisit = '';
                      if (lead.visitTime != null) {
                        try {
                          formattedVisit = DateFormat(
                            'd MMM y hh mm a',
                          ).format(lead.visitTime!.toLocal());
                        } catch (_) {
                          formattedVisit = 'Invalid Date';
                        }
                      }

                      String updatedAt =
                          lead.updatedAt != null
                              ? DateFormat(
                                'd MMM y hh mm a',
                              ).format(lead.updatedAt!.toLocal())
                              : "Not Available";

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                lead.name ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black1,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Purpose
                              if (lead.purpose != null)
                                _buildInfoRow("Purpose", lead.purpose!),

                              // Follow Up
                              _buildInfoRow(
                                "Follow Up",
                                lead.followupDate != null
                                    ? DateFormat(
                                      'd MMM y',
                                    ).format(lead.followupDate!.toLocal())
                                    : "No Follow Up Date",
                              ),

                              // Visit Date
                              if (formattedVisit.isNotEmpty)
                                _buildInfoRow("Visit Date", formattedVisit),

                              // Updated At
                              _buildInfoRow("Updated At", updatedAt),

                              // Company Name
                              if (lead.companyName != null)
                                _buildInfoRow("Company", lead.companyName!),

                              // Remark
                              if (lead.remark != null)
                                _buildInfoRow("Remark", lead.remark!),

                              // Status
                              if (lead.status != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Status: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: CRMColors.darkGrey,
                                        ),
                                      ),
                                      _buildStatusChip(lead.status!),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: CRMColors.darkGrey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: CRMColors.black1),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildStatusChip(String status) {
  Color backgroundColor;
  Color textColor = Colors.white;

  switch (status.toLowerCase()) {
    case 'hot':
      backgroundColor = Colors.redAccent;
      break;
    case 'cold':
      backgroundColor = Colors.blueGrey;
      break;
    case 'valid':
      backgroundColor = Colors.green;
      break;
    case 'invalid':
      backgroundColor = Colors.red;
      break;
    case 'followup':
      backgroundColor = Colors.orange;
      break;
    case 'not interested':
      backgroundColor = Colors.grey;
      textColor = Colors.black;
      break;
    case 'mature':
      backgroundColor = Colors.purple;
      break;
    default:
      backgroundColor = CRMColors.grey;
      textColor = Colors.black;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      status.capitalizeFirst ?? status,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

}
