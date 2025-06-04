import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/HR%20Leads/hrLeadsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Hrleadscontroller extends GetxController {
  var isLoading = false.obs;
  var hrLeadList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  Future<void> hrleadsFunction({
    bool isRefresh = false,
    String? startDate,
    String? endDate,
    String searchQuery = "",
  }) async {
    if (isLoading.value) return;

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
        hrLeadList.clear();
      }

      // Build query parameters
      final queryParams = {
        'page': currentPage.value.toString(),
        'limit': '20',
        'sort': 'date', // Changed from 'date' to 'created_at'
        'order': 'desc',
        'q': searchQuery,
        'status': '',
        'department': '',
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };

      final uri = Uri.parse(
        ApiConstants.hrleadList,
      ).replace(queryParameters: queryParams);

      print("Final HR lead list API URL: ${uri.toString()}");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final hrLeadListModel = hrLeadsModelFromJson(response.body);

        if (hrLeadListModel.result.isEmpty) {
          hasMoreData.value = false;
          if (currentPage.value > 1) {
            Get.snackbar(
              "Info",
              "No more leads available",
              backgroundColor: CRMColors.info,
              colorText: CRMColors.textWhite,
            );
          }
        } else {
          hrLeadList.addAll(hrLeadListModel.result);

          // Check if we should expect more data
          if (hrLeadListModel.result.length >= 20) {
            currentPage.value++;
          } else {
            hasMoreData.value = false;
          }
        }
      } else if (response.statusCode == 401) {
        clearSharedPreferences();
      } else {
        // Parse error message from response
        final errorMessage = _parseErrorMessage(response.body);
        print("Error fetching HR leads: $errorMessage");
        Get.snackbar(
          "Message",
          errorMessage,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch HR leads: ${e.toString()}",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _parseErrorMessage(String responseBody) {
    try {
      final json = jsonDecode(responseBody);
      return json['error'] ?? json['message'] ?? "Failed to fetch HR leads";
    } catch (e) {
      return "Failed to fetch HR leads";
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
