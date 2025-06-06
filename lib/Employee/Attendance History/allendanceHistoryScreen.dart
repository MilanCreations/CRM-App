// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:crm_milan_creations/Employee/Attendance%20History/attendanceHistoryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AttendanceHistoryController attendanceHistoryController = Get.put(
    AttendanceHistoryController(),
  );
  TextEditingController searchController = TextEditingController();
  late final ScrollController _scrollController;
  Timer? _debounce;
  String userRole = "";
  RxBool isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    getUserData();
    _scrollController = ScrollController()..addListener(_onScroll);
    attendanceHistoryController.AllEmployeesAttendanceHistoryfunctions(
      isRefresh: true,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !attendanceHistoryController.isLoading.value &&
        attendanceHistoryController.hasMoreData.value) {
      _fetchFilteredData();
    }
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(DateTime? dateTime) {
    try {
      if (dateTime == null) return "-";
      DateTime localDateTime = dateTime.toLocal();
      return DateFormat('hh:mm a').format(localDateTime);
    } catch (_) {
      return "-";
    }
  }

  String formatDateOnly(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return "-";
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _resetAndFetchFilteredData();
    });
  }

  Future<void> _resetAndFetchFilteredData() async {
    attendanceHistoryController.hasMoreData.value = true;
    attendanceHistoryController.currentPage.value = 1;
    attendanceHistoryController.allEmployeeAttendanceHistoryList.clear();
    await _fetchFilteredData();
  }

  Future<void> _fetchFilteredData() async {
    String? startDate =
        attendanceHistoryController.startDateTime.value != null
            ? DateFormat(
              'yyyy-MM-dd',
            ).format(attendanceHistoryController.startDateTime.value!)
            : null;

    String? endDate =
        attendanceHistoryController.endDateTime.value != null
            ? DateFormat(
              'yyyy-MM-dd',
            ).format(attendanceHistoryController.endDateTime.value!)
            : null;

    await attendanceHistoryController.AllEmployeesAttendanceHistoryfunctions(
      nameSearch: searchController.text.trim(),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> pickDateTime(Rx<DateTime?> dateTime) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateTime.value = pickedDate;

      if (attendanceHistoryController.startDateTime.value != null &&
          attendanceHistoryController.endDateTime.value != null) {
        await _resetAndFetchFilteredData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );

    return Scaffold(
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'History',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
              userRole != "EMPLOYEE"
         ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search employee...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              FocusScope.of(context).unfocus();
                              _resetAndFetchFilteredData();
                            },
                          )
                          : null,
                ),
              ),
            ),
          ): SizedBox(),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        readOnly: true,
                        onTap:
                            () => pickDateTime(
                              attendanceHistoryController.startDateTime,
                            ),
                        decoration: inputDecoration.copyWith(
                          labelText: "Start Date",
                          hintText: "MM/DD/YYYY",
                          filled: true,
                          fillColor:
                              Colors
                                  .transparent, // Keeps Container color visible
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              attendanceHistoryController.startDateTime.value !=
                                      null
                                  ? DateFormat.yMd().format(
                                    attendanceHistoryController
                                        .startDateTime
                                        .value!,
                                  )
                                  : '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        readOnly: true,
                        onTap:
                            () => pickDateTime(
                              attendanceHistoryController.endDateTime,
                            ),
                        decoration: inputDecoration.copyWith(
                          labelText: "End Date",
                          hintText: "MM/DD/YYYY",
                          filled: true,
                          fillColor:
                              Colors
                                  .transparent, // Keeps Container color visible
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              attendanceHistoryController.endDateTime.value !=
                                      null
                                  ? DateFormat.yMd().format(
                                    attendanceHistoryController
                                        .endDateTime
                                        .value!,
                                  )
                                  : '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  attendanceHistoryController.startDateTime.value = null;
                  attendanceHistoryController.endDateTime.value = null;
                  _resetAndFetchFilteredData();
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text("Clear Filters"),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (attendanceHistoryController.isLoading.value &&
                  attendanceHistoryController
                      .allEmployeeAttendanceHistoryList
                      .isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: CRMColors.black),
                );
              }

              if (attendanceHistoryController
                  .allEmployeeAttendanceHistoryList
                  .isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/emptyfile.json',
                      //   height: 200,
                      //   width: 200,
                      // ),
                      // const SizedBox(height: 16),
                      CustomText(
                        text: "No Records Found",
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
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                itemCount:
                    attendanceHistoryController
                        .allEmployeeAttendanceHistoryList
                        .length +
                    1,
                itemBuilder: (context, index) {
                  if (index < attendanceHistoryController
                          .allEmployeeAttendanceHistoryList
                          .length) {
                    final history =
                        attendanceHistoryController
                            .allEmployeeAttendanceHistoryList[index];
                    final status = history.status?.toLowerCase() ?? '';
                    final leftBarColor =
                        status == 'rejected'
                            ? CRMColors.error
                            : status == 'pending'
                            ? CRMColors.pending
                            : CRMColors.succeed;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 110,
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
                                horizontal: 12,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: history.name,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: CRMColors.black,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: formatDateOnly(
                                      history.attendanceDate.toString(),
                                    ),
                                    fontSize: 13,
                                    color: CRMColors.black,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text:
                                              "Clock In : ${formatDateTime(history.checkIn)}",
                                          fontSize: 12,
                                          color: CRMColors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          text:
                                              "Clock Out : ${formatDateTime(history.checkOut)}",
                                          fontSize: 12,
                                          textAlign: TextAlign.right,
                                          color: CRMColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Obx(() {
                      return attendanceHistoryController.isLoading.value
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
}
