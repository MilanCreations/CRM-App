// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Leads%20List/allLeadListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadListcontroller extends GetxController{
  var isLoading = false.obs;
  var leadList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var searchQuery = "".obs;

Future<void> leadListFunction({
  bool isRefresh = false,
  String search = '',
  DateTime? startDate,
  DateTime? endDate,
}) async {
  // Prevent duplicate calls
  if (isLoading.value) return;
  
  try {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      isLoading.value = false;
      clearSharedPreferences();
      Get.snackbar("Error", "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    // Reset for refresh
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      leadList.clear();
    }

    // Don't load more if no more data available
    if (!hasMoreData.value && !isRefresh) {
      isLoading.value = false;
      return;
    }

    String baseUrl = ApiConstants.leadList;
    // Updated to match your API parameters
    String queryParams = '?page=${currentPage.value}&_limit=10';

    if (search.isNotEmpty) {
      queryParams += '&search=$search';
    }
    if (startDate != null) {
      queryParams += '&startDate=${startDate.toIso8601String()}';
    }
    if (endDate != null) {
      queryParams += '&endDate=${endDate.toIso8601String()}';
    }

    final url = Uri.parse('$baseUrl$queryParams');
    print('Fetching URL: $url'); // Debug URL

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print('Response status: ${response.statusCode}'); // Debug status
    print('Response body: ${response.body}'); // Debug response

    if (response.statusCode == 200) {
      var allLeadsModel = ownLeadsModelFromJson(response.body);
      print('Received ${allLeadsModel.result.length} items'); // Debug count

      if (allLeadsModel.result.isEmpty) {
        hasMoreData.value = false;
        if (!isRefresh && currentPage.value > 1) {
          Get.snackbar("Info", "No more leads available",
              backgroundColor: CRMColors.info, colorText: CRMColors.textWhite);
        }
      } else {
        leadList.addAll(allLeadsModel.result);
        // Only increment page if we got the full limit of items
        if (allLeadsModel.result.length >= 10) {
          currentPage.value++;
        } else {
          hasMoreData.value = false;
        }
      }
    } else if (response.statusCode == 401) {
      clearSharedPreferences();
    } else {
      Get.snackbar("Error", "Failed to fetch leads: ${response.statusCode}",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: ${e.toString()}",
        backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
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