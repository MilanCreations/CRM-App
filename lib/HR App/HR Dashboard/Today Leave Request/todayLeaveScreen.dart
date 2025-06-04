import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Leave%20Request/todayLeaveController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrLeaveRequestScreen extends StatelessWidget {
  final String? statusFilter;
  final bool isToday;

  const HrLeaveRequestScreen({
    super.key,
    this.statusFilter,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HRLeaveRequestController());

    // Set initial filter
    if (isToday) {
      controller.selectedFilter.value = "today";
    } else if (statusFilter != null) {
      controller.selectedFilter.value = statusFilter!;
    } else {
      controller.selectedFilter.value = "all";
    }

    // Fetch data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.changeFilter(controller.selectedFilter.value);
    });

    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: controller.selectedFilter.value == "today"
              ? "Today's Leaves"
              : controller.selectedFilter.value == "pending"
                  ? "Pending Leaves"
                  : controller.selectedFilter.value == "approved"
                      ? "Approved Leaves"
                      : "All Leaves",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // _buildFilterChips(controller),
          Expanded(
            child: Obx(() {
              final selectedFilter = controller.selectedFilter.value;
              final isLoading = controller.isLoading.value;

              final leaveList = selectedFilter == "today"
                  ? controller.todayLeaves
                  : selectedFilter == "pending"
                      ? controller.pendingLeaves
                      : selectedFilter == "approved"
                          ? controller.approvedLeaves
                          : controller.leaveRequestHistory;

              if (isLoading && leaveList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (leaveList.isEmpty) {
                return Center(
                  child: Text(
                    selectedFilter == "today"
                        ? "No leaves for today"
                        : selectedFilter == "pending"
                            ? "No pending leaves"
                            : selectedFilter == "approved"
                                ? "No approved leaves"
                                : "No leaves found",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: leaveList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final leave = leaveList[index];
                  return _buildLeaveCard(leave);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget _buildFilterChips(HRLeaveRequestController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Obx(() {
  //         return Row(
  //           children: [
  //             _buildFilterChip(controller, "all", "All"),
  //             const SizedBox(width: 8),
  //             _buildFilterChip(controller, "today", "Today"),
  //             const SizedBox(width: 8),
  //             _buildFilterChip(controller, "pending", "Pending"),
  //             const SizedBox(width: 8),
  //             _buildFilterChip(controller, "approved", "Approved"),
  //           ],
  //         );
  //       }),
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(HRLeaveRequestController controller, String value, String label) {
  //   return ChoiceChip(
  //     label: Text(label),
  //     selected: controller.selectedFilter.value == value,
  //     onSelected: (selected) {
  //       controller.changeFilter(value);
  //     },
  //     selectedColor: CRMColors.primary,
  //     labelStyle: TextStyle(
  //       color: controller.selectedFilter.value == value ? Colors.white : Colors.black,
  //     ),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //   );
  // }

  Widget _buildLeaveCard(dynamic leave) {
    Color statusColor;
    IconData statusIcon;

    switch (leave.status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    leave.employeeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CRMColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        leave.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, "Duration: ${leave.duration}"),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.info_outline, "Reason: ${leave.reason.replaceAll('\n', ' ')}"),
            if (leave.approvedByName != null && leave.approvedByName!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.verified_user, "Approved by: ${leave.approvedByName}",
                  iconColor: Colors.blue),
            ],
            if (leave.rejectionReason != null && leave.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.cancel, "Rejection Reason: ${leave.rejectionReason}",
                  iconColor: Colors.red),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color iconColor = Colors.grey}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}