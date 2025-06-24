import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeaveRequestController extends GetxController {
  Rx<DateTime?> startDateTime = Rx<DateTime?>(null);
  Rx<DateTime?> endDateTime = Rx<DateTime?>(null);

  RxString leavetypeid  = ''.obs;
  var isLoading = false.obs;
  TextEditingController reasonController = TextEditingController();


Future<void> applyLeave() async {
  try {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? epmid = prefs.getString('id');


    if (token == null) {
      isLoading.value = false;
      Get.snackbar("Error", "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    final uri = Uri.parse(ApiConstants.applyLeave);
    print("Final Leave Apply API URL: $startDateTime");

    final body = {
      "employee_id": epmid,
      "start_date": startDateTime.toString(),
      "end_date": endDateTime.toString(),
      "reason": reasonController.text,
      "leave_type_id": leavetypeid.toString(),
    };

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("Leave Apply API Status Code: ${response.statusCode}");
    print("Leave Apply API Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      
      Get.snackbar("Success", "Leave request submitted",
          backgroundColor: Colors.green, colorText: CRMColors.textWhite);
          startDateTime.value = null;
      endDateTime.value = null;
      leavetypeid.value = '';
      reasonController.clear();
    } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500) {
      Get.snackbar('Error', 'Internal Server Error',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }
  } catch (e) {
    Get.snackbar("Exception", e.toString(),
        backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
  } finally {
    isLoading.value = false;
  }
}


void submitLeaveRequest() {
  if (startDateTime.value == null) {
    Get.snackbar("Error", "Please select start date and time",backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    return;
  }

  if (endDateTime.value == null) {
    Get.snackbar("Error", "Please select end date and time",backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    return;
  }

  if (leavetypeid.value.isEmpty) {
    Get.snackbar("Error", "Please select leave type",backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    return;
  }

  if (reasonController.text.trim().isEmpty) {
    Get.snackbar("Error", "Please enter reason for leave",backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    return;
  }

  applyLeave(); // All validations passed
}

}
