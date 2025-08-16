import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crm_milan_creations/API Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Subscription/Upgrade/upgradeModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';

class UpgradeController extends GetxController {
  final isLoading = false.obs;
  final upgradeModel = Rxn<Upgeademodel>();
  final errorMessage = ''.obs;

  Future<bool> upgradeFunction(int extraEmployees) async {
    print(
      '[UpgradeController] Starting upgradeFunction with $extraEmployees extra employees',
    );
    try {
      print('[UpgradeController] Setting loading state to true');
      isLoading.value = true;
      errorMessage.value = '';

      print('[UpgradeController] Getting token from SharedPreferences');
      final token = await _getToken();
      if (token == null) {
        print(
          '[UpgradeController] Token is null - clearing SharedPreferences and redirecting to login',
        );
        await clearSharedPreferences();
        return false;
      }

      print(
        '[UpgradeController] Making API request to ${ApiConstants.upgrade}',
      );
      print(
        '[UpgradeController] Request body: {"extraEmployees": $extraEmployees}',
      );

      final response = await http.post(
        Uri.parse(ApiConstants.upgrade),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'extraEmployees': extraEmployees}),
      );

      print(
        '[UpgradeController] Received response with status code: ${response.statusCode}',
      );
      print('[UpgradeController] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('[UpgradeController] Parsing successful response');
        upgradeModel.value = upgeademodelFromJson(response.body);

        print(
          '[UpgradeController] Upgrade successful. Message: ${upgradeModel.value?.message}',
        );
        Get.snackbar(
          'Success',
          upgradeModel.value?.message ?? 'Upgrade initiated',
          backgroundColor: CRMColors.success,
          colorText: CRMColors.white,
        );
        return true;
      } else {
        print('[UpgradeController] Handling error response');
        final error = jsonDecode(response.body);
        errorMessage.value = error['message'] ?? 'Upgrade failed';

        print('[UpgradeController] Error message: ${errorMessage.value}');
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.white,
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('[UpgradeController] Exception occurred: $e');
      print('[UpgradeController] Stack trace: $stackTrace');
      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return false;
    } finally {
      print('[UpgradeController] Setting loading state to false');
      isLoading.value = false;
    }
  }

  Future<String?> _getToken() async {
    print('[UpgradeController] _getToken() called');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(
        '[UpgradeController] Retrieved token from SharedPreferences: ${token != null ? "[exists]" : "null"}',
      );
      return token;
    } catch (e) {
      print('[UpgradeController] Error getting token: $e');
      return null;
    }
  }

  static Future<void> clearSharedPreferences() async {
    print('[UpgradeController] clearSharedPreferences() called');
    try {
      final prefs = await SharedPreferences.getInstance();
      print('[UpgradeController] Clearing all SharedPreferences data');
      await prefs.clear();
      print('[UpgradeController] Redirecting to LoginScreen');
      Get.offAll(LoginScreen());
    } catch (e) {
      print('[UpgradeController] Error clearing SharedPreferences: $e');
    }
  }
}
