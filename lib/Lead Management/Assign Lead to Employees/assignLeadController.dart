// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// NOtes :- chamge the company ID.

class AssignLeadController extends GetxController {
  var isLoading = false.obs;

  Future<void> assignLeadFunction(
    String leadId,
    String companyId,
    String employeeId
  ) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print("Retrieved token: $token");

      if (token == null) {
        isLoading.value = false;
        print("Token is null. Logging out user...");
        clearSharedPreferences();
        return;
      }


           Map<String, String> newData = {
          "lead_id": leadId.toString(),
          "company_id": "4",
          "employee_id": employeeId.toString(),
         
        };

        print("lead id:- $leadId");
        print("companyId id:- $companyId");
        print("employeeId id:- $employeeId");
        print("New Data :- $newData");

      final url = Uri.parse(ApiConstants.assignLeadToEmployees);
      print("Sending request to URL in assign lead: $url");

      final response = await http.post(
        url,
        body: jsonEncode(newData),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      print("Response status code in assign Lead to employee: ${response.statusCode}");
      print("Response body assign Lead to employee: ${response.body}");

      switch (response.statusCode) {
        case 200:
          print("assign Lead to employee successfully");
          Get.snackbar(
        'Success',
        'Lead assigned to employee.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
          break;

        case 400:
          Get.snackbar(
            "Error 400",
            "Bad request. Please check parameters.",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          break;

        case 401:
          Get.snackbar(
            "Unauthorized",
            "Your session expired. Please login again.",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          clearSharedPreferences();
          break;

        case 403:
          Get.snackbar(
            "Forbidden",
            "You don’t have permission to perform this action.",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          break;

        case 404:
          Get.snackbar(
            "Not Found",
            "Employee not found.",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          break;

        case 500:
          Get.snackbar(
            "Server Error",
            "Something went wrong on the server.",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          break;

        default:
          Get.snackbar(
            "Error",
            "Something went wrong (${response.statusCode})",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
      }
    } catch (e) {
      print("Exception occurred: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } finally {
      isLoading.value = false;
      print("Loading complete.");
    }
  }

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(LoginScreen());
  }
}
