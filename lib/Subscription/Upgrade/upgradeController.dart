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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await _getToken();
      if (token == null) {
        await clearSharedPreferences();
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.upgrade),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'extraEmployees': extraEmployees}),
      );

      if (response.statusCode == 200) {
        upgradeModel.value = upgeademodelFromJson(response.body);
        Get.snackbar(
          'Success',
          upgradeModel.value?.message ?? 'Upgrade initiated',
          backgroundColor: CRMColors.success,
          colorText: CRMColors.white,
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        errorMessage.value = error['message'] ?? 'Upgrade failed';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.white,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(LoginScreen());
  }
}
