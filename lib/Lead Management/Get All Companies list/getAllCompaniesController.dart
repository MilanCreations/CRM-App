// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetallCompanieslistcontroller extends GetxController {
  var isLoading = false.obs;
  var  companiesList = <String>[].obs; // Make it a list of employee names

  Future<void> getAllCompaniesListFunction() async {
    try {
      print("get All companies List Function called");
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

      final url = Uri.parse(ApiConstants.getAllComapies);
      print("Final all  companies list API URL: $url");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code in all  companies list: ${response.statusCode}");
      print("Body Response of all  companies list: ${response.body}");

      if (response.statusCode == 200) {
        var employeeListModel = getAllCompaniesModelFromJson(response.body);
        print("all  companies list fetched successfully");

      companiesList.value = employeeListModel.result
    .map((e) => e.companyName ?? '')
    .toSet() // remove duplicates
    .toList();

      } else if (response.statusCode == 401) {
        Get.snackbar('Message', 'Login session expired',
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite);
      } else {
        Get.snackbar("Error", "Failed to fetch employee list",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite);
      }
    } catch (error) {
      print("Error fetching employee list: $error");
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
