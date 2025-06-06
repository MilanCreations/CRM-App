import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Attendance/todayAttendanceController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodayAttendanceScreen extends StatefulWidget {
  const TodayAttendanceScreen({super.key});

  @override
  State<TodayAttendanceScreen> createState() => _TodayAttendanceScreenState();
}

class _TodayAttendanceScreenState extends State<TodayAttendanceScreen> {
  final TodayAttendanceHistoryController controller = Get.put(TodayAttendanceHistoryController());

  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !controller.isLoading.value &&
        controller.hasMoreData.value) {
      controller.AllEmployeesAttendanceHistoryfunctions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_outlined,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: const CustomText(
          text: "Today Dashboard",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allEmployeeAttendanceHistoryList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allEmployeeAttendanceHistoryList.isEmpty) {
          return const Center(child: Text("No attendance records for today."));
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: controller.allEmployeeAttendanceHistoryList.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.allEmployeeAttendanceHistoryList.length) {
              final history = controller.allEmployeeAttendanceHistoryList[index];
              final status = history.status?.toLowerCase() ?? '';
              final leftBarColor = status == 'rejected'
                  ? CRMColors.error
                  : status == 'pending'
                      ? CRMColors.pending
                      : CRMColors.succeed;

           return Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  height: 110,
  decoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Stack(
    children: [
     
      Row(
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
                    text: history.name ?? '',
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
                          text: "Clock Out : ${formatDateTime(history.checkOut) ?? '--'}",
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
    ],
  ),
);

            } else {
              return Obx(() => controller.hasMoreData.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()))
                  : const SizedBox());
            }
          },
        );
      }),
    );
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
}
