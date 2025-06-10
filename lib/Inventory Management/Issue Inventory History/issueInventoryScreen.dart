// ignore_for_file: deprecated_member_use

import 'package:crm_milan_creations/Inventory%20Management/Issue%20Inventory%20History/issueInventoryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueInventoryHistoryScreen extends StatefulWidget {
  const IssueInventoryHistoryScreen({super.key});

  @override
  State<IssueInventoryHistoryScreen> createState() =>
      IssueInventoryHistoryScreenState();
}

class IssueInventoryHistoryScreenState
    extends State<IssueInventoryHistoryScreen> {
  final IssueInventoryController controller = Get.put(IssueInventoryController());

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Inventory List',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 5,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FadeShimmer.round(
                        size: 40,
                        fadeTheme: FadeTheme.light,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeShimmer(
                              height: 12,
                              width: double.infinity,
                              radius: 4,
                              fadeTheme: FadeTheme.light,
                            ),
                            const SizedBox(height: 8),
                            FadeShimmer(
                              height: 12,
                              width: 150,
                              radius: 4,
                              fadeTheme: FadeTheme.light,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FadeShimmer(
                    height: 12,
                    width: 100,
                    radius: 4,
                    fadeTheme: FadeTheme.light,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.inventoryList.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final item = controller.inventoryList[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: CRMColors.blue.withOpacity(0.2),
                      child: Text(
                        item.employee[0],
                        style: const TextStyle(
                          color: CRMColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      item.employee,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text('Issued on ${item.date}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            item.issuedBy,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(child: Text('${item.items.length} item(s)')),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => controller.toggleExpanded(index),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.isExpanded
                                    ? 'Hide Details'
                                    : 'View Details',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                item.isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.isExpanded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: item.items.map((inv) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        inv.type,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        inv.model,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Serial No: ${inv.serialNumber}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Accessories:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: inv.accessories
                                        .map(
                                          (acc) => Chip(
                                            label: Text(acc),
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            labelStyle: const TextStyle(
                                              color: CRMColors.blue,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
