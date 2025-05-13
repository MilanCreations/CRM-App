import 'package:crm_milan_creations/Employee/Attendance%20History/attendanceHistoryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/dropdown.dart';
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

  late ScrollController _scrollController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch today's attendance only
    attendanceHistoryController.AttendanceHistoryfunctions(
      isRefresh: true,
      startDate: today,
      endDate: today,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      attendanceHistoryController.AttendanceHistoryfunctions();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(DateTime dateTime) {
    try {
      DateTime localDateTime = dateTime.toLocal();
      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return "";
    }
  }

  String formatDateOnly(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return "";
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
          text: 'Attendance History',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
      ),
      body: Obx(() {
        if (attendanceHistoryController.isLoading.value &&
            attendanceHistoryController.attendanceHistoryList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: CRMColors.black),
          );
        }

        if (attendanceHistoryController.attendanceHistoryList.isEmpty) {
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
                  text: "No Records Found",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CRMColors.black,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildDateFilterButtons(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount:
                    attendanceHistoryController.attendanceHistoryList.length + 1,
                itemBuilder: (context, index) {
                  if (index <
                      attendanceHistoryController.attendanceHistoryList.length) {
                    final history =
                        attendanceHistoryController.attendanceHistoryList[index];

                    final status = history.status?.toLowerCase() ?? '';
                    final leftBarColor = status == 'rejected'
                        ? CRMColors.error
                        : status == 'pending'
                            ? CRMColors.pending
                            : CRMColors.succeed;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                                vertical: 16,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        text: history.name,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: CRMColors.black,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: formatDateOnly(
                                        history.attendanceDate.toString()),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: CRMColors.black,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text:
                                              "Clock In: ${formatDateTime(history.checkIn).isEmpty ? "-" : formatDateTime(history.checkIn)}",
                                          fontSize: 12,
                                          color: CRMColors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          text:
                                              "Clock Out: ${formatDateTime(history.checkOut).isEmpty ? "-" : formatDateTime(history.checkOut)}",
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
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDateFilterButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // CustomDropdownButton2(hint: CustomText(text: 'Select Employee'), value: value, dropdownItems: , onChanged: (value) {
            
          // },),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    _startDate == null
                        ? 'Start Date'
                        : DateFormat('yyyy-MM-dd').format(_startDate!),
                    style: const TextStyle(color: CRMColors.black),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                        if (_endDate != null && _endDate!.isBefore(picked)) {
                          _endDate = null;
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    _endDate == null
                        ? 'End Date'
                        : DateFormat('yyyy-MM-dd').format(_endDate!),
                    style: const TextStyle(color: CRMColors.black),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
                      firstDate: _startDate ?? DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.search, color: CRMColors.black),
                onPressed: () {
                  if (_startDate == null || _endDate == null) {
                    Get.snackbar(
                      "Error",
                      "Please select both start and end dates",
                      backgroundColor: CRMColors.error,
                      colorText: CRMColors.textWhite,
                    );
                    return;
                  }
          
                  if (_endDate!.isBefore(_startDate!)) {
                    Get.snackbar(
                      "Error",
                      "End date must be after start date",
                      backgroundColor: CRMColors.error,
                      colorText: CRMColors.textWhite,
                    );
                    return;
                  }
          
                  final start = DateFormat('yyyy-MM-dd').format(_startDate!);
                  final end = DateFormat('yyyy-MM-dd').format(_endDate!);
          
                  attendanceHistoryController.AttendanceHistoryfunctions(
                    isRefresh: true,
                    startDate: start,
                    endDate: end,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear, color: CRMColors.black),
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  attendanceHistoryController.AttendanceHistoryfunctions(
                    isRefresh: true,
                    startDate: today,
                    endDate: today,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
