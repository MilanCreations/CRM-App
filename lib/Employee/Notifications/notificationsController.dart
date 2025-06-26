// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Notifications/notificationsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationsHistoryController extends GetxController {
  var isLoading = false.obs;
  var notificationsList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  Future<void> NotificationsHistoryfunctions({bool isRefresh = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        return;
      }

      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        notificationsList.clear();
      }

      final uri = Uri.parse(
        "${ApiConstants.notificationsList}?"
        "_page=${currentPage.value}"
        "&_limit=10",
       
      );

      print("Final Notification History API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code of Notification history: ${response.statusCode}");
      print("API Response of Notification history: ${response.body}");
      if (response.statusCode == 200) {
        var attendanceHistoryModel = notificationsModelFromJson(
          response.body,
        );

        if (attendanceHistoryModel.data.isEmpty) {
          hasMoreData.value = false;
        } else {
          notificationsList.addAll(attendanceHistoryModel.data);
          print("Notifications list :- ${notificationsList.length}");
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
