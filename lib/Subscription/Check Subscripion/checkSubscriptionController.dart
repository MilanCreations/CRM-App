import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Subscription/Check%20Subscripion/checkSubscriptionModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckEmployeesLengthcontroller extends GetxController {
  var isLoading = false.obs;
  var checkTotalEmployees = [].obs;

  Future<void> checkEmployeesLengthFunction() async {
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

      final url = Uri.parse(ApiConstants.checkEmployeeLengthForSubscription);
      print("Check Employees Length API URL: $url");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print(
        "API Status Code in Check Employees Length: ${response.statusCode}",
      );
      print("Body Response in Check Employees Length: ${response.body}");
      if (response.statusCode == 200) {
        var addemployeeModel = checksubscriptionFromJson(response.body);
        // checkEmployeesLength.value = int.parse(response.body);
        if (addemployeeModel.data.isNotEmpty) {
          checkTotalEmployees.addAll(addemployeeModel.data);
          update();
          print(
            "Check Employees Length in subscription model: ${addemployeeModel.data[0].baseEmployees}",
          );
        } else {
          print("Subscription not found");
        }
      }
      if (response.statusCode == 401) {
        isLoading.value = false;
        clearSharedPreferences();
      } else if (response.statusCode == 500) {
        print("Server error in checkEmployeesLengthFunction");
        Get.snackbar(
          'Message',
          'Internal server error',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 404) {
        print("No data found in checkEmployeesLengthFunction");
        Get.snackbar(
          'Message',
          'Internal server error',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 403) {
        print("Access forbidden in checkEmployeesLengthFunction");
        Get.snackbar(
          'Message',
          'Access forbidden',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 400) {
        print("Bad request in checkEmployeesLengthFunction");
        Get.snackbar(
          'Message',
          'Bad request',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 408) {
        print("Request timeout in checkEmployeesLengthFunction");
        Get.snackbar(
          'Message',
          'Request timeout',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        print(
          "Error fetching employees length subscription model: ${response.statusCode}",
        );
      }
    } catch (e) {
      print(
        "  Exception in checkEmployeesLengthFunction in subscription model: $e",
      );
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
