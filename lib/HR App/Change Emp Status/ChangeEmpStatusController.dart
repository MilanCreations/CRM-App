// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ChangeEmployeeStatusController extends GetxController {
  var isLoading = false.obs;
   var currentUpdatingId = (-1).obs;


Future<void> changeEmployeeFunction(int employeeId) async {
  try {
    currentUpdatingId.value = employeeId;
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

    final url = Uri.parse("${ApiConstants.changeEmpStatus}/$employeeId");

    print("Sending request to URL: $url");
    print("Employee ID: $employeeId");
    print("Request headers: Authorization: Bearer $token");

    final response = await http.put(url, headers: {"Authorization": "Bearer $token"});

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    switch (response.statusCode) {
      case 200:
        print("Status changed successfully");
        Get.snackbar(
          "Success",
          "Status changed successfully",
          backgroundColor: CRMColors.success,
          colorText: CRMColors.textWhite,
        );
        break;

      case 400:
        print("Bad Request");
        Get.snackbar(
          "Error 400",
          "Bad request. Please check parameters.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        break;

      case 401:
        print("Unauthorized - Token expired or invalid.");
        Get.snackbar(
          "Unauthorized",
          "Your session expired. Please login again.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        clearSharedPreferences();
        break;

      case 403:
        print("Forbidden - You don’t have permission.");
        Get.snackbar(
          "Forbidden",
          "You don’t have permission to perform this action.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        break;

      case 404:
        print("Not Found - Employee ID might be invalid.");
        Get.snackbar(
          "Not Found",
          "Employee not found.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        break;

      case 500:
        print("Internal Server Error");
        Get.snackbar(
          "Server Error",
          "Something went wrong on the server.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        break;

      default:
        print("Unhandled status code: ${response.statusCode}");
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
    currentUpdatingId.value = -1;
    isLoading.value = false;
    print("Loading complete.");
  }
}

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar(
      'Logout',
      'Login session expired',
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
    Get.offAll(LoginScreen());
  }


}
