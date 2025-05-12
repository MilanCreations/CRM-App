// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Attendance%20History/historyMode.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceHistoryController extends GetxController {
  var isLoading = false.obs;
  var attendanceHistoryList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  Future<void> AttendanceHistoryfunctions({bool isRefresh = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

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

      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        attendanceHistoryList.clear();
      }

      // ✅ Add page parameter to API URL
      final uri = Uri.parse(
        ApiConstants.attendanceHistory +"?_page=" +currentPage.toString() +"&_limit=20&_sort=date&_order=desc&q=&status=&department=&startDate=&endDate=",
      );
      print("Final attendance History API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code attendance History: ${response.statusCode}");
      print("API Response in attendance history: ${response.body}");

      if (response.statusCode == 200) {
        var attendanceHistoryModel = attendanceHistoryModelFromJson(
          response.body,
        );

        if (attendanceHistoryModel.data.attendance.isEmpty) {
          hasMoreData.value = false;
        } else {
          // ✅ Append new data only
          attendanceHistoryList.addAll(attendanceHistoryModel.data.attendance);
          currentPage.value++;
        }
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
        hasMoreData.value = false;
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch attendance history",
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
