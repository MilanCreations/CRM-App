// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Lead%20list/allLeadsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllLeadListcontroller extends GetxController {
  var isLoading = false.obs;
  var alleadList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var searchQuery = "".obs;
  DateTime? currentStartDate;
  DateTime? currentEndDate;

 Future<void> allLeadListFunction({
  bool isRefresh = false,
  bool loadMore = false, // Add this parameter
  String search = '',
  DateTime? startDate,
  DateTime? endDate,
}) async {
  // Don't load more if already loading or no more data
  if (isLoading.value || (loadMore && !hasMoreData.value)) return;
  
  try {
    if (!loadMore) {
      isLoading.value = true;
    }

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      isLoading.value = false;
      clearSharedPreferences();
      Get.snackbar("Error", "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    // Reset for refresh or when filters change
    if (isRefresh || 
        search != searchQuery.value || 
        startDate != currentStartDate || 
        endDate != currentEndDate) {
      currentPage.value = 1;
      hasMoreData.value = true;
      if (!loadMore) {
        alleadList.clear();
      }
      searchQuery.value = search;
      currentStartDate = startDate;
      currentEndDate = endDate;
    }

    String baseUrl = ApiConstants.allleadList;
    String queryParams = '?_page=${currentPage.value}&_limit=10';

    // Add search query if provided
    if (search.isNotEmpty) {
      queryParams += '&q=$search';
    }

    // Add date filters if provided
    if (startDate != null) {
      queryParams += '&startDate=${startDate.toIso8601String()}';
    }
    if (endDate != null) {
      queryParams += '&endDate=${endDate.toIso8601String()}';
    }

    final url = Uri.parse('$baseUrl$queryParams');
    print('Fetching URL: $url');

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      var allLeadsModel = allLeadsModelFromJson(response.body);

      if (allLeadsModel.result.isEmpty) {
        hasMoreData.value = false;
        // if (loadMore) {
        //   Get.snackbar("Info", "No more leads available",
        //       backgroundColor: CRMColors.info, colorText: CRMColors.textWhite);
        // }
      } else {
        if (loadMore) {
          alleadList.addAll(allLeadsModel.result);
        } else {
          alleadList.assignAll(allLeadsModel.result);
        }
        currentPage.value++;
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
  // Add a method to refresh with current filters
  Future<void> refreshWithCurrentFilters() async {
    await allLeadListFunction(
      isRefresh: true,
      search: searchQuery.value,
      startDate: currentStartDate,
      endDate: currentEndDate,
    );
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