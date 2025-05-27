import 'package:crm_milan_creations/Employee/Attendance%20History/attendanceHistoryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AttendanceHistoryController attendanceHistoryController = Get.put(
    AttendanceHistoryController(),
  );

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    attendanceHistoryController.AllEmployeesAttendanceHistoryfunctions(isRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !attendanceHistoryController.isLoading.value &&
        attendanceHistoryController.hasMoreData.value) {
      attendanceHistoryController.AllEmployeesAttendanceHistoryfunctions();
    }
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
          text: 'History',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
      ),
      body: Obx(() {
        if (attendanceHistoryController.isLoading.value &&
            attendanceHistoryController.allEmployeeAttendanceHistoryList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: CRMColors.black));
        }

        if (attendanceHistoryController.allEmployeeAttendanceHistoryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/images/emptyfile.json', height: 200, width: 200),
                const SizedBox(height: 16),
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
          physics: const BouncingScrollPhysics(),
          itemCount: attendanceHistoryController.allEmployeeAttendanceHistoryList.length + 1,
          itemBuilder: (context, index) {
            if (index < attendanceHistoryController.allEmployeeAttendanceHistoryList.length) {
              final history = attendanceHistoryController.allEmployeeAttendanceHistoryList[index];
              final status = history.status?.toLowerCase() ?? '';
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                              text: formatDateOnly(history.attendanceDate.toString()),
                              fontSize: 13,
                              color: CRMColors.black,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: "Clock In : ${formatDateTime(history.checkIn)}",
                                    fontSize: 12,
                                    color: CRMColors.black,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: "Clock Out : ${formatDateTime(history.checkOut)}",
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
                          child: CircularProgressIndicator(color: CRMColors.black),
                        ),
                      )
                    : const SizedBox();
              });
            }
          },
        );
      }),
    
    );
  }
}
