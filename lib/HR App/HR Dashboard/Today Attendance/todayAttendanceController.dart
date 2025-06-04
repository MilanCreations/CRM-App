// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Attendance%20History/allendanceHistoryMode.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TodayAttendanceHistoryController extends GetxController {
  var isLoading = false.obs;
  var allEmployeeAttendanceHistoryList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayAttendance(); // Auto fetch on init
  }

  @override
  void onClose() {
    super.onClose();
    allEmployeeAttendanceHistoryList.clear();
  }

  void fetchTodayAttendance() {
    AllEmployeesAttendanceHistoryfunctions(isRefresh: true);
  }

  Future<void> AllEmployeesAttendanceHistoryfunctions({
    bool isRefresh = false,
  }) async {
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        Get.snackbar("Error", "User is not authenticated. Login again!",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite);
        return;
      }

      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        allEmployeeAttendanceHistoryList.clear();
      }

      DateTime today = DateTime.now();
      String formattedDate = today.toIso8601String().substring(0, 10); // yyyy-MM-dd

      final uri = Uri.parse(
        "${ApiConstants.todayAttendanceHistory}?"
        "_page=${currentPage.value}"
        "&_limit=10"
        "&_sort=date"
        "&_order=desc"
        "&startDate=$formattedDate"
        "&endDate=$formattedDate",
      );

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        var attendanceHistoryModel = attendanceHistoryModelFromJson(response.body);

        if (attendanceHistoryModel.data.attendance.isEmpty) {
          hasMoreData.value = false;
        } else {
          allEmployeeAttendanceHistoryList.addAll(attendanceHistoryModel.data.attendance);
          currentPage.value++;
        }
      } else if (response.statusCode == 401) {
        clearSharedPreferences();
      } else {
        Get.snackbar("Error", "Failed to fetch data",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar('Logout', 'Login session expired',
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite);
    Get.offAll(LoginScreen());
  }
}
