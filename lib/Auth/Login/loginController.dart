// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, constant_pattern_never_matches_value_type

import 'dart:convert';
import 'dart:io';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginModel.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/EmployeeBottomNavBar.dart';
import 'package:crm_milan_creations/Employee/User%20Role%20Bottom%20Bar/CompanyAdminBottomBar.dart';
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
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String fcmToken = preferences.getString('fcm_token') ?? "";

  // ✅ Print the token
  print('📱 FCM Token retrieved in LoginController: $fcmToken');

 String devicePlatform = Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'unknown';
print('Device platform: $devicePlatform');

// ✅ Save platform in SharedPreferences
await preferences.setString('platform', devicePlatform);


  try {
    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text;

    print('Email: $email');
    print('Password: $password');
    print('Device Token: $fcmToken');
    print('Platform: $devicePlatform');

    Map<String, String> newData = {
      'email': email,
      'password': password,
      'device_token': fcmToken ,
      'platform': devicePlatform,
    };

    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: jsonEncode(newData),
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = jsonDecode(response.body);
    print('API Response: $responseBody');
    print('Status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      isLoading.value = false;

      if (responseBody is Map && responseBody['status'] == false) {
        String errorMsg = responseBody['message'] ?? formatErrors(responseBody['error'] ?? {});
        Get.snackbar(
          "Login Failed",
          errorMsg,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
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

    var loginModel = loginModelFromJson(response.body);

    await Future.wait([
      preferences.setString('token', loginModel.token),
      preferences.setString('id', loginModel.user.id.toString()),
      preferences.setString('fullname', loginModel.user.fullname),
      preferences.setString('username', loginModel.user.username),
      preferences.setString('email', loginModel.user.email),
      preferences.setString('role_id', loginModel.user.roleId.toString()),
      preferences.setString('role_name', loginModel.user.roleName),
      preferences.setString('role_code', loginModel.user.roleCode),
      preferences.setString('company_name', loginModel.user.companyName),
      preferences.setString('company_id', loginModel.user.companyId.toString()),
      preferences.setString('employee_id', loginModel.user.employeeId.toString()),
      preferences.setString('profile_pic', loginModel.user.profilePic),
      preferences.setString('name', loginModel.user.name),
      preferences.setString('designation', loginModel.user.designation),
      preferences.setString('permissions', jsonEncode(loginModel.user.permissions)),
    ]);

    print("✅ Full Name: ${loginModel.user.fullname}");
    print("✅ Permissions: ${loginModel.user.permissions}");

    isLoading.value = false;

    switch (loginModel.user.roleCode) {
      case "HR_MANAGER":
        Get.offAll(() => HRBottomNavBar(checkpagestatuss: "login"));
        break;
      case "COMPANY_ADMIN":
        Get.to(() => SuperAdminBottomNavBar(checkpagestatuss: "login"));
        break;
      case "EMPLOYEE":
        Get.offAll(() => EmployeeBottomNavBar(checkpagestatuss: "login"));
        break;
      case "Manager":
      case "TeamLead":
      case "":
      case null:
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
    print("❌ Catch Login Error: $error");
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
