// ignore_for_file: avoid_print
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/view%20employees/viewEmployeeDetailsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewEmployeecontroller extends GetxController {
  var isLoading = false.obs;
  var email = "".obs;
  var phone = "".obs;
  var companyName = "".obs;
  var department = "".obs;
  var joinDate = "".obs;
  var name = "".obs;
  var designation = "".obs;
  // var empID = 0.obs;
  var emergencyContact = "".obs;
  var selectedTab = 0.obs; // 0 = Contact Info, 1 = Employment Details, etc.
  var bankAccount = "".obs; // 0 = Contact Info, 1 = Employment Details, etc.
  var bankName = "".obs; // 0 = Contact Info, 1 = Employment Details, etc.

  Future<void> employeeDetailsFunction(int employeeId) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

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

      final url = Uri.parse("${ApiConstants.employeeDetails}/$employeeId");

      print("Final employee List API URL: $url");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code in Employee List: ${response.statusCode}");
      print("Body Response in Employee List: ${response.body}");

      if (response.statusCode == 200) {
        var employeeDetailsModel = employeedetailsFromJson(response.body);
        print("Employee Details model called");
        email = RxString(employeeDetailsModel.data.email);
        phone = RxString(employeeDetailsModel.data.phone);
        department = RxString(employeeDetailsModel.data.department.name);
        joinDate = RxString(employeeDetailsModel.data.joinDate.toString());
        name = RxString(employeeDetailsModel.data.name);
        designation = RxString(employeeDetailsModel.data.designation.name);
        // empID = RxInt(employeeDetailsModel.data.id);
        emergencyContact = RxString(employeeDetailsModel.data.emergencyContact);
        bankAccount = RxString(employeeDetailsModel.data.bankAccount);
        bankName = RxString(employeeDetailsModel.data.bankName);

        print("Email: ${employeeDetailsModel.data.email}");
        // if (employeeDetailsModel.data.companyId != null) {
        //   companyName.value = employeeDetailsModel.data.company!.name ?? "No Company";
        // } else {
        //   companyName.value = "No Company";
        // }

        isLoading.value = false;
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Error',
          'Bad Request',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Message',
          'Login session expired',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 500 || response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch attendance history",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (error) {
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
