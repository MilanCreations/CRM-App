// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Lead%20Management/Create%20Leads/createLeadModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreateLeadcontroller extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController queryTypeController = TextEditingController();

  var isLoading = false.obs;

  Future<void> createLeadCOntrollerFunction(
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
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "remark": purposeController.text.trim(),
          "branch_name": branchNameController.text.trim(),
          "address": addressController.text.trim(),
          "source": selectedSource,
          "query_type": queryTypeController.text.trim(),
          // optional fields
          // "company_id": companyid.toString(),
          "lead_creator": employeeID.toString(),
          "visit_time": datetimeController.text.trim(),
        };

         // PRINTING INDIVIDUAL PARAMETERS
      print("======= CREATE LEAD REQUEST =======");
      print("Name: ${newData['name']}");
      print("Email: ${newData['email']}");
      print("Phone: ${newData['phone']}");
      print("Remark: ${newData['remark']}");
      print("Branch Name: ${newData['branch_name']}");
      print("Address: ${newData['address']}");
      print("Source: ${newData['source']}");
      print("Query Type: ${newData['query_type']}");
      print("Company ID: ${newData['company_id']}");
      print("Employee ID: ${newData['employee_id']}");
      print("Visit time:- ${datetimeController.text.trim()}");
      print("Authorization Token: Bearer $token");
      print("API Endpoint: ${ApiConstants.creatLead}");
      print("Full Body JSON: ${jsonEncode(newData)}");
      
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
        print('API Response: $responseBody');
        print('Status code: ${response.statusCode}');

        // Handle all non-200 status codes first
        if (response.statusCode != 200) {
          var modelData = createLeadModelFromJson(response.body);
          print("lead created:- $modelData");
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
        // var loginModel = createLeadModelFromJson(response.body);
        // final prefs = await SharedPreferences.getInstance();

        isLoading.value = false;

        // Get.snackbar(
        //   "Success",
        //   responseBody['message'] ?? "Lead created successfully",
        //   backgroundColor: CRMColors.succeed,
        //   colorText: CRMColors.black,
        // );
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
            // Get.off(LeadListScreen());
     
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
  nameController.clear();
  datetimeController.clear();
  emailController.clear();
  phoneController.clear();
  branchNameController.clear();
  addressController.clear();
  purposeController.clear();
  queryTypeController.clear();
}

}
