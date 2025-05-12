import 'package:crm_milan_creations/Employee/Clock%20In%20Map/clockinMapController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClockInMapScreen extends StatefulWidget {
  const ClockInMapScreen({super.key});

  @override
  State<ClockInMapScreen> createState() => _ClockInMapScreenState();
}

class _ClockInMapScreenState extends State<ClockInMapScreen> {
  ClockController objClockController = Get.put(ClockController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: CustomText(
            text: 'Clock In',
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: CRMColors.black,
          )),
      body: Text(""));
           
  }
}