// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Leave%20Request/empLeaveRequestModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetAllEmployeeLeaveController extends GetxController{
  var isLoading = false.obs;
  var leaveHistoryList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
 
Future<void> getAllEmployeeLeaveFunction({String name = ""}) async {
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

    // Construct the URL with query parameters
    final url = Uri.parse(ApiConstants.allleaveHistory).replace(queryParameters: {
      '_page': currentPage.value.toString(),
      '_limit': '10',
      '_sort': '',
      // '_order': 'asc',
      'q': name, // Optional search query
    });

    print("Final Get All Employee Leave API URL: $url");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print("API Status Code in Get All Employee Leave: ${response.statusCode}");
    print("Body Response of Get All Employee Leave: ${response.body}");

    if (response.statusCode == 200) {
      var leaveHistoryModel = getAllEmployeeLeaveModelFromJson(response.body);
      print("All Employee Leave data fetched successfully");

      if (leaveHistoryModel.data.leaves.isEmpty) {
        hasMoreData.value = false;
      } else {
        leaveHistoryList.addAll(leaveHistoryModel.data.leaves);
        currentPage.value++;
      }

      update();
      isLoading.value = false;
    } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      isLoading.value = false;
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
      isLoading.value = false;
      Get.snackbar('Error', 'No More Data',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to fetch attendance history",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }
  } catch (error) {
    isLoading.value = false;
    print("Error fetching leave history: $error");
  } finally {
    isLoading.value = false; // <- THIS MUST ALWAYS RUN
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