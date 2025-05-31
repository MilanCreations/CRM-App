// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Getallemployeelistcontroller extends GetxController {
  var isLoading = false.obs;
  var employeeList = <Resultemp>[].obs; // Make it a list of employee names
  var selectedEmployee = Rxn<Resultemp>(); // Rxn allows null values


  Future<void> getAllEmployeeListFunction() async {
    try {
      print("getAllEmployeeListFunction called");
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

      final url = Uri.parse(ApiConstants.getAllEmployeeList);
      print("Final all employees list API URL: $url");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code in all employees list: ${response.statusCode}");
      print("Body Response of all employees list: ${response.body}");

      if (response.statusCode == 200) {
        var employeeListModel = getAllEmployeesModelFromJson(response.body);
        employeeList.addAll(employeeListModel.result);
        print("all employees list fetched successfully");

      
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
