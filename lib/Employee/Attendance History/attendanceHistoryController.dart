// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Attendance%20History/allendanceHistoryMode.dart';
import 'package:crm_milan_creations/Employee/Table%20Calender%20Dashboard/tableCalenderController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceHistoryController extends GetxController {
  var isLoading = false.obs;
  var attendanceHistoryList = [].obs;
  var allEmployeeAttendanceHistoryList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  final tableCalendarController = Get.find<TableCalendarController>();
  Rx<DateTime?> startDateTime = Rx<DateTime?>(null);
  Rx<DateTime?> endDateTime = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initial call to fetch attendance history
    AttendanceHistoryfunctions();
    AllEmployeesAttendanceHistoryfunctions();
  }

  @override
  void onClose() {
    super.onClose();
    attendanceHistoryList.clear();
    allEmployeeAttendanceHistoryList.clear();
  }

  //.............. Individual Function for Attendance History ................
  Future<void> AttendanceHistoryfunctions({
    bool isRefresh = false,
    String? startDate,
    String? endDate,
  }) async {
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String name = prefs.getString('name') ?? "";

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

      // ✅ Validate dates
      if (startDate != null && endDate != null) {
        print("-------");
        DateTime start = DateTime.parse(startDate);
        DateTime end = DateTime.parse(endDate);
        if (end.isBefore(start)) {
          Get.snackbar(
            "Invalid Dates",
            "End date should be after start date",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          return;
        }
      }

      // ✅ Build query params
      final uri = Uri.parse(
        "${ApiConstants.attendanceHistory}?"
        "_page=${currentPage.value}"
        "&_limit=20"
        "&_sort=date"
        "&_order=desc"
        "&q=$name"
        "&status="
        "&department="
        "&startDate=${startDate ?? ''}"
        "&endDate=${endDate ?? ''}",
      );

      print("Final Attendance History API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");
     if (response.statusCode == 200) {
  var attendanceHistoryModel = attendanceHistoryModelFromJson(response.body);

  if (attendanceHistoryModel.data.attendance.isEmpty) {
    hasMoreData.value = false;
  } else {
    attendanceHistoryList.addAll(attendanceHistoryModel.data.attendance);
    print("Lodaing page in pagination: ${currentPage.value}");
    currentPage.value++; // ✅ Move to next page
    tableCalendarController.mapAttendanceStatus(attendanceHistoryModel.data.attendance);
    
  }
}
 else if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again.',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch data",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //......... All EMployee Attendance History Function ..........

  Future<void> AllEmployeesAttendanceHistoryfunctions({
    bool isRefresh = false,
    String? startDate,
    String? endDate,
     String? nameSearch = "",
  }) async {
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      // String finalSearchName = searchName ?? '';

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
        allEmployeeAttendanceHistoryList.clear();
      }

      // ✅ Validate dates
      if (startDate != null && endDate != null) {
        print("-------");
        DateTime start = DateTime.parse(startDate);
        DateTime end = DateTime.parse(endDate);
        if (end.isBefore(start)) {
          Get.snackbar(
            "Invalid Dates",
            "End date should be after start date",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          return;
        }
      }

      // ✅ Build query params
      final uri = Uri.parse(
        "${ApiConstants.attendanceHistory}?"
        "_page=${currentPage.value}"
        "&_limit=10"
        "&_sort=date"
        "&_order=desc"
        "&q=$nameSearch"
        "&status="
        "&department="
        "&startDate=${startDate ?? ''}"
        "&endDate=${endDate ?? ''}",
      );

      print("Final Attendance History API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");
      if (response.statusCode == 200) {
        print("all Employee Attendance History List");

        var attendanceHistoryModel = attendanceHistoryModelFromJson(
          response.body,
        );

        if (attendanceHistoryModel.data.attendance.isEmpty) {
          hasMoreData.value = false;
        } else {
          allEmployeeAttendanceHistoryList.addAll(
            attendanceHistoryModel.data.attendance,
          );
          print(
            "All attendanceHistoryList :- ${allEmployeeAttendanceHistoryList.length}",
          );
          // // ✅ Map to calendar
          // tableCalendarController.mapAttendanceStatus(
          //   attendanceHistoryModel.data.attendance,
          // );
          currentPage.value++;
        }
      } else if (response.statusCode == 401) {
        clearSharedPreferences();
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch data",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (e) {
      print("Error: $e");
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
