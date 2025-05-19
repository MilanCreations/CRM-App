import 'dart:async';
import 'package:crm_milan_creations/HR%20App/Employee%20Leave%20Request/Action%20on%20Leave%20status/leaveAcionController.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Leave%20Request/empLeaveRequestController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmpLeaveRequestScreen extends StatefulWidget {
  const EmpLeaveRequestScreen({Key? key}) : super(key: key);

  @override
  State<EmpLeaveRequestScreen> createState() => _EmpLeaveRequestScreenState();
}

class _EmpLeaveRequestScreenState extends State<EmpLeaveRequestScreen> {
  final TextEditingController searchController = TextEditingController();
  late ScrollController scrollController;
  final GetAllEmployeeLeaveController controller = Get.put(GetAllEmployeeLeaveController());
  final LeaveActionController leaveActionController = Get.put(LeaveActionController());
  var isSearching = false.obs;
  var debounceTimer;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    controller.getAllEmployeeLeaveFunction();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          controller.hasMoreData.value &&
          !controller.isLoading.value) {
        if (isSearching.value) {
          controller.getAllEmployeeLeaveFunction(name: searchController.text.trim());
        } else {
          controller.getAllEmployeeLeaveFunction();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    debounceTimer?.cancel();
    super.dispose();
  }

  Widget statusChip(String status) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        text = 'Approved';
        icon = Icons.check_circle_outline;
        break;
      case 'rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        text = 'Rejected';
        icon = Icons.cancel_outlined;
        break;
      default:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        text = 'Pending';
        icon = Icons.access_time_outlined;
    }

    return Chip(
      backgroundColor: bgColor,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

void _handleSearch(String query) {
  if (debounceTimer != null) {
    debounceTimer.cancel();
  }

  debounceTimer = Timer(const Duration(milliseconds: 500), () {
    isSearching.value = query.isNotEmpty;
    controller.leaveHistoryList.clear();
    controller.currentPage.value = 1;
    controller.hasMoreData.value = true;
    controller.isLoading.value = true;  // Start loading indicator

    if (query.isEmpty) {
      controller.getAllEmployeeLeaveFunction().then((_) {
        controller.isLoading.value = false;  // Stop loading indicator after search
      });
    } else {
      controller.getAllEmployeeLeaveFunction(name: query.trim()).then((_) {
        controller.isLoading.value = false;  // Stop loading indicator after search
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
         leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: CustomText(
          text: 'Leave Requests',
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by employee name...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.leaveHistoryList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C46CC)),
                  ),
                );
              }

              if (controller.leaveHistoryList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isSearching.value
                            ? "No matching leave requests found"
                            : "No leave requests available",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.leaveHistoryList.clear();
                  controller.currentPage.value = 1;
                  await controller.getAllEmployeeLeaveFunction();
                },
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: controller.leaveHistoryList.length +
                      (controller.hasMoreData.value && !controller.isLoading.value ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    if (index < controller.leaveHistoryList.length) {
                      final leave = controller.leaveHistoryList[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child:  Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                
                                  children: [
                                    Expanded(
                                      child: Text(
                                        leave.employeeName ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    statusChip(leave.status ?? 'pending'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formatDateRange(
                                        leave.startDate.toString(),
                                        leave.endDate.toString(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                // Text("Reason"),
                               
                                //  Text(leave.reason ?? 'No reason provided'),
                                const SizedBox(height: 12),
                                CustomText(
                                 text:  'Reason',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                 text:  leave.reason ?? 'No reason provided',
                                  fontSize: 14,
                                ),
                                if (leave.status?.toLowerCase() == 'pending')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () => _showActionDialog(leave.id, 'rejected'),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.red),
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                          ),
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () => _showActionDialog(leave.id, 'approved'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                          ),
                                          child: const Text(
                                            'Approve',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (leave.status?.toLowerCase() == 'rejected' &&
                                    leave.rejectionReason != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Colors.red.shade400,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Rejection reason",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        leave.rejectionReason!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        
                      );
                   
                    } else {
                      return controller.hasMoreData.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C46CC)),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String formatDateRange(String startDate, String endDate) {
    try {
      DateTime startUtc = DateTime.parse(startDate);
      DateTime endUtc = DateTime.parse(endDate);

      // Convert to IST (UTC+5:30)
      DateTime startIst = startUtc.add(const Duration(hours: 5, minutes: 30));
      DateTime endIst = endUtc.add(const Duration(hours: 5, minutes: 30));

      String formattedStart = DateFormat('MMM d, yyyy').format(startIst);
      String formattedEnd = DateFormat('MMM d, yyyy').format(endIst);

      return "$formattedStart - $formattedEnd";
    } catch (e) {
      return "";
    }
  }

  void _showActionDialog(int leaveId, String action) {
    final isApprove = action == 'approved';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            isApprove ? 'Approve Leave' : 'Reject Leave',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
              'Are you sure you want to ${isApprove ? 'approve' : 'reject'} this leave request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await leaveActionController.leaveActionFunction(leaveId, action);

                final index = controller.leaveHistoryList.indexWhere((item) => item.id == leaveId);
                if (index != -1) {
                  setState(() {
                    controller.leaveHistoryList[index].status = action;
                  });
                }

                await controller.getAllEmployeeLeaveFunction();
              },
              child: Text(
                isApprove ? 'Approve' : 'Reject',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}