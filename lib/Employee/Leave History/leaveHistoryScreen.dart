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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    leavehistorycontroller.leavehistorycontrollerFunction();
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
    super.dispose();
  }

String formatDate(dynamic dateInput) {
  try {
    DateTime date;
    if (dateInput is String) {
      date = DateTime.parse(dateInput);
    } else if (dateInput is DateTime) {
      date = dateInput;
    } else {
      return "";
    }
    return DateFormat('MMMM d, yyyy').format(date);
  } catch (e) {
    return "";
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
      body: Obx(() {
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
                  text: "No Leave Records Found",
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

              final leftBarColor =
                  status == 'rejected'
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
                      height: 100,
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
                                  text: 'Name: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                CustomText(
                                  text: leave.employeeName ,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: 'Leave Type: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                CustomText(
                                  text: leave.leaveType,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: 'Start Date: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                CustomText(
                                  text: formatDate(leave.startDate),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                              ],
                            ),
                             Row(
                              children: [
                                CustomText(
                                  text: 'End Date: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                CustomText(
                                  text: formatDate(leave.endDate),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                              ],
                            ),
                              Row(
                              children: [
                                CustomText(
                                  text: 'Duration: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                CustomText(
                                  text: leave.duration,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                CustomText(
                                  text: 'Reason: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                Flexible(
                                  child: CustomText(
                                    text: leave.reason,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: CRMColors.black,
                                    
                                  ),
                                ),
                              ],
                            ),

                             Row(
                              children: [
                                CustomText(
                                  text: 'Status: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.black,
                                ),
                                Flexible(
                                  child: CustomText(
                                    text: leave.status,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
    );
  }
}
