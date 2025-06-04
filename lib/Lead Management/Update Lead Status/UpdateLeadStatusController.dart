// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Details/leadDetailsScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Update%20Lead%20Status/UpdateLeadStatusModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateLeadcontroller extends GetxController {
  TextEditingController feedBack = TextEditingController();
  TextEditingController statusController = TextEditingController();

  var isLoading = false.obs;

  Future<void> updateLeadCOntrollerFunction(
    String leadid,
    var followupdate,
    String leadstatus,
    String type,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');

    print(followupdate);

    if (token == null) {
      print("Empty token in  update lead status");
    } else {
      try {
        isLoading.value = true;

        Map<String?, String?> newData = {
          "type": type,
          "feedback": feedBack.text.trim(),
          "status": leadstatus,
          "lead_id": leadid,
          "followup_date": followupdate,
        };

        print("===================================");
        print("type:- $type");
        print("feedback:- ${feedBack.text.trim()}");
        print("lead_id:- ${leadid}");
        print("followup_date:- ${followupdate}");
        print("Lead Status:- $leadstatus");

        final response = await http.put(
          Uri.parse(ApiConstants.updateLeadStatus),
          body: jsonEncode(newData),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
        );

        final responseBody = jsonDecode(response.body);
        print('API Response in update lead status: $responseBody');
        print('Status code in update lead status: ${response.statusCode}');

        // Handle all non-200 status codes first
        if (response.statusCode != 200) {
          // var modelData = createLeadModelFromJson(response.body);

          isLoading.value = false;

          // If the API returns status: false with errors
          if (responseBody is Map && responseBody['status'] == false) {
            String errorMsg =
                responseBody['message'] ??
                formatErrors(responseBody['error'] ?? {});
            Get.snackbar(
              "Message",
              errorMsg,
              backgroundColor: CRMColors.error,
              colorText: CRMColors.textWhite,
            );
          } else {
            // Fallback to HTTP error code messages
            String msg = 'Something went wrong';
            switch (response.statusCode) {
              case 400:
                msg = 'Bad Request';
                break;
              case 401:
                msg = 'Invalid Credentials';
                break;
              case 404:
                msg = 'Not Found';
                break;
              case 500:
                msg = 'Internal Server Error';
                break;
            }

            Get.snackbar(
              "Message",
              msg,
              backgroundColor: CRMColors.error,
              colorText: CRMColors.textWhite,
            );
          }

          return;
        }

        // Handle successful login (statusCode 200)
        var updateStatus = updateleadStatusModelFromJson(response.body);
        // final prefs = await SharedPreferences.getInstance();
        print('updateStatus:- $updateStatus');

        isLoading.value = false;

        clearAllFields();

        Get.off(LeadDetailsScreen(assignID: leadid,));
      } catch (error) {
        isLoading.value = false;
        print("Catch Error: $error");
        Get.snackbar(
          'Message',
          error.toString(),
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Helper function to format API error messages
  String formatErrors(Map<String, dynamic> errors) {
    List<String> messages = [];
    errors.forEach((key, value) {
      messages.add("${key.toUpperCase()}: ${value.join(", ")}");
    });
    return messages.join("\n");
  }

  void clearAllFields() {
    // nameController.clear();
  }
}
