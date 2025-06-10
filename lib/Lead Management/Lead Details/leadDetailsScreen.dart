import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
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
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
       _checkInitialConnection();
   _setupConnectivityListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leadDetailsController.leadDetailsFunction(
        assignId: widget.assignID,
        isRefresh: true,
      );
    });
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
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CRMColors.lightGreyBackground,
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        title: CustomText(
          text: 'Lead Details',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
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
              // Modern Search Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search leads...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.search_rounded, 
                        color: Colors.grey.shade500),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, 
                                color: Colors.grey.shade500),
                            onPressed: () {
                              searchController.clear();
                              _onSearchChanged();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Lead List
              Expanded(
                child: Obx(() {
                  if (leadDetailsController.isLoading.value &&
                      leadDetailsController.leadDetailsList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CRMColors.black1),
                      ),
                    );
                  }

                  if (leadDetailsController.leadDetailsList.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_alt_rounded,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                         text:  'No Lead Details Found',
                         fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                        text:  'Try adjusting your search or filter',
                            fontSize: 14,
                            color: Colors.grey.shade500,
                        ),
                      ],
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await leadDetailsController.leadDetailsFunction(
                        assignId: widget.assignID,
                        isRefresh: true,
                      );
                    },
                    color: CRMColors.black1,
                    child: ListView.separated(
                      itemCount: leadDetailsController.leadDetailsList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final lead = leadDetailsController.leadDetailsList[index];

                        String formattedVisit = '';
                        if (lead.visitTime != null) {
                          try {
                            formattedVisit = DateFormat(
                              'd MMM y, hh:mm a',
                            ).format(lead.visitTime!.toLocal());
                          } catch (_) {
                            formattedVisit = 'Invalid Date';
                          }
                        }

                        String updatedAt = lead.updatedAt != null
                            ? DateFormat('d MMM y, hh:mm a')
                                .format(lead.updatedAt!.toLocal())
                            : "Not Available";

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                          )],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name Row with Status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lead.name ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: CRMColors.black1,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (lead.status != null)
                                      _buildStatusChip(lead.status!),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Divider
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 12),

                                // Info Grid
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  children: [
                                     // Company Name
                                    if (lead.companyName != null)
                                      _buildInfoTile(
                                        Icons.business_rounded,
                                        "Company",
                                        lead.companyName!,
                                      ),

                                    // Follow Up
                                    _buildInfoTile(
                                      Icons.calendar_today_rounded,
                                      "Follow Up",
                                      lead.followupDate != null
                                          ? DateFormat('d MMM y')
                                              .format(lead.followupDate!.toLocal())
                                          : "No Date",
                                    ),

                                    // Visit Date
                                    if (formattedVisit.isNotEmpty)
                                      _buildInfoTile(
                                        Icons.place_rounded,
                                        "Visit Date",
                                        formattedVisit,
                                      ),

                                    // Updated At
                                    _buildInfoTile(
                                      Icons.update_rounded,
                                      "Updated",
                                      updatedAt,
                                    ),

                                   


                                       if (lead.purpose != null)
                                      _buildInfoTile(Icons.assignment_rounded, 
                                          "Purpose", lead.purpose!),

                                  ],
                                ),

                                // Remark (full width)
                                if (lead.remark != null && lead.remark!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        "Remark",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lead.remark!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade800,
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
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: CustomText(
                 text:  value,
                 fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
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
        backgroundColor = Colors.blueAccent;
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.capitalizeFirst ?? status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}