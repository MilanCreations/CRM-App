// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginModel.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/EmployeeBottomNavBar.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/superadmin.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/HRbottomNavBar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    CheckClockInController objCheckClockInController = Get.put(CheckClockInController(checkpagestatus: "login"));

  var isLoading = false.obs;
  var isLoadingtoken = false.obs;

Future<void> loginAPI() async {
  try {
    isLoading.value = true;

    Map<String, String> newData = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: jsonEncode(newData),
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = jsonDecode(response.body);
    print('API Response: $responseBody');
    print('Status code: ${response.statusCode}');

    // Handle all non-200 status codes first
    if (response.statusCode != 200) {
      isLoading.value = false;

      // If the API returns status: false with errors
      if (responseBody is Map && responseBody['status'] == false) {
      String errorMsg = responseBody['message'] ?? formatErrors(responseBody['error'] ?? {});
        Get.snackbar(
          "Login Failed",
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
          "Login Failed",
          msg,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }

      return;
    }

    // Handle successful login (statusCode 200)
    var loginModel = loginModelFromJson(response.body);
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setString('token', loginModel.token),
      prefs.setString('id', loginModel.user.id.toString()),
      prefs.setString('fullname', loginModel.user.fullname),
      prefs.setString('username', loginModel.user.username),
      prefs.setString('email', loginModel.user.email),
      prefs.setString('role_id', loginModel.user.roleId.toString()),
      prefs.setString('role_name', loginModel.user.roleName),
      prefs.setString('role_code', loginModel.user.roleCode),
      prefs.setString('company_name', loginModel.user.companyName),
      prefs.setString('employee_id', loginModel.user.employeeId.toString()),
      prefs.setString('profile_pic', loginModel.user.profilePic),
      prefs.setString('name', loginModel.user.name),
      prefs.setString('designation', loginModel.user.designation),
    ]);

    print("Full Name: ${loginModel.user.fullname}");

   isLoading.value = false;

switch (loginModel.user.roleCode) {
  case "HR_MANAGER":
    Get.offAll(() => HRBottomNavBar(checkpagestatuss: "login"));
    break;
  case "SUPER_ADMIN":
    Get.to(() => SuperAdminBottomNavBar(checkpagestatuss: "login"));
    break;
  case "Manager":
    // Get.to(() => ManagerBottomNavBar(checkpagestatuss: "login"));
    break;
  case "TeamLead":
    // Get.to(() => TeamLeadBottomNavBar(checkpagestatuss: "login"));
    break;
  case "EMPLOYEE":
  Get.offAll(() => EmployeeBottomNavBar(checkpagestatuss: "login"));
  case "":
  case null:
  // default:
  //    Get.to(() => BottomNavBar(checkpagestatuss: "login"));

    break;
}

Get.snackbar(
  "Success",
  "Login Successful",
  backgroundColor: CRMColors.clockInDate_and_position,
  colorText: CRMColors.black,
);

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

  // Helper function to format API error messages
  String formatErrors(Map<String, dynamic> errors) {
    List<String> messages = [];
    errors.forEach((key, value) {
      messages.add("${key.toUpperCase()}: ${value.join(", ")}");
    });
    return messages.join("\n");
  }

}
