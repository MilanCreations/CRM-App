// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadStatuscontroller extends GetxController{
  var isLoading = false.obs;
  var leadstatus = [].obs;


Future<void> leadStatusFunction() async {
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

    String baseUrl = ApiConstants.leadStatus;


    final url = Uri.parse(baseUrl);
    print('Fetching URL: $url'); // Debug URL

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print('Response status in all lead status: ${response.statusCode}'); // Debug status
    print('Response body in all lead status: ${response.body}'); // Debug response

    if (response.statusCode == 200) {
      var leadStatusModel = leadStatusModelFromJson(response.body);
      leadstatus.addAll(leadStatusModel.status);
      print('Received lead status list:-  ${leadStatusModel.status.length} items'); // Debug count



    } else if (response.statusCode == 401) {
      clearSharedPreferences();
    } else {
      Get.snackbar("Error", "Failed to fetch leads: ${response.statusCode}",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }
  } catch (e) {
    Get.snackbar("Message", "Something went wrong: ${e.toString()}",
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