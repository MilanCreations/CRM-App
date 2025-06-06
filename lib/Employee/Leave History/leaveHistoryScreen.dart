// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:crm_milan_creations/Employee/Leave%20History/leaveHistoryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class LeavehistoryScreen extends StatefulWidget {
  const LeavehistoryScreen({super.key});

  @override
  State<LeavehistoryScreen> createState() => _LeavehistoryScreenState();
}

class _LeavehistoryScreenState extends State<LeavehistoryScreen> {
  final Leavehistorycontroller leavehistorycontroller = Get.put(
    Leavehistorycontroller(),
  );
  late ScrollController _scrollController;
  final TextEditingController searchController = TextEditingController();
   Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    leavehistorycontroller.leavehistorycontrollerFunction();
    searchController.addListener(_onSearchChanged);
  }
    void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      leavehistorycontroller.leavehistorycontrollerFunction(
        name: searchController.text.trim(),
        isNewSearch: true,
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      leavehistorycontroller.leavehistorycontrollerFunction();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
  String formatDateRange(String startDate, String endDate) {
    try {
      DateTime startUtc = DateTime.parse(startDate);
      DateTime endUtc = DateTime.parse(endDate);
      DateTime startIst = startUtc.add(const Duration(hours: 5, minutes: 30));
      DateTime endIst = endUtc.add(const Duration(hours: 5, minutes: 30));

      String formattedStart = DateFormat('MMM d, yyyy').format(startIst);
      String formattedEnd = DateFormat('MMM d, yyyy').format(endIst);

      return "$formattedStart - $formattedEnd";
    } catch (e) {
      return "";
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      showBackArrow: true,
       leadingIcon: Icons.arrow_back_ios_new_sharp,
      title: CustomText(
        text: 'Leave History',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: CRMColors.whiteColor,
      ),
      gradient: const LinearGradient(
        colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by employee name...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        leavehistorycontroller.leavehistorycontrollerFunction(
                          name: '',
                          isNewSearch: true,
                        );
                      },
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (leavehistorycontroller.isLoading.value &&
                leavehistorycontroller.leaveHistoryList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: CRMColors.black),
              );
            }

            if (leavehistorycontroller.leaveHistoryList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset('assets/images/emptyfile.json'),
                    ),
                    CustomText(
                      text: searchController.text.isEmpty
                          ? "No Leave Records Found"
                          : "No matching leave records",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CRMColors.black,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: leavehistorycontroller.leaveHistoryList.length + 1,
              itemBuilder: (context, index) {
                if (index < leavehistorycontroller.leaveHistoryList.length) {
                  final leave = leavehistorycontroller.leaveHistoryList[index];
                  final status = leave.status?.toLowerCase() ?? '';

                  final leftBarColor = status == 'rejected'
                      ? CRMColors.error
                      : status == 'pending'
                          ? CRMColors.pending
                          : CRMColors.succeed;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 6,
                            decoration: BoxDecoration(
                              color: leftBarColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInfoRow('Name: ', leave.employeeName),
                                  buildInfoRow('Leave Type: ', leave.leaveType),
                                  buildInfoRow(
                                    'Date: ',
                                    formatDateRange(
                                      leave.startDate!.toString(),
                                      leave.endDate!.toString(),
                                    ),
                                  ),
                                  buildInfoRow('Duration: ', leave.duration),
                                  buildInfoRow(
                                    'Reason: ',
                                    leave.reason,
                                    isFlexible: true,
                                  ),
                                  buildInfoRow(
                                    'Status: ',
                                    leave.status,
                                    isFlexible: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Obx(() {
                    return leavehistorycontroller.isLoading.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: CRMColors.black,
                              ),
                            ),
                          )
                        : const SizedBox();
                  });
                }
              },
            );
          }),
        ),
      ],
    ),
  );
}
  Widget buildInfoRow(String label, String? value, {bool isFlexible = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CRMColors.black,
          ),
          const SizedBox(width: 4),
          isFlexible
              ? Flexible(
                child: CustomText(
                  text: value ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CRMColors.black,
                ),
              )
              : CustomText(
                text: value ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CRMColors.black,
              ),
        ],
      ),
    );
  }
}
