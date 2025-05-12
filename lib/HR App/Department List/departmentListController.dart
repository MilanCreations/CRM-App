// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DepartmentlistController extends GetxController {
  var isLoading = false.obs;
 RxList<Department> departmentList = <Department>[].obs;

 var selectedDepartment = Rx<Department?>(null);


  Future<void> departmentListFunction() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        Get.snackbar(
          "Error",
          "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      // ✅ Add page parameter to API URL
      final uri = Uri.parse(ApiConstants.employeeDepartment);
      // print("Department list API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      // print("API Status Code Department list: ${response.statusCode}");
      // print("API Response in Department list: ${response.body}");

      if (response.statusCode == 200) {
        var attendanceHistoryModel = departmentModelFromJson(response.body);
        departmentList.assignAll(attendanceHistoryModel.data.departments);
        update();
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Error',
          'Bad Request',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Message',
          'Login session expired',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 500 || response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch Department list",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (error) {
      isLoading.value = false;
      print("Error: $error");
    } finally {
      isLoading.value = false;
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
