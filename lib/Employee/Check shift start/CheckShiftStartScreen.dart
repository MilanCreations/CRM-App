import 'package:crm_milan_creations/Employee/Check%20shift%20start/CheckShiftStartController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckStartShiftScreen extends StatefulWidget {
  const CheckStartShiftScreen({super.key});

  @override
  State<CheckStartShiftScreen> createState() => _CheckStartShiftScreenState();
}

class _CheckStartShiftScreenState extends State<CheckStartShiftScreen> {
  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    locationController.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start Shift Location")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.person_pin_circle,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                locationController.currentAddress.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              )),
              
          const SizedBox(height: 20),
              CustomButton(text: 'Start shift', 
              textColor: CRMColors.black,
              width: Get.width * 0.7,
              gradient: LinearGradient(colors: [CRMColors.crmMainCOlor, CRMColors.whiteColor,CRMColors.crmMainCOlor]),
              onPressed: () {
                
              },)
        ],
      ),
    );
  }
}
