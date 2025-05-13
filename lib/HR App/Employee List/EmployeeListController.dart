// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmployeeListcontroller extends GetxController{
  var isLoading = false.obs;
  var employeeList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var searchQuery = "".obs;

  Future<void> employeeListFunction({bool isRefresh = false}) async {
     if (isLoading.value || !hasMoreData.value) return;
    try{
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

      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        employeeList.clear();
      }

final url = Uri.parse(
  "${ApiConstants.employeeList}?_page=${currentPage.value}&_limit=10&_sort=name&_order=asc&q=${searchQuery.value.trim()}");

    // print("Final employee List API URL: $url");
    final response = await http.get(url,
    headers: {"Authorization": "Bearer $token"},
    );
    
  

    // print("API Status Code in Employee List: ${response.statusCode}");
    // print("Body Response in Employee List: ${response.body}");

        if (response.statusCode == 200) {
      var employeeModel = employeeListFromJson(response.body);
      //  print("Employee List model called");
      if (employeeModel.result.isEmpty) {
          hasMoreData.value = false;
        } else {
          // ✅ Append new data only
          employeeList.addAll(employeeModel.result);
          currentPage.value++;
        }
       
        
        // print("Got the Employee List from api:- $employeeList");
        isLoading.value = false;

    } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
        hasMoreData.value = false;
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
      Get.snackbar("Error", "Failed to fetch attendance history",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }

    } catch(error){
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

  Future<void> refreshList() async {
    currentPage.value = 1;
    employeeList.clear();
    hasMoreData.value = true;
    await employeeListFunction();
  }

    void setSearchQuery(String query) {
    searchQuery.value = query;
    refreshList();
  }
}