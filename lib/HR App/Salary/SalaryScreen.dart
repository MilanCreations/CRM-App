import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';

class Salaryscreen extends StatefulWidget {
  const Salaryscreen({super.key});

  @override
  State<Salaryscreen> createState() => _SalaryscreenState();
}

class _SalaryscreenState extends State<Salaryscreen> {
  final List<Map<String, dynamic>> salaryHistory = [
    {
      "month": "April 2025",
      "amount": "₹25,000",
      "status": "Paid",
      "date": "05 Apr 2025",
    },
    {
      "month": "March 2025",
      "amount": "₹25,000",
      "status": "Paid",
      "date": "05 Mar 2025",
    },
    {
      "month": "February 2025",
      "amount": "₹25,000",
      "status": "Due",
      "date": "Pending",
    },
  ];

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
          text: 'Salary',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CRMColors.crmMainCOlor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem("Total", "₹75,000"),
                  _buildSummaryItem("Paid", "₹50,000"),
                  _buildSummaryItem("Due", "₹25,000"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Salary History Heading
            CustomText(
              text: "Salary History",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            const SizedBox(height: 10),

            // Salary History List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: salaryHistory.length,
              itemBuilder: (context, index) {
                final item = salaryHistory[index];
                final isPaid = item["status"] == "Paid";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPaid ? Colors.green : Colors.red,
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item["month"],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Amount: ${item["amount"]}",
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          CustomText(
                            text: "Status: ${item["status"]}",
                            fontSize: 14,
                            color: isPaid ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: "Date: ${item["date"]}",
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      children: [
        CustomText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        const SizedBox(height: 6),
        CustomText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ],
    );
  }
}
