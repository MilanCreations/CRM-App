import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';

class LeadHistoryScreen extends StatefulWidget {
  const LeadHistoryScreen({super.key});

  @override
  State<LeadHistoryScreen> createState() => _LeadHistoryScreenState();
}

class _LeadHistoryScreenState extends State<LeadHistoryScreen> {
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
        text: 'Lead History',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: CRMColors.whiteColor,
      ),
    ),
    body: Column(
      children: [
        
      ],
    ),
    );
  }
}