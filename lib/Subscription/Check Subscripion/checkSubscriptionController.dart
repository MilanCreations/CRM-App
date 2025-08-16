import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeController.dart';
import 'package:crm_milan_creations/Subscription/Check%20Subscripion/checkSubscriptionModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckSubscriptioncontroller extends GetxController {
  final AddEmployeeController addEmployeeController = Get.put(
    AddEmployeeController(),
  );
  var isLoading = false.obs;
  var checkTotalEmployees = [].obs;

  /// return true if subscription is active, else false
  Future<bool> checkSubscriptionFunction() async {
    print("Check subscription controller called");
    if (isLoading.value) return false;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        return false;
      }

      final url = Uri.parse(ApiConstants.checkSubscription);
      print("Check Subscription API URL: $url");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code: ${response.statusCode}");
      print("API Body: ${response.body}");
      var subModel = checksubscriptionFromJson(response.body);

      if (response.statusCode == 200) {
        if (subModel.status == "success") {
          print("✅ Subscription is active");
          if (subModel.data.isNotEmpty) {
            checkTotalEmployees.assignAll(subModel.data);
            update();
          }
          return true;
        } else {
          print("❌ Subscription not active");
          return false;
        }
      }

      if (response.statusCode == 401) {
        clearSharedPreferences();
      } else if (response.statusCode == 500) {
        Get.snackbar('Message', 'Internal server error',
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      } else if (response.statusCode == 404) {
        Get.snackbar('Message', 'No subscription data found',
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      } else if (response.statusCode == 403) {
        Get.snackbar('Message', subModel.message,
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      } else if (response.statusCode == 400) {
        Get.snackbar('Message', 'Bad request',
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      } else if (response.statusCode == 408) {
        Get.snackbar('Message', 'Request timeout',
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      }

      return false;
    } catch (e) {
      print("❌ Exception in Check Subscription: $e");
      return false;
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
