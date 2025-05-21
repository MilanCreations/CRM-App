// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Lead%20Management/Create%20Leads/createLeadModel.dart';
import 'package:crm_milan_creations/Lead%20Management/My%20Leads%20List/myLeadListScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateLeadcontroller extends GetxController {
  TextEditingController feedBack = TextEditingController();
  TextEditingController statusController = TextEditingController();


  var isLoading = false.obs;

  Future<void> updateLeadCOntrollerFunction(
    BuildContext context,
    String selectedSource,
    String token,
    String employeeID,
    String visitTime,
  ) async {

    if (token.isEmpty) {

    } else {
      try {
        isLoading.value = true;

        Map<String, String> newData = {
          "type": "mature",
          "feedback": feedBack.text.trim(),
          "status": statusController.text.trim(),
          // "lead_id": nameController.text.trim(),
          // "followup_date": nameController.text.trim(),
         
        };

      
      
      // print("===================================");

        final response = await http.post(
          Uri.parse(ApiConstants.creatLead),
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
        var loginModel = createLeadModelFromJson(response.body);
        // final prefs = await SharedPreferences.getInstance();

        isLoading.value = false;

      
       clearAllFields();
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Dialog Title',
            desc: responseBody['message'] ?? 'Lead created successfully',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
            ).show();
            Get.off(LeadListScreen());
     
      } catch (error) {
        isLoading.value = false;
        print("Catch Login Error: $error");
        Get.snackbar(
          'Login Failed',
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
